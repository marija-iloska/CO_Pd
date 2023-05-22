clear all
close all
clc

% STEP 1
% Get fitting for 450K COV vs WV
load weights450isotherm.mat

% STEP 2
% Load  data
load area_ref490_MA5.mat
load wv_MA5.mat
load temps_info.mat

% Molar absorptivity at saturation
range = 28;

% Get a window
lim = 7;

% WV split
wv_split = wv_splits(1);
Pcw = Pc(2,:);



% Range through all temps
for n = 1:N

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
    move = 1;
    range1{1} = idx1(end-lim : end-move); % 450
    range1{2} = idx1(end - lim :end-move-2); % 460
    range1{3} = idx1(end - lim + 3: end-move);
    range1{4} = idx1(end - lim + 3: end-move);
    range1{5} = idx1(end - lim: end-move);
    range1{6} = idx1(end - lim : end-move);



    % Get epsilon at split
    mean_cov_split(n) = mean( cov(range1{n}));
    mean_area_split(n) = mean( area{n}(range1{n}) );
    epsilon_exp(n) = mean_area_split(n) / mean_cov_split(n);


    % Find rest
    cov(idx0) = area{n}(idx0)./epsilon_exp(n);
    %cov(cov > 0.45) = cov_sat(n);

    % Store vars
    cov_all{n} = cov;
    range_all{n} = range1{n};

end


% Plot settings
lg = [18, 166, 119]/256;
lb = [35, 124, 219]/256;
lr = [209, 25, 99]/256;
lwd = 2;
sz = 10;

% WINDOWS plot
for n = 1:N
    figure;
    plot(time_mat_area{n}, cov_all{n}, '.', 'Color', 'k', 'MarkerSize', sz)
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
end

% RAW AREA
%save('epsilons_mat.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
%save('mean_mat_area.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')


% NORMALIZED AREA
%save('mean_norm_area.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')
save('epsilons_mat_norm.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
