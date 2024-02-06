% Clear
clear all
close all
clc

% Load data
P = 0.001;
load ../DataConversion/Data/cov_time_noise.mat
load ../DataConversion/Data/temps_info.mat


t = 6;
cov = cov_all{t};
time = time{t};
str = temps_strings{t};




%% Process Data
% Get system divisions
cut_off1 = 0.26;
tp_AB = find(cov > cut_off1);
tp_AB = [tp_AB(1), tp_AB(end)];


% Delta Time
dt = [0, time(2:end)' - time(1:end-1)'];
dtime = 0.01 : 0.02 : 11;
tN = 1:length(cov);


% Get individual coverages
[M, covA, covB] = get_sat(cov, tN, tp_AB, cut_off1);


% Initial points shifts
r12 = 0;
r23 = 0;
r34 = 0;


% Get k constants
[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k(cov, time, covA, covB, dt, tp_idx, tp_AB, tN(end), P, M);

vals = [ k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA];


% Store stats to excel file
%write_out(str, dlms, vals);

% Get fitting (simulation)
[theta_A, theta_B] = fitting(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, M, P);


theta = theta_A + theta_B;
dtime(end)=[];


% Plotting 
lwd = 2.5;
sz = 30;
fsz = 35;

purple = [132, 53, 148]/256;
blue = [62, 158, 222]/256;
green = [44, 199, 114]/256;
tq = [50, 230, 191]/256;
gd = [196, 191, 24]/256;

figure(1)
scatter(time, covB, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
yline(cut_off1, 'color', 'm', 'LineWidth', lwd, 'LineStyle', '--')
hold on
plot(dtime, theta_B, 'Color', gd, 'Linewidth',lwd)
hold on
ylim([0,0.4])
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time [s]', 'FontSize', 20)
ylabel('Coverage B [ML]', 'FontSize', 20)
legend('Data','Pressure off', 'Phase change','Fitting',  'FontSize',15)
grid on
box on

% filename = join(['figs/', str, '_Bfit.eps']);
% print(gcf, filename, '-depsc2', '-r300');


% Plot A
figure(2)
scatter(time, covA, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
plot(dtime, theta_A, 'Color', gd, 'Linewidth', lwd)
hold on
ylim([0,0.4])
xlabel('Time [s]', 'FontSize', fsz)
ylabel('Coverage A [ML]','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
legend('Data','Pressure off', 'Fitting',  'FontSize',15)
grid on
box on
% 
% filename = join(['figs/', str, '_Afit.eps']);
% print(gcf, filename, '-depsc2', '-r300');

% Plot FINAL
figure(3)
scatter(time, cov, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(dtime, theta, 'Color', gd, 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
yline(cut_off1, 'color', 'm', 'LineWidth', lwd, 'LineStyle', '--')
hold on
ylim([0,0.5])
xlabel('Time [s]', 'FontSize', fsz)
ylabel('Coverage [ML]','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
grid on
box on
legend('Data','Fitting', 'Pressure off', 'Phase change', 'FontSize',15)
 
% filename = join(['figs/', str, '_Xfit.eps']);
% print(gcf, filename, '-depsc2', '-r300');
% 
% save('Data/450ks_fix.mat', 'vals', 'dlms')
%save('475fit.mat', 'theta', 'theta_A', 'theta_B', 'dtime', 'dt', 'tN');

% filename = join(['Data/', temps_strings{t}, 'ks_stoch.mat']);
% save(filename, 'vals', 'dlms')
%save('475fit_stoch.mat', 'theta', 'theta_A', 'theta_B', 'dtime', 'dt', 'tN');
