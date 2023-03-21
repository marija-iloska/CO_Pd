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


%save('expected_coverage.mat', "cov_sat")


for p = 1:length(P)

    % Here I extrapolate to get the coverages at P = 1e-5;
    covp(p,:) = interp1(T, cov3(:,p)', [450, 475, 490]);

end

T_interest = [450, 475, 490];


% Plot ISOTHERMS
figure(1)
h(1) = plot(P(1:end), covp(1:end,1), '.', 'MarkerSize', 20);
hold on
plot(P(1:end), covp(1:end,1), '-', 'Color', 'b', 'Linewidth', 0.5)
hold on
h(2) = plot(P(1:end), covp(1:end,2), '.', 'MarkerSize', 20)
hold on
plot(P(1:end), covp(1:end,2), '-', 'Color', 'r', 'Linewidth', 0.5)
hold on
h(3) = plot(P(1:end), covp(1:end,3), '.', 'MarkerSize', 20)
hold on
plot(P(1:end), covp(1:end,3), '-', 'Color', 'g', 'Linewidth', 0.5)
hold on
h(4) = plot(p_raw{1}, cov_raw{1}, 'Linewidth', 1.5, 'Color', 'k')
hold on
h(5) = plot(p_raw{2}(1:end), cov_raw{2}(1:end), 'Linewidth', 1.5, 'Color', 'k')
hold on
h(6) = plot(p_raw{3}(1:end), cov_raw{3}(1:end), 'Linewidth', 1.5, 'Color', 'k')
hold on
legend(h, '450K int', '475K int', '490K int', '448K paper', '453K paper', '493K paper', 'FontSize', 20)


