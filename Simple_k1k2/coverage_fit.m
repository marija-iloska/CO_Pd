clear all

eps = 1.2914;

% Temporary
coverage0 = @(area) area./eps;
coverage1 = @(w) 0.001642*w - 2.7119;





% Read in data
%y = xlsread("450K_no_O2_new.xlsx");
%y = xlsread("475K_no_O2.xlsx");
y = xlsread("450K_no_O2.xlsx");
% y2 = xlsread("500K_no_O2.xlsx");

% % Wavenumber vs time
% time = y(:,3);
% wave_t = y(:,4);
% area = y(:,5);

% Wavenumber vs time
time_new = y(:,3);
wave_new = y(:,4);
area_new = y(:,5);




% Get indices before and after 1820 of Cov vs Wv
idx0 = find(wave_new < 1825);
idx1 = find(wave_new > 1825);

% Initialize
cov_time = zeros(1,length(time_new));


% Get data
cov_time(idx0) = coverage0(area_new(idx0));
cov_time(idx1) = coverage1(wave_new(idx1));
% cov_time = [0.3, cov_time,];
% time_new = [0, time_new'];


% Plot data
scatter(time_new, cov_time, 50,'filled', 'k', 'Linewidth', 3)
hold on
plot(time_new, cov_time, 'b', 'Linewidth', 1)
hold on
xline(time((time_new==2)), 'm','Linewidth',2);
xlabel('Time', 'FontSize', 30)
ylabel('Coverage','FontSize', 30)
title('Data', 'FontSize',35)
set(gca,'FontSize',15, 'Linewidth',1)
grid on
box on
legend('Coverage','','Pulse off')

% Save data
save('coverage.xlsx', 'cov_time')

