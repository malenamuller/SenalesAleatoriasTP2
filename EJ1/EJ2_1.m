%% TP2 - EJ 2.1 %%

%% ITEM 1
clear all;
clc;

S = load('Archivo_2.mat');
%whos S
%whos -file Archivo_2.mat

N = 4096;
length = 128;
% Estimador no polarizado y polarizado
RxxNP = zeros(length,1); %contendrá el RxxNP para cada valor de k entre 0 y 127
RxxP = zeros(length,1); %contendrá el RxxP para cada valor de k entre 0 y 127
for k = 0:length-1
    sum = 0;
    for i = 0:N-k-1
        sum = sum + (S.x(i+1) * S.x(i+1+k));
    end
    RxxNP(k+1) = (1/(N-k)) * sum;
    RxxP(k+1) = (1/N) * sum; 
end

clearvars sum;
clearvars i;
clearvars k;

% Coeficiente de correlacion
rxxNP = RxxNP/RxxNP(1);
rxxP = RxxP/RxxP(1);

k = 0:1:length-1;
figure;
plot(k,rxxNP)
figure;
plot(k,rxxP)

%% ITEM 2
length = 127

%Caso a partir de estimacion de Rxx NO polarizado
partialCorrCoefNP = zeros(1,length); %contendrá los coeficientes de 
                                  %correlación parcial para k entre 1 y 127
                                  %a partir del caso no polarizado.
for k = 1:length
    rxxToep = toeplitz([1 rxxNP']); % Generating Toeplitz Matrix
    rxxMat = rxxToep(1:k,1:k);
    rxxVect = (rxxNP(1:k))';
    corrCoefVect = inv(rxxMat) * rxxVect'; % Solving Yule Walker Equation
    partialCorrCoefNP(k)= corrCoefVect(k)
end

%Caso a partir de estimacion de Rxx polarizado
partialCorrCoefP = zeros(1,length); %contendrá los coeficientes de 
                                 %correlación parcial para k entre 1 y 127; 
                                 %a partir del caso polarizado
for k = 1:length
    rxxToep = toeplitz([1 rxxP']); % Generating Toeplitz Matrix
    rxxMat = rxxToep(1:k,1:k);
    rxxVect = (rxxP(1:k))';
    corrCoefVect = inv(rxxMat) * rxxVect'; % Solving Yule Walker Equation
    partialCorrCoefP(k)= corrCoefVect(k)
end

%% ITEM 3
% El AR(2) aparentemente lo describe
% X(n) = phi21*X(n-1) + phi22*X(n-2) + e(n)
phi21 = 0.1276;
phi22 = -0.0288;

%% ITEM 4

Rxx_T = zeros(length,1);
Rxx_T(1) = RxxNP(1);
Rxx_T(2) = RxxNP(2);

for k = 3:length-1
   Rxx_T(k) = phi21.*Rxx_T(k-1) + phi22.*Rxx_T(k-2); 
end
rxx_T = Rxx_T/Rxx_T(1);

k = 0:1:length-1;
figure
plot(k,rxx_T)

%% ITEM 5

SxxNP = fft(RxxNP);
mag_SxxNP = abs(SxxNP);
SxxNP(mag_SxxNP<1e-6) = 0;
f = 0:1:length;
figure
plot(f,mag_SxxNP)

SxxP = fft(RxxP);
mag_SxxP = abs(SxxP);
SxxP(mag_SxxP<1e-6) = 0;
f = 0:1:length;
figure
plot(f,mag_SxxP)