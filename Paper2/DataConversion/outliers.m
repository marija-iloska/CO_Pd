function [cov, time, area, wv, tp_idx, id0, id1] = outliers(cov, time, area, wv, wv_split, high, low, tp_idx)


% Outliers
idx = find(cov > high);
cov(idx) = [];
time(idx) = [];
area(idx) = [];
wv(idx) = [];

o_down = sum(idx < tp_idx);

tp_idx = tp_idx - o_down;
id1 = find(wv > wv_split);

% Outliers
idx = find(cov < low);
cov(idx) = [];
time(idx) = [];
area(idx) = [];
wv(idx) = [];

o_down = sum(idx < tp_idx);
tp_idx = tp_idx - o_down;
id0 = find(wv < wv_split);

end