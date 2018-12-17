Fs=44100;
time=0:1/Fs:1-1/Fs; %Create 0.5sn time vector

freq=6e3; % frequency of the sin

sin6k(1,:)=round(sin(2*pi*freq.*time),2);

csvwrite('sin6k.csv',sin6k);
 audiowrite('sin1k.wav',sin1k,44100);
 
 