clear all
close all
clc

% STEP 1
% Get fitting for 450K COV vs WV
load 'weights450isotherm.mat'

% STEP 2
% Load raw data
load Temps/all_temps.mat

% Load expected coverage
load ExpectedCov/expected_coverage.mat

% Pressure on index
tp_idx = 45;

% Molar absorptivity at saturation
range = 30;

% Get a window
lim = 10;

% WV split
wv_split = 1840;
Pcw = Pc(2,:);


% Range through all temps
for n = 1:1

    % Reset vars
    clear cov

    % Find indices for low and high regions
    idx0 = find(wv{n} < wv_split);
    idx1 = find(wv{n} > wv_split);


    % EPSILON SAT_______________________________________________
    % Get mean area at saturation
    mean_area_sat(n) = mean( area{n}( (tp_idx - range) : (tp_idx) )); 

    % Get epsilon saturation
    epsilon_sat(n) = mean_area_sat(n)/cov_sat(n);


    % COVERAGES_______________________________________________
    % Convert half half
    cov(idx1) = polyval(Pcw, wv{n}(idx1));
    cov(idx0) = zeros(1, length(idx0));
    
    % Get mean area at split
    range1 = idx1(end-lim-15 : end-15);
    %range1 = idx1(end - lim): idx1(end- 2);
    
    % Get epsilon at split
    mean_cov_split(n) = mean( cov(range1));
    mean_area_split(n) = mean( area{n}(range1) );
    epsilon_exp(n) = mean_area_split(n) / mean_cov_split(n);

       
    % Find rest
    cov(idx0) = area{n}(idx0)./epsilon_exp(n);
    
    % Store vars
    cov_all{n} = cov;
    range_all{n} = range1;

end



lg = [18, 166, 119]/256;
lb = [35, 124, 219]/256;
lr = [209, 25, 99]/256;
lwd = 2;
sz = 10;

% Choose temperature
% 1:450  2:460  3:470   4:475  5:480  6:490
n = 1;

% WINDOWS plot
figure(2)
plot(time_wv{n}, cov_all{n}, '.', 'Color', 'k', 'MarkerSize', sz)
hold on
% plot(time_area{n}, area{n}, '.', 'Color', lr, 'MarkerSize', sz)
% hold on
xline(time_area{n}(range_all{n}(1)), 'Color', lb, 'linewidth',lwd)
hold on
xline(time_area{n}(range_all{n}(end)), 'Color', lb,'linewidth',lwd)
hold on
xline(time_area{n}(tp_idx-range), 'Color', lg, 'linewidth',lwd)
hold on
xline(time_area{n}(tp_idx), 'Color', lg, 'linewidth',lwd)
set(gca, 'FontSize', 15)
xlabel('Time', 'FontSize',13)
title(join( [temps_strings{n}, 'K', ' Windows']) ,'FontSize',16)
legend('Coverage', 'Area', 'FontSize',13)
grid on


%save('epsilons.mat', 'epsilon_sat', 'epsilon_exp')
%save('450info.mat', 'cov', 'epsilon_exp', 'epsilon_sat', 'cov_sat', 'wv_split', 'tp_idx');

