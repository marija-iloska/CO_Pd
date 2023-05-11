clear all
close all
clc

% STEP 1
% Get fitting for 450K COV vs WV
load 'weights450isotherm.mat'

% STEP 2
% Load raw data
%load Temps/all_temps.mat
load Temps/T3.mat
area = area_mat;

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

for i = 1:N
    area{i} = movmean(area{i}, 5);
end

wv = wv_dat;


% Range through all temps
for n = 1:N

    if (n <= 3)
        Pcw = Pc(2,:);
    else
        load weights490isotherm.mat
        Pcw = Pc(2,:);
    end
        

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
    range1{1} = idx1(end-lim : end); % 450
    range1{2} = idx1(end - lim :end - 3); % 460
    range1{6} = idx1(end - 4 : end);
    range1{3} = idx1(end - lim: end);
    range1{4} = idx1(end - lim: end-3);
    range1{5} = idx1(end - 7: end-3);


    
    % Get epsilon at split
    mean_cov_split(n) = mean( cov(range1{n}));
    mean_area_split(n) = mean( area{n}(range1{n}) );
    epsilon_exp(n) = mean_area_split(n) / mean_cov_split(n);

       
    % Find rest
    cov(idx0) = area{n}(idx0)./epsilon_exp(n);
    cov(cov > 0.45) = cov_sat(n);
    
    % Store vars
    cov_all{n} = cov;
    range_all{n} = range1{n};

end



lg = [18, 166, 119]/256;
lb = [35, 124, 219]/256;
lr = [209, 25, 99]/256;
lwd = 2;
sz = 10;

% Choose temperature
% 1:450  2:460  3:470   4:475  5:480  6:490
n = 6;

% WINDOWS plot
figure(2)
plot(time_wv{n}, cov_all{n}, '.', 'Color', 'k', 'MarkerSize', sz)
hold on
plot(time_mat_area{n}, area{n}, '.', 'Color', lr, 'MarkerSize', sz)
hold on
xline(time_wv{n}(range_all{n}(1)), 'Color', lb, 'linewidth',lwd)
hold on
xline(time_wv{n}(range_all{n}(end)), 'Color', lb,'linewidth',lwd)
hold on
xline(time_wv{n}(tp_idx-range), 'Color', lg, 'linewidth',lwd)
hold on
xline(time_wv{n}(tp_idx), 'Color', lg, 'linewidth',lwd)
set(gca, 'FontSize', 15)
xlabel('Time', 'FontSize',13)
title(join( [temps_strings{n}, 'K', ' Windows']) ,'FontSize',16)
legend('Coverage', 'Area', 'FontSize',20)
grid on

%save('epsilon_abs.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
save('epsilons_mat.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
%save('epsilons.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
%save('450info.mat', 'cov', 'epsilon_exp', 'epsilon_sat', 'cov_sat', 'wv_split', 'tp_idx');
%save('mean_abs_area.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')
%save('mean_mat_area.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')
