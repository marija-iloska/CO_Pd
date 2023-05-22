clear all
close all
clc

% Load dft data  and  Breadshaw paper exp data
% This is unscaled DFT data
load wv_cv.mat

% Interpolate WV exp points for the selected COV input
wv_exp_interp = interp1(cov_exp, wv_exp, cov);

% Scaling factor
c1 = sum(wv.*wv_exp_interp)/sum(wv.^2);

% Get scaled WV
wv_scaled = wv*c1;
wv_dft = wv_scaled;

%save('exp_dft_data.mat', 'wv_dft', 'cov_dft', "wv_exp", 'cov_exp')


% VISUALIZE

% Plot compare EXP and EXP interpolated
figure(1)
plot(cov, wv_exp_interp, '.', 'MarkerSize', 20, 'Color', [0.8,0.4,0])
hold on
plot(cov_exp, wv_exp, '.', 'MarkerSize', 20, 'Color', [0,0.5,0.8])
set(gca,'Ydir','reverse', 'FontSize', 12)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('EXP interpolated', 'EXP', 'FontSize', 15)
grid on


% Plot compare DFT and EXP data
figure(2)
plot(cov, wv_dft, '.', 'MarkerSize', 20, 'Color', [0.8,0,0])
hold on
plot(cov_exp, wv_exp, '.', 'MarkerSize', 20, 'Color', [0,0.5,0.8])
set(gca,'Ydir','reverse', 'FontSize', 12)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('DFT', 'EXP', 'FontSize', 15)
grid on