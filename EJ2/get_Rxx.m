function [ Rxx ] = get_Rxx(x,Muestras)
%Esta función es para obtener el estimador de la autocorrelacion de X
%Está en la página 567 del Shanmugan
Rxx = double.empty ;
for k = 0:Muestras-1
    sumatoria = 0;
    for i = 0:Muestras-k-1
        sumatoria = sumatoria + x(i+k+1)*x(i+1); % calculo la sumatoria
    end
    Rxx(k+1) = (1/(Muestras-k))*sumatoria; % los sumo y divido por el k correspondiente
end
end

