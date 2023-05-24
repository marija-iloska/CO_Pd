function [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = k_model_test(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M)


% Region indices
R1 = 1:tp_AB(1)+1;
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx : tp_AB(2);
R4 = tp_AB(2) : N;



% Get kBo _________________________________________________ 
% It takes tau = 0 as starting point
tau1 = R4(2:end);
tau = R4(1:end-1);

ln_covB = - log(covB(tau1)./covB(tau(1)));
timeR4 = time(tau1) - time(tau(1)+1);
timeR4 = time(tau1) - time(tau(1));
dlm_kbo = fitlm(timeR4,ln_covB,'Intercept',false);
k_Bo = dlm_kbo.Coefficients.Estimate;
k_Bo_SE = dlm_kbo.Coefficients.SE;


% Get koB _________________________________________________ 
% Takes tau 0 starting
tau1 = R1(2:end);
tau = R1(1:end-1);

Y = covB(tau1) - (1 - k_Bo*dt(tau)).*covB(tau);
X = dt(tau).*P.*(M - cov(tau));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;
k_oB_SE = dlm_kob.Coefficients.SE;



% Get kAB from kBo_________________________________________________ 
tau1 = R3(2:end);
tau = R3(1:end-1);


Bdiff = (cov(tau) - covB(tau))./cov(tau);
Adiff = (cov(tau) - covA(tau))./cov(tau);

Y = covB(tau1) - covB(tau) + k_Bo*dt(tau).*covB(tau).*Adiff;
X = covA(tau).*dt(tau).*(M - cov(tau)).*Bdiff;
dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;
k_AB_SE = dlm_kab.Coefficients.SE;


% Get kAo from kBo_________________________________________________ 
% tau1 = R3(2:end)-4;
% tau = R3(1:end-1)-4;
% 
% Y = cov(tau1) -  cov(tau) + k_Bo*dt(tau).*covB(tau).*(M - covA(tau))/M;
% X = -dt(tau).*covA(tau);
% dlm_kao = fitlm(X,Y,'Intercept',false);
% k_Ao = dlm_kao.Coefficients.Estimate;
% k_Ao_SE = dlm_kao.Coefficients.SE;


% Get kAo from kAB_________________________________________________ 
tau1 = R3(2:end);
tau = R3(1:end-1);

Bdiff = (cov(tau) - covB(tau))./cov(tau);
Adiff = (cov(tau) - covA(tau))./cov(tau);

Y = covA(tau1) - (1 - k_AB*dt(tau).*(M - cov(tau) ).*Bdiff).*covA(tau);
X = -dt(tau).*covA(tau);
dlm_kao = fitlm(X,Y,'Intercept',false);
k_Ao = dlm_kao.Coefficients.Estimate;


% Get kAB from kAO__________________________________________________
% tau1 = R3(2:end);
% tau = R3(1:end-1);
% Y = covA(tau1) - (1 - k_Ao*dt(tau).*covA(tau);
% X = - dt(tau).*covA(tau).*(M - cov(tau));
% dlm_kab = fitlm(X,Y,'Intercept',false);
% k_AB = dlm_kab.Coefficients.Estimate;
% k_AB_SE = dlm_kab.Coefficients.SE;




% Get kBA_________________________________________________ 
% Adding 1 to tp_AB(1) makes kBA MUCH higher. Check in results
tau1 = R2(2:end);
tau = R2(1:end-1);

Bdiff = (cov(tau) - covB(tau))./cov(tau);
Adiff = (cov(tau) - covA(tau))./cov(tau);

Y = covB(tau1) - covB(tau) - k_AB*dt(tau).*covA(tau).*(M - cov(tau)).*Bdiff;
Y = Y + k_Bo*dt(tau).*covB(tau).*Adiff  - k_oB*P*(M - cov(tau)).*Adiff;
X = - dt(tau)*P.*covB(tau).*Adiff;
dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;
k_BA_SE = dlm_kba.Coefficients.SE;



% Get koA
tau1 = R2(2:end);
tau = R2(1:end-1);

Bdiff = (cov(tau) - covB(tau))./cov(tau);
Adiff = (cov(tau) - covA(tau))./cov(tau);
Y = cov(tau1) - cov(tau) + k_Ao*dt(tau).*covA(tau);
Y = Y + k_Bo*dt(tau).*covB(tau).*Adiff;
X = dt(tau)*P.*(M - cov(tau));
dlm_koa = fitlm(X,Y,'Intercept',false);
k_oA = dlm_koa.Coefficients.Estimate;
k_oA_SE = dlm_kba.Coefficients.SE;


dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_koa, dlm_kab, dlm_kba};

end