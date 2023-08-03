clear all
close all
clc

% Hoffman paper data
cov_hf = [0.013038885 0.029151625 0.058573858 0.080991927 0.094303115 0.121633928 ...
    0.181878323 0.240725613 0.297527809 0.319248739 0.409326644 0.419216537 0.450801937 0.478862092 0.505523448];

wv_hf =[1822.817992 1822.930359 1822.958833 1823.174076 1823.380506 1825.148891 ...
    1825.013643 1825.554463 1835.770724 1836.565937 1906.911174 1921.049777 1931.628731 1938.333305 1945.423623];

load Paper2/DataConversion/ExpectedCov/P_extrap.mat

% OUR data
cov = [0.087 0.197 0.24 0.328 0.357 0.408 0.425 0.455];
wv = [1820 1830.15466 1834.01168 1861.0108 1872.58185 1891.86694 1897.65246 1913.08053];


% % COV vs WV
% figure
% plot(wv_hf, cov_hf, '.', 'Color', 'k', 'MarkerSize',22)
% hold on
% plot(wv, cov, '.', 'Color', 'm', 'linewidth',2,'MarkerSize',22)
% hold on
% plot(wv_hf, cov_hf, 'Color', 'k')
% hold on
% plot(wv, cov, 'Color', 'm')
% set(gca, 'FontSize', 15)
% xlabel('Wavenumber [cm^-^1]', 'FontSize', 15)
% ylabel('Coverage [ML]', 'FontSize', 15')
% xlim([1810, 1950])
% legend('Reference data', 'Obtained data', 'FontSize', 15)
% grid on

pp = [135, 79, 194]/256;

% P vs WV
idx = 1:8;
figure
plot(P(idx), wv(idx), '.', 'Color', pp, 'MarkerSize',30)
hold on
plot(P(idx), wv(idx), 'Color', 'm')
set(gca, 'FontSize', 15)
ylabel('Wavenumber [cm^-^1]', 'FontSize', 15)
xlabel('Pressure [mbar]', 'FontSize', 15')
grid on
legend('Experimental data', 'FontSize', 20)