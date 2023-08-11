clear all
close all
clc

load ../DataConversion/Data/temps_info.mat

%temps_strings(4) = [];
N = length(temps_strings);

% vals = [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA,k_oX, k_Xo];]

for n = 1 : N

    str = join(['Data/', temps_strings{n}, 'ks.mat']);
    load(str)

    koB(n) = vals(1);
    kBo(n) = vals(2);
    kAo(n) = vals(3);
    koA(n) = vals(4);
    kAB(n) = vals(5);
    kBA(n) = vals(6);
    koX(n) = vals(7);
    kXo(n) = vals(8);
    c(n) = vals(9);

end

k = {koB, kBo, kAo, koA, kAB, kBA, koX, kXo};
T = [450, 460, 470, 475, 480, 490];
R = 0.001987204258;

idx = 1:6;
idx = setdiff(idx, 4);

dlm_c = fitlm(T(idx), c(idx),'Intercept',true);
a = dlm_c.Coefficients.Estimate(2);
b = dlm_c.Coefficients.Estimate(1);


c_new = a*T(4)+ b;


% Ea
for n = 1:8
     [Ea(n), A(n), Ea_SE(n), A_SE(n), ln_k, Rsq_Ea(n)] = get_Ea(k{n}(idx), T(idx), R);
end

save('Ea_all.mat', 'Ea', 'Ea_SE', 'A', 'A_SE', 'Rsq_Ea', 'T', 'R', "k", 'c_new')

