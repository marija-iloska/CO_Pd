clear all
close all
clc

% Data for 450K 475K and 500K
%load rate_const25.mat

% Data for 450K 460K and 500K
% load rate_const475.mat

% Data for 450K 460K and 500K
% load rate_const500.mat

% Data for 460K 475K and 500K
load rate_const25.mat

% Ideal Gas constant  (kcal / (K mol))
R = 0.001987204258;


% Arrhenious equation
% k2 = A exp(-Ea/(RT))


% ln(k) = -Ea/(RT) + ln(A)

% Let x = - 1/(RT)

% ln(k) = Ea x + ln(A)

% Independent variable
x = - 1./(R*T);


% Get best fitting
res = polyfit( x, log(k1), 1);

Ea1 = res(1);
A1 = exp(res(2));

ln_k = Ea1 * x + log(A1);

% Des separation
purple = [194, 110, 240]/256;

%save('activation1_450K.mat', 'A1', 'Ea1', 'R');

figure(1)
plot(1./T, ln_k, 'k', 'Linewidth', 3)
hold on
scatter(1./T, log(k1), 200, purple, 'filled')
set(gca, 'FontSize', 20)
xlabel('$\bf{T^{-1}}$', 'FontSize', 40, 'Interpreter', 'Latex')
ylabel('$log( {\bf{k_1}} )$', 'FontSize', 40, 'Interpreter', 'Latex')
title('Rate constant fitting','FontSize', 30)
box on
grid on
legend('fitting', 'ln(k_1)', 'FontSize', 20)



