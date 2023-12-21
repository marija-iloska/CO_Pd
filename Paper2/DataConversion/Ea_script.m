clear all
close all
clc


% %-------------------------------------------------
% %        Ea in Region 4
% %--------------------------------------------------
% 
load Data/temps_info.mat
load Paper2_data/colors.mat

% load Data/cov_time_marija.mat
% load Data/cov_time_zubin.mat
%load Data/cov_time_for_fitting.mat
load Data/clean_coverage_vs_time.mat
time_mix = time_padded;
%cov_mix = cov_a_all;


% cut = [14, 14, 10, 8, 8, 9];
cut = [14, 15, 13, 13, 10, 10];
for i = 1:N

    cov_mix{i}(time_mix{i} > cut(i)) = [];
    time_mix{i}(time_mix{i} > cut(i)) = [];
end



% Temperatures
T = [450, 460, 470, 475, 480, 490];
N = length(T);


% Which data point to exclude
idx = setdiff(1:N, []);

% Ideal Gas constant  (kcal / (K mol))
R = 0.001987204258;

% Ea with different initial coverages
covs = 0.17 : 0.01 : 0.33;
%covs = 0.23;
Nsplit = length(covs);


for j = 1 : Nsplit

    for n = 1:N    
        % Get k_des for each temp
        [k(j,n), k_SE(j,n), Rsq_k(j,n)] = k_des(cov_mix{n}, time_mix{n}, covs(j), tp_idx);   
    end
    % Get Ea
    [Ea(j), A(j), Ea_SE(j), A_SE(j), ln_k, Rsq_Ea(j)] = get_Ea(k(j, idx), T(idx), R);

end

id = find(covs < 0.24);
sz = 60;
% Plot fit
figure;
plot(1./T(idx), ln_k, 'LineWidth', 1)
hold on
scatter(1./T(idx), log(k(j,idx)), sz, 'filled')
set(gca, 'FontSize', 13)
xlabel('1/T', 'FontSize', 20)
ylabel('log(k)','FontSize', 20)
title('Arrhenius Equation Paper 2 Marija', 'FontSize', 15)

blue = [62, 158, 222]/256;
figure;
%h = errorbar(covs, Ea, Ea_SE, 'Linewidth', 1, 'Color' , 'k');
plot(covs, Ea)
hold on
%plot(covs(id), mean(Ea(id))*ones(1, length(id)), 'Color', 'r', 'Linewidth', 3)
%hold on
%xline(0.24, 'Linewidth', 3, 'Color', blue)
set(gca, 'FontSize', 15)
xlabel('Initial Coverage', 'FontSize', 15)
ylabel('Ea', 'FontSize', 15)
legend('Ea', 'Mean Ea', 'Change starts', 'FontSize', 15)
title('Paper 2 Data Marija', 'FontSize', 15)
% ylim([floor(min(Ea)),round(max(Ea))])
% 
% filename = 'figs/Ea.eps';
% print(gcf, filename, '-depsc2', '-r300');

