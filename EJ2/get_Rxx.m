function [ Rxx ] = get_Rxx(x,N)
%Esta función es para obtener el estimador de la autocorrelacion de X
%Está en la página 567 del Shanmugan
Rxx = double.empty ;
Rxx_terms = double.empty;
for k = 0:N-1
    for i = 0:N-k-1
        Rxx_terms = [Rxx_terms x(i+k+1)*x(i+1)]; % voy concatenando los terminos
    end
    Rxx(k+1) = (1/(N-k))*sum(Rxx_terms); % los sumo y divido por el k correspondiente
end

end

