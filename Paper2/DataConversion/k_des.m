function [k] = k_des(cov, time, cov_split)

% Region 4
N = length(time);
tp_AB = find(cov > cov_split);
R = tp_AB(end) + 1 : N;

% Get indexed lnCOV and time for linear equation
ln_cov = - log(cov(R)./cov(tp_AB(2)));
time = time(R) - time(tp_AB(2)+1);

% Get fitting
dlm_k = fitlm(time, ln_cov,'Intercept',false);
k = dlm_k.Coefficients.Estimate;

end