function [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, dlms] = get_k_NM(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M, cut_off)


% Region indices
R1 = 1:tp_AB(1)+1;
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx : tp_AB(2);
R4 = tp_AB(2)+1 : N;


% PHASE B

% Get kBo _________________________________________________ 
tau1 = R4(7:end);
tau = R4(6:end-1);

Y = (covB(tau1) - covB(tau))./dt(tau);
X = - covB(tau);
dlm_kbo = fitlm(X, Y,'Intercept',false);
k_Bo = dlm_kbo.Coefficients.Estimate(1);
k_Bo_SE = dlm_kbo.Coefficients.SE;




% Get koB _________________________________________________ 
tau1 = R1(2:end);
tau = R1(1:end-1);

Y = covB(tau1) - (1 - k_Bo*dt(tau)).*covB(tau); 
X = dt(tau).*P.*(M - cov(tau));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;
k_oB_SE = dlm_kob.Coefficients.SE;



% PHASE A

% Get kAo _________________________________________________ 
% It takes tau = 0 as starting point
tau1 = R3(2:end)+3;
tau = R3(1:end-1)+3;

Y= - log(cov(tau1)./cov(tau(1)));
X = time(tau1) - time(tau(1));
dlm_kxo = fitlm(X, Y,'Intercept',false);
k_Xo = dlm_kxo.Coefficients.Estimate;
k_Xo_SE = dlm_kxo.Coefficients.SE;

Y = cov(tau)*k_Xo;
X = covA(tau);
dlm_kao = fitlm(X,Y,'Intercept',false);
k_Ao = dlm_kao.Coefficients.Estimate;





% Get koA _________________________________________________ 
% Takes tau 0 starting
tau1 = R2(2:end)-3;
tau = R2(1:end-1)-3;

Y = cov(tau1) - (1 - k_Xo*dt(tau)).*cov(tau); 
X = dt(tau).*P.*(M - cov(tau));

dlm_koa = fitlm(X,Y,'Intercept',false);
k_oA = dlm_koa.Coefficients.Estimate;
k_oA_SE = dlm_koa.Coefficients.SE;



% TRANSITIONS

% Get kBA and KAB____________________________________
% Number of points
L3 = length(R3);
L2 = length(R2);

L = min(L2, L3);

start = 2;

if L == L2
    range2 = start : 1 : L;
    range3 = floor(linspace(start, L3, length(range2)));
else
    range3 = start : 1 : L;
    range2 = floor(linspace(start, L2, length(range3)));
end


skip3 = -1;
skip2 = 0;
tau13 = R3(range3) + skip3;
tau3 = R3(range3-1) + skip3;
tau12 = R2(range2) + skip2;
tau2 = R2(range2-1) + skip2;


% Definitions
C2 = covB(tau12) - covB(tau2);
C3 = covA(tau13) - (1 - k_Ao*dt(tau3)).*covA(tau3);

C2AB = dt(tau2).*covA(tau2).*(M - cov(tau2));
C2BA = dt(tau2).*covB(tau2).*covA(tau3);

C3AB = dt(tau3).*covA(tau3).*(M - cov(tau3));
C3BA = dt(tau3).*covB(tau3).*covA(tau3);



% Get kBA________________________________________
Y = C2 + C3.*(C2AB./C3AB);
X = (C3BA./C3AB).*C2AB - C2BA;

dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;
k_BA_SE = dlm_kba.Coefficients.SE;



% Get kBA________________________________________
Y = k_BA*C3BA - C3;
X = C3AB;
dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;
k_AB_SE = dlm_kab.Coefficients.SE;

dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_kab, dlm_kba};

end