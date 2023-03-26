clear all
close all
clc


% Area
%wv = [1820 1830.15466 1834.01168 1861.0108 1872.58185 1891.86694 1897.65246]; 
%cov = [0.065669165, 0.168939787, 0.224750444, 0.35752177, 0.394330745, 0.418598707, 0.439547591]; 

% Isoterm
wv = [1820 1830.15466 1834.01168 1861.0108 1872.58185 1891.86694 1897.65246, 1913.08053]; 
cov = [0.087 0.197 0.24 0.328 0.357 0.408 0.425 0.455];


% Points to fit
% id0 = 1:3;
% id1 = 4:8;
% id2 = 5:8;

id0 = 1:3;
id1 = 3:5;
id2 = 5:7;

id0 = 1:3;
id1 = 3:8;

id = {id0, id1}; %, id2};
N = length(id);

% id = {1:8};
% N = 1;


% Polynomial degrees
degE = 1;

% % Fit regions, and get derivatives
for n = 1:N

    P(n,:) = polyfit( cov(id{n}),  wv(id{n}), degE);
    Pc(n,:) = polyfit( wv(id{n}), cov(id{n}), degE);

    Der(n) = polyder(P(n,:));

end

Wf = Der./max(Der);
Wa = 1-Wf;

%save('weights450isotherm.mat', 'Wf', 'Wa', 'Der', 'Pc');

cov_test = 0 :0.01 : 0.5;

% idx0 = find(cov_test < 0.25);
% idx2 = find(cov_test > 0.34);
% idx1 = find(cov_test < 0.6);
% idx1 = setdiff(idx1, [idx0 idx2]);
% 
% idx = {idx0, idx1, idx2};

idx0 = find(cov_test < 0.245);
idx1  = find(cov_test >0.245);
idx = {idx0, idx1};

%idx = {1:length(cov_test)};
% Get coverage fittings for low and high regions
for n = 1:N

    wv_fit{n} = polyval(P(n,:), cov_test(idx{n}));

end


figure(1)
for n = 1:N
    plot(cov_test(idx{n}), wv_fit{n}, 'linewidth',1)
    hold on
end
scatter(cov, wv, 40, 'k', 'filled')
xlabel('Coverage', 'FontSize',15)
ylabel('Wavenumber', 'FontSize',15)
set(gca, 'Ydir', 'reverse', 'FontSize', 15)
title('Line fitting in regions','FontSize', 15)
grid on


