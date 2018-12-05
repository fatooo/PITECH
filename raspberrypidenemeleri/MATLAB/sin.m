%64 sample
clear
sampling_rate=44100;
frame_length=128;
time=0:1/sampling_rate:1-1/sampling_rate;

channel_frequencies=[32,64,125,250,500,1e3,2e3,4e3,8e3,16e3];

for i=1:10
   sines(i,:)=round(sin(2*pi*channel_frequencies(i).*time),2,'significant'); 
    
    hold on
    plot(time,sines(i,:));
    
    
end
    time_2=0:1/44100:4-1/44100;
    time_3=0:1/44100:1-1/44100;
    ssss=sin(2*pi*2e3.*time_3);
    vvvv(:,1)=sin(2*pi*4e3.*time_3);
    signal=[ssss,vvvv];
    
    audiowrite('sin2k-4k.wav',signal,44100);
    
    time=0:1/44100:1-1/44100;
    
