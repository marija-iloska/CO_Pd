clear all
close all
clc

% PLOT coverages
load Data/coverage_mat_vs_time.mat
load Data/temps_info.mat
load Paper2_data/colors.mat
% 
% % cut = [21.5, 20, 11, 10.3, 10];
% cut = [19.2, 19.2, 10.9, 10.8, 9.2, 10];
% 
% for i = 1:N-1
% 
%     cov_mix{i}(time_mix{i} > cut(i)) = [];
%     time_mix{i}(time_mix{i} > cut(i)) = [];
% end


% cov_mix{1}(end-5:end) = 10e-4;

sz = 20;
msz = 11;
gr = [48, 219, 159]/256;
for t = 1 : N
% 
%      plot( theta{t},wv{t}, '.', 'MarkerSize', msz)
%      hold on
%      ylim([1810, 1900])
% 
     plot(time_mix{t}, movmean(cov_mix{t}, 1), 'Color', col{t}, 'Linewidth', 2)
      hold on
%     xline(3, 'Color', 'm', 'linewidth', 3)
%     hold on
%     yline(0.31, 'Color', gr, 'linewidth', 3)
%     hold on

      %cov_mix{t} = movmean(cov_mix{t}, [1,2]);

end
set(gca, 'FontSize', 15)
xlabel('Time [s]', 'FontSize', sz)
ylabel('Coverage [ML]', 'FontSize', sz)
legend( temps_strings, 'FontSize', sz)
title('Marija Coverage', 'FontSize',sz)
%legend( '\theta_{\tau}^X', 'FontSize', sz)
grid on

% filename = 'figs/all_cov.eps';
% print(gcf, filename, '-depsc2', '-r300');

% cov_zubin = cov_mix;
% time_zubin = time_mix;
cov_marija = cov_mix;
time_marija = time_mix;

% Save for fitting
%save('Data/cov_time_zubin.mat', 'cov_zubin', 'time_zubin')
% save('Data/cov_time_marija.mat', 'cov_marija', 'time_marija')

% 
% filename = 'all_cov.csv';
% 
% writecell(cov_mix', filename, 'Delimiter', ',');
% 
% for col = 1:N
%     writecell(filename, cov_mix(:, col), 1, char('A' + col - 1));
% end