clear all
close all
clc

% Coverage at saturation
load ExpectedCov/expected_coverage.mat

% Mean area at saturation
load Absorptivity/mean_area.mat
%load mean_abs_area.mat
load mean_mat_area.mat

% Our data
load Temps/T3.mat

% Temperatures 450 460 and 490
%cov_sat_temps = cov_sat(idx);
% area_sat_temps = mean_area_sat(idx);
% 
% for i = 1:N-1
% 
%     A_new{i} = (cov_sat(i)/cov_sat(N))*(mean_area_sat(N)/mean_area_sat(i))*movmean(area_mat{i},5);
% 
% end
% A_new{N} = movmean(area_mat{N}, 5);
for i = 1:N
    MA_area{i} = movmean(area_mat{i}, 5);
end


for i = 2:N

    A_new{i} = (cov_sat(i)/cov_sat(1))*(MA_area{1}./mean_area_sat(i)).*MA_area{i};

end
A_new{1} = MA_area{1};

figure(7)
for i = 1:N

    plot(time_mat_area{i}, A_new{i}, 'linewidth', 1.5)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Coverage', 'FontSize',20)
title('Area-MAT')
grid on


for i = 1:N
    figure(i)
    plot(time_mat_area{i}, A_new{i})
    hold on
    plot(time_mat_area{i}, movmean(area_mat{i},5))
    title(temps_strings{i}, 'FontSize', 20)
    legend('New', 'Old','FontSize', 20)
end


i = 3;
plot(time_mat_area{i}, MA_area{i})
hold on
%plot(time_mat_area{i}, MA_area{i}/mean_area_sat(i))
%hold on
plot(time_mat_area{i}, A_new{i})
% hold on
% plot(time_mat_area{1}, A_new{1})



