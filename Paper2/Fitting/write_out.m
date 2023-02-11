function [] = write_out(str, dlms, vals)

[dlm_kob, dlm_kbo, dlm_kao, dlm_koa, dlm_kab, dlm_kba] = dlms{:};

STORE = cell(7,7);
headings = {'Constants', 'MSE', 'R^2', 'SSE', 'SSR', 'SST'};
constant = {'k_oB', 'k_Bo', 'k_Ao', 'k_oA', 'k_AB', 'k_BA'};


dlms_MSE = [dlm_kob.MSE, dlm_kbo.MSE, dlm_kao.MSE, dlm_koa.MSE, dlm_kab.MSE, dlm_kba.MSE];
dlms_R = [dlm_kob.Rsquared.Ordinary, dlm_kbo.Rsquared.Ordinary, dlm_kao.Rsquared.Ordinary, ...
    dlm_koa.Rsquared.Ordinary, dlm_kab.Rsquared.Ordinary, dlm_kba.Rsquared.Ordinary];

dlms_SSE = [dlm_kob.SSE, dlm_kbo.SSE, dlm_kao.SSE, dlm_koa.SSE, dlm_kab.SSE, dlm_kba.SSE];
dlms_SSR = [dlm_kob.SSR, dlm_kbo.SSR, dlm_kao.SSR, dlm_koa.SSR, dlm_kab.SSR, dlm_kba.SSR];
dlms_SST = [dlm_kob.SST, dlm_kbo.SST, dlm_kao.SST, dlm_koa.SST, dlm_kab.SST, dlm_kba.SST];

for j = 2 : length(headings)+ 1
    STORE{1, j} = headings{j-1};
end

for i = 2 : length(constant) + 1
    STORE{i, 1} = constant{i-1};
end


for i = 2 : length(vals) + 1
    STORE{i, 2} = vals(i-1);
    STORE{i, 3} = dlms_MSE(i-1);
    STORE{i, 4} = dlms_R(i-1);
    STORE{i, 5} = dlms_SSE(i-1);
    STORE{i, 6} = dlms_SSR(i-1);
    STORE{i, 7} = dlms_SST(i-1);
end


writecell(STORE,  strcat('Results/store', str, '.','xls') );

end