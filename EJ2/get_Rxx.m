function [ Rxx ] = get_Rxx(x,N)
Rxx = double.empty ;
Rxx_terms = double.empty;
for k = 0:N-1
    for i = 0:N-k-1
        Rxx_terms = [Rxx_terms x(i+k+1)*x(i+1)];
    end
    Rxx(k+1) = (1/(N-k))*sum(Rxx_terms);
end

end

