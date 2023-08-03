clear all
close all
clc

% PLot areas
load Data/T6.mat


sz = 20;
msz = 11;
for t = 1 : N

%      plot(time_mat_area{t}, movmean(area_mat{t}, 1), '.', 'MarkerSize', msz)
%      hold on
%      plot(time_mat_area{t}, movmean(area_mat{t}, 1), 'Linewidth', 1)
%      hold on
%     plot(time_wv{t}, wv_dat{t}, '.', 'MarkerSize', msz)
%     hold on
%     plot(time_abs_area{t}, area_abs{t}, '.', 'MarkerSize', msz)
%     hold on

end
xlabel('Time', 'FontSize', sz)
ylabel('MAT Area', 'FontSize', sz)
%ylabel('Wavenumber', 'FontSize', sz)
title('Smoothed (5 MA points)', 'FontSize', sz)
set(gca, 'FontSize', 15)
legend( temps_strings, 'FontSize', sz)
