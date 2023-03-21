clear all
close all
clc

load Absorptivity/molar_abs.mat
load Absorptivity/mean_area.mat

% Temperatures
T = [450, 460, 470, 475, 480, 490];

plot(T, cov_sat)
xlabel('Temperature')
ylabel('COV')


% Methods
method = {'dft',  'exp', 'sat'};
col = {'r',  'b',  'k'};
N = length(col);

% ABSORPTIVITIES___________________________________________
for n = 1:N

    epsilon_str = str2var(join(['epsilon_', method{n}]));

    figure(1)
    hi(n) = plot(T, epsilon_str, '.', 'Color', col{n}, 'MarkerSize', 20);
    hold on
    plot(T, epsilon_str, '-', 'Color', col{n}, 'MarkerSize', 12);
    hold on

end
xlabel('Temperatures', 'FontSize',20)
ylabel('Molar Absorptivity', 'FontSize', 20)
legend(hi, 'DFT',  'EXP', 'SAT', 'FontSize', 15)
set(gca, 'FontSize', 13)
grid on




% MEAN AREA PLOT___________________________________________

% Temps to include
idx = 1:length(T);
idx = setdiff(idx, 0);

% The plot
figure(2)
ha(1)= plot(T(idx), mean_area_split(idx), '.', 'Color', 'k', 'MarkerSize', 20);
hold on
plot(T(idx), mean_area_split(idx), '-', 'Color', 'k', 'MarkerSize', 12);
hold on
ha(2) = plot(T(idx), mean_area_sat(idx), '.', 'Color', 'm',  'MarkerSize', 20);
hold on
plot(T(idx), mean_area_sat(idx), '-',  'Color', 'm', 'MarkerSize', 12);
xlabel('Temperatures', 'FontSize',23)
ylabel('Mean Area', 'FontSize', 23)
legend(ha, 'At Split', 'At Saturation',  'FontSize', 18)
set(gca, 'FontSize', 13)
grid on




% COV vs EPSILON___________________________________________

% The plot
figure(3)
hc(1)= plot( cov_sat(idx), epsilon_sat(idx), '.', 'Color', 'k', 'MarkerSize', 20);
hold on
plot( cov_sat(idx), epsilon_sat(idx), '-', 'Color', 'k', 'MarkerSize', 12);
xlabel('Coverages', 'FontSize',23)
ylabel('Epsilon', 'FontSize', 23)
legend(hc, 'At Saturation', 'FontSize', 18)
set(gca, 'FontSize', 13)
grid on


