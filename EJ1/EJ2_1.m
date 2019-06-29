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
length = 127;

%Caso a partir de estimacion de Rxx NO polarizado
partialCorrCoefNP = zeros(1,length); %contendrá los coeficientes de 
                                  %correlación parcial para k entre 1 y 127
                                  %a partir del caso no polarizado.

rxxNP_aux = rxxNP;                                
for k = 1:length
    rxxToep = toeplitz(rxxNP_aux'); % Se genera la matriz de Toeplitz
    rxxMat = rxxToep(1:k,1:k);
    rxxVect = (rxxNP_aux(2:k+1));
    corrCoefVect = inv(rxxMat) * rxxVect;% Se resuelve la ecuación de Yule Walker
    partialCorrCoefNP(k)= corrCoefVect(k);
end

%Caso a partir de estimacion de Rxx polarizado
partialCorrCoefP = zeros(1,length); %contendrá los coeficientes de 
                                 %correlación parcial para k entre 1 y 127; 
                                 %a partir del caso polarizado
rxxP_aux = rxxP;                                
for k = 1:length
    rxxToep = toeplitz(rxxP_aux'); % Generating Toeplitz Matrix
    rxxMat = rxxToep(1:k,1:k);
    rxxVect = (rxxP_aux(2:k+1));
    corrCoefVect = inv(rxxMat) * rxxVect; % Solving Yule Walker Equation
    partialCorrCoefP(k)= corrCoefVect(k);
end
q = 1:length;
figure
stem(q,partialCorrCoefNP)

q = 1:length;
figure
stem(q,partialCorrCoefP)

%% ITEM 3
% El AR(2) aparentemente lo describe
% X(n) = phi21*X(n-1) + phi22*X(n-2) + e(n)
% Los phi los calcule en hoja aparte. Hay que pasarlos al informe despues
phi21 = 0.1276;
phi22 = -0.0288;

%% ITEM 4

Rxx_TNP = zeros(length,1);
Rxx_TNP(1) = RxxNP(1);
Rxx_TNP(2) = RxxNP(2);

for k = 3:length-1
   Rxx_TNP(k) = phi21.*Rxx_TNP(k-1) + phi22.*Rxx_TNP(k-2); 
end
rxx_TNP = Rxx_TNP/Rxx_TNP(1);

k = 0:1:length-1;
figure
plot(k,rxx_TNP)


Rxx_TP = zeros(length,1);
Rxx_TP(1) = RxxP(1);
Rxx_TP(2) = RxxP(2);

for k = 3:length-1
   Rxx_TP(k) = phi21.*Rxx_TP(k-1) + phi22.*Rxx_TP(k-2); 
end
rxx_TP = Rxx_TP/Rxx_TP(1);

k = 0:1:length-1;
figure
plot(k,rxx_TP)

%% ITEM 5
% Por transformada
SxxNP = fft(RxxNP);
mag_SxxNP = abs(SxxNP);
SxxNP(mag_SxxNP<1e-6) = 0;
f = 0:1:length;
figure
plot(f,mag_SxxNP)

% Por periodogramas
Rxx_Vector = zeros(16,128);
% Se divide la entrada en 16 grupos de 256 muestras, calculando
% a 16 funciones de autocorrelación sus 128 primeros valores
% para el caso no polarizado
for l = 1:16
    for k = 0:127
        sum = 0;
        for i = 0:256-k-1
            sum = sum + (S.x(256*(l-1)+i+1) * S.x(256*(l-1)+i+1+k));
        end
        Rxx_Vector(l,k+1) = (1/(256-k)) * sum;
    end
end
Sxx_Vector = zeros(128,16);
% Se calcula la densidad espectral de cada uno
for k = 1:16
    Sxx_Vector(:,k) = fft(Rxx_Vector(k,:));
end
Sxx_Vector = Sxx_Vector';
Sxx_Med = zeros(1,128);
% Se estima la densidad promedio
for k = 1:16
    Sxx_Med = Sxx_Med + Sxx_Vector(k,:);
end
Sxx_Med = Sxx_Med/16;
mag_SxxMed = abs(Sxx_Med);
SxxNP(mag_SxxMed<1e-6) = 0;
figure
plot(1:128,mag_SxxMed)