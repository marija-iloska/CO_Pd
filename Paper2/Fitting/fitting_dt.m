function [theta_A, theta_B] = fitting_dt(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, N, r12, r23, r34, M, P)

vals = num2cell(vals);
[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA] = vals{:};


dt = dtime(2:end)-dtime(1:end-1);
N = length(dt);

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
idx = find(dtime < time(tp_AB(1)));
R1 = idx(end);
for t = 2 : R1
    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B =   k_oB*dt(t)*P*( M - covX );
    loss_B = - k_Bo*dt(t)*theta_B(t-1);

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
end

% theta_A(t) = covA(t);
% theta_B(t) = covB(t);

idx = find(dtime < time(tp_idx));
R2 = idx(end);
% Region II
for t = R1+1 : R2

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

idx = find(dtime < time(tp_AB(2)));
R3 = idx(end);

% Region III
for t = R2+1 : R3
    
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

% 
% theta_B(t) = covB(t);
% theta_A(t) = covA(t);

idx = find(dtime > time(tp_AB(2)));
R4 = idx(end-1);

% Region IV
for t = R3+1 : R4
    loss_B = - k_Bo*dt(t)*theta_B(t-1);
    theta_B(t) = theta_B(t-1) + loss_B;
end


end