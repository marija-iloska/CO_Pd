clc
clear all
close all

%% LOAD AND CONCATENATE 

% Load the digitized data Cov and P
load tpc_digitized.mat

% Pressure and coverage at 448K
p448 = dat448(:,1);
c448 = dat448(:,2);

% Pressure and coverage at 453K
p453 = dat453(:,1);
c453 = dat453(:,2);

% Pressure and coverage at 493K
p493 = dat493(:,1);
c493 = dat493(:,2);

% Concatenate digitized data
cov_raw = {c448, c453, c493};
p_raw = {p448, p453, p493};


%% EXTRAPOLATION

% I want to extrapolate for the following points
P = [1e-8, 1e-7, 5e-7, 7.5e-7, 1e-6, 2.5e-6, 5e-6, 7.5e-6, 1e-5, 1.2e-5]; %, 5e-5];
	
% Extrapolate
for p = 1:length(P)

    %Here I extrapolate to get the coverages at P = 1e-5;
    cov448(p) = interp1(p448, c448, P(p), "linear", "extrap");
    cov453(p) = interp1(p453, c453, P(p), "linear", "extrap");
    cov493(p) = interp1(p493, c493, P(p), "linear", "extrap");


end

% Concatenating extrapolated points
cov3 = [cov448; cov453; cov493];
T  = [448, 453, 493];
% 
% for i = 1:3
%     cov_raw{i}(end) = [];
%     p_raw{i}(end) = [];
% end


%% PLOTTING 

% Colors for plotting
c = 0.85;
red = [c 0 0];
pp = [0 0 c];
gr = [0 c 0];
col = {red, pp, gr};
str = {'448K dig', '453K dig', '493K dig', '448K inferred', '453K inferred', '493K inferred'};


% Concatenate original and interpolated points together for plotting
for i = 1:3

    cov_all{i} = sort([cov3(i,:), cov_raw{i}']);
    p_all{i} = sort([P, p_raw{i}']);
end

% Plot ORIGINAL digitized data
figure(1)
for i = 1:3

    plot(p_raw{i}, cov_raw{i}, 'k', 'LineWidth',1)
    hold on
    h(i) = plot(p_raw{i}, cov_raw{i}, '.', 'MarkerSize', 20, 'Color', 'k');

end

% Plot interpolated points and lines
figure(1)
for i = 1:3

    h(3+i) = plot(P, cov3(i,:), '.', 'MarkerSize', 20, 'Color', col{i});
    hold on
    plot(p_all{i}, cov_all{i}, 'Linestyle', '--', 'Color', col{i})
end
%xline(1e-5, 'Color', 'k', 'LineStyle','--', 'LineWidth', 2)
xlim([0, 1.2e-5])
legend(h, str, 'FontSize', 15)
set(gca, 'FontSize', 20)
xlabel('Pressure [mbar]', 'FontSize', 20)
ylabel('Coverage [ML]', 'FontSize', 20)
grid on



% interpolation = @(x,y, xq) y(1) + (y(2)-y(1))*((xq - x(1))/(x(2)-x(1)));
% 
% test = interpolation(p453(end-1:end), c453(end-1:end), P(end-1:end));

% figure;
% scatter(p_raw{i}, cov_raw{i}, 'k')
% hold on
% scatter(P(end-1:end), test)

%save('Ptc.mat', 'T','cov')
save('inferred.mat', 'T', 'P', 'cov_all','p_all', 'cov3','cov_raw', 'p_raw')

