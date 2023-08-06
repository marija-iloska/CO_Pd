clear all
close all
clc

load ../DataConversion/Data/temps_info.mat
load ../DataConversion/Data/cov_time_for_fitting.mat
load Ea_all.mat
load 475fit.mat

% k = {koB, kBo, kAo, koA, kAB, kBA};
% T = [450, 460, 470, 475, 480, 490];

% Index of temperature we want to predict for
idx = 4;
P = 0.001;

% Arrhenious equation
% k = A exp(-Ea/(RT))
k_pred = A.*exp(- Ea./(R*T(idx)) );

cov = cov_mix{idx};
time = time_mix{idx};
str = temps_strings{idx};

%% Process Data
% Get system divisions
cut_off1 = 0.33;
tp_AB = find(cov > cut_off1);
tp_AB = [tp_AB(1), tp_AB(end)];

% Get individual coverages
[M, covA, covB] = get_sat(cov, tN, tp_AB, cut_off1);

% Fit
[theta_A_pred, theta_B_pred] = fitting1(cov, covA, covB, dtime, time, k_pred, tp_AB, tp_idx, M, P);

theta_pred = theta_A_pred + theta_B_pred;
sz = 40;
lwd = 2.5;
purple = [132, 53, 148]/256;
blue = [62, 158, 222]/256;
green = [44, 199, 114]/256;
tq = [50, 230, 191]/256;
gd = [196, 191, 24]/256;
fsz = 20;

% Plot 
figure(1)
scatter(time, cov, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
yline(cut_off1, 'color', 'm', 'LineWidth', lwd, 'LineStyle', '--')
hold on
plot(dtime, theta, 'Color', gd, 'Linewidth', lwd)
hold on
plot(dtime(1:end-1), theta_pred, 'Color', blue, 'Linewidth', lwd)
hold on
xlabel('Time [s]', 'FontSize', fsz)
ylabel('Coverage [ML]','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
legend('Data','Pressure off', 'Phase change', 'Fitting', 'Prediction',  'FontSize',15)
grid on
box on



% Plot B
figure(2)
scatter(time, covB, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
yline(cut_off1, 'color', 'm', 'LineWidth', lwd, 'LineStyle', '--')
hold on
plot(dtime, theta_B, 'Color', gd, 'Linewidth', lwd)
hold on
plot(dtime(1:end-1), theta_B_pred, 'Color', blue, 'Linewidth', lwd)
xlabel('Time [s]', 'FontSize', fsz)
ylabel('Coverage [ML]','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
legend('Data','Pressure off', 'Phase change', 'Fitting', 'Prediction',  'FontSize',15)
grid on
box on

% Plot A
figure(3)
scatter(time, covA, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
plot(dtime, theta_A, 'Color', gd, 'Linewidth', lwd)
hold on
plot(dtime(1:end-1), theta_A_pred, 'Color', blue, 'Linewidth', lwd)
xlabel('Time [s]', 'FontSize', fsz)
ylabel('Coverage [ML]','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
legend('Data','Pressure off', 'Fitting', 'Prediction',  'FontSize',15)
grid on
box on
