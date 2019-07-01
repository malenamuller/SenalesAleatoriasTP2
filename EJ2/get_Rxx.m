function [ Rxx ] = get_Rxx(x,N,k)
%Esta funci�n es para obtener el estimador de la autocorrelacion de X
%Est� en la p�gina 567 del Shanmugan
% x es el vector con las muestras
% N es la cantidad de muestras
% k es hasta donde calcular Rxx
Rxx = double.empty ;
for j = 0:k-1
    sumatoria = 0;
    for i = 0:N-j-1
        sumatoria = sumatoria + x(i+j+1)*x(i+1); % calculo la sumatoria
    end
    Rxx(j+1) = (1/(N-j))*sumatoria; % los sumo y divido por el k correspondiente
end
end

