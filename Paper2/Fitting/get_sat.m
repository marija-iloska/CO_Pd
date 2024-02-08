function [ M, theta_A, theta_B] = get_sat(theta_X, tN, tp_AB, cut_off1)

% Max possible
M = 0.5; 

% Define three regions: no A, some A, no A
R1 = 1:tp_AB(1)+1;
R2 = tp_AB(2)+1 : tN(end);
R3 = setdiff(tN, [R1, R2]);

% Get the fractions of A in each region
X_A = zeros(1, tN(end));
X_A(R3) = (theta_X(R3) - cut_off1)./(M - cut_off1);

% Get A using the fraction, and get B using A
theta_A = M*X_A;
theta_B = theta_X - theta_A;



end