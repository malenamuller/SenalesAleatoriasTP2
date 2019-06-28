%clear;
clc;
info = audioinfo('Romayyohablando.m4a');
[y,Fs] = audioread('Romayyohablando.m4a');
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end);
data = y(:,1);
compressed = compand(data,255,max(data),'mu/compressor');

figure
plot(t,data)
hold on
figure
plot(t,compressed)
noise = wgn(length(data),1,-25);
%xlabel('Time')
%ylabel('Audio Signal')
%figure
total = compressed + noise;
total = smooth(total);
plot(t,noise)
sound(total,fs)
