clear all
close all
clc

% PLot areas
load Temps/T3.mat


sz = 20;
msz = 10;
for t = 1 : 3

%     plot(time_area{t}, movmean(area_mat{t}, 2), '.', 'MarkerSize', msz)
%     hold on
    plot(time_area{t}, area_abs{t}, '.', 'MarkerSize', msz)
    hold on

end
xlabel('Time', 'FontSize', sz)
ylabel('Area', 'FontSize', sz)
set(gca, 'FontSize', 15)
legend( temps_strings, 'FontSize', sz)
