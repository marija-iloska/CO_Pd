clear all
close all
clc


% This script covnerts code using Weights (Area + Frequency)
load weights450isotherm.mat
%load Absorptivity/mean_area.mat

% Load molar absorptivities
load 450info.mat
%load epsilons.mat

% Load data
load Temps/all_temps.mat

% Create load string
temp_strings = {'450'};
Nt = length(temp_strings);

% Extinction coefficient
%eps_mystery = 0.3727;
eps_cov = sort([ 0.41369185 0.489873814 0.498506692], 'descend');
%wv_eps = sort([1897.65246, 1882.22 ,1864.87], 'ascend');
wv_eps = sort([1882.22 ,1864.87, 1842], 'ascend');


wv_splits = wv_split;

N = length(wv_splits);
k = 2;


% Weights
% Wf = Der./sum(Der);
% ratio = Der(2:end)./Der(1:end-1);


% Weights of area
% Wa = 1 - Wf;


% Loop for all temperatures
for nt = 1:1

    area{nt}(area{nt}<0) = 0;

    clear cov cov_f
    % Region indices based on WV fitting for derivatives
    id{1} = find(wv{nt} < wv_splits(1));
    for n = 2:N
        % Get indices UP to split
        id{n} = find(wv{nt} < wv_splits(n));
    end

    % Remove repeating coeffs
    for n = 1:N-1
        id{N-n+1} = setdiff(id{N-n+1}, id{N-n});
    end

    % Last index
    id{N+1} = find(wv{nt} > wv_splits(end));


    % GET COV_F
    for n = 1:N+1
        cov_f(id{n}) = polyval(Pc(n,:), wv{nt}(id{n}));
%         cov_a(id{n}) = area(id{n})./eps_cov(n);
    end
    cov_f(cov_f < 0) = 0;


    cov_a = area{nt}'./epsilon_exp(nt);
    cov_a(id{k}) = area{nt}(id{k})./epsilon_sat(nt);
    
    % Get coverage only through area with each epsilon 
    cov_a_exp{nt} = area{nt}./epsilon_exp(nt);
    cov_a_sat{nt} = area{nt}./epsilon_sat(nt);
    cov_a_eps1{nt} = area{nt}./eps_cov(1);
    cov_a_eps2{nt} = area{nt}./eps_cov(2);     
    cov_a_eps3{nt} = area{nt}./eps_cov(3);

    % TEST
    % Get indices based on WV
    cov_a_test = area{nt}'/epsilon_exp(nt);
    for m = 1:3
        idx1 = wv{nt} > wv_eps(1);
        cov_a_test(idx1) = area{nt}(idx1)'/eps_cov(m);
    end




    % Get weighted mix
    for n = 1:N+1
        cov(id{n}) = Wf(n)*cov_f(id{n}) + Wa(n)*cov_a_test(id{n});
    end

    cov_mix{nt} = cov;
    cov_f_all{nt} = cov_f;
    cov_a_all{nt} = cov_a;
    area_all{nt} = area;
    %time_all{nt} = time;



end




% Choose a temperature
nt =1;
dp = [92, 1, 138]/256;
ym = [247, 190, 2]/256;

% Plot weighted mix
figure(1)
plot(time_area{nt}, cov_a_test, 'color', [0 0.4470 0.7410], 'linewidth', 1)
hold on
plot(time_wv{nt}, cov_f_all{nt}, 'color', ym, 'linewidth', 1)
hold on
plot(time_wv{nt}, cov_mix{nt}, 'color', 'k','linewidth', 2)
hold on
legend('cov(A)', 'cov(F)' , 'cov(A+F)', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on

% Plot weighted mix
% figure(4)
% plot(time_area{nt}, cov_a_exp{nt}, 'r', 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_sat{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_eps1{nt}, 'color', 'b', 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_eps2{nt}, 'color', 'g', 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_eps3{nt}, 'color', 'm', 'linewidth', 1)
% hold on
% plot(time_wv{nt}, cov_f_all{nt}, 'color', 'k', 'linewidth', 2)
% set(gca, 'FontSize', 20)
% legend('exp area', 'sat area', 'freq' , 'FontSize', 20)
% xlabel('Time', 'FontSize',20)
% ylabel('COVERAGE', 'FontSize',20)
% title(temp_strings{nt}, 'FontSize', 20)
% grid on

gr = [4, 148, 124]/256;

figure(5)
plot(time_area{nt}, cov_a_test, 'r', 'linewidth', 1)
hold on
plot(time_area{nt}, cov_a_exp{nt}, 'k', 'linewidth', 1)
hold on

% 
% figure(2)
% plot(time_area{nt}, cov_a_exp{nt}, 'color', gr, 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_sat{nt}, 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_all{nt},'linewidth', 1)
% hold on
% legend('Area exp', 'Area sat', 'Area mix', 'FontSize', 20)
% xlabel('Time', 'FontSize',20)
% ylabel('Coverage', 'FontSize',20)
% title(temp_strings{nt}, 'FontSize', 20)
% grid on
% 
% 
% figure(3)
% plot(time_wv{nt}, cov_mix{nt}, '.', 'Color', 'k', 'MarkerSize', 12)


% figure(4)
%plot(time_area{nt}, area{nt})

