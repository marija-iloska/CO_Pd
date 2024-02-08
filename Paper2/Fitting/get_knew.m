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
tau1 = R1(2:end);
tau = R1(1:end-1);

Y = covB(tau1) - (1 - k_Bo*dt(tau)).*covB(tau);
X = dt(tau).*P.*(M - cov(tau));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;
k_oB_SE = dlm_kob.Coefficients.SE;


d = 1;

% Get kAB and kBA_________________________________________________ 
if length(R2) > length(R3)
    L = length(R3);
    tau21 = [R2(2:L-d), R2(end-d+1 : end)];
    tau2 = [R2(1:L-d-1), R2(end-d : end-1)];
    tau31 = R3(2:L);
    tau3 = R3(1:L-1);
else
    L = length(R2);
    tau21 = R2(2:L);
    tau2 =  R2(1:L-1);

    tau31 = [R3(2:L-d), R3(end-d+1:end)];
    tau3 = [R3(1:L-d-1), R3(end-d:end-1)];
end


rho2 = covA(tau2).*(M - cov(tau2));
rho3 = covA(tau3).*(M - cov(tau3));
rho = rho2./rho3;

alpha3 = covA(tau3)./cov(tau3);
alpha2 = covA(tau2)./cov(tau2);

Y2 = covB(tau21) - (1- k_Bo*dt(tau2)).*covB(tau2) - k_oB*dt(tau2).*P.*(M-cov(tau2));   
Y3 = covB(tau31) - (1- k_Bo*dt(tau3)).*covB(tau3);  

Y = Y2 - Y3;
X = dt(tau2).*( covB(tau3).*alpha3.*rho - covB(tau2).*alpha2 );

dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;



Y = Y3 + k_BA*dt(tau3).*covB(tau3).*alpha3;
X = dt(tau3).*rho;

dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;

%dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_koa, dlm_kab, dlm_kba};
dlms = {dlm_kob, dlm_kbo, dlm_kab, dlm_kba};


end