clear all
close all
clc

% TESTING area myself

% Read in data
dat = table2array(readtable('480K.xlsx'));


range = 2: 1609;
wv_idx = 1;
wv = dat(2: end, 1);
idx0 = find(wv>1750);
idx0 = idx0(end);

idx1 = find(wv< 2050);
idx1 = idx1(1);

range_idx = idx1:idx0;

for i = 2:length(dat(1, :))

%     figure(1)
    temp = dat(range,i) - mean(dat(range,i));
    y = lowpass(temp, 0.02);
    plot(dat(range_idx, wv_idx), y(range_idx-1))
    hold on
    yline(0)
    hold on
    %plot(dat(range_idx, wv_idx), dat(range_idx, i), 'Linestyle', '--', 'Linewidth', 2)
    xlim([1500, 2350])


     area_mat_raw(i-1) = trapz(temp(range_idx-1));
     area_mat(i-1) = trapz(abs(y(range_idx-1)));
end


figure;
plot(movmean(lowpass(area_mat, 0.02), 1))
hold on
plot(area_mat)
