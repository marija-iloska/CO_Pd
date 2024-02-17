clear all
close all
clc


% %-------------------------------------------------
% %        Ea in Region 4
% %--------------------------------------------------
% 
load Data/temps_info.mat
load Paper2_data/colors.mat
load Data/cov_vs_time_noise.mat
time_mix = time_padded;
% cov_mix = cov_a_all;
cov_mix = area;


file_start = 'no450';
file_end = '_nocut';
file_ext = '.png';

% cut = 15*ones(1,N);
% %cut = [19, 19, 11, 10, 9, 7];
% cut = [18, 18, 12, 13, 13, 9];
% cut = 11*ones(1,N);
% for i = 1:N
% 
%     cov_mix{i}(time_mix{i} > cut(i)) = [];
%     time_mix{i}(time_mix{i} > cut(i)) = [];
% end



% Temperatures
T = [450, 460, 470, 475, 480, 490];
N = length(T);


% Which data point to exclude
idx = setdiff(1:N, [1]);

% Ideal Gas constant  (kcal / (K mol))
R = 0.001987204258;

% Ea with different initial coverages
covs = 0.06;
%covs = 0.23;
Nsplit = length(covs);


for j = 1 : Nsplit

    for n = 1:N    
        % Get k_des for each temp
        [k(j,n), k_SE(j,n), Rsq_k(j,n)] = k_des(cov_mix{n}, time_mix{n}, covs(j), tp_idx);   
    end
    % Get Ea
    [Ea(j), A(j), Ea_SE(j), A_SE(j), ln_k, Rsq_Ea(j), ln_k_SE] = get_Ea(k(j, idx), T(idx), R);

end

x = [ (1./T(idx))'; fliplr(1./T(idx))'];
y = ln_k_SE';
y = y(:);
id = find(covs < 0.24);
sz = 60;
% Plot fit
figure;
plot(1./T(idx), ln_k, 'LineWidth', 3, 'Color', 'k')
hold on
scatter(1./T(idx), log(k(idx)), sz, 'filled', 'MarkerFaceColor','r')
hold on
patch(x,y, 'red', 'FaceAlpha', 0.05, 'EdgeColor', 'none')
set(gca, 'FontSize', 13)
xlabel('1/T [K^{-1}]', 'FontSize', 20)
ylabel('ln k [s^{-1}]','FontSize', 20)
title('Arrhenius Plot', 'FontSize', 20)
legend('Rate Constants', 'Fitting', 'Uncertainty Region', 'fontsize',15, 'location', 'southwest')



filename = join(['figs_Qin/', file_start, '_uEa', file_end, file_ext]);
saveas(gcf, filename)

% Plot fit
figure;
plot(1./T(idx), ln_k, 'LineWidth', 3, 'Color', 'k')
hold on
scatter(1./T(idx), log(k(idx)), sz, 'filled', 'MarkerFaceColor','r')
hold on
set(gca, 'FontSize', 13)
xlabel('1/T [K^{-1}]', 'FontSize', 20)
ylabel('ln k [s^{-1}]','FontSize', 20)
title('Arrhenius Plot', 'FontSize', 20)
legend('Rate Constants', 'Fitting', 'fontsize',15, 'location', 'northeast'); %, 'southwest')


filename = join(['figs_Qin/', file_start, file_end, file_ext]);
saveas(gcf, filename)
 


x = [ (1./T(idx))'; fliplr(1./T(idx))'];
y = log([k(idx) - k_SE(idx); fliplr(k(idx) + k_SE(idx))])';
y = y(:);
err = log([k(idx) + k_SE(idx)]) - log(k(idx));
sz = 80;
% Plot fit
figure;
plot(1./T(idx), ln_k, 'LineWidth', 3, 'Color', 'k')
hold on
scatter(1./T(idx), log(k(idx)), sz, 'filled', 'MarkerFaceColor','r')
hold on
errorbar(1./T(idx), log(k(idx)), err,"LineStyle","none", "Color","k")
set(gca, 'FontSize', 13)
xlabel('1/T [K^{-1}]', 'FontSize', 20)
ylabel('ln k [s^{-1}]','FontSize', 20)
title('Arrhenius Plot', 'FontSize', 20)
legend('Rate Constants', 'Fitting', 'Error Bars', 'fontsize',15, 'location', 'northeast'); % 'southwest')


filename = join(['figs_Qin/', file_start, '_uk', file_end, file_ext]);
saveas(gcf, filename)
%print(gcf, filename, '-depsc2', '-r300');


% blue = [62, 158, 222]/256;
% figure;
% %h = errorbar(covs, Ea, Ea_SE, 'Linewidth', 1, 'Color' , 'k');
% plot(covs, Ea)
% hold on
% set(gca, 'FontSize', 15)
% xlabel('Initial Coverage', 'FontSize', 15)
% ylabel('Ea', 'FontSize', 15)
% legend('Ea', 'Mean Ea', 'Change starts', 'FontSize', 15)
% title('Paper 2 Noise', 'FontSize', 15)
% ylim([floor(min(Ea)),round(max(Ea))])
% 
% filename = 'figs/Ea.eps';
% print(gcf, filename, '-depsc2', '-r300');

