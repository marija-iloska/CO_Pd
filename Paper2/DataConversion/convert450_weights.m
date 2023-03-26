clear all
close all
clc


% This script covnerts code using Weights (Area + Frequency)
load weights450isotherm.mat
%load Absorptivity/mean_area.mat

% Load molar absorptivities
load 450info.mat
load epsilons.mat

% Load data
load Temps/all_temps.mat

% Create load string
temp_strings = {'450', '460'};
Nt = length(temp_strings);

% Extinction coefficient
eps_cov = [0.3727, 0.41369185 0.489873814 0.498506692];
  

wv_splits = wv_split;

N = length(wv_splits);
k = 2;


% Weights
% Wf = Der./sum(Der);
% ratio = Der(2:end)./Der(1:end-1);


% Weights of area
% Wa = 1 - Wf;


% Loop for all temperatures
for nt = 1:2

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
    cov_a_eps2{nt} = area{nt}./epsilon_sat(2);
    cov_a_eps3{nt} = area{nt}./epsilon_sat(3);     
    cov_a_eps4{nt} = area{nt}./epsilon_sat(4);




    % Get weighted mix
    for n = 1:N+1
        cov(id{n}) = Wf(n)*cov_f(id{n}) + Wa(n)*cov_a(id{n});
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


% Plot weighted mix
% figure(1)
% plot(time_wv{nt}, cov_mix{nt}, 'color', 'k','linewidth', 2)
% hold on
% plot(time_area{nt}, cov_a_all{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
% hold on
% plot(time_wv{nt}, cov_f_all{nt},'linewidth', 1)
% hold on
% legend('cov', 'area', 'freq' , 'FontSize', 20)
% xlabel('Time', 'FontSize',20)
% ylabel('Coverage', 'FontSize',20)
% title(temp_strings{nt}, 'FontSize', 20)
% grid on

% Plot weighted mix
figure(4)
plot(time_area{nt}, cov_a_exp{nt}, 'r', 'linewidth', 1)
hold on
plot(time_area{nt}, cov_a_sat{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
hold on
plot(time_area{nt}, cov_a_eps2{nt}, 'color', 'b', 'linewidth', 1)
hold on
plot(time_area{nt}, cov_a_eps3{nt}, 'color', 'g', 'linewidth', 1)
hold on
plot(time_area{nt}, cov_a_eps4{nt}, 'color', 'm', 'linewidth', 1)
hold on
plot(time_wv{nt}, cov_f_all{nt}, 'color', dp, 'linewidth', 1.5)
hold on
legend('exp area', 'sat area', 'freq' , 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on

gr = [4, 148, 124]/256;

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


figure(4)
%plot(time_area{nt}, area{nt})

