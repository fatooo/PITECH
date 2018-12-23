Fs=44100;
time=0:1/Fs:2-1/Fs; %Create 0.5sn time vector

freq=1e3; % frequency of the sin

sin1k(1,:)=round(sin(2*pi*freq.*time),2);

csvwrite('sin1k.csv',sin1k);
 audiowrite('sin1k.wav',sin1k,44100);
 
 