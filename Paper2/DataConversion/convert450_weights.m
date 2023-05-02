clear all
close all
clc


% This script covnerts code using Weights (Area + Frequency)
load weights450isotherm.mat
%load Absorptivity/mean_area.mat

% Load molar absorptivities
%load 450info.mat
%load epsilon_abs.mat
load epsilons_mat.mat

% Load data
load Temps/T3.mat

% Create load string
temp_strings = {'450', '460', '490'};
Nt = length(temp_strings);

% Extinction coefficient
eps_cov = sort([ 0.41369185 0.489873814 0.498506692], 'descend');
%wv_eps = sort([1897.65246, 1882.22 ,1864.87], 'ascend');
wv_eps = sort([1882.22 ,1864.87, 1842], 'ascend');


wv_splits = wv_split;
wv_splits = 1855;
N = length(wv_splits);
k = 2;

%area = area_abs;
area = area_mat;
for i = 1:N
    area{i} = movmean(area{i}, 7);
end





% Weights of area
Wa = 1 - Wf;


% Loop for all temperatures
for nt = 1:3

    clear cov cov_f

    % Region indices based on WV fitting for derivatives
    id = region_indices(wv{nt}, wv_splits, N);


    % GET COV( F )
    for n = 1:N+1
        cov_f(id{n}) = polyval(Pc(n,:), wv{nt}(id{n}));
    end

    % Get COV( A )
    cov_a = area{nt}'./epsilon_exp(nt);
    cov_a(id{k}) = area{nt}(id{k})./epsilon_sat(nt);
    
    % Get coverage only through area with each epsilon 
    cov_a_exp{nt} = area{nt}./epsilon_exp(nt);
    cov_a_sat{nt} = area{nt}./epsilon_sat(nt);


    % Get COV(A + F) 
    for n = 1:N+1
        cov(id{n}) = Wf(n)*cov_f(id{n}) + Wa(n)*cov_a(id{n});
    end
    cov(cov < 0) = 0;

    cov_mix{nt} = cov;
    cov_f_all{nt} = cov_f;
    cov_a_all{nt} = cov_a;
    area_all{nt} = area;
    time_all{nt} = time;



end




% Choose a temperature
nt = 2;
dp = [92, 1, 138]/256;
ym = [247, 190, 2]/256;

% Plot weighted mix
figure(1)
plot(time_area{nt}, cov_a_all{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
hold on
plot(time_area{nt}, cov_f_all{nt}, 'color', ym, 'linewidth', 1)
hold on
plot(time_area{nt}, cov_mix{nt}, 'color', 'k','linewidth', 2)
hold on
legend('cov(A)', 'cov(F)' , 'cov(A+F)', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on



gr = [4, 148, 124]/256;


% All areas
figure(2)
plot(time_area{nt}, cov_a_exp{nt}, 'color', 'k', 'linewidth', 1)
hold on
plot(time_area{nt}, cov_a_sat{nt}, 'linewidth', 1)
hold on
%plot(time_area{nt}, cov_a_all{nt},'linewidth', 1)
%hold on
legend('Area exp', 'Area sat', 'Area mix', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on


