function [k1, k2] = get_k(coverage, time, P)

% Pulse off time
t_idx = find(time==2);


% Get k2
theta0 = coverage(t_idx);
theta1 = coverage(end);

k2 = -(1/time(end))*log(theta1/theta0);


% Get k1
%k1 = k2*theta0/(P*(1 - exp(-k2*time(t_idx))));

theta0 = coverage(1);
theta1 = coverage(t_idx);

top = k2*(theta1 - theta0*exp(-k2*time(t_idx)));
bottom = P*(1-exp(-k2*time(t_idx)));

k1 = top/bottom;



end

