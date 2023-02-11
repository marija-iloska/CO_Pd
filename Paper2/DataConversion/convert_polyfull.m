clear all
close all
clc

% This script converts WV to COV using the best polynomial fits for the
% FULL RANGE for both EXP and DFT

% Load data for conversion (choose Temp)
load Temps/450K.mat

% Load the FN of conversion
load PolyFIT/poly_full_range_both.mat

% Load expected coverage (obtained from German paper)
load ExpectedCov/expected_coverage.mat

% Convert Wv to Cov
covE = polyval(E4, wv);
covD = polyval(D3, wv);


% Pressure on
tp_idx = 45;

% Outlier Limits
high = cov_sat(i)+ 0.2;
low = 0;

[covE, timeE] = outliers(covE, time, high, low);

% Outlier Limits
high = cov_sat(i)+ 0.05;
low = 0;
[covD, timeD] = outliers(covD, time, high, low);


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

%save( join( ['Converted/', str, '_polyfull.mat'] ), temp, time_temp)
