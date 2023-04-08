clear all
close all
clc

% PLot areas
load Temps/all_temps.mat


sz = 20;
for t = 1 : length(area)-2

    plot(time_area{t}, area{t}, '.', 'MarkerSize', 15)
    hold on

end
xlabel('Time', 'FontSize', sz)
ylabel('Area', 'FontSize', sz)
set(gca, 'FontSize', 15)
legend( temps_strings, 'FontSize', sz)
