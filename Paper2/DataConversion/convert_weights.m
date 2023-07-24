clear all
close all
clc

% DESCRIPTION OF SCRIPT PURPOSE

% Load fitting for WV vs COV in regions
load Data/weights450isotherm.mat

% Load molar absorptivities
load Absorptivity/epsilons_mat_norm.mat

% Load data Area and Frequency
load Data/area_ref490.mat
load Data/wv.mat

% Load Temperature INFO
load Data/temps_info.mat

% Number of region splits (R + 2 regions)
R = length(wv_splits);


% Wf(1) = 0;
% Wf(2) = (Der(2) - Der(1))/(Der(3) - Der(1));

% Include weights for lowest regions
%Wf = [0, 0, 1, 1];
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
    w = (area{n}./ max(area{n}));
    epsilon = w.*epsilon_sat(n) + (1-w).*(epsilon_exp(n));
    cov_a = area{n}./epsilon;
    cov_a(cov_a < 0) = 10e-4;
   
    % COV ( eps_SAT  vs eps_EXP )
     cov_a_sat{n} = area{n}./epsilon_sat(n);
     cov_a_exp{n} = area{n}./epsilon_exp(n);




    % Get COV(A + F)
    for r = 1:R+2
        cov(id{r}) = Wf(r)*cov_f(id{r}) + Wa(r)*cov_a(id{r});
    end
    % Set negative covs to 0s 
    cov(cov <= 0) = 10e-4;

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


% Choose a temperature
gr = [4, 148, 124]/256;
dp = [92, 1, 138]/256;
ym = [247, 190, 2]/256;

for n = 1:N
    % Plot weighted mix
    figure
    plot(time_mat_area{n}, cov_a_all{n}, 'color', 'r', 'linewidth', 1.5)
    hold on
    plot(time_wv{n}, cov_f_all{n}, 'color', [0 0.4470 0.7410], 'linewidth', 1.5)
    hold on
    plot(time_mat_area{n}, movmean(cov_mix{n}, [1,2]), 'color', 'k','linewidth', 2)
    hold on
    legend('cov( A )', 'cov( F )', 'cov( A+F )', 'FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('Coverage', 'FontSize',20)
    title(temps_strings{n}, 'FontSize', 20)
    grid on

end

% Store TIME for plotting
time_mix = time_mat_area;



save('Data/coverage_vs_time.mat', 'cov_mix', 'time_mix', 'area', 'wv', 'time_wv', 'cov_f_all', 'cov_a_sat', 'cov_a_exp', 'cov_a_all')

