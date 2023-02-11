function [] = plotting(theta, cov, str, tp_idx, time, lwd, sz, fsz)

purple = [132, 53, 148]/256;
green = [124, 166, 65]/256;

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
legend('Pressure OFF', 'Fiited', 'Data')


end