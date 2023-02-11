clear all
close all
clc

% Data for 450K 475K and 500K
%load rate_const25.mat

% Data for 450K 460K and 500K
%load rate_const475.mat

% Data for 460K 475K and 500K
load rate_const25.mat


k = [k2_1; k2_2];


% Ideal Gas constant  (kcal / (K mol))
R = 0.001987204258;


% Arrhenious equation
% k2 = A exp(-Ea/(RT))


% ln(k) = -Ea/(RT) + ln(A)

% Let x = - 1/(RT)

% ln(k) = Ea x + ln(A)

% Independent variable
x = - 1./(R*T);


for i = 1:2
% Get best fitting
res = polyfit( x, log(k(i,:)), 1);

Ea2(i) = res(1);
A2(i) = exp(res(2));

ln_k(i,:) = Ea2(i) * x + log(A2(i));

end

% Des separation
magenta  = [209, 75, 167]/256;
purple = [160, 66, 179]/256;

%save('activation2_450K.mat', 'A2', 'Ea2', 'R');

figure(1)
plot(1./T, ln_k(1,:), 'k', 'Linewidth', 3)
hold on
scatter(1./T, log(k2_1), 200, magenta, 'filled')
set(gca, 'FontSize', 20)
xlabel('$\bf{T^{-1}}$', 'FontSize', 40, 'Interpreter', 'Latex')
ylabel('$log( \bf{k_2^ {(1)}} )$', 'FontSize', 40, 'Interpreter', 'Latex')
title('Rate constant fitting','FontSize', 30)
box on
grid on
legend('fitting', 'ln(k_2)', 'FontSize', 20)

figure(2)
plot(1./T, ln_k(2,:), 'k', 'Linewidth', 3)
hold on
scatter(1./T, log(k2_2), 200, purple, 'filled')
set(gca, 'FontSize', 20)
xlabel('$\bf{T^{-1}}$', 'FontSize', 40, 'Interpreter', 'Latex')
ylabel('$log( \bf{k_2^ {(2)}} )$', 'FontSize', 40, 'Interpreter', 'Latex')
title('Rate constant fitting','FontSize', 30)
box on
grid on
legend('fitting', 'ln(k_2)', 'FontSize', 20)

