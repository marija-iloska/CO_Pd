clear all
close all
clc


% Load DFT data and EXP Hoffman paper data
load exp_dft_data.mat

% INFO FOR DERIVATIVE
cov_test = 0.01:0.01:0.5;

% Manually choose points
% id0 = 1:5;
% id1 = 4:7;
% id2 = 7:9;
% id3 = 8:11;
% id4 = 11:15;

id0 = 1:8;
id1 = 8:10;
id2 = 9:14;
id3 = 13:15;
%:15;


% id0 = 1:8;
% id1 = 8:10;
% id2 = 9:12;


id = {id0, id1, id2, id3}; %, id4};
N = length(id);

% Polynomial degrees
degE = 1;


% % Fit regions, and get derivatives
for n = 1:N

    P(n,:) = polyfit( cov_exp(id{n}),  wv_exp(id{n}), degE);
    Pc(n,:) = polyfit( wv_exp(id{n}), cov_exp(id{n}), degE);

    Der(n) = polyder(P(n,:));

end

% Normalize derivatives to get weights
Ws = sum(Der);
Wf = Der./Ws;


%WV split
% idx0 = find(cov_test < 0.1);
% idx1 = find(cov_test < 0.25);
% idx2 = find(cov_test < 0.39);
% idx3 = find(cov_test < 0.43);
% idx4 = find(cov_test > 0.41);

idx0 = find(cov_test < 0.24);
idx1 = find(cov_test < 0.305);
idx2 = find(cov_test < 0.43);
idx3 = find(cov_test > 0.41);

% 
% idx0 = find(cov_test < 0.28);
% idx1 = find(cov_test < 0.43);
% idx2 = find(cov_test > 0.41);

%idx3 = setdiff(idx3, idx2);
idx2 = setdiff(idx2, idx1);
idx1 = setdiff(idx1, idx0);

idx = {idx0, idx1, idx2, idx3}; %, idx4};

% Get coverage fittings for low and high regions
% for n = 1:N
% 
%     wv_fit{n} = polyval(P(n,:), cov_test(idx{n}));
% 
% end
% 
% 
% 
save('weights.mat', 'Der', 'Wf', 'Ws', 'Pc');

figure(1)
for n = 1:N
    plot(cov_test(idx{n}), wv_fit{n}, 'linewidth',1)
    hold on
end
scatter(cov_exp, wv_exp, 40, 'k', 'filled')
xlabel('Coverage', 'FontSize',15)
ylabel('Wavenumber', 'FontSize',15)
set(gca, 'Ydir', 'reverse', 'FontSize', 15)
title('Line fitting in regions','FontSize', 15)
grid on
