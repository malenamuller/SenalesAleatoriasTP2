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
%para una ventana de ancho N
Rxx = zeros(1,N);
sum = zeros(1,N);
for k = 0:N-1
    for i = 0:N-k-1
        sum(k+1) = sum(k+1)+ x(i+k+1)*x(i+1); % no sabemos si esta bien
    end
    Rxx(k+1) = (1/(N-k))*sum(k+1);
end
%plot(1:length(Rxx),Rxx)
R = toeplitz(Rxx);
Rxs = repmat( varS, [1,length(Rxx)] )';
h = inv(R)*Rxs;
Shat = zeros(1,N);
sum2 = zeros(1,N);
for n = 0:N-1
    for k = 0:n
        sum2(k+1)= sum2(k+1)+h(k+1)*x(n-k+1);
    end    
    Shat(n+1)= sum2(n+1);
end
%plot(1:length(Shat),S(1:length(Shat)))
%hold on
plot(1:length(Shat),Shat)

