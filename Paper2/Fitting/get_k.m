function [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M)


% Region indices
R1 = 1:tp_AB(1);
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx + 1 : tp_AB(2);
R4 = tp_AB(2) + 1 : N;

% R1 = find(time < 0.738);
% idx = find(time < time(tp_idx));
% R2 = R1(end)+1 : idx(end);
% idx = find(time < 3.552);
% R3 = R2(end)+1 : idx(end);
% R4 = R3(end)+1: N;


% Get kBo   R4    and  R1
ln_covB = - log(covB(R4)./covB(tp_AB(2)));
timeR4 = time(R4) - time(tp_AB(2)+1);
dlm_kbo = fitlm(timeR4,ln_covB,'Intercept',false);
k_Bo = dlm_kbo.Coefficients.Estimate;



% Get koB  R1
Y = covB(R1+1) - (1 - k_Bo*dt(R1)).*covB(R1);
X = dt(R1).*P.*(M - cov(R1));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;


% Get kAB   R2   R3
Y = covB(R3(2:end)) - covB(R3(1:end-1));
X = covA(R3(1:end-1)).*dt(R3(1:end-1)).*(M - cov(R3(1:end-1)));
dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;



% Get kAo  R2 R3
Y = covA(R3(2:end)) - (1 - k_AB*dt(R3(1:end-1)).*(M - cov(R3(1:end-1))) ).*covA(R3(1:end-1));
X = -dt(R3(1:end-1)).*covA(R3(1:end-1));
dlm_kao = fitlm(X,Y,'Intercept',false);
k_Ao = dlm_kao.Coefficients.Estimate;



% Get kBA  R2
Y = covB(R2(2:end)) - covB(R2(1:end-1)) - k_AB*dt(R2(1:end-1)).*covA(R2(1:end-1)).*(M - cov(R2(1:end-1)));
X = - dt(R2(1:end-1))*P.*covB(R2(1:end-1));
dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;



% Get koA
Y = cov(R2(2:end)) - cov(R2(1:end-1)) + k_Ao*dt(R2(1:end-1)).*covA(R2(1:end-1));
X = dt(R2(1:end-1))*P.*(M - cov(R2(1:end-1)));
dlm_koa = fitlm(X,Y,'Intercept',false);
k_oA = dlm_koa.Coefficients.Estimate;

dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_koa, dlm_kab, dlm_kba};

end