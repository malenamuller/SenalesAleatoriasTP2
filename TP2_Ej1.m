%tp2 Ej1

clear all

S = load('Archivo_2.mat')
%whos S
%whos -file Archivo_2.mat
S.ans(2)
S.x(S.ans(2))
S.x(4096)

N = 128

%Estimador no polarizado
estimRxxNP = zeros(N,1); %contendrá el RxxNP para cada valor de k entre 0 y N-1
for k = 0:N-1
    sum = 0;
    for i = 0:N-k-1
        sum = sum + (S.x(i+1) * S.x(i+1+k))
    end
    estimRxxNP(k+1) = (1/(N-k)) * sum; 
end

%Estimador polarizado
estimRxxP = zeros(N,1); %contendrá el RxxP para cada valor de k entre 0 y N-1
for k = 0:N-1
    sum = 0;
    for i = 0:N-k-1
        sum = sum + (S.x(i+1) * S.x(i+1+k))
    end
    estimRxxP(k+1) = (1/N) * sum; 
end

estimRxxNP
estimRxxP