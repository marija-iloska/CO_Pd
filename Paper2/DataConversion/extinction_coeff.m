clear all
close all
clc

% This script computes MOLAR ABSORPTIVITIES for all temperatures and 
% converts to coverage using HALF WV linear fit HALF Area

% Both EXP or DFT reference data can be used


% Load the FN of conversion
%load PolyFIT/poly_half_range_both.mat

% Load expected coverage (obtained from German paper)
load ExpectedCov/expected_coverage.mat

% Pressure on index
tp_idx = 45;

% Molar absorptivity at saturation
range = 30;

% Get a window
lim = 7;


% Temps
temp_strings = {'450', '460', '470', '475', '480', '490'};
N = length(temp_strings);


%-------------------------
%      EXP vs DFT
%-------------------------

% Outliers ranges
o_up = 2000;
o_down = 1700;

% WV split
wv_split = 1838;

% Polynomial Fitting
load weights450.mat
P = Pc(2,:);
%P = str2var(join(['P_', method]));


% Range through all temps
for n = 1:N

    % Reset vars
    clear cov time wv area

    % Load temp data__________________________________________
    temp_data = join(['Temps/', temp_strings{n}, 'K.mat']);
    load(temp_data)

    % Outliers_______________________________________________
    hidx = find(wv > o_up);
    wv(hidx) = [];
    time(hidx) = [];
    area(hidx) = [];
    tp_idx = tp_idx - sum(hidx < tp_idx);
    
    lidx = find(wv < o_down);
    wv(lidx) = [];
    time(lidx) = [];
    area(lidx) = [];
    tp_idx = tp_idx - sum(lidx < tp_idx);


    % Find indices for low and high regions
    idx0 = find(wv < wv_split);
    idx1 = find(wv > wv_split);


    % EPSILON SAT_______________________________________________
    % Get mean area at saturation
    mean_area_sat(n) = mean( area( (tp_idx - range) : (tp_idx) )); 

    % Get epsilon saturation
    epsilon_sat(n) = mean_area_sat(n)/cov_sat(n);


    % COVERAGES_______________________________________________
    % Convert half half
    cov(idx1) = polyval(P, wv(idx1));
    cov(idx0) = zeros(1, length(idx0));
    
    % Outlier Limits
    high = cov_sat(n)+ 0.04;
    low = 0;
    
    % Remove outliers
    [cov, time, area, wv, tp_idx, idx0, idx1] = outliers(cov, time, area, wv, wv_split, high, low, tp_idx);

    % Get mean area at split
    range1 = idx1(end-lim-1 : end-1);
    
    % Get epsilon at split
    mean_cov_split(n) = mean( cov(range1));
    mean_area_split(n) = mean( area(range1) );
    epsilon(n) = mean_area_split(n) / mean_cov_split(n);

       
    % Find rest
    cov(idx0) = area(idx0)./epsilon(n);
    
    % Store vars
    cov_all{n} = cov;
    time_all{n} = time;
    tp_idx_all{n} = tp_idx;
    area_all{n} = area;
    wv_all{n} = wv;
    range_all{n} = range1;


end

% Create correct epsilon string/variable for saving
%epsilon_str = join(['epsilon_', method]);

% Assign the computed value
%assignin('base', epsilon_str, epsilon);


%save('Absorptivity/molar_new.mat', 'epsilon', 'epsilon_sat')
%save('Absorptivity/molar_abs.mat', 'epsilon_sat', 'epsilon_exp', 'epsilon_dft')
%save('Absorptivity/mean_area.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split', 'cov_sat', epsilon_str)
%save(join(['Converted/half_area_', method,'.mat']), 'cov_all', 'time_all', 'tp_idx_all', 'area_all', 'wv_all')


lg = [18, 166, 119]/256;
lb = [35, 124, 219]/256;
lr = [209, 25, 99]/256;
lwd = 2;
sz = 10;

% Choose temperature
% 1:450  2:460  3:470   4:475  5:480  6:490
n = 4;

% WINDOWS plot
figure(2)
plot(time_all{n}, cov_all{n}, '.', 'Color', 'k', 'MarkerSize', sz)
hold on
plot(time_all{n}, area_all{n}, '.', 'Color', lr, 'MarkerSize', sz)
hold on
xline(time_all{n}(range_all{n}(1)), 'Color', lb, 'linewidth',lwd)
hold on
xline(time_all{n}(range_all{n}(end)), 'Color', lb,'linewidth',lwd)
hold on
xline(time_all{n}(tp_idx-range), 'Color', lg, 'linewidth',lwd)
hold on
xline(time_all{n}(tp_idx), 'Color', lg, 'linewidth',lwd)
set(gca, 'FontSize', 15)
xlabel('Time', 'FontSize',13)
title(join( [temp_strings{n}, 'K', ' Windows']) ,'FontSize',16)
legend('Coverage', 'Area', 'FontSize',13)
grid on



% COVERAGE vs TIME  Plots
% figure(3)
% plot(time_all{n}, cov_all{n}, '.', 'Color', 'm', 'MarkerSize', 12)
% xlabel('Time', 'FontSize',13)
% ylabel('Coverage', 'FontSize',13)
% title(join( [temp_strings{n}, 'K', ' PolyHALF']) ,'FontSize',13)
% legend('EXP')
% set(gca, 'FontSize', 13)
% grid on




