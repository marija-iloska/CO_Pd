clear all
close all
clc

% STEP 1
% Get fitting for 450K COV vs WV
load Data/weights450isotherm.mat

% STEP 2
% Load  data
load Data/area_ref490.mat
load Paper2_data/my_areas.mat
load Data/wv.mat
load Data/temps_info.mat

%area = area_mat;

% Molar absorptivity at saturation
range = 20;

% Get a window
lim = 10;
move = 2;
% WV split
wv_split = wv_splits(1);
Pcw = Pc(2,:);



% Range through all temps
for n = 1:N

    % Reset vars
    clear cov
    L = length(area{n});
    wv_padded{n} = wv_padded{n}(1:L);
    time_padded{n} = time_padded{n}(1:L);

    % Find indices for low and high regions
    idx0 = find(wv_padded{n} < wv_split);
    idx1 = find(wv_padded{n} > wv_split);


    % EPSILON SAT_______________________________________________
    % Get mean area at saturation
    mean_area_sat(n) = mean( area{n}( (tp_idx - range) : (tp_idx) ));

    % Get epsilon saturation
    epsilon_sat(n) = mean_area_sat(n)/cov_sat(n);


    % COVERAGES_______________________________________________
    % Convert half half
    cov(idx1) = polyval(Pcw, wv_padded{n}(idx1));
    cov(idx0) = zeros(1, length(idx0));


    % WINDOWS
%     if (ismember(n, [1,4]))
%         range1{n} = idx1(end - lim -5 :end-3);
%     elseif n == 3
%         range1{n} = idx1(end - lim-8 :end-1);
%     else
%         range1{n} = idx1(end - lim :end-1);
%     end
%     if n==1
%         range1{n} = idx1(end - lim-5 :end-3);
%     elseif n==3
%         range1{n} = idx1(end - 2: end);
%     else 
%         range1{n} = idx1(end - lim-3 :end-2);
%     end
    range1{n} = idx1(end - lim : end-move);
%     if (n==3)
%         range1{n} = idx1(end - lim - 6 : end);
%     end
% 
%     if n==6
%         range1{n} = idx1(end-1);
%     end

    % EPSILON SPLIT_______________________________________________
    mean_cov_split(n) = mean( cov(range1{n}));
    mean_area_split(n) = mean( area{n}(range1{n}+1) );
    epsilon_exp(n) = mean_area_split(n) / mean_cov_split(n);


    % Find rest
    cov(idx0) = area{n}(idx0)./epsilon_exp(n);

    % Store vars
    cov_all{n} = cov;
    range_all{n} = range1{n};

end


%% Plot settings
lg = [18, 166, 119]/256;
lb = [35, 124, 219]/256;
lr = [209, 25, 99]/256;
lwd = 2;
sz = 10;

% WINDOWS plot
figure;
for n = 1:N    
    subplot(2,3, n)
    plot(time_padded{n}, cov_all{n}, '.', 'Color', 'k', 'MarkerSize', sz)
    hold on
    plot(time_padded{n}, area{n}, '.', 'Color', lr, 'MarkerSize', sz)
    hold on
    xline(time_padded{n}(range_all{n}(1)), 'Color', lb, 'linewidth',lwd)
    hold on
    xline(time_padded{n}(range_all{n}(end)), 'Color', lb,'linewidth',lwd)
    hold on
    xline(time_padded{n}(tp_idx-range), 'Color', lg, 'linewidth',lwd)
    hold on
    xline(time_padded{n}(tp_idx), 'Color', lg, 'linewidth',lwd)
    hold on
    yline(0.24, 'linewidth', 1)
    set(gca, 'FontSize', 15)
    xlabel('Time', 'FontSize',13)
    title(join( [temps_strings{n}, 'K', ' Windows']) ,'FontSize',16)
    legend('Coverage', 'Area', 'FontSize',15)
    grid on
end

%%
% RAW AREA
save('Absorptivity/my_epsilons.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
save('Absorptivity/my_mean.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')

% Zubin area data
% save('Absorptivity/epsilons490.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
% save('Absorptivity/my_mean.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')


% % NORMALIZED AREA
%save('Absorptivity/mean_norm_area.mat', 'mean_area_split', 'mean_area_sat', 'mean_cov_split')
%save('Absorptivity/epsilons_mat_norm.mat', 'epsilon_sat', 'epsilon_exp', 'wv_split', 'tp_idx')
