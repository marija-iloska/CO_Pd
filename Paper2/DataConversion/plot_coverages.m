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



sz = 20;
msz = 11;
for t = 1 : N

  %   plot(time_mix{t}, movmean(cov_mix{t}, [1,1]), '.', 'MarkerSize', msz)
  %    hold on

     plot(time_mix{t}, movmean(cov_mix{t}, [1,1]), 'Linewidth', 2)
     hold on

      cov_mix{t} = movmean(cov_mix{t}, [1,1]);

end
set(gca, 'FontSize', 15)
xlabel('Time', 'FontSize', sz)
ylabel('Coverages', 'FontSize', sz)
legend( temps_strings, 'FontSize', sz)
grid on



% Save for fitting
save('Data/cov_time_for_fitting.mat', 'cov_mix', 'time_mix')