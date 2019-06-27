%PROBANDO YULE WALKER
Rxx = zeros(1,4);
Rxx(1) = 1;
Rxx(2) = 0.674;
Rxx(3) = 0.2696;
Rxx(4) = 0.108;


Rxx2 = zeros(1,3);
Rxx2(1) = 0.674;
Rxx2(2) = 0.2696;
Rxx2(3) = 0.108;




%fi1,1
Rxxm_mat = toeplitz(Rxx); % Generating Toeplitz Matrix
B = Rxxm_mat(1:1,1:1);
Rxxm_vect = Rxx(2:2);
a = inv(B) * Rxxm_vect' % Solve Yule Walker Equation for 

%fi2,2
Rxxm_mat = toeplitz(Rxx); % Generating Toeplitz Matrix
B = Rxxm_mat(1:2,1:2);
Rxxm_vect = Rxx(2:3);
a = inv(B) * Rxxm_vect' % Solve Yule Walker Equation for 

%fi3,3
%Rxxm_mat = toeplitz(Rxx); % Generating Toeplitz Matrix
Rxxm_matTT = toeplitz([1 Rxx2]) % Generating Toeplitz Matrix
BB = Rxxm_matTT(1:3,1:3)
%B = Rxxm_mat(1:3,1:3)
Rxxm_vect = Rxx2(1:3);
a = inv(BB) * Rxxm_vect' % Solve Yule Walker Equation for 




