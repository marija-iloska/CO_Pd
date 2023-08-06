clear all
close all
clc

load ../DataConversion/Data/temps_info.mat

%temps_strings(4) = [];
N = length(temps_strings);

%    vals = [k_oB, k_Bo, k_Ao, k_oA, k_AB, k_BA,k_oX, k_Xo];]

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

end

k = {koB, kBo, kAo, koA, kAB, kBA};
T = [450, 460, 470, 475, 480, 490];
R = 0.001987204258;

idx = 1:6;

for n = 1:N
     [Ea, A, Ea_SE, A_SE, ln_k, Rsq_Ea] = get_Ea(k{n}(idx), T(idx), R);
     Ea_k(n) = Ea;
     Ea_kSE(n) = Ea_SE;
end



