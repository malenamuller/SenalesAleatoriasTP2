clear;
clc;
file = 'martu.wav';
info = audioinfo(file);
[y,Fs] = audioread(file);
t = 0:seconds(1/Fs):seconds(info.Duration);
t = t(1:end);
data = y(:,1);
S = compand(data,255,max(data),'mu/compressor');
Noise = wgn(length(data),1,-20);
X_tot = S + Noise;

N = 13;

x = X_tot(1:N);
varS = var(S);

%Acá calculamos Rxx(n) según la formula de Shanmugan
Rxx = get_Rxx(x,N);

%Sacamos la respuesta h(n) del filtro (Página 412 Shanmugan)
R = toeplitz(Rxx);
Rxs = repmat( varS, [1,length(Rxx)] )';
h = inv(R)*Rxs;

%Shat la calculamos con la formula página 411 Shanmugan
Shat = get_Shat(h,x,N);

plot(1:length(Shat),Shat)
