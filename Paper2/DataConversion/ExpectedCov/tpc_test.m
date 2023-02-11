clc
clear all
close all

% Load the digitized data Cov and P
load tpc_digitized.mat

p448 = dat448(:,1);
c448 = dat448(:,2);

p453 = dat453(:,1);
c453 = dat453(:,2);

p493 = dat493(:,1);
c493 = dat493(:,2);

% Here I extrapolate to get the coverages at P = 1e-5;
cov488 = interp1(p448, c448, 1e-5, "linear", "extrap");
cov453 = interp1(p453, c453, 1e-5, "linear", "extrap");
cov493 = interp1(p493, c493, 1e-5, "linear", "extrap");

cov = [cov488, cov453, cov493];
T  = [448, 453, 493];

%save('Ptc.mat', 'T','cov')

