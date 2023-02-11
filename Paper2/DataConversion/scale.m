clear all
close all
clc

% Load expected saturation coverage from German paper
load ExpectedCov/expected_coverage.mat

% Load converted data
load Converted/'470 K_polyfull.mat'


% Scaling factor
c = cov_sat(i)/ max(covD470);

% Scale
covD470_sc = covD470*c;

%save('Converted/490K_polyfull_scaled.mat', "covD490_sc", 'timeD490')

 
% Plot
plot(timeD470, covD470, '.', 'MarkerSize', 12, 'Color', 'k')
hold on
plot(timeD470, covD470_sc, '.', 'Color', 'm', 'MarkerSize', 12)
xlabel('Time', 'FontSize',13)
ylabel('Coverage', 'FontSize',13)
title('470 K' ,'FontSize',13)
legend('DFT polyFULL', 'DFT poluFULL scaled')
set(gca, 'FontSize', 13)
grid on