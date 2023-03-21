clc
clear all
close all

% Load the digitized data Cov and P
load tpc_digitized.mat

% Pressure and coverage at 448K
p448 = dat448(:,1);

c448 = dat448(:,2);

% Pressure and coverage at 453K
p453 = dat453(:,1);
c453 = dat453(:,2);

p493 = dat493(:,1);
c493 = dat493(:,2);

cov_raw = {c448, c453, c493};
p_raw = {p448, p453, p493};


% I want to interpolate for this
%P = [1e-8, 5e-8, 1e-7, 5e-7, 1e-6, 5e-6, 1e-5, 5e-5];
P = [1.3e-8, 5.2e-8, 1.16e-7, 4.86e-7, 9.76e-7, 5.38e-6, 1.1e-5, 5.1e-5];
%P = [5.15256e-8, 1.20003e-7, 5.00938e-7, 1.10275e-6, 6.00147e-6, 1.10092e-5];
	

for p = 1:length(P)

    % Here I extrapolate to get the coverages at P = 1e-5;
    cov448(p) = interp1(p448, c448, P(p), "linear", "extrap");
    cov453(p) = interp1(p453, c453, P(p), "linear", "extrap");
    cov493(p) = interp1(p493, c493, P(p), "linear", "extrap");

end

cov3 = [cov448; cov453; cov493];

% cov = [cov488, cov453, cov493];
T  = [448, 453, 493];

%save('Ptc.mat', 'T','cov')

save('P_extrap.mat', 'T', 'P', 'cov3', 'cov_raw', 'p_raw')

