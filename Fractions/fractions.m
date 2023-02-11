% Clear
clear all
close all
clc

% Load data
P = 0.001;
load Coverage_data/CO_450K.mat

% Get system divisions
MB = 0.3;
tp_AB = find(cov > MB);
tp_AB = [tp_AB(1), tp_AB(end)];

% Get approximations
idx = find(cov == 0);
cov(idx) = 10e-3;

% Delta Time
dt = [0, time(2:end) - time(1:end-1)];
N = length(cov);
tN = 1:N;


% Region indices
R1 = 1:tp_AB(1);
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx + 1 : tp_AB(2);
R4 = tp_AB(2) + 1 : N;



% Max possible
M = 0.5; 

% Saturation Coverage
covX = cov([R2, R3]);

S = cov(tp_idx);


% X_A = zeros(1,N);
% X_A([R2, R3]) = (covX - MB)/(0.5 - MB);
% 
% 
% theta_A = 0.5*X_A;
% 
% theta_B = cov - theta_A;
% 
% 
% syms a b c x

% k = 0;
% for t = R2(1) : R3(end)
%     k = k+1;
%     a = MB;
%     b = - M;
%     c = cov(t) - MB;
%     eqn = a*x^2 + b*x + c == 0;
%     solx = vpasolve(eqn, x);
%     x_a(k) = double(solx(1));
% end
% 
% 
% x_b = sqrt(1 - x_a.^2);
% 
% covB(R1) = cov(R1);
% covA(R1) = zeros(1,length(R1));
% covA(R2(1):R3(end)) = M*x_a;
% covB(R2(1):R3(end)) = MB*x_b;
% 
% 
% plot(covA)
% hold on
% plot(covB)


% Model 2
% k = 0;
% for t = R2(1) : R3(end)
%     k = k+1;
%     a = M^2 + MB^2;
%     b = - 2*cov(t)*MB;
%     c = cov(t)^2 - M^2;
%     eqn = a*x^2 + b*x + c == 0;
%     solx = vpasolve(eqn, x);
%     x_bb(k) = double(solx(2));
% 
% end
% 
% x_aa = (1 - x_bb.^2).^0.5 ;
% 
% 
% 
% covB = zeros(1,N);
% covB([R1, R4]) = cov([R1, R4]);
% covA = zeros(1,N);
% covA([R2, R3]) = M*x_aa;
% covB([R2, R3]) = MB*x_bb;
% 
% 
% % Model 3
% 
% k = 0;
% for t = R2(1) : R3(end)
%     k = k + 1;
%     a = MB^2;
%     b = M^2;
%     c = - 2*M*cov(t);
%     d = cov(t)^2 - MB^2;
%     eqn = a*x^3 + b*x^2 + c*x + d == 0;
%     solx = vpasolve(eqn, x);
%     x_aa3(k) = double(solx(2));
% end
% 
% x_bb3 = (1 - x_aa3.^3).^0.5;
% 
% covB3 = zeros(1,N);
% covB3([R1, R4]) = cov([R1, R4]);
% covA3 = zeros(1,N);
% covA3([R2, R3]) = M*x_aa3;
% covB3([R2, R3]) = MB*x_bb3;
% 
% 
% % Model 4
% k = 0;
% for t = R2(1) : R3(end)
%     k = k + 1;
%     a = MB^2;
%     b = M^2 - 2*MB*cov(t);
%     c = cov(t)^2 - M^2;
%     eqn = a*x^2 + b*x + c*x == 0;
%     solx = vpasolve(eqn, x);
%     x_bb2(k) = double(solx(2));
% end
% 
% x_aa2 = sqrt(1 - x_bb2);
% 
% covB2 = zeros(1,N);
% covB2([R1, R4]) = cov([R1, R4]);
% covA2 = zeros(1,N);
% covA2([R2, R3]) = M*x_aa2;
% covB2([R2, R3]) = MB*x_bb2;
cov(1) = 1e-4;
cov(end)=1e-4;

[covA1, covB1] = model1(cov, N, R1, R2, R3, R4, M, MB);
[covA2, covB2] = model2(cov, N, R1, R2, R3, R4, M, MB);
[covA3, covB3] = model3(cov, N, R1, R2, R3, R4, M, MB);
[covA4, covB4] = model4(cov, N, R1, R2, R3, R4, M, MB);
[covA5, covB5] = model5(cov, N, R1, R2, R3, R4, M, MB);
[covA6, covB6] = model6(cov, N, R1, R2, R3, R4, M, MB);


db = [36, 104, 181]/256;
lb = [184, 211, 245]/256;
lwd = 3; 
cov_new = cov*1.21814;
%cov_new([R1 R2]) = cov([R1 R2]);
sz = 120;

gr = [19, 168, 146]/256;

figure()
plot(cov_new,  'Color', 'k' ,'LineWidth',lwd)
set(gca, 'FontSize', 12)
%title('$$', 'FontSize',25, 'Interpreter', 'latex')
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
xline(tp_idx, 'm', 'Linewidth', lwd-1)
yline(MB, 'm', 'Linewidth', lwd-1)
legend('$$\theta^X_{\tau}$$', 'FontSize',25, 'Interpreter', 'latex')
hold on
scatter(tp_idx, cov_new(tp_idx), sz, 'm', 'filled')
hold on
scatter(3.2, MB, sz, gr, 'filled')


figure(1)
plot(covA1,  'Color', db, 'LineWidth',lwd)
hold on
plot(covB1, 'Color', lb, 'LineWidth',lwd)
hold on
plot(cov, 'k', 'LineWidth',2)
set(gca, 'FontSize', 12)
title('$$\mathcal{M}_1:   \alpha_{\tau} + \beta_{\tau} = 1$$', 'FontSize',25, 'Interpreter', 'latex')
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
legend('$$\theta^A_{\tau}$$', '$$\theta^B_{\tau}$$', '$$\theta^X_{\tau}$$','FontSize',25, 'Interpreter', 'latex')


figure(2)
plot(covA2, 'Color', db,'LineWidth',lwd)
hold on
plot(covB2,'Color', lb, 'LineWidth', lwd)
hold on
plot(cov, 'k', 'LineWidth',2)
set(gca, 'FontSize', 12)
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
title('$$\mathcal{M}_2:  \alpha_{\tau}^2 + \beta_{\tau} = 1$$', 'FontSize',25, 'Interpreter', 'latex')
legend('$$\theta^A_{\tau}$$', '$$\theta^B_{\tau}$$', '$$\theta^X_{\tau}$$','FontSize',25, 'Interpreter', 'latex')


figure(3)
plot(covA3, 'Color', db, 'LineWidth',lwd)
hold on
plot(covB3, 'Color', lb, 'LineWidth',lwd)
hold on
plot(cov, 'k', 'LineWidth',2)
set(gca, 'FontSize', 12)
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
title('$$\mathcal{M}_3: \alpha_{\tau} + \beta_{\tau}^2 = 1$$', 'FontSize',25, 'Interpreter', 'latex')
legend('$$\theta^A_{\tau}$$', '$$\theta^B_{\tau}$$', '$$\theta^X_{\tau}$$','FontSize',25, 'Interpreter', 'latex')

figure(4)
plot(covA4, 'Color', db, 'LineWidth',lwd)
hold on
plot(covB4, 'Color', lb, 'LineWidth',lwd)
hold on
plot(cov, 'k', 'LineWidth',2)
set(gca, 'FontSize', 12)
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
title('$$\mathcal{M}_4: \alpha_{\tau}^2 + \beta_{\tau}^2 = 1$$', 'FontSize',25, 'Interpreter', 'latex')
legend('$$\theta^A_{\tau}$$', '$$\theta^B_{\tau}$$', '$$\theta^X_{\tau}$$','FontSize',25, 'Interpreter', 'latex')

figure(5)
plot(covA5, 'Color', db, 'LineWidth',lwd)
hold on
plot(covB5, 'Color', lb, 'LineWidth',lwd)
hold on
plot(cov, 'k', 'LineWidth',2)
set(gca, 'FontSize', 12)
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
title('$$\mathcal{M}_5:  \alpha_{\tau}^3 + \beta_{\tau} = 1$$', 'FontSize',25, 'Interpreter', 'latex')
legend('$$\theta^A_{\tau}$$', '$$\theta^B_{\tau}$$', '$$\theta^X_{\tau}$$','FontSize',25, 'Interpreter', 'latex')

figure(6)
plot(covA6, 'Color', db, 'LineWidth',lwd)
hold on
plot(covB6, 'Color', lb, 'LineWidth',lwd)
hold on
plot(cov, 'k', 'LineWidth',2)
set(gca, 'FontSize', 12)
xlabel("Time $$\tau$$", 'FontSize', 25, 'Interpreter', 'latex' )
ylabel("Coverage", 'FontSize', 17)
title('$$\mathcal{M}_6:  \alpha_{\tau}^3 + \beta_{\tau}^2 = 1$$', 'FontSize',25, 'Interpreter', 'latex')
legend('$$\theta^A_{\tau}$$', '$$\theta^B_{\tau}$$', '$$\theta^X_{\tau}$$','FontSize',25, 'Interpreter', 'latex')
