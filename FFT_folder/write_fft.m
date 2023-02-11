close all
clear all
clc

% Load raw and processed data
load 480K_fft.mat

% Concatenate them in matrix
A = [wv, x, y];

% Write matrix in excel sheet
% FFT_res.xlsx is the name of the excel sheet
% 'Sheet', 'Name of Sheet'
writematrix(A, 'FFT_res.xlsx', 'Sheet', '480K')

