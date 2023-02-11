clear all
close all
clc


%-------------------------------------------------
%       NON-SCALED POLYFIT FULL RANGE DATA
%--------------------------------------------------

temp_strings = {'450', '460', '470', '475', '480', '490'};
N = length(temp_strings);
sz = 60;

% Splitting coverage
cov_split = 0.3;

% Temperatures
T = [450, 460, 470, 475, 480, 490];
% Which data points to include
idx = 1:N-2;

% Ideal Gas constant  (kcal / (K mol))
R = 0.001987204258;

covs = 0.25 : 0.005 : 0.32;

covs = 0.28;

Nsplit = length(covs);

for j = 1 : Nsplit

    k = 1;

    for n = 1:N
        % Create load string
        str_polyfull = join( [ 'Converted/', temp_strings{n}, ' K_polyfull.mat'] );
    
        % Load data
        load(str_polyfull)
    
        % Rename vars with temp to make easier
        % For COV
        strV = erase(temp_strings{n}, ' K');
        cov_pf = str2var(join(['covD', strV]));
        
        % For TIME
        time_pf = str2var(join(['timeD', strV]));
    
        % Get k_des for each temp
        k_pf(n) = k_des(cov_pf, time_pf, covs(j));
    
    end
    
    
    % Get Ea
    [Ea, A, ln_k] = get_Ea(k_pf(idx), T(idx), R);

    Ea_ns_pf(j) = Ea;

end

% Plot fit
figure(1)
plot(1./T(idx), ln_k, 'LineWidth', 1)
hold on
scatter(1./T(idx), log(k_pf(idx)), sz, 'filled')
set(gca, 'FontSize', 13)
xlabel('1/T', 'FontSize', 20)
ylabel('log(k)','FontSize', 20)
title('Ea fitting POLYFIT FULL RANGE', 'FontSize', 15)


figure(2)
plot(covs, Ea_ns_pf)


%---------------------------------------------
%       SCALED FULL RANGE POLYFIT DATA
%---------------------------------------------



for j = 1 : Nsplit

    for n = 1:N
    
        % Create load string
        str_polyfull = join( [ 'Converted/', temp_strings{n}, 'K_polyfull_scaled.mat'] );
    
        % Load data
        load(str_polyfull)
    
        % Rename vars with temp to make easier
        % For COV
        cov_pf = str2var(join(['covD', temp_strings{n}, '_sc']));
        
        % For TIME
        time_pf = str2var(join(['timeD', temp_strings{n}]));
    
        % Get k_des for each temp
        k_pf_sc(n) = k_des(cov_pf, time_pf, covs(j));
    
    end
    
    
    % Get Ea
    [Ea_sc, A_sc, ln_ksc] = get_Ea(k_pf_sc(idx), T(idx), R);
    
    Ea_sc_pf(j) = Ea_sc;


end


% Plot fit
figure(2)
plot(1./T(idx), ln_ksc, 'LineWidth', 1)
hold on
scatter(1./T(idx), log(k_pf_sc(idx)), sz, 'filled')
xlabel('1/T', 'FontSize', 20)
ylabel('log(k)','FontSize', 20)
title('Ea fitting POLYFIT FULL RANGE scaled', 'FontSize', 15)




%---------------------------------------------
%       AREA ONLY (SATURATION EPSILON)
%----------------------------------------------



for j = 1:Nsplit

    % Get all temps
    for n = 1:N

        % Load string
        str_area_cov = join(['Converted/AREA/cov', temp_strings{n}, 'Asat.mat']);
        load(str_area_cov)
        k_area(n) = k_des(cov_sat, time, covs(j));

    end


    % Get Ea
    [Ea_area, A_area, ln_k_area] = get_Ea(k_area(idx), T(idx), R);

    Ea_a(j) = Ea_area;

end



% Plot fit
figure(3)
plot(1./T(idx), ln_k_area, 'LineWidth', 1)
hold on
scatter(1./T(idx), log(k_area(idx)), sz, 'filled')
xlabel('1/T', 'FontSize', 20)
ylabel('log(k)','FontSize', 20)
title('Ea fitting Area SAT only', 'FontSize', 15)


% Ea vs Cov plot
figure(4)
plot(covs, Ea_a, 'linewidth', 1)
hold on
plot(covs, Ea_sc_pf, 'k', 'linewidth', 1)
hold on
plot(covs, Ea_ns_pf, 'r', 'linewidth', 1)
set(gca, 'FontSize', 12)
xlabel('Coverage', 'FontSize',15)
ylabel('E_a [kcal/mol]', 'FontSize', 20)
legend('Area SAT', 'PF nonscaled', 'PF scaled', 'FontSize', 15)


