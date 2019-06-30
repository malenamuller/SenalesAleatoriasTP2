clear;
clc;
file = 'whereIam8Khz.wav';
info = audioinfo(file);
[y,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end);
data = y(:,1);

snr = 30;

S = compand(data,255,max(data),'mu/compressor');
noise_var = 10^(-snr/10);
X_tot = awgn(S,snr);

Muestras = 160;

% td = Offset:Muestras+Offset-1; % el -1 es para que tenga length = muestras
% 
% x = X_tot(td);
% %Acá calculamos Rxx(n) según la formula de Shanmugan
% %Rxx = get_Rxx(X_tot(td),Muestras);
% Rss = get_Rxx(S(td),Muestras);
% 
% %----------Lo que esta encerrado esta mal-----------------------
% % Esta opción es con la ecuación de h(n) del filtro (Página 412 Shanmugan)
% %R = toeplitz(Rxx);
% %Rxs = repmat( varS, [1,length(Rxx)] )';
% %h = inv(R)*Rxs;
% 
% %Esta otra opción es con la Ec 7.18 de la Página 387
% Rss_1_N = Rss(2:length(Rss));
% Rss_0_N_menos_1 = Rss(1:length(Rss)-1); 
% RssMat = toeplitz(Rss_0_N_menos_1);
% h = (inv(RssMat))*Rss_1_N';
% %----------------------------------------------------------------
% %Shat la calculamos con la formula página 411 Shanmugan
% Shat = conv(h,x,'same');
% plot(1:length(Shat),Shat)
% %hold on 
% %plot(1:length(Shat),S(td(1:length(td)-1)))
% %plot(1:length(X_tot),X_tot(1:length(X_tot)))
