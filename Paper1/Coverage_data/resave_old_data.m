clear all
close all
clc

str = {'450', '475', '500' };

for n = 1:length(str)
    load( join(['CO_', str{n}, 'K.mat']) )

    cov_old{n} = cov;
    time_old{n} = time;

end

save('cov_old.mat')