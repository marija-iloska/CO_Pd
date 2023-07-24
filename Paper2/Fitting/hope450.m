% Clear
clear all
close all
clc

% Load data
P = 0.001;
load ../DataConversion/Data/cov_time_for_fitting.mat
load ../DataConversion/Data/temps_info.mat

t = 2;
cov = cov_mix{t};
time = time_mix{t};
str = temps_strings{t};

%% Process Data
% Get system divisions
cut_off1 = 0.22;
tp_AB = find(cov > cut_off1);
tp_AB = [tp_AB(1), tp_AB(end)];


% Delta Time
dt = [0, time(2:end)' - time(1:end-1)'];
dtime = 0.01 : 0.02 : 24;
tN = 1:length(cov);


% Get individual coverages
[M, covA, covB] = get_sat(cov, tN, tp_AB, cut_off1);


% Initial points shifts
r12 = 0;
r23 = 0;
r34 = 0;


% Get k constants
[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k(cov, time, covA, covB, dt, tp_idx, tp_AB, tN(end), P, M);
% [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = k_model_test(cov, time, covA, covB, dt, tp_idx, tp_AB, tN(end), P, M);

vals = [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA];


% Store stats to excel file
%write_out(str, dlms, vals);

% Get fitting (simulation)
[theta_A, theta_B] = fitting_dt(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, N, r12, r23, r34, M, P);
% [theta_A, theta_B] = model_test(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, N, r12, r23, r34, M, P);

theta = theta_A + theta_B;
dtime(end)=[];


% Plotting 
lwd = 2;
sz = 20;
fsz = 35;
%plotting(theta, theta_A, theta_B, cov, covA, covB, str, tp_idx, time, lwd, sz, fsz)

purple = [132, 53, 148]/256;

figure(1)
scatter(time, covB, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(dtime, theta_B, 'b', 'Linewidth',lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
xline(time(tp_idx), 'm','Linewidth',lwd);
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage B', 'FontSize', 20)
legend('Experimental', 'Fitted','FontSize', 15)



% Plot A
figure(2)
scatter(time, covA, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(dtime, theta_A, 'b','Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage A', 'FontSize', 20)
legend('Experimental', 'Fitted', 'FontSize', 15)

% Plot B
figure(3)
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
scatter(time, cov, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(dtime, theta, 'Color', 'b', 'Linewidth', lwd)
xlabel('Time', 'FontSize', fsz)
ylabel('Coverage','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
grid on
box on
legend('Pressure off', 'Data','Fitted')



