clc 
clear all
close all

% Load the data where I saved the interpolated coverage points based on the
% digitized Pressure - Coverage Isotherms. I interpolated points for
% different pressures
%load Ptc.mat
load P_extrap.mat

% In this code, I'm interpolating at temperatures I want to get the saturation
% coverage using the Cov and Temps from the German paper at P = 1e-5 mbar

%cov_sat = interp1(T,cov, [450, 460, 470, 475, 480, 490]);

temps_strings = {'450 int', '460 int', '470 int', '475 int', '480 int', '490 int'};
%save('expected_coverage.mat', "cov_sat")

str = {'450 int', '460 int', '470 int', '475 int', '480 int', '490 int', '448K paper', '453K paper', '493K paper'};

T_interest = [450, 460, 470, 475, 480, 490];


for p = 1:length(P)

    % Here I extrapolate to get the coverages at P = 1e-5;
    covp(p,:) = interp1(T, cov3(:,p)', T_interest);

end


% Plot ISOTHERMS
N = length(T_interest);
col = {'b', 'r', 'g', 'm', 'y', [150, 50, 180]/256};
for i = 1:N
    figure(1)
    h(i) = plot(P(1:end), covp(1:end,i), '.', 'MarkerSize', 20);
    hold on
    plot(P(1:end), covp(1:end,i), '-', 'Color', col{i}, 'Linewidth', 0.5)
    hold on

end

for i = 1:3

    h(N+i) = plot(p_raw{i}, cov_raw{i}, 'Linewidth', 1.5, 'Color', 'k');
    hold on

end
legend(h, str, 'FontSize', 20)
set(gca, 'FontSize', 20)
xlabel('Pressure', 'FontSize', 20)
ylabel('Coverage', 'FontSize', 20)
grid on




