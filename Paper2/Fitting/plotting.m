function [] = plotting(cov, theta, time, dtime, tp_idx, sz, lwd, str_cov, str, cut_off, gd)

scatter(time, cov, sz, 'filled', 'k', 'Linewidth', lwd)
hold on
xline(time(tp_idx), 'm','Linewidth',lwd);
hold on
yline(cut_off, 'color', 'm', 'LineWidth', lwd, 'LineStyle', '--')
hold on
plot(dtime, theta, 'Color', gd, 'Linewidth',lwd)
hold on
ylim([0,0.45])
set(gca,'FontSize',15, 'Linewidth', 1)
xlabel('Time [s]', 'FontSize', 20)
ylabel( str_cov, 'FontSize', 20)
legend('Data', 'Pressure off', 'Phase change', 'Fitting',  'FontSize',15)
grid on
box on


end