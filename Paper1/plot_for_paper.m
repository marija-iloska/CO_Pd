clear all
close all
clc


% Plotting for paper

% Load Data
load Des450.mat
%load Des460.mat
load Des475.mat
load Des500.mat


% All plots
figure(1)

gp = [87, 194, 105]/ 256;
gs = [5, 102, 37]/256;

bp = [145, 165, 235]/256;
bs = [18, 22, 148]/256;

rp = [212, 19, 19]/256;
rs = [94, 4, 4]/256;

tp = [30, 214, 187]/256;
ts = [14, 117, 102]/256;


ms = [120, 16, 71]/256;
mp = [214, 118, 169]/256;

lwd = 3;
sz = 40;

figure(1);
%plot(time450, theta450, 'Color', rp, 'Linewidth', lwd)
%hold on
scatter(time450, cov450, sz,'filled','MarkerFaceColor', rp, 'Linewidth', 1)
hold on
%plot(time460, theta460, 'Color',rp, 'Linewidth', lwd)
%hold on
%scatter(time460, cov460, sz,'filled','MarkerFaceColor', rs, 'Linewidth', 1)
%hold on
%plot(time475, theta475,'Color', bp, 'Linewidth', lwd)
%hold on
scatter(time475, cov475, sz,'filled','MarkerFaceColor', bp, 'Linewidth', 1)
%hold on
%plot(time500, theta500, 'Color', gp, 'Linewidth', lwd)
%hold on
scatter(time500, cov500, sz,'filled', 'MarkerFaceColor', gs, 'Linewidth', 1)
set(gca,'FontSize',15, 'Linewidth',1)
xlabel('Time [s]', 'FontSize', 30)
ylabel('Coverage','FontSize', 30)
title('CO on Pd(111)', 'FontSize',30)
%grid on
box on
%legend('450K Fitting', '450K Data',  '460K Fitting', '460K Data', ...
%    '475K Fitting', '475K Data', '500K Fitting', '500K Data', 'FontSize', 30)
%legend('450K Fitting', '450K Data',  ...
%    '475K Fitting', '475K Data', '500K Fitting', '500K Data', 'FontSize', 20)
legend("450K", "475K", "500K")
ylim([0,0.34])
xlim([0,8])


ln450 = log(theta450./theta450(1));
ln475 = log(theta475./theta475(1));
ln500 = log(theta500./theta500(1));

lncov450 = log(cov450./cov450(1));
lncov475 = log(cov475./cov475(1));
lncov500 = log(cov500./cov500(1));


figure(2);
plot(time450, -ln450, 'Color', rp, 'Linewidth', lwd)
hold on
scatter(time450, -lncov450, sz,'filled','MarkerFaceColor', rs, 'Linewidth', 1)
set(gca,'FontSize',15, 'Linewidth',1)
xlabel('$$\tau$$', 'FontSize', 25, 'Interpreter',"latex")
ylabel('$$\bf{-ln(\frac{\theta_{\tau}}{\theta_{\tau_0}})}$$','FontSize', 20,'Interpreter',"latex")
legend('450K Fitting', '450K Data', 'FontSize',20)

figure(3)
plot(time475, -ln475,'Color', bp, 'Linewidth', lwd)
hold on
scatter(time475, -lncov475, sz,'filled','MarkerFaceColor', bs, 'Linewidth', 1)
set(gca,'FontSize',15, 'Linewidth',1)
xlabel('$$\tau$$', 'FontSize', 25, 'Interpreter',"latex")
ylabel('$$\bf{-ln(\frac{\theta_{\tau}}{\theta_{\tau_0}})}$$','FontSize', 20,'Interpreter',"latex")
legend('475K Fitting', '475K Data','FontSize',20)

figure(4)
plot(time500, -ln500, 'Color', gp, 'Linewidth', lwd)
hold on
scatter(time500, -lncov500, sz,'filled', 'MarkerFaceColor', gs, 'Linewidth', 1)
set(gca,'FontSize',15, 'Linewidth',1)
xlabel('$$\tau$$', 'FontSize', 25, 'Interpreter',"latex")
ylabel('$$\bf{-ln(\frac{\theta_{\tau}}{\theta_{\tau_0}})}$$','FontSize', 20,'Interpreter',"latex")
legend('500K Fitting', '500K Data','FontSize',20)



% Ideal Gas constant  (kcal / (K mol))
R = 0.001987204258;
%T = [450, 460, 475, 500];
%k2 = [k2_450, k2_460, k2_475, k2_500];
% 
T = [450, 475, 500];
k = [k450, k475, k500];

%Arrhenious equation
%k = A exp(-Ea/(RT))


%ln(k) = -Ea/(RT) + ln(A)

%Let x = - 1/(RT)

%ln(k) = Ea x + ln(A)

%Independent variable
x = - 1./(R*T);

% Get params
res = polyfit( x, log(k), 1);

Ea = res(1);
A = exp(res(2));

% Fit
ln_k = Ea*x + log(A);
k_fit = exp(ln_k);


figure(2)
scatter(1./T, log(k), 100, ms, 'filled')
hold on
plot(1./T, ln_k, 'Color', mp, 'Linewidth', 3)
set(gca, 'FontSize', 15)
xlabel('T^{-1} [ K^-^1 ]', 'FontSize', 30)
ylabel('ln(k [ s^-^1 ] )', 'FontSize', 30)
title('Arrhenius Plot','FontSize', 30)
box on
grid on
legend('ln(k)', 'Fitting', 'FontSize', 20)


