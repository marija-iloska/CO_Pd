function [covA, covB] = model1(cov, N, R1, R2, R3, R4, M, MB)

covA = zeros(1,N);
covB = zeros(1,N);


x_a = (cov([R2, R3]) - MB)/(M - MB);


x_b = 1 - x_a;

covB(R1) = cov(R1);
covB(R4) = cov(R4);

covA([R2, R3]) = M*x_a;
covB([R2, R3]) = MB*x_b;


end