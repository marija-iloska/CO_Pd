clear all
close all
clc

% This code fits Cov with WV using DFT and/or EXP data 
% It has HALF-HALF and FULL RANGE polynomial fitting (including line)
%_______________________________________________________________________



% Load DFT data and EXP Hoffman paper data
load ../exp_dft_data.mat

% -----------------------------------------------
%               POLYFIT HALF HALF
% -----------------------------------------------

% DFT________________________________

% Get splitting coverage 
cov_split_dft = 0.3;

% Choose wavenumber test range
wv_test = 1805 : 2 : 1960;

% Degree of polynomials
degD0 = 1;
degD1 = 1;

% Get half half fitting
[covD0, covD1, wvD0, wvD1, wv_split_dft, D0, D1] = polyfit_half_half(cov_dft, wv_dft, cov_split_dft, wv_test, degD0, degD1);


% Visualize fitting
% Plotting params
lwd = 1.5;

% Plot
figure(1)
scatter(cov_dft, wv_dft, 'r', 'filled')
hold on
plot(covD0, wvD0, 'Color', 'k', 'LineWidth', lwd)
set(gca, 'Ydir', 'reverse')
hold on
plot(covD1, wvD1, 'LineWidth', lwd)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('DFT', join(['P_', num2str(degD0)]), join(['P_', num2str(degD1)]), 'FontSize', 15)
grid on



% % EXP________________________________

% Get splitting coverage 
cov_split_exp = 0.3;

% Choose wavenumber test range
wv_test = 1820.5 : 1 : 1950;

% Degree of polynomials
degE0 = 1;
degE1 = 1;

% Get half half fitting
[covE0, covE1, wvE0, wvE1, wv_split_exp, E0, E1] = polyfit_half_half(cov_exp, wv_exp, cov_split_exp, wv_test, degE0, degE1);



% Visualize fitting
% Plot
figure(2)
scatter(cov_exp, wv_exp, 'r', 'filled')
hold on
plot(covE0, wvE0, 'Color', 'k', 'LineWidth', lwd)
set(gca, 'Ydir', 'reverse')
hold on
plot(covE1, wvE1, 'LineWidth', lwd)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('EXP', join(['P_', num2str(degE0)]), join(['P_', num2str(degE1)]), 'FontSize', 15)
grid on

% Save both for HALF ranges
%save('poly_half_range_both.mat', 'E0', 'E1', 'D1', 'D0', 'wv_split_exp', 'wv_split_dft')


% ------------------------------------------------
%               POLYFIT FULL RANGE
% ------------------------------------------------

% % DFT________________________________ 

%  Comparing what Poly degree is best

%  Polynomial fit
D3 = polyfit(wv_dft, cov_dft, 3);
D4 = polyfit(wv_dft, cov_dft, 4);
D5 = polyfit(wv_dft, cov_dft, 5);



% Test model
wv_test = 1800:2:1950;

% Evaluate fitting
covD3 = polyval(D3, wv_test);
covD4 = polyval(D4, wv_test);
covD5 = polyval(D5, wv_test);


% % EXP________________________________ 

%  Polynomial fit
E3 = polyfit(wv_exp, cov_exp, 3);
E4 = polyfit(wv_exp, cov_exp, 4);
E5 = polyfit(wv_exp, cov_exp, 5);

% Evaluate fitting
covE3 = polyval(E3, wv_test);
covE4 = polyval(E4, wv_test);
covE5 = polyval(E5, wv_test);



def_b = [0, 0.4470, 0.741];
lwd = 1.5;

% Plotting all DFT res
figure(3)
plot(cov_dft, wv_dft, '.', 'MarkerSize',20, 'Color', [0,0,0.8])
hold on
plot( covD3, wv_test, 'g', 'linewidth', lwd)
hold on
plot( covD4, wv_test, 'k', 'linewidth', lwd)
hold on
plot( covD5, wv_test, 'Color', 'r', 'linewidth', lwd)
set(gca,'Ydir','reverse', 'FontSize', 12)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('DFT', 'D3', 'D4', 'D5', 'FontSize', 15)
grid on
ylim([1780, 1960])
xlim([0, 0.6])


% Plotting all EXP res
figure(4)
plot(cov_exp, wv_exp, '.', 'MarkerSize',20, 'Color', [0.8,0,0])
hold on
plot(covE3, wv_test, 'g', 'linewidth', lwd)
hold on
plot(covE4, wv_test, 'k', 'linewidth', lwd)
hold on
plot(covE5, wv_test, 'Color', 'r', 'linewidth', lwd)
set(gca,'Ydir','reverse', 'FontSize', 12)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('EXP', 'E3', 'E4', 'E5', 'FontSize', 15)
grid on
ylim([1780, 1960])
xlim([0, 0.6])

 
% Best of both POLY choices compare
figure(5)
plot(covE4, wv_test, 'r', 'linewidth', lwd)
hold on
plot(covD3, wv_test, 'Color', def_b, 'linewidth', lwd)
hold on
plot(cov_dft, wv_dft, '.', 'MarkerSize', 20, 'Color', def_b)
hold on
plot(cov_exp, wv_exp, '.', 'MarkerSize', 20, 'Color', [0.8,0,0])
set(gca,'Ydir','reverse', 'FontSize', 12)
xlabel('Coverage', 'FontSize',20)
ylabel('Wavenumber', 'FontSize',20)
legend('P_E4', 'P_D3', 'DFT', 'EXP', 'FontSize', 15)
grid on
ylim([1780, 1960])
xlim([0, 0.6])

% Best full poly range EXP and DFT
%save('poly_full_range_both.mat', 'E4', 'D3' )

