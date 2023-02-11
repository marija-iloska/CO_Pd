% Clear
clear all
close all
clc

% Load data
P = 0.001;
load Coverage_data/CO_490K.mat
str = '490';



%% Process Data
% Get system divisions
cut_off = 0.3;
tp_AB = find(cov > cut_off);
tp_AB = [tp_AB(1), tp_AB(end)];

% Get approximations
idx = find(cov == 0);
cov(idx) = 10e-3;

% Delta Time
dt = [0, time(2:end) - time(1:end-1)];
N = length(cov);
tN = 1:N;

% Get individual coverages
[S, M, covA, covB] = get_sat(cov, tN, tp_idx, tp_AB, cut_off);

% Saturation
SA = covA(tp_idx);
SB = covB(tp_idx);

% Region indices
R1 = 1:tp_AB(1);
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx + 1 : tp_AB(2);
R4 = tp_AB(2) + 1 : N;

% Initial points shifts
r12 = 1;
r23 = 5;
r34 = 0;


%% Get k constants

% Get kBo
ln_covB = - log(covB(R4)./covB(tp_AB(2)+1));
timeR4 = time(R4) - time(tp_AB(2) + 1);
k_Bo = timeR4(:)\ln_covB(:);


% Get koB
timeR1 = time(R1) - time(R1(1));
Y = covB(R1+1) - (1 - k_Bo*dt(R1)).*covB(R1);
X = dt(R1).*P.*(M - cov(R1));
k_oB = X(:)\Y(:);


% Get kAB
Y = covB(R3+1) - covB(R3);
X = covA(R3).*dt(R3).*(M - cov(R3));
k_AB = X(:)\Y(:);



% Get kAo
Y = covA(R3+1) - (1 - k_AB*dt(R3).*(M - cov(R3)) ).*covA(R3);
X = dt(R3).*covA(R3);
k_Ao = - X(:)\Y(:);


% Get kBA
Y = covB(R2+1) - covB(R2) - k_AB*dt(R2).*covA(R2).*(M - cov(R2));
X =- dt(R2)*P.*covB(R2);
k_BA = X(:)\Y(:);


% Get koA
Y = cov(R2+1) - cov(R2) + k_Ao*dt(R2).*covA(R2);
X = dt(R2)*P.*(M - cov(R2));
%k_oA = X(:)\Y(:);
k_oA = k_Ao*SA / (P*(M - S));





dtp_idx = 0;
tp_idx = tp_idx + dtp_idx;


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

theta_A(t) = covA(t);
theta_B(t) = covB(t);


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


theta_A(t) = covA(t);
theta_B(t) = covB(t);

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


theta_B(t) = covB(t);
theta_A(t) = covA(t);

% Region IV
for t = R4(1) + r34 : R4(end)
    loss_B = - k_Bo*dt(t)*theta_B(t-1);
    theta_B(t) = theta_B(t-1) + loss_B;
end

theta = theta_A + theta_B;



% Plotting 
lwd = 2;
sz = 40;
fsz = 35;
plotting(theta, cov, str, tp_idx, time, lwd, sz, fsz)



figure(2)
scatter(time, covA, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(time, theta_A, 'b')
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage A', 'FontSize', 20)
legend('Experimental', 'Fitted', 'FontSize', 15)


figure(3)
scatter(time, covB, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(time, theta_B, 'b', 'Linewidth',1)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
xline(time(tp_idx), 'm','Linewidth',lwd);
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage B', 'FontSize', 20)
legend('Experimental', 'Fitted','FontSize', 15)




