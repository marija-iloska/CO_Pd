clear all
close all
clc

% Coverage at saturation
load ExpectedCov/expected_coverage.mat

% Mean area at saturation
load Absorptivity/mean_area.mat
load mean_mat_area.mat

% Our data
load Temps/T6.mat


% MOVING AVERAGE OF AREA
MA = 5;
kb = 3;
kf = 6;
for i = 1:N
    MA_area{i} = [ area_mat{i}(1:4)' movmean(area_mat{i}(5:end), [kb, kf])' ];
end

kb = 3;
kf = 3;
% MOVING AVERAGE OF WV
for i = 1:N
    MA_wv{i} = [ wv_dat{i}(1:4)' movmean(wv_dat{i}(5:end), [kb, kf])' ];
    L = length(MA_wv{i});
    wv{i}(1:L) = MA_wv{i};
end


% PLOT regular Area
figure(1)
for i = 1:N

    plot(time_mat_area{i}, MA_area{i}, 'linewidth', 1.5)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
title('Raw AREA', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Area-MAT', 'FontSize',20)
grid on

% NORMALIZE
% Choose 1 for ref 450 and 2 for ref 490
ref = 2;
T = [1, N];
range{1} = [2, N];
range{2} = [1, N-1];
for i = range{ref}(1) : range{ref}(2)

    c = mean_area_sat(T(ref))/mean_area_sat(i);
    A_new{i} = (cov_sat(i)/cov_sat(T(ref)))*c*MA_area{i};

end
A_new{T(ref)} = MA_area{T(ref)};




% Plot ALL normalized Area together
figure(2)
for i = 1:N

    plot(time_mat_area{i}, A_new{i}, 'linewidth', 1.5)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
title('Normalized AREA', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('Area-MAT', 'FontSize',20)
grid on


% Plot all raw areas against their normalization
for i = 1:N
    figure;
    plot(time_mat_area{i}, MA_area{i}, 'Linewidth',1.5)
    hold on
    plot(time_mat_area{i}, A_new{i}, 'linewidth', 1.5)
    title(temps_strings{i}, 'FontSize', 20)
    legend('Unnormalized', 'Normalized','FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('Area-MAT', 'FontSize',20)
    grid on
end



% PLOT all frequencies Together
figure;
for i = 1:N

    plot(time_wv{i}, MA_wv{i}, 'linewidth', 1.5)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
title('Smoothed FREQ', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('FREQ', 'FontSize',20)
grid on

% PLOT all frequencies
for i = 1:N
    figure;
    plot(time_wv{i}, wv_dat{i}, 'linewidth',1)
    hold on
    plot(time_wv{i}, MA_wv{i}, 'linewidth', 1)
    title(temps_strings{i}, 'FontSize', 20)
    legend('Raw', 'Smoothed','FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('FREq', 'FontSize',20)
    grid on
end



area = A_new;

save('area_ref490_MA5.mat', 'area', 'time_mat_area', 'cov_sat')
save('wv_MA5.mat', 'wv', 'wv_dat', 'time_wv', 'cov_sat')
