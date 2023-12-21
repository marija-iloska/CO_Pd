clear all
close all
clc


% Isoterm 450
wv = [1820 1830.15466 1834.01168 1861.0108 1872.58185 1891.86694 1897.65246, 1913.08053]; 
cov = [0.087 0.197 0.24 0.328 0.357 0.408 0.425 0.455];

% Isotherm 490
% cov = [0.022064467 0.057060629 0.134727552 0.183844973 0.289754413 0.321680737, 0.35972];
% wv = [1818.58 1820.5 1824.37 1834 1855.23 1864.87, 1888];

% % Points to fit 450
id0 = 1:3;
id1 = 3:8;
 %id2 = 6:8;
wv_splits = [(wv(id1(1))), (wv(id1(end-1)))];

% id = {id0, id1, id2};
% N = length(id);

% Points to fit 490
% id0 = 1:4;
% id1 = 5:7;
% 
id = {id0, id1};
N = length(id);



% Polynomial degrees
degE = 1;

% % Fit regions, and get derivatives
for n = 1:N

    P(n,:) = polyfit( cov(id{n}),  wv(id{n}), degE);
    Pc(n,:) = polyfit( wv(id{n}), cov(id{n}), degE);
    Pnew(n,:) = polyfit( wv(id{n}), cov(id{n}), 2);


    Der(n) = polyder(P(n,:));

end

Wf = Der./max(Der);
Wa = 1-Wf;



cov_test = 0 :0.005 : 0.5;

% 450 split
% idx0 = find(cov_test < 0.25);
% idx2 = find(cov_test > 0.36);
% idx1 = find(cov_test < 0.6);
% idx1 = setdiff(idx1, [idx0 idx2]);
% 
% idx = {idx0, idx1, idx2};


% 490 split
% idx0 = find(cov_test < 0.2);
% idx1  = find(cov_test >0.2);
% idx = {idx0, idx1};

save('Data/weights450isotherm.mat', 'Wf', 'Wa', 'Der', 'Pc', 'wv_splits');
%save('weights490isotherm.mat', 'Wf', 'Wa', 'Der', 'Pc');




%idx = {1:length(cov_test)};

wv_test = 1813:1:1940;

idx{1} = find(wv_test < wv_splits(1));
idx{2} = find(wv_test < wv_splits(2));
idx{2} = setdiff(idx{2}, idx{1});
idx{3} = find(wv_test > wv_splits(2));




% Get coverage fittings for low and high regions
for n = 1:N
 
      cov_fit{n} = polyval(Pc(n,:), wv_test(idx{n}));
%     wv_fit{n} = polyval(P(n,:), cov_test(idx{n}));
 
 end
 
% figure(1)
% for n = 1:N
%     plot(cov_test(idx{n}), wv_fit{n}, 'linewidth',3)
%     hold on
% end
% scatter(cov, wv, 60, 'k', 'filled')
% xlabel('Coverage [ML]', 'FontSize',15)
% ylabel('Wavenumber [cm^{-1}]', 'FontSize',15)
% set(gca, 'Ydir', 'reverse', 'FontSize', 15)
% %title('Line fitting in regions','FontSize', 15)
% grid on

figure(1)
for n = 1:N
    plot(wv_test(idx{n}), cov_fit{n}, 'linewidth',3)
    hold on
end
scatter(wv, cov, 60, 'k', 'filled')
ylabel('Coverage [ML]', 'FontSize',15)
xlabel('Wavenumber [cm^{-1}]', 'FontSize',15)
set(gca, 'FontSize', 15)
%title('Regions','FontSize', 15)
grid on


% i{1}= 1:4;
% i{2} = 5:8;
% N = 2;
% 
% Pnew(1,:) = polyfit( wv(i{1}), cov(i{1}), 2);
% Pnew(2,:) = polyfit( wv(i{2}), cov(i{2}), 2);
% 
% % ONE FITTING
% %Pnew = polyfit(wv, cov, 4);
% for n = 1:N
%     cov_new{n} = polyval(Pnew(n,:), wv_test(idx{n}));
% end
% figure;
% for n = 1:N
%     plot(wv_test(idx{n}), cov_new{n}, 'linewidth',3)
%     hold on
% end
% scatter(wv, cov, 60, 'k', 'filled')

