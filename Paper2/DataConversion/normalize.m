clear all
close all
clc

% Coverage at saturation
load ExpectedCov/expected_coverage.mat

% Mean area at saturation
load Absorptivity/mean_mat_area.mat

% Our data
load Data/T6.mat


% Preserve the first L points since they have higher uncertainty
% MOVING AVERAGE OF AREA
K = 3;
MA = 5;
kb = 4;
kf = 4;
for i = 1:N
    MA_area{i} = [ area_mat{i}(1:K)' movmean(area_mat{i}(K+1:end), [kb, kf])' ];
end

kb = 5;
kf = 3;
K = 5;
% MOVING AVERAGE OF WV
% Preserve 0s padding/replacements in wv, but remove in wv_dat for plotting
for i = 1:N
    MA_wv{i} = [ wv_dat{i}(1:K)' movmean(wv_dat{i}(K+1:end), [kb, kf])' ];
    L = length(MA_wv{i});
    wv{i}(3:L+2) = MA_wv{i};
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



% PLOT all frequencies Together smoothed
figure;
for i = 1:N

    plot(time_dat{i}, MA_wv{i}, 'linewidth', 1.5)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
title('Smoothed FREQ', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
ylabel('FREQ', 'FontSize',20)
grid on

% PLOT frequencies against their smoothed version
for i = 1:N
    figure;
    plot(time_dat{i}, wv_dat{i}, 'linewidth',1)
    hold on
    plot(time_dat{i}, MA_wv{i}, 'linewidth', 1)
    title(temps_strings{i}, 'FontSize', 20)
    legend('Raw', 'Smoothed','FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('FREq', 'FontSize',20)
    grid on
end

% Store area
area = A_new;

% Store P off index
tp_idx = 45;

save('Data/area_ref490.mat', 'area', 'time_mat_area', 'cov_sat')
save('Data/wv.mat', 'wv', 'wv_dat', 'time_wv', 'time_dat', 'cov_sat')
save('Data/temps_info.mat', 'temps_strings', 'N', 'tp_idx')

