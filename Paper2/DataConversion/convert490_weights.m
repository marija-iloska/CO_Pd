clear all
close all
clc


% This script covnerts 490 using Weights (Area + Frequency)
load weights490isotherm.mat

% Load molar absorptivities
load epsilon_abs.mat
%load epsilons_mat.mat

% Load data
load Temps/T3.mat

% Create load string
temp_strings = {'490'};
Nt = length(temp_strings);
N = length(wv_split);
area = area_abs;



% Weights of area
Wa = 1 - Wf;
Wa(end) = 1;
Wf(end) = 0;


% Loop for all temperatures
for nt = 3:3

    clear cov cov_f

    % Region indices based on WV fitting for derivatives
    wv_splits = 1840;
    id{1} = find(wv{nt} < wv_splits);
    id{2} = find(wv{nt} > wv_splits);
    id{3} = find(wv{nt} == 0);
    id{1} = setdiff(id{1}, id{3});


    % GET COV( F )
    for n = 1:N+1
        cov_f(id{n}) = polyval(Pc(n,:), wv{nt}(id{n}));
    end

    % Get COV( A )
    cov_a = area{nt}'./epsilon_sat(nt);


    % Get COV(A + F)
    wv_splits = 1840;
    id{1} = find(wv{nt} < wv_splits);
    id{2} = find(wv{nt} > wv_splits);
    id{3} = find(wv{nt} == 0);
    id{1} = setdiff(id{1}, id{3});
    for n = 1:N+1
        cov(id{n}) = Wf(N-n+2)*cov_f(id{n}) + Wa(N+2-n)*cov_a(id{n});
    end
    cov(id{N+2}) = cov_a(id{N+2});
    cov(cov < 0) = 0;

    % STORE variables
    cov_mix{nt} = cov;
    cov_f_all{nt} = cov_f;
    cov_a_all{nt} = cov_a;
    time_all{nt} = time;

end


% Choose a temperature
gr = [4, 148, 124]/256;
dp = [92, 1, 138]/256;
ym = [247, 190, 2]/256;

for nt = 3:3
    % Plot weighted mix
    figure(nt)
    plot(time_area{nt}, cov_a_all{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1)
    hold on
    plot(time_wv{nt}, cov_f_all{nt}, 'color', ym, 'linewidth', 1)
    hold on
%     plot(time_area{nt}, cov_mix{nt}, 'color', 'k','linewidth', 2)
%     hold on
    legend('cov(A)', 'cov(F)' , 'cov(A+F)', 'FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('Coverage', 'FontSize',20)
    title(temp_strings{1}, 'FontSize', 20)
    grid on

end





% All areas
% figure(2)
% plot(time_area{nt}, cov_a_exp{nt}, 'color', 'k', 'linewidth', 1)
% hold on
% plot(time_area{nt}, cov_a_sat{nt}, 'linewidth', 1)
% hold on
% %plot(time_area{nt}, cov_a_all{nt},'linewidth', 1)
% %hold on
% legend('Area exp', 'Area sat', 'Area mix', 'FontSize', 20)
% xlabel('Time', 'FontSize',20)
% ylabel('Coverage', 'FontSize',20)
% title(temp_strings{nt}, 'FontSize', 20)
% grid on

% figure(3)
% for n = 1:3
%     plot(time_area{n}, cov_mix{n}, 'linewidth', 1)
%     hold on
% end
% set(gca, 'FontSize', 20)
% legend('450', '460', '490', 'FontSize', 20)
% xlabel('Time', 'FontSize',20)
% ylabel('Coverage', 'FontSize',20)
% title('Area-ABS')
% grid on

