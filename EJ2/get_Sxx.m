function [ Sxx,M ] = get_Sxx( Rxxder )
Rxxizq = fliplr(Rxxder);
Rxxizq = Rxxizq(1:length(Rxxizq)-1);    
Rxx = [Rxxizq Rxxder] ;  % Rxx es par!
Sxx_shifteada = fft(Rxx);
k = 0:length(Sxx_shifteada)-1; % en la formula de exp(-j2*pik/N)
% Ahora Rxx(0) está en Rxx(M+1)
% length(Rxx) =  2M+1
M = (length(Rxx)-1)/2;
n0 = -(M+1); % quiero que Rxx(M+1) pase a Rxx(0)
N = length(k);
Sxx = Sxx_shifteada .* exp(-1i*2*pi*k*n0/N);
end

