clear;
clc;
file = 'pcm mono 8 bit 8kHz.wav';
info = audioinfo(file);
[y,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end);
data = y(:,1);
S = compand(data,255,max(data),'mu/compressor');
Noise = wgn(length(S),1,-60);
X_tot = S + Noise;

Stot = double.empty;
Muestras = 160;

Iteraciones = cast(length(S)/Muestras,'uint64'); 
for l=0:Iteraciones-1
    % td significa tiempo discretizado
    td = 1+l*Muestras:Muestras+l*Muestras; % el -1 es para que tenga length = muestras
    x = X_tot(td);
    Rss = get_Rxx(S(td),Muestras);
    
    Rxx = get_Rxx(x,Muestras);
    Rxx_mat = toeplitz(Rxx);
    %plot(1:length(Rxx),Rxx)
    h = inv(Rxx_mat)*Rss';
    %Rss_1_N = Rss(2:length(Rss));
    %Rss_0_N_menos_1 = Rss(1:length(Rss)-1); 
    %RssMat = toeplitz(Rss_0_N_menos_1);
    %h = (inv(RssMat))*Rss_1_N';
    Shat = conv(h,x,'same');
    Stot = [Stot Shat'];
end
subplot(4,1,1);
plot(t(1:length(t)-1),S)
title('Original')
subplot(4,1,2);
plot(t(1:length(t)-1),X_tot)
title('Con ruido')
subplot(4,1,3);
plot(t(1:length(t)-1),Noise)
title('Ruido')
subplot(4,1,4);
plot(t(1:length(Stot)),Stot)
title('Estimación')

sound(Stot)