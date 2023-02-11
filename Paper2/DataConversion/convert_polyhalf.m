clear all
close all
clc

% This script converts WV to COV using the best polynomial fits for the
% FULL RANGE for both EXP and DFT

% Load data for conversion (choose Temp)
load Temps/460K.mat

% Load the FN of conversion
load PolyFIT/poly_half_range_both.mat

% Load expected coverage (obtained from German paper)
load ExpectedCov/expected_coverage.mat


%-----------------------
%           EXP 
%-----------------------

% Find indices for low and high regions
idx0 = find(wv < wv_split_exp);
idx1 = find(wv > wv_split_exp);

% Convert half half
covE(idx0) = polyval(E0, wv(idx0));
covE(idx1) = polyval(E1, wv(idx1));


% Outlier Limits
high = cov_sat(i)+ 0.1;
low = 0;
tp_idx = 45;

% Remove outliers
[covE, timeE, tp_idxE] = outliers(covE, time, high, low, tp_idx);



%-----------------------
%           DFT 
%-----------------------

% Find indices for low and high regions
idx0 = find(wv < wv_split_dft);
idx1 = find(wv > wv_split_dft);

% Convert half half
covD(idx0) = polyval(D0, wv(idx0));
covD(idx1) = polyval(D1, wv(idx1));

% Outlier Limits
high = cov_sat(i)+ 0.05;
low = 0;


% Remove outliers
[covD, timeD, tp_idxD] = outliers(covD, time, high, low, tp_idx);


%-----------------------
%          PLOT 
%-----------------------

% Pressure on
tp_idx = 45;

% Plot
plot(timeD, covD, '.', 'MarkerSize', 12, 'Color', 'k')
hold on
plot(timeE, covE, '.', 'Color', 'm', 'MarkerSize', 12)
xlabel('Time', 'FontSize',13)
ylabel('Coverage', 'FontSize',13)
title(join( [str, '  PolyFULL']) ,'FontSize',13)
legend('DFT', 'EXP')
set(gca, 'FontSize', 13)
grid on

% Rename vars with temp to make easier
% For COV
strV = erase(str, ' K');
temp = join(['covD', strV]);
assignin('base', temp, covD);

% For TIME
time_temp = join(['timeD', strV]);
assignin('base', time_temp, timeD);

%save( join( ['Converted/', str, '_polyhalf.mat'] ), temp, time_temp)
