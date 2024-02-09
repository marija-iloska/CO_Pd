% Clear
clear all
close all
clc

% Load data
P = 0.001;
load ../DataConversion/Data/cov_time_noise.mat
load ../DataConversion/Data/temps_info.mat


t = 5;
cov = cov_all{t};
time = time{t};
str = temps_strings{t};


%% Process Data
% Get system divisions
cut_off1 = 0.25;
tp_AB = find(cov > cut_off1);
tp_AB = [tp_AB(1), tp_AB(end)];


% Delta Time
dt = [0, time(2:end)' - time(1:end-1)'];
dtime = 0.01 : 0.03 : 12;
tN = 1:length(cov);


% Get individual coverages
[M, covA, covB] = get_sat(cov, tN, tp_AB, cut_off1);



% Get k constants
[k_oB, k_Bo, k_AB, k_BA, dlms] = get_knew(cov, time, covA, covB, dt, tp_idx, tp_AB, tN(end), P, M);
%[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k(cov, time, covA, covB, dt, tp_idx, tp_AB, tN(end), P, M);

%vals = [ k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA];
vals = [ k_oB, k_Bo,  k_AB, k_BA];

% Store stats to excel file
%write_out(str, dlms, vals);

% Get fitting (simulation)
[theta_A, theta_B] = fitting(cov, covA, covB, dtime, time, vals, tp_AB, tp_idx, M, P);


theta = theta_A + theta_B;
dtime(end)=[];


%% Plotting 
lwd = 2.5;
sz = 30;
fsz = 35;

purple = [132, 53, 148]/256;
blue = [62, 158, 222]/256;
green = [44, 199, 114]/256;
tq = [50, 230, 191]/256;
gd = [196, 191, 24]/256;

figure
subplot(1,3,2)
str_B = 'Coverage B [ML]';
str_A = 'Coverage A [ML]';
str_X = 'Coverage [ML]';
plotting(covB, theta_B, time, dtime, tp_idx, sz, lwd, str_B, str, cut_off1, gd)

subplot(1,3,3)
plotting(covA, theta_A, time, dtime, tp_idx, sz, lwd, str_A, str, cut_off1, gd)

subplot(1,3,1)
plotting(cov, theta, time, dtime, tp_idx, sz, lwd, str_X, str, cut_off1, gd)

sgtitle(strcat(str,'K'), 'FontSize', 40)
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.4, 0.5, 0.6, 0.35]);
 
% filename = join(['figs/', str, '_Xfit.eps']);
% print(gcf, filename, '-depsc2', '-r300');
