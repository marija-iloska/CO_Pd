clear all
close all
clc

load Data\area_ref490.mat
area_zubin = area;
load Paper2_data\my_areas.mat
area_marija = area;
load Paper2_data\colors.mat
load Data\temps_info.mat


for n = 1:N

    time{n} = time_mat_area{n}(1:length(area_marija{n}));
    coeff(n) = mean(area_zubin{n}(tp_idx-20:tp_idx)) / mean(area_marija{n}(tp_idx-20:tp_idx));

%     figure(n)
%     plot(time_mat_area{n}, area_zubin{n}, 'color','k', 'linewidth',2)
%     hold on
%     plot(time{n}, area_marija{n}, 'color', col{n}, 'linewidth',2)
%     hold on
%     plot(time{n}, coeff(n)*area_marija{n})

end
% legend('490K Zubin', '490K Marija', '450K Marija scaled', 'FontSize',15)
% title('Area Comparison', 'FontSize',15)
% filename = 'Comparison/example_area.jpg';
% print(gcf, filename, '-depsc2', '-r300');

% figure;
% for n = 1:N
% 
%     area_marija_scaled{n} = coeff(n)*area_marija{n};
% 
%     plot(time{n}, coeff(n)*area_marija{n}, 'Color', col{n}, 'LineWidth',1)
%     hold on
% 
% end
% ylim([-0.05, 0.22])
% title('Marija Area Scaled', 'FontSize', 15)
% xlabel('Time', 'FontSize',15)
% ylabel('Area', 'FontSize',15)
% legend(temps_strings, 'FontSize', 15)
% grid on


% filename = 'Comparison/Marija_area.jpg';
% print(gcf, filename, '-depsc2', '-r300');
% 
% figure;
% for n = 1:N
% 
%     plot(time_mat_area{n}, area_zubin{n}, 'Color', col{n}, 'LineWidth',1)
%     hold on
% end
% ylim([-0.05, 0.22])
% title('Zubin Area Normalized', 'FontSize', 15)
% xlabel('Time', 'FontSize',15)
% ylabel('Area', 'FontSize',15)
% legend(temps_strings, 'FontSize', 15)
% grid on

% filename = 'Comparison/Zubin_area.jpg';
% print(gcf, filename, '-depsc2', '-r300');



% Read in WV and AREA excel
dat_wv = table2array(readtable('../mat_area_latest.xlsx', 'Sheet', 'Peak'));
dat_marea = table2array(readtable('../mat_area_latest.xlsx', 'Sheet', 'Area'));


% Read in old data
dat500 = readtable('Paper1_data/500K_paper1.xlsx');
dat475 = readtable('Paper1_data/475K_paper1.xlsx');
dat450 = readtable('Paper1_data/450K_paper1.xlsx');


time450_old = table2array(dat450(:,3));
wv450_old = table2array(dat450(:,4));
area450_old = table2array(dat450(:,5));

time475_old = table2array(dat475(:,3));
wv475_old = table2array(dat475(:,4));
area475_old = table2array(dat475(:,5));

time500_old = table2array(dat500(:,3));
wv500_old = table2array(dat500(:,4));
area500_old = table2array(dat500(:,5));

figure;
scatter(time450_old, area450_old, 10, 'filled')
hold on
scatter(time_mat_area{1}, area_zubin{1},  10, 'filled')
hold on
scatter(time{1}, area_marija{1}, 10, 'filled')
% xlabel('Time', 'FontSize',15)
% ylabel('Area', 'FontSize',15)
title('450K', 'FontSize',15)
legend('OLD', 'ZUBIN', 'MARIJA', 'FontSize', 15)
grid on

figure;
scatter(time475_old, area475_old, 10, 'filled')
hold on
scatter(time_mat_area{4}, area_zubin{4},  10, 'filled')
hold on
scatter(time{4}, area_marija{4}, 10, 'filled')
xlabel('Time', 'FontSize',15)
ylabel('Area', 'FontSize',15)
title('475K', 'FontSize',15)
legend('OLD', 'ZUBIN', 'MARIJA', 'FontSize', 15)
grid on


% figure;
% scatter(time500_old, area500_old, 20, 'filled')
% hold on
% scatter(time_mat_area{6}, area{6},  20, 'filled')
% legend('OLD 450', 'NEW 450', 'OLD 475', 'NEW 475', 'OLD 500', 'NEW 490', 'FontSize', 15)

% [X,Y] = meshgrid(time500_old, area500_old);
% Z = [wv500_old; wv500_old];
% 
% figure;
% surf(X,Y, Z')


