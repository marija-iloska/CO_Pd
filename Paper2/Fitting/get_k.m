function [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M)


% Region indices
R1 = 1:tp_AB(1);
R2 = tp_AB(1) : tp_idx;
R3 = tp_idx : tp_AB(2);
R4 = tp_AB(2) : N;



% Get kBo   R4  
% It takes tau = 0 as starting point
ln_covB = - log(covB(R4(2:end))./covB(R4(1)));
timeR4 = time(R4(2:end)) - time(R4(1)+1);
%timeR4 = time(R4(2:end)) - time(R4(1));
dlm_kbo = fitlm(timeR4,ln_covB,'Intercept',false);
k_Bo = dlm_kbo.Coefficients.Estimate;
k_Bo_SE = dlm_kbo.Coefficients.SE;


% Takes tau 0 starting
R1 = 2:tp_AB(1);
Y = covB(R1) - (1 - k_Bo*dt(R1-1)).*covB(R1-1);
X = dt(R1-1).*P.*(M - cov(R1-1));
%Y = covB(R1) - (1 - k_Bo*dt(R1)).*covB(R1-1);
%X = dt(R1).*P.*(M - cov(R1-1));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;
k_oB_SE = dlm_kob.Coefficients.SE;






% Get kAo from other equation R3
Y = cov(R3(2:end)) -  cov(R3(1:end-1));
X = -dt(R3(1:end-1)).*covA(R3(1:end-1));
dlm_kao = fitlm(X,Y,'Intercept',false);
k_Ao = dlm_kao.Coefficients.Estimate;
k_Ao_SE = dlm_kao.Coefficients.SE;


% Get kAB from kAO
R3 = tp_idx : tp_AB(2);
Y = covA(R3(2:end)) - (1 - k_Ao*dt(R3(1:end-1))).*covA(R3(1:end-1));
X = - dt(R3(1:end-1)).*covA(R3(1:end-1)).*(M - cov(R3(1:end-1)));
dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;
k_AB_SE = dlm_kab.Coefficients.SE;




% Get kAB   R2   R3
% R3 = tp_idx : tp_AB(2);
% Y = covB(R3(2:end)) - covB(R3(1:end-1));
% X = covA(R3(1:end-1)).*dt(R3(1:end-1)).*(M - cov(R3(1:end-1)));
% dlm_kab = fitlm(X,Y,'Intercept',false);
% k_AB = dlm_kab.Coefficients.Estimate;
% k_AB_SE = dlm_kab.Coefficients.SE;


% Get kAo  R2 R3
% Y = covA(R3(2:end)) - (1 - k_AB*dt(R3(1:end-1)).*(M - cov(R3(1:end-1))) ).*covA(R3(1:end-1));
% X = -dt(R3(1:end-1)).*covA(R3(1:end-1));
% dlm_kao = fitlm(X,Y,'Intercept',false);
% k_Ao = dlm_kao.Coefficients.Estimate;





% Get kBA  R2
% Adding 1 to tp_AB(1) makes kBA MUCH higher. Check in results
R2 = tp_AB(1)+2 : tp_idx;
Y = covB(R2(2:end)) - covB(R2(1:end-1)) - k_AB*dt(R2(1:end-1)).*covA(R2(1:end-1)).*(M - cov(R2(1:end-1)));
X = - dt(R2(1:end-1))*P.*covB(R2(1:end-1));
dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;
k_BA_SE = dlm_kba.Coefficients.SE;



% Get koA
Y = cov(R2(2:end)) - cov(R2(1:end-1)) + k_Ao*dt(R2(1:end-1)).*covA(R2(1:end-1));
X = dt(R2(1:end-1))*P.*(M - cov(R2(1:end-1)));
dlm_koa = fitlm(X,Y,'Intercept',false);
k_oA = dlm_koa.Coefficients.Estimate;

dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_koa, dlm_kab, dlm_kba};

end