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

end

k = {koB, kBo, kAo, koA, kAB, kBA, koX, kXo};
T = [450, 460, 470, 475, 480, 490];
R = 0.001987204258;

idx = 1:6;

<<<<<<< HEAD
% Ea
for n = 1:8
     [Ea(n), ln_A(n), Ea_SE(n), A_SE(n), ln_k, Rsq_Ea(n)] = get_Ea(k{n}(idx), T(idx), R);
end

%save('Ea_all.mat', 'Ea', 'Ea_SE', 'A', 'A_SE', 'Rsq_Ea', 'T', 'R', "k")
=======
for n = 1:N
     [Ea, A, Ea_SE, A_SE, ln_k, Rsq_Ea] = get_Ea(k{n}(idx), T(idx), R);
     Ea_k(n) = Ea;
     Ea_kSE(n) = Ea_SE;
end


>>>>>>> parent of b4b1e03 (475K worked without initial points but cut-off diff)

