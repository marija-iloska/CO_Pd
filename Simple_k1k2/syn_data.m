 clear all
clc
% Simplified system
% CO  --k1-->  CO-Pd
% CO  <--k2--  CO-Pd

% BASIC CODE
% T 475K  no O2 
%_______________________________________________________________


% Read in data
y = xlsread("475K_no_O2.xlsx");

% time
time = y(:,3);
cov = y(:,5);


% Data size (t_final)
t_f = length(cov);

% Pressure used
Pco = 0.001; %Pascals  (or 1e-5 mbar);



% Get rate constants deterministically
[k1, k2] = get_k(cov, time, Pco);


% Initialize
theta_x(1) = cov(1);
theta_x0 = cov(1);

% Pulse off index
t_off = find(time==2);



% Create data with k1 and k2
for t = 2:t_f
    
    % Pulse on
    if (t <= find(time==2))
        theta_x(t) = theta_x0*exp(-k2*time(t)) + (k1/k2)*Pco*(1 - exp(-k2*time(t)));    
    
    % Pulse off
    else
        theta_x(t) = theta_x(t_off)*exp(-k2*time(t));
    end
    
end



% Plotting

 % Deterministic
plot(time, theta_x, 'g', 'Linewidth',2)
hold on

% Real data
scatter(time, cov, 50,'filled', 'k', 'Linewidth', 3)
hold on
plot(time, cov, 'b', 'Linewidth', 2)
hold on
xline(time((time==2)), 'm','Linewidth',2);
xlabel('Time', 'FontSize', 30)
ylabel('Coverage','FontSize', 30)
title('Data', 'FontSize',35)
set(gca,'FontSize',15, 'Linewidth',1)
grid on
box on

legend('Syn data','Real data','','Pulse off')
%legend('Deterministic','Stochastic','Real data','','Pulse off')
