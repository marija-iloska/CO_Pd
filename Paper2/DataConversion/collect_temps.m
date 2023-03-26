clear all
close all
clc

% PLot areas
load Temps/AllTemp_old.mat

sz = 20;
for t = 1 : length(areas)

    plot(times{t}, areas{t}, '.', 'MarkerSize', 15)
    hold on

end
xlabel('Time', 'FontSize', sz)
ylabel('Area', 'FontSize', sz)
set(gca, 'FontSize', 15)
legend( temps, 'FontSize', sz)
