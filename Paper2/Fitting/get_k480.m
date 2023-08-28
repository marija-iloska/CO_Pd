function [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA, k_oX, k_Xo, dlms] = get_k480(cov, time, covA, covB, dt, tp_idx, tp_AB, N, P, M)


% Region indices
R1 = 1:tp_AB(1)+1;
R2 = tp_AB(1)+1 : tp_idx;
R3 = tp_idx : tp_AB(2);
R4 = tp_AB(2)+1 : N;


% DESORPTION

% Get kBo _________________________________________________ 
% It takes tau = 0 as starting point
tau1 = R4(3:end);
tau = R4(2:end-1);

% Y= - log(covB(tau1)./covB(tau(1)));
% X = time(tau1) - time(tau(1));
Y = (covB(tau1) - covB(tau))./dt(tau);
X = - covB(tau);
% dlm_kbo = fitlm(X, Y,'Intercept',true);
% c = dlm_kbo.Coefficients.Estimate(1);
dlm_kbo = fitlm(X, Y,'Intercept',false);
%c = dlm_kbo.Coefficients.Estimate(1);
k_Bo = dlm_kbo.Coefficients.Estimate(1);
k_Bo_SE = dlm_kbo.Coefficients.SE;


% Get kXo _________________________________________________ 
% It takes tau = 0 as starting point
tau1 = R3(2:end)+1;
tau = R3(1:end-1)+1;

Y= - log(cov(tau1)./cov(tau(1)));
X = time(tau1) - time(tau(1));
dlm_kxo = fitlm(X, Y,'Intercept',false);
k_Xo = dlm_kxo.Coefficients.Estimate;
k_Xo_SE = dlm_kxo.Coefficients.SE;


% Get koA_________________________________________________ 
%k_Ao = k_Xo; % (k_Xo*cov(tau) - k_Bo*covB(tau))./covA(tau);
Y = cov(tau)*k_Xo;
X = covA(tau);
dlm_kao = fitlm(X,Y,'Intercept',false);
k_Ao = dlm_kao.Coefficients.Estimate;


% ADSORPTION

% Get koB _________________________________________________ 
% Takes tau 0 starting
tau1 = R1(2:end);
tau = R1(1:end-1);

Y = covB(tau1) - (1 - k_Bo*dt(tau)).*covB(tau); % - c*dt(tau);
X = dt(tau).*P.*(M - cov(tau));
dlm_kob = fitlm(X,Y,'Intercept',false);
k_oB = dlm_kob.Coefficients.Estimate;
k_oB_SE = dlm_kob.Coefficients.SE;



% Get koX _________________________________________________ 
% Takes tau 0 starting
tau1 = R2(2:end)-2;
tau = R2(1:end-1)-2;

Y = cov(tau1) - (1 - k_Xo*dt(tau)).*cov(tau);
X = dt(tau).*P.*(M - cov(tau));
dlm_kox = fitlm(X,Y,'Intercept',false);
k_oX = dlm_kox.Coefficients.Estimate;
k_oX_SE = dlm_kox.Coefficients.SE;

% Get koA 
k_oA = k_oX; % - k_oB;


% Get kAB from kBo_________________________________________________ 
tau1 = R3(2:end)-1;
tau = R3(1:end-1)-1;

Y = covB(tau1) - covB(tau); 
% Y = covB(tau1) - (1 - k_Bo*dt(tau)).*covB(tau); 
X = covA(tau).*dt(tau).*(M - cov(tau));
dlm_kab = fitlm(X,Y,'Intercept',false);
k_AB = dlm_kab.Coefficients.Estimate;
k_AB_SE = dlm_kab.Coefficients.SE;



% Get kBA ______________________________________________________
tau1 = R2(2:end)+1;
tau = R2(1:end-1)+1;

% Y = covA(tau1) - (1 - k_Ao*dt(tau) - k_AB*dt(tau).*(M - cov(tau)) ).*covA(tau);
% Y = Y - k_oA*dt(tau).*P.*(M-cov(tau));
% X = dt(tau)*P.*covB(tau);
Y = covB(tau1) - covB(tau);
Y = Y - k_AB*covA(tau).*dt(tau).*(M - cov(tau));
X = - dt(tau)*P.*covB(tau);
dlm_kba = fitlm(X,Y,'Intercept',false);
k_BA = dlm_kba.Coefficients.Estimate;
k_BA_SE = dlm_kba.Coefficients.SE;


dlms = {dlm_kob, dlm_kbo, dlm_kao, dlm_kab, dlm_kba};

end