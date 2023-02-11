function [] = plotting(theta, theta_A, theta_B, cov, covA, covB, str, tp_idx, time, lwd, sz, fsz)

purple = [132, 53, 148]/256;

figure(1)
scatter(time, covB, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(time, theta_B, 'b', 'Linewidth',1)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
xline(time(tp_idx), 'm','Linewidth',lwd);
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage B', 'FontSize', 20)
legend('Experimental', 'Fitted','FontSize', 15)



% Plot A
figure(2)
scatter(time, covA, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
plot(time, theta_A, 'b')
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time', 'FontSize', 20)
ylabel('Coverage A', 'FontSize', 20)
legend('Experimental', 'Fitted', 'FontSize', 15)

% Plot B
figure(3)
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
plot(time, theta, 'Color', purple, 'Linewidth', lwd)
hold on
scatter(time, cov, sz, 'filled', 'k', 'Linewidth', lwd)
xlabel('Time', 'FontSize', fsz)
ylabel('Coverage','FontSize', fsz)
title(strcat(str,'K'), 'FontSize', 40)
set(gca,'FontSize',15, 'Linewidth', 1)
grid on
box on
legend('Fitted', 'Data', 'Pressure off')


end