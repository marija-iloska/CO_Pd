clear all
close all
clc


% CONVERT data ONLY USING AREA

% Load data for conversion (choose Temp)
load Temps/490K.mat

% Load the FN of conversion
load PolyFIT/poly_half_range_both.mat

% Load expected coverage (obtained from German paper)
load ExpectedCov/expected_coverage.mat

% Load absorptivities
% Create load string
str_load = join(['Absorptivity/molar', str(1:3), 'k.mat']);
load(str_load)


% Only each
cov_exp = area./epsilon_exp;
cov_dft = area./epsilon_dft;
cov_sat = area./epsilon_sat;

%str_save = join(['Converted/AREA/cov', str(1:3), 'Asat.mat']);
%save(str_save, 'cov_sat', 'time')


red = [214, 9, 9]/256;
blue = [32, 129, 227]/256;

% Check Plot
sz = 10;
figure(1)
plot(time, cov_exp, '.', 'Color', blue, 'MarkerSize', sz)
hold on
plot(time, cov_dft, '.', 'Color', red, 'MarkerSize', sz)
hold on
plot(time, cov_sat, '.', 'Color', 'k', 'MarkerSize', sz)
xlabel('Time', 'FontSize',13)
ylabel('Coverage', 'FontSize',13)
title(join( [str, ' Area Only']) ,'FontSize',14)
legend('EXP', 'DFT', 'SAT')
set(gca, 'FontSize', 18)
grid on