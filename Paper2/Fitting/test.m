clear all
close all
clc

j = 0;
for kk = 1:6
    k = kk-1;


    m(kk) = mod(k+j, 3) - j;
    j = mod(k, j);

    if( mod(k,3)==0)
        m(kk) = mod(k+1, 3) - j;
    end

end

m