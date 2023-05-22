clear all
close all
clc

% DESCRIPTION OF SCRIPT PURPOSE

% Load fitting for WV vs COV in regions
load weights450isotherm.mat

% Load molar absorptivities
load epsilons_mat_norm.mat

% Load data Area and Frequency
load area_ref490_MA5.mat
load wv_MA5.mat

% Load Temperature INFO
load temps_info.mat

% Number of region splits (R + 2 regions)
R = length(wv_splits);

% Include weights for lowest regions
Wf = [0, Wf];
Wa = 1 - Wf;

% Use original time with padding for WV
time_wv = time_mat_area;

% Loop for all temperatures
for n = 1:N

    % Reset variables
    clear cov cov_f cov_a id

    % Region indices based on WV fitting for derivatives
    id = region_indices(wv{n}, wv_splits, R);

    % GET COV( F )
    for r = 1:R+2
        if (r == 1)
            cov_f(id{r}) = 0;
        else
            cov_f(id{r}) = polyval(Pc(r-1,:), wv{n}(id{r}));
        end
    end

    % Get COV( A )
    cov_a_sat{n} = area{n}./epsilon_sat(n);
    cov_a_exp{n} = area{n}./epsilon_exp(n);
    cov_a_mid2{n} = 0.85*cov_a_exp{n} + 0.15*cov_a_sat{n};
    cov_a_mid3{n} = 0.15*cov_a_exp{n} + 0.85*cov_a_sat{n};


    % COV ( A ) importance
    cov_a = cov_a_sat{n};
    cov_a(id{1}) = cov_a_exp{n}(id{1});
    cov_a(id{2}) = cov_a_exp{n}(id{2});
    cov_a(id{2}) = cov_a_mid2{n}(id{2});
    cov_a(id{3}) = cov_a_mid3{n}(id{3});



    % Get COV(A + F)
    for r = 1:R+2
        cov(id{r}) = Wf(r)*cov_f(id{r}) + Wa(r)*cov_a(id{r});
    end
    % Set negative covs to 0s 
    cov(cov < 0) = 0;

    % Remove indices in cov( F ) that were padded with 0s
    cov_f(id{1}) = [];   
    time_wv{n}(id{1})=[];


    % STORE variables
    cov_mix{n} = cov;
    cov_f_all{n} = cov_f;
    cov_a_all{n} = cov_a;

    % Plot horizontal lines to observe the split changes
    range{n} = [cov(id{1}(end)), cov(id{2}(end)), cov(id{3}(end))];

end

% for n = 1:N
%     figure;
%     plot(time_mat_area{n}, cov_a_mid2{n}, 'k', 'linewidth', 1)
%     hold on    
%     plot(time_mat_area{n}, cov_a_mid3{n}, 'b', 'linewidth', 1)
%     hold on
%     plot(time_mat_area{n}, cov_a_exp{n}, 'linewidth', 1)
%     hold on
%     plot(time_mat_area{n}, cov_a_sat{n}, 'linewidth', 1)
% end




% Choose a temperature
gr = [4, 148, 124]/256;
dp = [92, 1, 138]/256;
ym = [247, 190, 2]/256;

for n = 1:N
    % Plot weighted mix
    figure
    plot(time_mat_area{n}, cov_a_sat{n}, 'color', [0 0.4470 0.7410], 'linewidth', 1.5)
    hold on
    plot(time_mat_area{n}, cov_a_exp{n}, 'color', 'r', 'linewidth', 1.5)
    hold on
    plot(time_wv{n}, cov_f_all{n}, 'color', gr, 'linewidth', 1.5)
    hold on
    plot(time_mat_area{n}, cov_mix{n}, 'color', 'k','linewidth', 1)
    hold on
    yline(range{n}(1), 'm')
    hold on
    yline(range{n}(2), 'm')
    hold on
    yline(range{n}(3), 'm')
    legend('cov( A_{SAT} )', 'cov( A_{EXP} )', 'cov( F )' , 'cov( A+F )', 'FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('Coverage', 'FontSize',20)
    title(temps_strings{n}, 'FontSize', 20)
    grid on

end

% Store TIME for plotting
time_mix = time_mat_area;

save('coverage_vs_time.mat', 'cov_mix', 'time_mix', 'area', 'wv', 'time_wv', 'cov_f_all', 'cov_a_sat', 'cov_a_exp', 'cov_a_all')

