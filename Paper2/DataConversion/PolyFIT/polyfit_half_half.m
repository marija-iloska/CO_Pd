function [cov0, cov1, wv0, wv1, wv_split, P0, P1] = polyfit_half_half(cov, wv, cov_split, wv_test, degree0, degree1)



% Get indices for low and high cov
idx0 = find(cov < cov_split);
idx1 = find(cov > cov_split);

wv_split = wv(idx0(end));

% Fit low regions (D0) and high regions (D1)
P0 = polyfit(wv(idx0), cov(idx0), degree0);
P1 = polyfit(wv(idx1), cov(idx1), degree1);


% WV split
wv0 = wv_test(wv_test < wv_split);
wv1 = wv_test(wv_test > wv_split);

% Get coverage fittings for low and high regions
cov0 = polyval(P0, wv0);
cov1 = polyval(P1, wv1);


% Get the associated splitting wavenumber
wv_split = wv(idx1(1));


end