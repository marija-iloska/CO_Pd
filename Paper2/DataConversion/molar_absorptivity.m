clear all
close all
clc

% This script converts WV to COV using the best polynomial fits for the
% FULL RANGE for both EXP and DFT

% Load data for conversion (choose Temp)
load Temps/490K.mat

clear epsilon_dft epsilon_exp

str_save = join(['Absorptivity/molar', str(1:3), 'k.mat']);


% Load the FN of conversion
load PolyFIT/poly_half_range_both.mat

% Load expected coverage (obtained from German paper)
load ExpectedCov/expected_coverage.mat

% Pressure on index
tp_idx = 45;

load(str_save)


% Molar absorptivity at saturation
range = 30;
epsilon_sat = mean(area((tp_idx - range) : (tp_idx)))/cov_sat(i);




%save(str_save, 'epsilon_sat', 'epsilon_exp', 'epsilon_dft')

%-----------------------
%           EXP 
%-----------------------

hidx = find(wv > 2000);
wv(hidx) = [];
time(hidx) = [];
area(hidx) = [];
tp_idx = tp_idx - sum(hidx < tp_idx);

lidx = find(wv < 1700);
wv(lidx) = [];
time(lidx) = [];
area(lidx) = [];
tp_idx = tp_idx - sum(lidx < tp_idx);



% Find indices for low and high regions
idx0 = find(wv < wv_split_exp);
idx1 = find(wv > wv_split_exp);


% Convert half half
covE(idx1) = polyval(E1, wv(idx1));
covE(idx0) = zeros(1, length(idx0));

% Outlier Limits
high = cov_sat(i)+ 0.04;
low = 0;


% % Remove outliers
[covE, timeE, areaE, wvE, tp_idxE, idx0, idx1] = outliers(covE, time, area, wv, wv_split_exp, high, low, tp_idx);

% Get a window
range1 = 10;

mean_cov = mean(covE( idx1(end-range1 : end) ));
mean_area = mean(areaE( idx1(end-range1 : end) ));

epsilon_obt = mean_area / mean_cov;

% Find rest
eps_test = epsilon_obt;
covE(idx0) = area(idx0)./eps_test;


% Visualize range
figure(1)
plot(timeE, covE, '.', 'Color', 'k', 'MarkerSize', 7)
hold on
xline(timeE(tp_idxE-range))
hold on
xline(timeE(tp_idxE))


figure(2)
plot(timeE, covE, '.', 'Color', 'k', 'MarkerSize', 7)
hold on
xline(timeE(idx1(end-range1)))
hold on
xline(timeE(idx1(end-1)))











%-----------------------
%           DFT
%-----------------------


% Find indices for low and high regions
% idx0 = find(wv < wv_split_dft);
% idx1 = find(wv > wv_split_dft);
% 
% 
% % Convert half half
% covD(idx1) = polyval(D1, wv(idx1));
% covD(idx0) = zeros(1, length(idx0));
% 
% % Outlier Limits
% high = cov_sat(i)+ 0.05;
% low = 0;
% 
% % Remove outliers
% [covD, timeD, tp_idxD] = outliers(covD, time, high, low, tp_idx);
% 
% 
% % Find rest
% idx0 = find(covD == 0);
% covD(idx0) = area(idx0)./epsilon_dft;




% Check Plot
figure(3)
plot(timeE, covE, '.', 'Color', 'm', 'MarkerSize', 12)
xlabel('Time', 'FontSize',13)
ylabel('Coverage', 'FontSize',13)
title(join( [str, '  PolyHALF']) ,'FontSize',13)
legend('EXP')
set(gca, 'FontSize', 13)
grid on

% Check Plot
% figure(3)
% plot(timeD, covD, '.', 'Color', 'b', 'MarkerSize', 12)
% xlabel('Time', 'FontSize',13)
% ylabel('Coverage', 'FontSize',13)
% title(join( [str, '  PolyHALF']) ,'FontSize',13)
% legend('DFT')
% set(gca, 'FontSize', 13)
% grid on






