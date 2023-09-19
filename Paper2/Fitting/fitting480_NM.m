function [theta_A, theta_B] = fitting450(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, M, P, cut_off)

vals = num2cell(vals);
[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA] = vals{:};

dt = dtime(2:end)-dtime(1:end-1);
N = length(dt);


% Fitting
theta_B = zeros(1,N);
theta_A = zeros(1,N);



% Region I _________________________________________________
theta_B(1) = cov(1);

idx = find(dtime < time(tp_AB(1)));
R1 = idx(end);
for t = 2 : R1
    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B =   k_oB*dt(t)*P*( M - covX );
    loss_B = - k_Bo*dt(t)*theta_B(t-1);

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
end



% Region II ________________________________________________
% theta_A(t) = covA(tp_AB(1));
% theta_B(t) = covB(tp_AB(1));
% theta_A(t+1) = theta_A(t);
% theta_B(t+1) = theta_B(t);

idx = find(dtime < time(tp_idx+1));
R2 = idx(end);
for t = R1 : R2

    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B =  k_AB*dt(t)*theta_A(t-1)*( M - covX );
    loss_B = - k_BA*dt(t)*theta_B(t-1)*theta_A(t-1); 

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
    
    % A
    gain_A = k_oA*P*dt(t)*(M - covX) + k_BA*dt(t)*theta_B(t-1)*theta_A(t-1);
    loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB*dt(t)*theta_A(t-1)*( M - covX );

    theta_A(t) = theta_A(t-1) + gain_A + loss_A;

end



% Region III ________________________________________________
% theta_A(t) = covA(tp_idx);
% theta_B(t) = covB(tp_idx);
% theta_A(t+1) = theta_A(t);
% theta_B(t+1) = theta_B(t);


idx = find(dtime < time(tp_AB(2)+8));
R3 = idx(end);

for t = R2+1 : R3
    
    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B = k_AB*dt(t)*theta_A(t - 1)*(M - covX);
    loss_B = - k_BA*dt(t)*theta_B(t-1)*theta_A(t-1);

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
    
    %A
    gain_A =  k_BA*dt(t)*theta_B(t-1)*theta_A(t-1);
    loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB*dt(t)*theta_A(t - 1)*(M - covX);
    theta_A(t) = theta_A(t - 1) + gain_A + loss_A;
    
end


% Region IV ________________________________________________

% theta_B(t) = covB(tp_AB(2)+2);
% theta_A(t) = covA(tp_AB(2)+2);
 
% theta_A(t+1) = theta_A(t);
% theta_B(t+1) = theta_B(t);


idx = find(dtime < time(end));
R4 = idx(end-1);

for t = R3 : N
    loss_B = - k_Bo*dt(t)*theta_B(t-1);
    theta_B(t) = theta_B(t-1) + loss_B;
end


end