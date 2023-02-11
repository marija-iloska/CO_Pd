clear all
close all
clc


% This script covnerts code using Weights (Area + Frequency)
load weights.mat


% Load data for conversion (choose Temp)
load Temps/450K.mat

% Load absorptivities
% Create load string
str_load = join(['Absorptivity/molar', str(1:3), 'k.mat']);
load(str_load)


% Weights of area
Wa = 1 - Wf;

% WV splits
%wv_splits = [1824, 1826, 1835, 1907];
wv_splits = [1828, 1840]; %, 1920];
N = length(wv_splits);

id{1} = find(wv < wv_splits(1));
for n = 2:N
    % region indices
    id{n} = find(wv < wv_splits(n));
    
end

% INdices
for n = 1:N-1
    % region indices
    id{N-n+1} = setdiff(id{N-n+1}, id{N-n});   
end

id{N+1} = find(wv > wv_splits(end));

% GET COV_F AND COV_A
for n = 1:N+1
    cov_f(id{n}) = polyval(Pc(n,:), wv(id{n}));
    if (n == 3)
        cov_a(id{n}) = area(id{n})./epsilon_sat;
    else
        cov_a(id{n}) = area(id{n})./epsilon_exp;
    end
end

out = find(cov_f < 0);
cov_f(out) = 0; % cov_a(out);
out = find(cov_f > max(cov_a));
cov_f(out) = cov_a(out);

for n = 1:N+1
    cov(id{n}) = Wf(n)*cov_f(id{n}) + Wa(n)*cov_a(id{n});
end

cov_a_exp = area./epsilon_exp;
cov_area_sat = area./epsilon_sat;

figure(1)
plot(time, cov, 'k', 'linewidth', 2)
hold on
plot(time, cov_a, 'color', [0 0.4470 0.7410], 'linewidth', 1)
hold on
plot(time, cov_f,'linewidth', 1)
hold on
legend('cov', 'area', 'freq' , 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(str, 'FontSize', 20)
grid on

gr = [4, 148, 124]/256;

figure(2)
plot(time, cov_a_exp, 'color', gr, 'linewidth', 1)
hold on
plot(time, cov_area_sat, 'linewidth', 1)
hold on
plot(time, cov_f,'linewidth', 1)
legend('Area exp', 'Area sat', 'Frequency', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title(str, 'FontSize', 20)
grid on


figure(3)
plot(time, cov, '.', 'Color', 'k', 'MarkerSize', 12)

