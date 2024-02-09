function [k_oB, k_Bo, k_AB, k_BA, dlms] = get_knew(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M)


% Region indices
R1 = 1:tp_AB(1)+1;
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx : tp_AB(2);
R4 = tp_AB(2)+1 : N;



% Get kBo _________________________________________________ 
% It takes tau = 0 as starting point
tau1 = R4(2:end);
tau = R4(1:end-1);
ln_covB = - log(covB(tau1)./covB(tau(1)));
timeR4 = time(tau1) - time(tau(1));
dlm_kbo = fitlm(timeR4,ln_covB,'Intercept',false);
k_Bo = dlm_kbo.Coefficients.Estimate;
k_Bo_SE = dlm_kbo.Coefficients.SE;


% Get koB _________________________________________________ 
% Takes tau 0 starting
tau1 = R1(3:end);
tau = R1(2:end-1);

Y = covB(tau1) - (1 - k_Bo*dt(tau)).*covB(tau);
X = dt(tau).*P.*(M - cov(tau));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;
k_oB_SE = dlm_kob.Coefficients.SE;



% Get kAB _________________________________________________ 
tau1 = R3(2:end-5);
tau = R3(1:end-6);

Y = (covA(tau1) - covA(tau))./covA(tau);
X = - dt(tau).*(M - cov(tau));

dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;


% Get kBA _________________________________________________ 
tau1 = R2(3:end);
tau = R2(2:end-1);

Y = covA(tau1) - covA(tau) + k_AB*dt(tau).*covA(tau).*(M-cov(tau));
X = dt(tau)*P.*covB(tau);

dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;

%dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_koa, dlm_kab, dlm_kba};
dlms = {dlm_kob, dlm_kbo, dlm_kab, dlm_kba};


end