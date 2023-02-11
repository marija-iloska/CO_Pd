function [covA, covB] = model6(cov, N, R1, R2, R3, R4, M, MB)

covA = zeros(1,N);
covB = zeros(1,N);

syms a3 a2 a1 a0 x
k = 0;
for t = R2(1) : R3(end)
    k = k+1;
    a3 = MB;
    a2 = M^2;
    a1 = - 2*M*cov(t);
    a0 = cov(t)^2 - MB^2;
    eqn = a3*x^3 + a2*x^2 + a1*x + a0 == 0;
    solx = vpasolve(eqn, x);
    x_a(k) = double(solx(2));
end


x_b = sqrt(1 - x_a.^3);

covB(R1) = cov(R1);
covB(R4) = cov(R4);

covA([R2, R3]) = M*x_a;
covB([R2, R3]) = MB*x_b;


end