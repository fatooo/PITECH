/*
    fm_transmitter - use Raspberry Pi as FM transmitter

    Copyright (c) 2015, Marcin Kondej
    All rights reserved.

    See https://github.com/markondej/fm_transmitter

    Redistribution and use in source and binary forms, with or without modification, are
    permitted provided that the following conditions are met:

    1. Redistributions of source code must retain the above copyright notice, this list
    of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above copyright notice, this
    list of conditions and the following disclaimer in the documentation and/or other
    materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of its contributors may be
    used to endorse or promote products derived from this software without specific
    prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
    EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
    SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
    TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
    BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
    WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include "transmitter.h"
#include "wave_reader.h"
#include "stdin_reader.h"
#include <sstream>
#include <cmath>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fstream>

using std::ostringstream;

#define GPIO_BASE 0x00200000
#define CLK0_BASE 0x00101070
#define CLK0DIV_BASE 0x00101074
#define TCNT_BASE 0x00003004

#define STDIN_READ_DELAY 700000

#define ACCESS(base, offset) *(volatile unsigned*)((int)base + offset)
#define ACCESS64(base, offset) *(volatile unsigned long long*)((int)base + offset)

bool Transmitter::isTransmitting = false;
unsigned Transmitter::clockDivisor = 0;
unsigned Transmitter::frameOffset = 0;
vector<float>* Transmitter::buffer = NULL;
void* Transmitter::peripherals = NULL;

Transmitter::Transmitter()
{
    bool isBcm2835 = true;

    FILE* pipe = popen("uname -m", "r");
    if (pipe) {
        char buffer[64];
        string machine = "";
        while (!feof(pipe)) {
            if (fgets(buffer, 64, pipe)) {
                machine += buffer;
            }
        }
        pclose(pipe);

        machine = machine.substr(0, machine.length() - 1);
        if (machine != "armv6l") {
            isBcm2835 = false;
        }
    }

    int memFd;
    if ((memFd = open("/dev/mem", O_RDWR | O_SYNC)) < 0) {
        throw ErrorReporter("Cannot open /dev/mem (permission denied)");
    }

    peripherals = mmap(NULL, 0x002FFFFF, PROT_READ | PROT_WRITE, MAP_SHARED, memFd, isBcm2835 ? 0x20000000 : 0x3F000000);
    close(memFd);
    if (peripherals == MAP_FAILED) {
        throw ErrorReporter("Cannot obtain access to peripherals (mmap error)");
    }
}

Transmitter::~Transmitter()
{
    munmap(peripherals, 0x002FFFFF);
}

Transmitter* Transmitter::getInstance()
{
    static Transmitter instance;
    return &instance;
}

void Transmitter::play(string filename, double frequency, bool loop)
{
    if (isTransmitting) {
        throw ErrorReporter("Cannot play, transmitter already in use");
    }

    WaveReader* file = NULL;
    StdinReader* stdin = NULL;
    AudioFormat* format;

    bool readStdin = filename == "-";

    if (!readStdin) {
        file = new WaveReader(filename);
        format = file->getFormat();
    } else {
        stdin = StdinReader::getInstance();
        format = stdin->getFormat();
        usleep(STDIN_READ_DELAY);
    }

    clockDivisor = (unsigned)((500 << 12) / frequency + 0.5);

    isTransmitting = true;
    doStop = false;

    unsigned bufferFrames = (unsigned)((unsigned long long)format->sampleRate * BUFFER_TIME / 1000000);

    buffer = (!readStdin) ? file->getFrames(bufferFrames, 0) : stdin->getFrames(bufferFrames, doStop);

    pthread_t thread;
    void* params = (void*)&format->sampleRate;

    int returnCode = pthread_create(&thread, NULL, &Transmitter::transmit, params);
    if (returnCode) {
        if (!readStdin) {
            delete file;
        }
        delete format;
        ostringstream oss;
        oss << "Cannot create new thread (code: " << returnCode << ")";
        throw ErrorReporter(oss.str());
    }

    usleep(BUFFER_TIME / 2);

    bool doPlay = true;
    while (doPlay && !doStop) {
        while ((readStdin || !file->isEnd(frameOffset + bufferFrames)) && !doStop) {
            if (buffer == NULL) {
                buffer = (!readStdin) ? file->getFrames(bufferFrames, frameOffset + bufferFrames) : stdin->getFrames(bufferFrames, doStop);
            }
            usleep(BUFFER_TIME / 2);
        }
        if (loop && !readStdin && !doStop) {
            isTransmitting = false;

            buffer = file->getFrames(bufferFrames, 0);

            pthread_join(thread, NULL);

            isTransmitting = true;

            returnCode = pthread_create(&thread, NULL, &Transmitter::transmit, params);
            if (returnCode) {
                if (!readStdin) {
                    delete file;
                }
                delete format;
                ostringstream oss;
                oss << "Cannot create new thread (code: " << returnCode << ")";
                throw ErrorReporter(oss.str());
            }
        } else {
            doPlay = false;
        }
    }
    isTransmitting = false;

    pthread_join(thread, NULL);

    if (!readStdin) {
        delete file;
    }
    delete format;
}

void* Transmitter::transmit(void* params)
{
    unsigned long long current, start, playbackStart;
    unsigned offset, length, temp;
    vector<float>* frames = NULL;
    float value = 0.0;
    float* data;
#ifndef NO_PREEMP
    float prevValue = 0.0;
#endif

    unsigned sampleRate = *(unsigned*)(params);

#ifndef NO_PREEMP
    float preemp = 0.75 - 250000.0 / (float)(sampleRate * 75);
#endif

    ACCESS(peripherals, GPIO_BASE) = (ACCESS(peripherals, GPIO_BASE) & 0xFFFF8FFF) | (0x01 << 14);
    ACCESS(peripherals, CLK0_BASE) = (0x5A << 24) | (0x01 << 9) | (0x01 << 4) | 0x06;

    frameOffset = 0;
    playbackStart = ACCESS64(peripherals, TCNT_BASE);
    current = playbackStart;
    start = playbackStart;
	
//float bahadir[64]={0,	0.54,	0.91,	0.99,	0.76,	0.29,	-0.27,	-0.75,	-0.99,	-0.91,	-0.55,	-0.01,	0.53,	0.90,	0.99,	0.77,	0.30,	-0.26,	-0.74,	-0.99,	-0.92,	-0.56,	-0.03,	0.52,	0.90,	0.99,	0.78,	0.32,	-0.25,	-0.73,	-0.98,	-0.93,	-0.58,	-0.04,	0.50,	0.89,	1.00,	0.79,	0.33,	-0.23,	-0.72,	-0.98,	-0.93,	-0.59,	-0.06,	0.49,	0.88,	1.00,	0.79,	0.34,	-0.22,	-0.71,	-0.98,	-0.94,	-0.60,	-0.07,	0.48,	0.88,	1.00,	0.80,	0.36,	-0.21,	-0.70,	-0.97};
//float sin8k[128]={0,	0.76,	-0.99,	0.53,	0.3,	-0.92,	0.9,	-0.25,	-0.58,	1,	-0.72,	-0.057,	0.79,	-0.98,	0.48,	0.36,	-0.94,	0.87,	-0.19,	-0.62,	1,	-0.68,	-0.11,	0.83,	-0.96,	0.43,	0.41,	-0.96,	0.84,	-0.13,	-0.66,	1,	-0.64,	-0.17,	0.86,	-0.95,	0.38,	0.46,	-0.97,	0.81,	-0.078,	-0.71,	1,	-0.59,	-0.23,	0.89,	-0.93,	0.32,	0.51,	-0.98,	0.77,	-0.021,	-0.75,	0.99,	-0.55,	-0.28,	0.91,	-0.91,	0.27,	0.56,	-0.99,	0.74,	0.036,	-0.78,	0.98,	-0.5,	-0.34,	0.93,	-0.88,	0.21,	0.6,	-1,	0.7,	0.092,	-0.82,	0.97,	-0.45,	-0.39,	0.95,	-0.85,	0.16,	0.65,	-1,	0.65,	0.15,	-0.85,	0.95,	-0.39,	-0.44,	0.97,	-0.82,	0.1,	0.69,	-1,	0.61,	0.21,	-0.88,	0.94,	-0.34,	-0.49,	0.98,	-0.79,	0.043,	0.73,	-0.99,	0.56,	0.26,	-0.9,	0.91,	-0.29,	-0.54,	0.99,	-0.75,	-0.014,	0.77,	-0.99,	0.52,	0.32,	-0.93,	0.89,	-0.23,	-0.59,	1,	-0.71,	-0.071,	0.8,	-0.97,	0.47};	
	/*ifstream filee("sin2k.txt");
	if(filee.open()){
		filee >> bahadir;
		filee.close();
	}*/
	
    while (isTransmitting) {
        while ((buffer == NULL) && isTransmitting) {
            usleep(1);
            current = ACCESS64(peripherals, TCNT_BASE);
        }
        if (!isTransmitting) {
            break;
        }
        frames = buffer;
        frameOffset = (current - playbackStart) * (sampleRate) / 1000000;
        buffer = NULL;

        length = frames->size();
        data = *frames[0];
		
        offset = 0;

        while (true) {
            temp = offset;
            if (offset >= length) {
                offset -= length;
                break;
            }

            value = data[offset];
			
#ifndef NO_PREEMP
            value = value + (value - prevValue) * preemp;
            value = (value < -1.0) ? -1.0 : ((value > 1.0) ? 1.0 : value);
#endif

            ACCESS(peripherals, CLK0DIV_BASE) = (0x5A << 24) | ((clockDivisor) - (int)(round(value * 16.0)));
            while (temp >= offset) {
                asm("nop");
                current = ACCESS64(peripherals, TCNT_BASE);
                offset = (current - start) * (sampleRate) / 1000000;
            }
#ifndef NO_PREEMP
            prevValue = value;
#endif
        }

        start = ACCESS64(peripherals, TCNT_BASE);
        delete frames;
    }

    ACCESS(peripherals, CLK0_BASE) = (0x5A << 24);

    return NULL;
}

AudioFormat* Transmitter::getFormat(string filename)
{
    WaveReader* file;
    StdinReader* stdin;
    AudioFormat* format;

   if (filename != "-") {
        file = new WaveReader(filename);
        format = file->getFormat();
        delete file;
    } else {
        stdin = StdinReader::getInstance();
        format = stdin->getFormat();
    }
	
    return format;
}

void Transmitter::stop()
{
    doStop = true;
}
