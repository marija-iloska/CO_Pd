lear all
close all
clc


% This script covnerts 450 using Weights (Area + Frequency)
load weights450isotherm.mat

% Load molar absorptivities
load epsilons_mat_norm.mat

% Load data
load area_ref490_MA5.mat
load wv_MA5.mat

% Strings of temps in data
temps_strings = { '450', '460', '470', '475', '480', '490'};

% Create load string
Nt = length(temps_strings);

wv_splits = [1834, 1872];
N = length(wv_splits);


WF = [0, Wf];
WA = 1 - WF;


% Loop for all temperatures
for nt = 1:Nt

    clear cov cov_f cov_a id

    % Region indices based on WV fitting for derivatives
    id{1} = find(wv{nt} == 0);
    id{2} = find(wv{nt} < wv_splits(1));
    id{3} = find(wv{nt} < wv_splits(2));
    id{4} = find(wv{nt} > wv_splits(2));

    id{3} = setdiff(id{3}, id{2});
    id{2} = setdiff(id{2}, id{1});

    % GET COV( F )
    for n = 1:N+2
        if (n == 1)
            cov_f(id{n}) = 0;
        else
            cov_f(id{n}) = polyval(Pc(n-1,:), wv{nt}(id{n}));
        end
    end

    wv_splits = [1834, 1872];
    % Region indices based on WV fitting for derivatives
    id{1} = find(wv{nt} == 0);
    id{2} = find(wv{nt} < wv_splits(1));
    id{3} = find(wv{nt} < wv_splits(2));
    id{4} = find(wv{nt} > wv_splits(2));

    id{3} = setdiff(id{3}, id{2});
    id{2} = setdiff(id{2}, id{1});

    % Get COV( A )
    cov_a_sat{nt} = area{nt}./epsilon_sat(nt);
    cov_a_exp{nt} = area{nt}./epsilon_exp(nt);
    cov_a = cov_a_sat{nt};
    cov_a(id{1}) = cov_a_exp{nt}(id{1});
    cov_a(id{2}) = cov_a_exp{nt}(id{2});


    % Get COV(A + F)
    for n = 1:N+2
        cov(id{n}) = WF(n)*cov_f(id{n}) + WA(n)*cov_a(id{n});
    end
    cov(cov < 0) = 0;
    cov_f(id{1}) = [];


    % STORE variables
    cov_mix{nt} = cov;
    cov_f_all{nt} = cov_f;
    cov_a_all{nt} = cov_a;

    range{nt} = [cov(id{1}(end)), cov(id{2}(end)), cov(id{3}(end))];

end


% Choose a temperature
gr = [4, 148, 124]/256;
dp = [92, 1, 138]/256;
ym = [247, 190, 2]/256;

for nt = 1:Nt
    % Plot weighted mix
    figure
    plot(time_mat_area{nt}, cov_a_sat{nt}, 'color', [0 0.4470 0.7410], 'linewidth', 1.5)
    hold on
    plot(time_mat_area{nt}, cov_a_exp{nt}, 'color', 'r', 'linewidth', 1.5)
    hold on
    plot(time_wv{nt}, cov_f_all{nt}, 'color', ym, 'linewidth', 1.5)
    hold on
    plot(time_mat_area{nt}, cov_mix{nt}, 'color', 'k','linewidth', 1)
    hold on
%     yline(range{nt}(1), 'm')
%     hold on
%     yline(range{nt}(2), 'm')
%     hold on
%     yline(range{nt}(3), 'm')
    legend('cov( A_{SAT} )', 'cov( A_{EXP} )', 'cov( F )' , 'cov( A+F )', 'FontSize', 20)
    xlabel('Time', 'FontSize',20)
    ylabel('Coverage', 'FontSize',20)
    title(temps_strings{nt}, 'FontSize', 20)
    grid on

end

time_mix = time_mat_area;

save('coverage_vs_time.mat', 'cov_mix', 'time_mix', 'area', 'wv', 'time_wv', 'cov_f_all', 'cov_a_sat', 'cov_a_exp', 'cov_a_all', 'temps_strings', 'tp_idx', 'Nt')

