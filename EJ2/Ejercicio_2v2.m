clear;
clc;
%leemos archivo (debe ser mono)
file = 'pcm mono 8 bit 8kHz.wav';
info = audioinfo(file);
[data,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
S = compand(data,255,max(data),'mu/compressor'); % esta es la señal

snr = 40; %creo que esto esta en dB
X_tot = awgn(S,snr);

var_Ruido = var(X_tot) - var(S);

%sound(X_tot)
length(S)
Muestras = 160; 
Iteraciones = cast(floor(length(S)/Muestras),'uint64'); 

size = 5;

m = -size:size;


shat = double.empty;



for l=0:Iteraciones-1
    td = (1+l*Muestras):(Muestras+l*Muestras);
    Act_X = X_tot(td);
    %Rss = get_Rxx(S(td),size+1);
    
    Rxx = get_Rxx(Act_X, size*2+1);
    Rss = Rxx;
    
    Rss(1) = Rss(1) - var_Ruido;
    
    super_mat = toeplitz(Rxx); %ones(size*2+1, size*2+1);
    %Rxx = get_Rxx(Act_X, size*2+1);
    %for i=1:size*2+1
    %   for j=1:size*2+1
    %       super_mat(i,j) = Rxx(abs(i-j)+1);
    %   end
    %end
    
    
    RssMat = 1:size*2+1;
    for i=1:size*2+1
        %abs(12-i)+1
        RssMat(i) = Rss( abs(size+1-i)+1 );
    end
  
    Hmat = super_mat\transpose(RssMat);
    
    Shift_X = circshift(Act_X,-size);
    
    % tengo la h
    
    % hacemos convolución
    %for i = 1:size
    %    Shift_X(length(Act_X)-i+1) = 0;
    %end
    
    estimacion = conv(Shift_X,Hmat','same');
    
    shat = [shat estimacion'];
end
%sound(X_tot);
%sound(shat);

%Muestras = 160; 
%Iteraciones = cast(floor(length(S)/Muestras),'uint64'); 
%shat = double.empty;

%for l=0:Iteraciones-1
%    td = (1+l*Muestras):(Muestras+l*Muestras); % td es el tiempo entre muestras(tiene length = muestras)
%    Rxx = get_Rxx(X_tot(td),Muestras);
%    Rss = get_Rxx(S(td),Muestras);
%    Sxx = fft(Rxx);
%    Sxs = fft(Rss);
%    k = 0:length(Sxx)-1;

    %(esto le aplica un (x(t+alpha)) alpha tiene que ser <0 para smoothing
%    H = (Sxs./Sxx);
    %.*(shift);
%    h = ifft(H);
%    h = real(h);
%    Entrada = fft(X_tot(td));
%    estimacion = conv(X_tot(td),h','same'); % computo la respuesta al filtro
    %estimacion = real(ifft(H.*Entrada'));
%    shat = [shat estimacion']; % concateno las estimaciones en el vector Shat
%end
subplot(3,1,1);
plot(t(1:length(t)-1),S)
title('Original')
subplot(3,1,2);
plot(t(1:length(X_tot)),X_tot)
title('Con ruido')
subplot(3,1,3);
plot(t(1:length(shat)),shat)
title('Estimación')
%sound(S);
%sound(X_tot);
sound(shat)