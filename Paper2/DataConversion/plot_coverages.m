clear all
close all
clc

% PLOT coverages
load Data/coverage_vs_time.mat
load Data/temps_info.mat

% cut = [21.5, 20, 11, 10.3, 10];
cut = [25, 25, 25, 25, 10.3, 25];

for i = 1:N-1

    cov_mix{i}(time_mix{i} > cut(i)) = [];
    time_mix{i}(time_mix{i} > cut(i)) = [];
end

cov_mix{1}(end-5:end) = 10e-4;

sz = 20;
msz = 11;
gr = [48, 219, 159]/256;
for t = 1 : N

     plot(time_mix{t}, movmean(cov_mix{t}, [1,2]), '.', 'MarkerSize', msz)
      hold on
% 
%     plot(time_mix{t}, movmean(cov_mix{t}, [0,1]), 'Linewidth', 3)
%      hold on
%     xline(3, 'Color', 'm', 'linewidth', 3)
%     hold on
%     yline(0.31, 'Color', gr, 'linewidth', 3)
%     hold on

      cov_mix{t} = movmean(cov_mix{t}, [1,2]);

end
set(gca, 'FontSize', 15)
xlabel('Time', 'FontSize', sz)
ylabel('Coverage', 'FontSize', sz)
%legend( temps_strings, 'FontSize', sz)
legend( '\theta_{\tau}^X', 'FontSize', sz)
%grid on

% filename = 'figs/all_cov.eps';
% print(gcf, filename, '-depsc2', '-r300');

% Save for fitting
save('Data/cov_time_for_fitting.mat', 'cov_mix', 'time_mix')
% 
% filename = 'all_cov.csv';
% 
% writecell(cov_mix', filename, 'Delimiter', ',');
% 
% for col = 1:N
%     writecell(filename, cov_mix(:, col), 1, char('A' + col - 1));
% end