function [ Shat ] = get_Shat(h,x,N)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
Shat = double.empty ;
shat_terms = double.empty;
for n = 0:N-1
    for k = 0:n
        shat_terms = [shat_terms,h(k+1)*x(n-k+1)];
    end    
    Shat = [Shat sum(shat_terms)];
end

end

