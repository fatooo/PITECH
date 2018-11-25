#include <iostream>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <string>
#include <sstream>
#include "gpio.h"
using namespace std;
gpio::gpio()
{
    this->gpionum = 4;
    val_str = string("/sys/class/gpio/gpio");
    val_str+=static_cast<ostringstream*>( &(ostringstream() << gpionum) )->str();
    val_str+=string("/value");
    enable();
    setdirection(output); //output is default direction
}

gpio::gpio(int gnum)
{
    this->gpionum = gnum;  //Instatiate gpio object for GPIO pin number "gnum"
    val_str = "/sys/class/gpio/gpio";
    val_str+=static_cast<ostringstream*>( &(ostringstream() << gpionum) )->str();
    val_str+="/value";
    enable();
    setdirection(output); //output is default direction
}
gpio::gpio(int gnum,bool direction)
{
    this->gpionum = gnum;  //Instatiate gpio object for GPIO pin number "gnum"
    val_str = "/sys/class/gpio/gpio";
    val_str+=static_cast<ostringstream*>( &(ostringstream() << gpionum) )->str();
    val_str+="/value";
    enable();
    setdirection(direction);
}
gpio::~gpio()
{
    if(direct==output)
    {
        setval(low);
    }
    disable();
}
int gpio::enable()
{
    string exportString;
    exportString+="echo \"";
    exportString+=static_cast<ostringstream*>( &(ostringstream() << gpionum) )->str();
    exportString+="\" > /sys/class/gpio/export";
    system(exportString.c_str());
    return 0;
}

int gpio::disable()
{
    string exportString;
    exportString+="echo \"";
    exportString+=static_cast<ostringstream*>( &(ostringstream() << gpionum) )->str();
    exportString+="\" > /sys/class/gpio/unexport";
    system(exportString.c_str());
    return 0;
}

int gpio::setdirection(bool direction)
{

    string setdir_str ="/sys/class/gpio/gpio";
    setdir_str+=static_cast<ostringstream*>( &(ostringstream() << gpionum) )->str();
    setdir_str+="/direction";
    fstream setdir_gpio(setdir_str.c_str()); // open direction file for gpio
        if (setdir_gpio < 0){
            cout << " OPERATION FAILED: Unable to set direction of GPIO"<< this->gpionum <<" ."<< endl;
            return -1;
        }
        if(direction)
        {
            setdir_gpio<<"in";
        } else
        {
            setdir_gpio<<"out";
        }
        setdir_gpio.close(); // close direction file
        direct=direction;
        return 0;
}

bool& gpio::setval(const bool& val)
{
    if(direct==input)
    {
        throw "OPERATION FAILED: attempt to set the value of an input pin";
    }
    fstream setval_gpio(val_str.c_str()); // open value file for gpio
        if (setval_gpio < 0){
            throw " OPERATION FAILED: Unable to set the value of GPIO";
        }

        setval_gpio << val ;//write value to value file
        setval_gpio.close();// close value file
        curval=val;
        return curval;
}

bool gpio::getval(){
    int val;
    if(direct==input)
    {
        ifstream getval_gpio(val_str.c_str());// open value file for gpio
        if (getval_gpio < 0){
            cout << " OPERATION FAILED: Unable to get value of GPIO"<< this->gpionum <<" ."<< endl;
            return -1;
        }
        getval_gpio >> val ;  //read gpio value
        getval_gpio.close(); //close the value file
    } else { //if this is an output pin, simply return the currently set output
        val = curval;
    }
    return val;
}
bool gpio::getdirection()
{
    return direct;
}
bool& gpio::operator=(const bool& val)
{
    return setval(val);
}
int gpio::getnum(){

return this->gpionum;

}

