clear all
close all
clc

% Load Settings
load Data/temps_info.mat
load Paper2_data/colors.mat

% Load coverages
load Data/cov_time_marija.mat
load Data/cov_time_zubin.mat
load Paper1_data/cov_old.mat


% Plot settings
sz = 15;
temp = 1;
temp_old = [1,2];
str_title = join([temps_strings{temp_old(temp)}, 'K']);

for t = 1 : 1


    plot(time_old{temp_old(temp)}, cov_old{temp_old(temp)}, 'Color', col{4}, 'Linewidth',2)
    hold on
    plot(time_zubin{temp}, cov_zubin{temp}, 'Color', 'k', 'LineWidth',2)
    hold on
    plot(time_marija{temp}, cov_marija{temp}, 'Color', col{1}, 'Linewidth',2)
    hold on
    xline(3, 'Color', 'k', 'linewidth', 1)
    hold on
    xline(2, 'Color', 'k', 'linewidth', 1)
    hold on
    yline(0.33, 'Color', 'k', 'linewidth', 1)
    hold on

end
set(gca, 'FontSize', 15)
xlabel('Time [s]', 'FontSize', sz)
ylabel('Coverage [ML]', 'FontSize', sz)
% legend(temps_strings, 'FontSize',sz)
title(str_title, 'FontSize', sz)
legend('OLD', 'Zubin', 'Marija', 'FontSize', sz)
grid on

