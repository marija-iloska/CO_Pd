clear all
close all
clc


% For Paper

% Load data
P = 0.001;
load Coverage_data/CO_450K.mat

cut_off = 0.33;
tp_AB = find(cov > cut_off);
tp_AB = [tp_AB(1), tp_AB(end)];

% Get approximations
idx = find(cov == 0);
cov(idx) = 10e-4;


% Delta Time
dt = time(2:end) - time(1:end-1);
N = length(cov);
tN = 1:N;

% Get sat
%[S, M, covA, covB] = get_sat(cov, tN, tp_idx, tp_AB, cut_off);



% Now state B desorption
cov_de = cov(tp_AB(2) : end);
time_des = time(tp_AB(2):end) - time(tp_AB(2));

% Get k_Bo
ln_y = -log(cov_de./cov_de(1));
k2 = time_des(:)\ln_y(:);


theta(1) = cov_de(1);
% Desorption B
for t = 2 : length(time_des)
    theta(t) = theta(1)*exp(-k2*time_des(t));
end


time450 = time_des;
theta450 = theta;
cov450 = cov_de;
k2_450 = k2;

plot(time_des, theta)
hold on
plot(time_des, cov_de, '.')

%save('Des450.mat', 'theta450', 'cov450', 'time450', 'k2_450')
%save('Des475.mat', 'theta475', 'cov475', 'time475', 'k2_475')
%save('Des500.mat', 'theta500', 'cov500', 'time500', 'k2_500')


