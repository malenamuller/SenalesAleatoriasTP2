clear;
clc;
file = 'pcm mono 8 bit 8kHz.wav';
info = audioinfo(file);
[y,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end);
data = y(:,1);
S = compand(data,255,max(data),'mu/compressor');
Noise = wgn(length(data),1,-60);
X_tot = S + Noise;

Stot = double.empty;
Muestras = 160;
Iteraciones = length(S)/Muestras; 
for l=0:Iteraciones-1
    % td significa tiempo discretizado
    td = 1+l*Muestras:Muestras+l*Muestras; % el -1 es para que tenga length = muestras
    x = X_tot(td);
    Rss = get_Rxx(S(td),Muestras);
    Rss_1_N = Rss(2:length(Rss));
    Rss_0_N_menos_1 = Rss(1:length(Rss)-1); 
    RssMat = toeplitz(Rss_0_N_menos_1);
    h = (inv(RssMat))*Rss_1_N';
    Shat = conv(h,x,'same');
    Stot = [Stot Shat'];
end

plot(1:length(Stot),Stot)
% figure
% plot(t(1:length(t)-1),data)
% figure
% plot(1:length(X_tot),X_tot)

