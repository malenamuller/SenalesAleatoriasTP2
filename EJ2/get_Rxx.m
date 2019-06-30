%function [ Rxx ] = get_Rxx(x,Muestras)
function [ acf ] = get_Rxx(xAux,muestras)
%Esta función es para obtener el estimador de la autocorrelacion de X
%Está en la página 567 del Shanmugan
% Rxx = double.empty ;
% Rxx_terms = double.empty;
% for k = 0:Muestras-1
%     for i = 0:Muestras-k-1
%         Rxx_terms = [Rxx_terms x(i+k+1)*x(i+1)]; % voy concatenando los terminos
%     end
%     Rxx(k+1) = (1/(Muestras-k))*sum(Rxx_terms); % los sumo y divido por el k correspondiente
% end
acf = zeros(1,muestras-1);
for j = 0.0:1.0:muestras-1
    factor = (muestras-j);
    cumsum = 0;
    for k = 0.0:1.0:(muestras-j-1)
        cumsum = cumsum + xAux(k+1)*xAux(k+j+1);
    end
    acf(j+1) = cumsum/factor;
end
end

