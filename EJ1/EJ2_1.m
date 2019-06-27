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
