function [k, k_SE, Rsq_k] = k_des(cov, time, cov_split, tp_idx)

cov(cov <= 0) = 10e-4;

% Region 4
R = find(cov < cov_split);
R(R < tp_idx) = [];

% Get indexed lnCOV and time for linear equation
ln_cov = - log(cov(R(2:end))./cov(R(1)));
time = time(R(2:end)) - time(R(1));

% Get fitting
dlm_k = fitlm(time, ln_cov,'Intercept',false);
k = dlm_k.Coefficients.Estimate;


k_SE = dlm_k.Coefficients.SE(1);
Rsq_k = dlm_k.Rsquared.Ordinary;

end