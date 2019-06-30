clear;
clc;
%leemos archivo (debe ser mono)
file = 'pcm mono 8 bit 8kHz.wav';
info = audioinfo(file);
[data,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
S = compand(data,255,max(data),'mu/compressor'); % esta es la señal
snr = 30; %creo que esto esta en dB
X_tot = awgn(S,snr); % X = S + N 
Muestras = 160;
n = 11; % longitud de la rta impulsiva 
Iteraciones = cast(floor(length(S)/Muestras),'uint64'); 
shat = double.empty;

for l=0:Iteraciones-1
    td = (1+l*Muestras):(Muestras+l*Muestras); % td es el tiempo entre muestras(tiene length = muestras)
    Rxx = get_Rxx(X_tot(td),Muestras);
    vector = Rxx(2:n+1)';
    matrix =  toeplitz(Rxx(1:n));
    h = matrix\vector; % es lo mismo inv(matrix)*vector
    estimacion = conv(X_tot(td),h','same'); % computo la respuesta al filtro
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
title('Estimación')
%sound(X_tot)
sound(shat)