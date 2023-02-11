function [theta_A, theta_B] = fitting(cov, covA, covB, dt, vals, tp_AB, tp_idx, N, r12, r23, r34, M, P)

vals = num2cell(vals);
[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA] = vals{:};


% Region indices
R1 = 1:tp_AB(1);
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx + 1 : tp_AB(2);
R4 = tp_AB(2) + 1 : N;


% Fitting
theta_B = zeros(1,N);
theta_A = zeros(1,N);


theta_B(1) = cov(1);

% Region I
for t = R1(2) : R1(end) + r12
    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B =   k_oB*dt(t)*P*( M - covX );
    loss_B = - k_Bo*dt(t)*theta_B(t-1);

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
end

% theta_A(t) = covA(t);
% theta_B(t) = covB(t);


% Region II
for t = R2(1)+ r12 : R2(end) + r23

    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B =  k_AB*dt(t)*theta_A(t-1)*( M - covX );
    loss_B = - k_BA*dt(t)*P*theta_B(t-1);

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
    
    % A
    gain_A = k_oA*P*dt(t)*(M - covX) + k_BA*dt(t)*P*theta_B(t-1);
    loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB*dt(t)*theta_A(t-1)*( M - covX );

    theta_A(t) = theta_A(t-1) + gain_A + loss_A;

end


% theta_A(t) = covA(t);
% theta_B(t) = covB(t);

% Region III
for t = R3(1) + r23 : R3(end) + r34
    
    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B = k_AB * dt(t) * theta_A(t - 1)*(M - covX);
    loss_B = 0;

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
    
    %A
    gain_A = 0;
    loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB * dt(t) * theta_A(t - 1)*(M - covX);
    theta_A(t) = theta_A(t - 1) + gain_A + loss_A;
    
end


% theta_B(t) = covB(t);
% theta_A(t) = covA(t);

% Region IV
for t = R4(1) + r34 : R4(end)
    loss_B = - k_Bo*dt(t)*theta_B(t-1);
    theta_B(t) = theta_B(t-1) + loss_B;
end


end