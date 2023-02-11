close all
clear all
clc



% Coverage data 450K 
%____________________________________________________________
load Coverage_data/CO_460K.mat
y460 = cov;
time460 =time;


% Coverage data 475K
%____________________________________________________________
load Coverage_data/CO_475K.mat
y475 = cov;
time475 = time;


% Coverage data 500K
%____________________________________________________________
load Coverage_data/CO_500K.mat
y500 = cov;
time500 = time;


g = [34, 153, 65]/ 256;

rp = [212, 19, 19]/256;
rs = [94, 4, 4]/256;

bp = [145, 165, 235]/256;
bs = [18, 22, 148]/256;

lwd = 2;
sz = 80;
figure(1);
plot(time460, y460,'k', 'Linewidth', lwd)
hold on
plot(time475, y475, 'Color', bp, 'Linewidth', lwd)
hold on
plot(time500, y500, 'Color', rp, 'Linewidth', lwd)
xline(2, 'm','Linewidth',2);
scatter(time460, y460, sz,'filled', 'k', 'Linewidth', 1)
hold on
scatter(time475, y475, sz,'filled', 'MarkerFaceColor', bs, 'Linewidth', 1)
hold on
scatter(time500, y500, sz,'filled', 'MarkerFaceColor', rs, 'Linewidth', 1)
hold on
set(gca,'FontSize',15, 'Linewidth',1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage','FontSize', 20)
title('CO on Pd(111)', 'FontSize',30)
grid on
box on
legend('460K', '475K', '500K', 'Pulse off', 'FontSize', 20)
