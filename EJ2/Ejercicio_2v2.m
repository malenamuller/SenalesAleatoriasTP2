clear;
clc;
%leemos archivo (debe ser mono)
file = 'whereIam8Khz.wav';
info = audioinfo(file);
[data,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
S = compand(data,255,max(data),'mu/compressor'); % esta es la se�al
PotRuido = -30; % esta en dB
Noise = wgn(length(S),1,PotRuido);
X_tot = S+Noise;
var_Ruido = var(Noise);
%fs*20ms = Muestras
Muestras = Fs*20e-3; %160 si fs 8Khz 
Iteraciones = cast(floor(length(S)/Muestras),'uint64'); 
size = 5;
m = -size:size;
shat = double.empty;
for l=0:Iteraciones-1
    td = (1+l*Muestras):(Muestras+l*Muestras);
    Act_X = X_tot(td);    
    Act_S = S(td);
    Muestras = length(Act_X);
    Rxx = get_Rxx(Act_X, Muestras,2*size+1);
    Rss = get_Rxx(Act_S, Muestras,size+1);
    Rxx = Rxx(1:2*size+1);
    RssMat = 1:size*2+1;
    for i=1:size*2+1
        index =  abs(size+1-i)+1;
        RssMat(i) = Rss( index );
    end
    R = toeplitz(Rxx);
    h = R\RssMat';
    Shift_H = circshift(h,size);
    estimacion = conv(Act_X,Shift_H,'same');        
    shat = [shat estimacion'];
end

subplot(3,1,1);
plot(t(1:length(t)-1),S)
title('Original')
subplot(3,1,2);
plot(t(1:length(X_tot)),X_tot)
title('Con ruido')
subplot(3,1,3);
plot(t(1:length(shat)),shat)
title('Estimaci�n')
%player = audioplayer(X_tot, Fs);
player = audioplayer(shat, Fs);
play(player);
%para parar el audio stop(player);