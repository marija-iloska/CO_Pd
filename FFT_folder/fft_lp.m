clear all
close all
clc


% Read in data
dat = readcell('100avg_allT.xlsx', 'Sheet','500K');

% Row and Column lengths
dr = length(dat(:,1));
dc = length(dat(1,:));

% Wavenumber
wv = cell2mat(dat(778:1245, 1));

% Raw data
x = cell2mat(dat(778:1245, 2:dc));

% Processed data
y = lowpass(x, 0.02);



j = datasample(1:dc-1, 1);
plot(wv, x(:,j));
hold on
plot(wv, y(:,j), 'k', 'LineWidth',1);
set(gca, 'FontSize', 12)
xlabel('Wavenumber')
legend('Raw Data', 'From Example', 'From Code', 'FontSize', 15)

%save('500K_fft.mat','x', 'y', 'wv')


