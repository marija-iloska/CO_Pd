% Clear
clear all
close all
clc

% Load data
P = 0.001;
load Coverage_data/CO_475K.mat
str = '475';

%% Process Data
% Get system divisions
cut_off = 0.33;
tp_AB = find(cov > cut_off);
tp_AB = [tp_AB(1), tp_AB(end)];

% Get approximations
idx = find(cov == 0);
cov(idx) = 10e-3;

% Delta Time
dt = [0, time(2:end) - time(1:end-1)];
N = length(cov);
tN = 1:N;



% Get individual coverages
[S, M, covA, covB] = get_sat(cov, tN, tp_idx, tp_AB, cut_off);

% Saturation
SA = covA(tp_idx);
SB = covB(tp_idx);

% Region indices
R1 = 1:tp_AB(1);
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx + 1 : tp_AB(2);
R4 = tp_AB(2)+1 : N;

% R1 = 1:tp_AB(1);
% R2 = tp_AB(1)+1 : tp_idx;
% R3 = tp_idx + 1 : tp_AB(2)+3;
% R4 = tp_AB(2) + 4 : N;

% Initial points shifts
r12 = 1;
r23 = 1;
r34 = 0;


% Get k constants
[k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M);

vals = [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA];


% Store stats to excel file
write_out(str, dlms, vals);

% Get fitting (simulation)
[theta_A, theta_B] = fitting(cov, covA, covB, dt, vals, tp_AB, tp_idx, N, r12, r23, r34, M, P);
theta = theta_A + theta_B;


% Plotting 
lwd = 2;
sz = 40;
fsz = 35;
plotting(theta, theta_A, theta_B, cov, covA, covB, str, tp_idx, time, lwd, sz, fsz)

% R1 = 1:tp_AB(1);
% R2 = tp_AB(1)+1 : tp_idx;
% R3 = tp_idx + 1 : tp_AB(2);
% R4 = tp_AB(2) + 1 : N;
% 
% theta475 = theta(R4);
% time475 = time(R4)-time(R4(1));
% cov475 = cov(R4);
% save('Des475.mat', 'theta475', "cov475", "time475");


