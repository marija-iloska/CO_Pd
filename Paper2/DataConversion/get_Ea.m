function [Ea, A, ln_k] = get_Ea(k, T, R)

% The units of Ea depend on the units of the R value entered

% Arrhenious equation
% k = A exp(-Ea/(RT))
% ln(k) = -Ea/(RT) + ln(A)

% Let x = - 1/(RT)
% ln(k) = Ea x + ln(A)
x = - 1./(R*T);


% Linear Fit
res = polyfit(x, log(k), 1);

% Get activation energy and exponential factor
Ea = res(1);
A = exp(res(2));

% Get fitted ln(k)s
ln_k = Ea*x + res(2);




end