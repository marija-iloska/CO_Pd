clear all
close all
clc


% This script covnerts code using Weights (Area + Frequency)
load weights450area.mat
%load Absorptivity/mean_area.mat

% Load molar absorptivities
load Absorptivity/molar_new.mat

% Create load string
temp_strings = {'450', '460', '470', '475', '480', '490'};
Nt = length(temp_strings);

% Extinction coefficient
eps_cov = [0.3727, 0.41369185 0.489873814 0.498506692];



% WV splits
%wv_splits = [1824, 1826, 1835, 1907];
%wv_splits = [1828, 1835, 1900];
%wv_splits = [1840]; %, 1880];
wv_splits = [1835, 1860];

N = length(wv_splits);
k = 3;

o_up = 2000;
o_down=1700;

% Weights
% Wf = Der./sum(Der);
% ratio = Der(2:end)./Der(1:end-1);

ext_coeff =@(coverage) - 0.8266*coverage + 0.7756;

% Weights of area
% Wa = 1 - Wf;


% Loop for all temperatures
for nt = 1:Nt

    clear cov time cov_a cov_f area id
    load(join(['Temps/',temp_strings{nt},'K.mat'] ))

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


    % Region indices based on WV fitting for derivatives
    id{1} = find(wv < wv_splits(1));
    for n = 2:N
        % Get indices UP to split
        id{n} = find(wv < wv_splits(n));
    end

    % Remove repeating coeffs
    for n = 1:N-1
        id{N-n+1} = setdiff(id{N-n+1}, id{N-n});
    end

    % Last index
    id{N+1} = find(wv > wv_splits(end));


    % GET COV_F
    for n = 1:N+1
        cov_f(id{n}) = polyval(Pc(n,:), wv(id{n}));
%         cov_a(id{n}) = area(id{n})./eps_cov(n);
    end


    cov_a = area'./epsilon(nt);
    cov_a(id{k}) = area(id{k})./epsilon_sat(nt);
    
    % Get coverage only through area with each epsilon 
    cov_a_exp{nt} = area./epsilon(nt);
    cov_a_sat{nt} = area./epsilon_sat(nt);



    % Get weighted mix
    for n = 1:N+1
        cov(id{n}) = Wf(n)*cov_f(id{n}) + Wa(n)*cov_a(id{n});
    end

    % Outliers
    out = find(cov_f < 0);
    cov_f(out) = 0; % cov_a(out);
    cov(out) = 0;
%     time(out) = [];
%     area(out)=[];
%     cov_a(out) = [];
%     cov(out) = [];
    out = find(cov_f > 0.42);
    cov_f(out) = cov_a(out);
    cov(out) = cov_a(out);

    cov_mix{nt} = cov;
    cov_f_all{nt} = cov_f;
    cov_a_all{nt} = cov_a;
    area_all{nt} = area;
    time_all{nt} = time;



end




% Choose a temperature
nt = 1;
dp = [92, 1, 138]/256;


% Plot weighted mix
figure(1)
plot(time_all{nt}, cov_mix{nt}, 'color', 'k','linewidth', 2)
hold on
plot(time_all{nt}, cov_a_all{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
hold on
plot(time_all{nt}, cov_f_all{nt},'linewidth', 1)
hold on
legend('cov', 'area', 'freq' , 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on

% Plot weighted mix
figure(4)
plot(time_all{nt}, cov_a_exp{nt}, 'r', 'linewidth', 1)
hold on
plot(time_all{nt}, cov_a_sat{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
hold on
plot(time_all{nt}, cov_f_all{nt}, 'color', dp, 'linewidth', 1.5)
hold on
legend('exp area', 'sat area', 'freq' , 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on

gr = [4, 148, 124]/256;


figure(2)
plot(time_all{nt}, cov_a_exp{nt}, 'color', gr, 'linewidth', 1)
hold on
plot(time_all{nt}, cov_a_sat{nt}, 'linewidth', 1)
hold on
plot(time_all{nt}, cov_a_all{nt},'linewidth', 1)
hold on
legend('Area exp', 'Area sat', 'Area mix', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(temp_strings{nt}, 'FontSize', 20)
grid on


figure(3)
plot(time_all{nt}, cov_mix{nt}, '.', 'Color', 'k', 'MarkerSize', 12)

