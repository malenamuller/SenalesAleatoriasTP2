clear;
clc;
%leemos archivo (debe ser mono)
file = 'pcm mono 8 bit 8kHz.wav';
info = audioinfo(file);
[data,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
S = compand(data,255,max(data),'mu/compressor'); % esta es la se�al
snr = 30; %creo que esto esta en dB
X_tot = awgn(S,snr); % X = S + N 
Muestras = 160; 
Iteraciones = cast(floor(length(S)/Muestras),'uint64'); 
shat = double.empty;

for l=0:Iteraciones-1
    td = (1+l*Muestras):(Muestras+l*Muestras); % td es el tiempo entre muestras(tiene length = muestras)
    Rxx = get_Rxx(X_tot(td),Muestras);
    Rss = get_Rxx(S(td),Muestras);
    Sxx = fft(Rxx);
    Sxs = fft(Rss);
    k = 0:length(Sxx)-1;
    alpha = -10;
    shift = exp((1i*2*pi*k*alpha)/length(Sxx));
    %(esto le aplica un (x(t+alpha)) alpha tiene que ser <0 para smoothing
    H = (Sxs./Sxx);
    %.*(shift);
    h = ifft(H);
    h = real(h);
    Entrada = fft(X_tot(td));
    estimacion = conv(X_tot(td),h','same'); % computo la respuesta al filtro
    %estimacion = real(ifft(H.*Entrada'));
    shat = [shat estimacion']; % concateno las estimaciones en el vector Shat
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
%sound(X_tot)
sound(shat)