clear all
close all
clc

% Initialize
temp_strings = {'450K.mat', '460K.mat', '470K.mat', '475K.mat', '480K.mat', '490K.mat'};
Nt = length(temp_strings);

% Load absorptivity
for n = 1:Nt

    str_load = join(['Absorptivity/molar', temp_strings{n}]);
    load(str_load)
    epsilons_sat(n) = epsilon_sat;
    epsilons_exp(n) = epsilon_exp;
    epsilons_dft(n) = epsilon_dft;

end

% Temperatures
T = [450, 460, 470, 475, 480, 490];


% Plot molar absorptivity with temperature
% Check Plot
plot(T, epsilons_dft, '.', 'Color', 'r', 'MarkerSize', 20)
hold on
plot(T, epsilons_dft, '-', 'Color', 'r', 'MarkerSize', 12)
hold on
plot(T, epsilons_exp, '.', 'Color', 'b', 'MarkerSize', 20)
hold on
plot(T, epsilons_exp, '-', 'Color', 'b', 'MarkerSize', 12)
hold on
plot(T, epsilons_sat, '.', 'Color', 'k', 'MarkerSize', 20)
hold on
plot(T, epsilons_sat, '-', 'Color', 'k', 'MarkerSize', 12)
xlabel('Temperatures', 'FontSize',20)
ylabel('Molar Absorptivity', 'FontSize', 20)
legend('DFT', '--', 'EXP', '--', 'SAT', '--', 'FontSize', 15)
set(gca, 'FontSize', 13)
grid on