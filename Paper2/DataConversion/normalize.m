clear all
close all
clc

% Coverage at saturation
load ExpectedCov/expected_coverage.mat

% Mean area at saturation
load Absorptivity/mean_mat_area.mat

% Our data
load Data/T6.mat


% Choose number of moving average points for FREQ
kb = 2;
kf = 1;
K = 5;
% MOVING AVERAGE OF WV
% Preserve 0s padding/replacements in wv, but remove in wv_dat for plotting
for i = 1:N
    wv_smoothed{i} = [ wv_dat{i}(1:K)' movmean(wv_dat{i}(K+1:end), [kb, kf])' ];
    L = length(wv_smoothed{i});
    wv{i}(3:L+2) = wv_smoothed{i};
end




% NORMALIZE
% Choose 1 for ref 450 and 2 for ref 490
ref = 2;
T = [1, N];
range{1} = [2, N];
range{2} = [1, N-1];
for i = range{ref}(1) : range{ref}(2)

    c = mean_area_sat(T(ref))/mean_area_sat(i);
    A_normalized{i} = (cov_sat(i)/cov_sat(T(ref)))*c*area_mat{i};

end
A_normalized{T(ref)} = area_mat{T(ref)};


%% PLOT AREA (unnormalized OR normalized)
figure(1)
for i = 1:N
    %plot(time_mat_area{i}, A_new{i}, 'linewidth', 1.5)
    plot(time_mat_area{i}, area_mat{i}, 'linewidth', 1.5)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
title('Raw AREA', 'FontSize', 20)
xlabel('Time', 'FontSize',20)
%ylabel('Area Normalized', 'FontSize',20)
ylabel('Area', 'FontSize',20)
grid on



%% RAW AREAs against their normalization
figure;
for i = 1:N
    subplot(2,3,i)
    plot(time_mat_area{i}, area_mat{i}, 'Linewidth',1.5)
    hold on
    plot(time_mat_area{i}, A_normalized{i}, 'linewidth', 1.5)
    title(temps_strings{i}, 'FontSize', 20)
    legend('Unnormalized', 'Normalized','FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('Area', 'FontSize',20)
    grid on
end


%% MOVING AVERAGE OF AREA
% Preserve the first L points since they have higher uncertainty
K = 3;
MA = 5;
kb = 1;
kf = 1;
for i = 1:N
    A_smoothed{i} = [ A_normalized{i}(1:K)' movmean(A_normalized{i}(K+1:end), [kb, kf])' ];
end




%%  RAW AREAs against their smoothing
or = [0.9290 0.6940 0.1250];
figure;
for i = 1:N

    subplot(2,3, i)
    plot(time_mat_area{i}, A_normalized{i}, 'linewidth', 1.5, 'Color', or)
    hold on
    plot(time_mat_area{i}, A_smoothed{i}, 'Linewidth', 1.2, 'Color', 'k')
    set(gca, 'FontSize', 15)
    title(temps_strings{i}, 'FontSize', 20)
    legend('Raw', 'Smoothed','FontSize', 20)
    xlabel('Time[s]', 'FontSize',20)
    ylabel('Area', 'FontSize',20)
    ylim([-0.05, 0.2])
    grid on
end



%% FREQUENCIES against their smoothed version
figure;
for i = 1:N
    subplot(2,3, i)
    plot(time_dat{i}, wv_dat{i}, 'linewidth', 2)
    hold on
    plot(time_dat{i}, wv_smoothed{i}, 'linewidth', 1.5, 'color', 'k')
    title(temps_strings{i},'FontSize',20)
    legend('Raw', 'Smoothed','FontSize', 20)
    set(gca, 'FontSize', 15)
    xlabel('Time [s]', 'FontSize',20)
    ylabel('Wavenumber [cm^{-1}]', 'FontSize',20)
    grid on
end

%% FREQUENCIES Together smoothed
figure;
for i = 1:N
    subplot(2,3, i)
    plot(time_dat{i}, wv_smoothed{i}, 'linewidth', 2)
    title(temps_strings{i},'FontSize',20)
    set(gca, 'FontSize', 15)
    xlabel('Time [s]', 'FontSize',15)
    ylabel('Wavenumber [cm^{-1}]', 'FontSize',15)
    grid on
end


%%  AREAs Together normalized and smoothed
figure;
for i = 1:N

    plot(time_mat_area{i}, A_smoothed{i}, 'linewidth', 2)
    hold on
end
set(gca, 'FontSize', 20)
legend(temps_strings, 'FontSize', 20)
%title('Smoothed', 'FontSize', 20)
xlabel('Time [s]', 'FontSize',20)
ylabel('Area Processed', 'FontSize',20)
grid on


%% STORE AND SAVE
% Store area
area = A_smoothed;

% Store P off index
tp_idx = 45;
 
save('Data/area_ref490.mat', 'area', 'time_mat_area', 'cov_sat')
save('Data/wv.mat', 'wv', 'wv_dat', 'time_wv', 'time_dat', 'cov_sat')
save('Data/temps_info.mat', 'temps_strings', 'N', 'tp_idx')

