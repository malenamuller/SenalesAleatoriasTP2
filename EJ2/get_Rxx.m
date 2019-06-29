function [ Rxx ] = get_Rxx(x,N)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
Rxx = double.empty ;
Rxx_terms = double.empty;
for k = 0:N-1
    for i = 0:N-k-1
        Rxx_terms = [Rxx_terms x(i+k+1)*x(i+1)];
    end
    Rxx(k+1) = (1/(N-k))*sum(Rxx_terms(k+1));
end

end

