clear all
close all
clc


% This script covnerts code using Weights (Area + Frequency)
load weights.mat

% Load molar absorptivities
load Absorptivity/molar_abs.mat

% Create load string
temp_strings = {'450', '460', '470', '475', '480', '490'};
Nt = length(temp_strings);

% WV splits
%wv_splits = [1824, 1826, 1835, 1907];
wv_splits = [1828, 1835, 1900];
N = length(wv_splits);

o_up = 2000;
o_down=1700;


% Weights of area
Wa = 1 - Wf;


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
    end

    cov_a = area'./epsilon_exp(nt);
    cov_a(id{3}) = area(id{3})./epsilon_sat(nt);
    
    % Get coverage only through area with each epsilon 
    cov_a_exp{nt} = area./epsilon_exp(nt);
    cov_a_sat{nt} = area./epsilon_sat(nt);


    % Get weighted mix
    for n = 1:N+1
        cov(id{n}) = Wf(n)*cov_f(id{n}) + Wa(n)*cov_a(id{n});
    end

    % Outliers
    out = find(cov_f < 0);
    cov_f(out) = []; % cov_a(out);
    time(out) = [];
    area(out)=[]
    cov_a(out) = [];
    cov(out) = [];
    out = find(cov_f > max(cov_a));
    cov_f(out) = cov_a(out);

    cov_mix{nt} = cov;
    cov_f_all{nt} = cov_f;
    cov_a_all{nt} = cov_a;
    area_all{nt} = area;
    time_all{nt} = time;



end




% Choose a temperature
nt = 1;


% Plot weighted mix
figure(1)
plot(time_all{nt}, cov_mix{nt}, 'k', 'linewidth', 2)
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

