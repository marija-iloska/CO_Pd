clear all
close all
clc

% TESTING area myself

% Read in data
dat = table2array(readtable('460K.xlsx'));


range = 800: 1100;
wv_idx = 1;
in_idx = 100;


for i = 2:20
    temp = dat(range,i) - mean(dat(range,i));
    plot(dat(range, wv_idx), temp)
    hold on

    area_abs(i-1) = trapz(temp);
    area_mat(i-1) = trapz(abs(temp));
end


figure;
plot(area_mat)
hold on
plot(area_abs)
