clc 
clear all
close all

% Load the data where I saved the interpolated coverage points based on the
% digitized Pressure - Coverage Isotherms. I interpolated points for
% different pressures
%load Ptc.mat
load P_extrap.mat
load inferred.mat
% In this code, I'm interpolating at temperatures I want to get the saturation
% coverage using the Cov and Temps from the German paper at P = 1e-5 mbar

%cov_sat = interp1(T,cov, [450, 460, 470, 475, 480, 490]);

temps_strings = {'450 int', '460 int', '470 int', '475 int', '480 int', '490 int'};
%save('expected_coverage.mat', "cov_sat")

str = {'450K int', '460K int', '470K int', '475K int', '480K int', '490K int', '448K', '453K', '493K'};

T_interest = [450, 460, 470, 475, 480, 490];

for p = 1:length(P)

    % Here I extrapolate to get the coverages at P = 1e-5;
    covp(p,:) = interp1(T, cov3(:,p)', T_interest);

end

% For only 450K plot
% str = {'450 int', '448K dig', '453K dig', '493K dig'};
% T_interest = [450];
% clear h

% Plot ISOTHERMS
N = length(T_interest);
c= 0.7;
bb = [0 c c];
rr = [c 0 0];
gr = [0 c 0];
mm = [c 0 c];
yy = [0 0 c];


col = {bb, rr, gr, mm, yy, [220, 200, 0]/256};
for i = 1:N
    figure(1)
    h(i) = plot(P(1:end), covp(1:end,i), '.', 'MarkerSize', 20, 'Color', col{i});
    hold on
    plot(P(1:end), covp(1:end,i), '-', 'Color', col{i}, 'Linewidth', 0.5, 'LineStyle','--')
    hold on

end

for i = 1:3

%     h(N+i) = plot(p_raw{i}, cov_raw{i}, 'Linewidth', 1.5, 'Color', 'k');
%     hold on
    %plot(P, cov3(i,:), 'Linewidth', 1.5, 'Color', 'k');
    h(N+i) = plot(p_all{i}, cov_all{i}, 'Linewidth', 1.5, 'Color', 'k');
    hold on

end
xlim([0, 1.2e-5])
xline(1e-5, 'Color', 'k', 'LineStyle','--', 'LineWidth', 2)
legend(h, str, 'FontSize', 15)
set(gca, 'FontSize', 20)
xlabel('Pressure [mbar]', 'FontSize', 20)
ylabel('Coverage [ML]', 'FontSize', 20)
grid on




