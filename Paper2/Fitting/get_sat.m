function [S, M, theta_A, theta_B] = get_sat(theta_X, tN, tp_idx, tp_AB, cut_off1, cut_off2)

% Max possible
M = 0.5; 

% Saturation Coverage
covX1 = theta_X(1:tp_idx);
covX2 = theta_X(tp_idx+1:end);

covX = theta_X(tN);
S = theta_X(tp_idx);



X_A1 = (covX1 - cut_off1)/(M - cut_off1);
X_A2 = (covX2 - cut_off2)/(M - cut_off2);



X_A = [X_A1, X_A2];

if (length(tN) == length(theta_X))
    X_A(1:tp_AB(1)) = 0;
    X_A(tp_AB(2)-1:end) = 0;
end



theta_A = 0.5*X_A;

theta_B = covX - theta_A;




end