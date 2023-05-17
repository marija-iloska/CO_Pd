clear all
close all
clc

% PLOT coverages
load coverage_vs_time.mat

sz = 20;
msz = 11;
for t = 1 : Nt

%      plot(time_mix{t}, cov_mix{t}, '.', 'MarkerSize', msz)
%      hold on

     plot(time_mix{t}, movmean(cov_mix{t}, 1), 'Linewidth', 2)
     hold on

end
set(gca, 'FontSize', 15)
xlabel('Time', 'FontSize', sz)
ylabel('Coverages', 'FontSize', sz)
legend( temps_strings, 'FontSize', sz)
grid on
