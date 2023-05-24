function [theta_A, theta_B] = model_test(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, N, r12, r23, r34, M, P)

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
R1 = idx(end)+3;
for t = 2 : R1
    covX = theta_A(t-1) + theta_B(t-1);

    % B
    gain_B =   k_oB*dt(t)*P*( M - covX );
    loss_B = - k_Bo*dt(t)*theta_B(t-1);

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
end




% Region II ________________________________________________
theta_A(t+1) = covA(tp_AB(1)+2);
theta_B(t+1) = covB(tp_AB(1)+2);

idx = find(dtime < time(tp_idx-1));
R2 = idx(end);
for t = R1+2 : R2

    covX = theta_A(t-1) + theta_B(t-1);
    Adiff = (covX - theta_A(t-1))/covX;
    Bdiff = (covX - theta_B(t-1))/covX;

    % B
    gain_B =  k_AB*dt(t)*theta_A(t-1)*( M - covX )*Bdiff + k_oB*P*(M - covX)*Adiff;
    loss_B = - k_BA*dt(t)*P*theta_B(t-1)*Adiff - k_Bo*dt(t)*theta_B(t-1)*Adiff;

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
    
    % A
    gain_A = k_oA*P*dt(t)*(M - covX) + k_BA*dt(t)*P*theta_B(t-1)*Adiff;
    loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB*dt(t)*theta_A(t-1)*( M - covX )*Bdiff;

    theta_A(t) = theta_A(t-1) + gain_A + loss_A;

end



% Region III ________________________________________________
theta_A(t) = covA(tp_idx);
theta_B(t) = covB(tp_idx);

idx = find(dtime < time(tp_AB(2)));
R3 = idx(end);

for t = R2+1 : R3
    
    covX = theta_A(t-1) + theta_B(t-1);
    Adiff = (covX - theta_A(t-1))/covX;
    Bdiff = (covX - theta_B(t-1))/covX;

    % B
    gain_B = k_AB * dt(t) * theta_A(t - 1)*(M - covX)*Bdiff;
    loss_B = 0;
    loss_B = - k_Bo*dt(t)*theta_B(t-1)*Adiff;

    theta_B(t) = theta_B(t-1) + gain_B + loss_B;
    
    %A
    gain_A = 0;
    loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB * dt(t) * theta_A(t - 1)*(M - covX)*Bdiff;
    theta_A(t) = theta_A(t - 1) + gain_A + loss_A;
    
end

% 
% while (theta_A(t-1) > 10e-3)
%     
%     covX = theta_A(t-1) + theta_B(t-1);
% 
%     % B
%     gain_B = k_AB * dt(t) * theta_A(t - 1)*(M - covX);
%     %loss_B = 0;
%     loss_B = - k_Bo*dt(t)*theta_B(t-1)*(M - theta_A(t-1))/M;
%     %loss_B = - k_Bo*dt(t)*theta_B(t-1)*(M - covX);
% 
% 
%     theta_B(t) = theta_B(t-1) + gain_B + loss_B;
%     
%     %A
%     gain_A = 0;
%     loss_A = - k_Ao*dt(t)*theta_A(t-1) - k_AB * dt(t) * theta_A(t - 1)*(M - covX);
%     theta_A(t) = theta_A(t - 1) + gain_A + loss_A;
% 
%     t = t+1;
%     
% end



% Region IV ________________________________________________

theta_B(t) = covB(tp_AB(2)-2);
theta_A(t) = covA(tp_AB(2)-2);

idx = find(dtime > time(tp_AB(2)+1));
R4 = idx(end-1);

for t = R3+1 : R4
    loss_B = - k_Bo*dt(t)*theta_B(t-1);
    theta_B(t) = theta_B(t-1) + loss_B;
end


end