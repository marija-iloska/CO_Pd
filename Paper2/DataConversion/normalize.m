clear all
close all
clc

% Coverage at saturation
load ExpectedCov/expected_coverage.mat

% Mean area at saturation
load Absorptivity/mean_area.mat
%load mean_abs_area.mat
load mean_mat_area.mat

% Our data
load Temps/T3.mat

% Temperatures 450 460 and 490
idx = [1,2,6];
cov_sat_temps = cov_sat(idx);
% area_sat_temps = mean_area_sat(idx);

% Try for 450 K
for n = 1:N
    timeA = time_area{n};
    %A = area_abs{n};
     A = movmean(area_mat{n}, 5);
    cov = A*cov_sat_temps(n)./mean_area_sat(n);
   
    %cov = A*cov_sat_temps(n)./area_sat_temps(n);
    plot(timeA, cov, 'linewidth', 1)
    hold on

end
set(gca, 'FontSize', 20)
legend('450', '460', '490', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title('Area-MAT')
grid on







