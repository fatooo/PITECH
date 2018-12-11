Fs=44100;
time=0:1/Fs:1-1/Fs; %Create 0.5sn time vector

freq=2e3; % frequency of the sin

sin2k(1,:)=round(sin(2*pi*freq.*time),2);

csvwrite('sin2k.csv',sin2k);
 audiowrite('sin1k.wav',sin1k,44100);
 
 