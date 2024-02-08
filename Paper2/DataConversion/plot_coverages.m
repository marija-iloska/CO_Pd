clear all
close all
clc

% PLOT coverages
load Data/cov_vs_time_noise.mat
load Data/temps_info.mat
load Paper2_data/colors.mat

time_mix = time_padded;

% cut = [17, 16, 11, 10, 9.5, 8];
cut = [19, 19, 11, 10, 9, 7];
cut = 12*ones(1,N);
for i = 1:N

    cov_mix{i}(time_mix{i} > cut(i)) = [];
    time_mix{i}(time_mix{i} > cut(i)) = [];
end
cov_all = cov_mix;
time = time_mix;

sz = 20;
msz = 11;
gr = [48, 219, 159]/256;
for t = 1 : N

     plot(time{t}, cov_all{t}, 'Color', col{t}, 'Linewidth', 2)
      hold on


end
set(gca, 'FontSize', 15)
xlabel('Time [s]', 'FontSize', sz)
ylabel('Coverage [ML]', 'FontSize', sz)
legend( temps_strings, 'FontSize', sz)
title('Marija Coverage', 'FontSize',sz)
grid on

% filename = 'figs/all_cov.eps';
% print(gcf, filename, '-depsc2', '-r300');


% Save for fitting
save('Data/cov_time_noise.mat', 'cov_all', 'time')

 
% filename = 'all_cov.csv';
% 
% writecell(cov_mix', filename, 'Delimiter', ',');
% 
% for col = 1:N
%     writecell(filename, cov_mix(:, col), 1, char('A' + col - 1));
% end