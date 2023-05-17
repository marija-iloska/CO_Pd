clear all
close all
clc

% Read in
dat_wv = table2array(readtable('../peaks_latest.xlsx'));

% Strings of temps in data
temps_strings = { '450', '460', '470', '475', '480', '490'};

% Number of Temps
N = length(temps_strings);


dat_wv(1:3, :) = [];


% Get time
time = dat_wv(:,2);
dat_wv(:,3) = [];


% Extract all WV peak and Time
min_temp = min(min(dat_wv(:,3:end)));

% Get wv peaks
for i = 3:N+2

    % Clear nans
    temp_nan = dat_wv(:, i);
    %min_temp = min(temp_nan);
    nan_indx = isnan(temp_nan);
    if (nan_indx(2))
        temp_nan(1:2) = min_temp;
    elseif (nan_indx(1))
        temp_nan(1) = min_temp;
    end
    temp_nan(isnan(temp_nan))= [];
    wv{N-(i-3)} = temp_nan;

    time_wv{N-(i-3)} = time(1:length(temp_nan));

end

rm = find(wv{2}(end - 20: end) > 1840);
wv{2}(end-21 + rm) = [];
time_wv{2}(end-21 + rm) = [];

wv_dat = wv;



% Get mathematical normalized area
%dat_marea = table2array(readtable('../all_area.xlsx', 'Sheet', 'Area_math'));
%dat_aarea = table2array(readtable('../all_area.xlsx', 'Sheet', 'Area_absolute'));

dat_marea = table2array(readtable('../mat_area_latest.xlsx', 'Sheet', 'Area'));

% Clean first two rows
L = length(dat_marea(1,:));

for i = 1:N

    temp_nan = dat_marea(:, L+1-i);
    temp_nan(isnan(temp_nan)) = [];
    area_mat{i} = temp_nan;
    time_mat_area{i} = time(1:length(temp_nan));

end


% for i = 1:N
% %     if(i==3)
% %         temp_nan = dat_marea(:, L+1-i -3);
% %         temp_nana = dat_aarea(:, La+1-i -3);
% %     else
%         temp_nan = dat_marea(:, L+1-i);
%         temp_nana = dat_aarea(:, La+1-i);
%     %end
%     temp_nan(isnan(temp_nan)) = [];
%     temp_nana(isnan(temp_nana)) = [];
%     area_mat{i} = temp_nan;
%     time_mat_area{i} = time(1:length(temp_nan));
%     area_abs{i} = temp_nana;
%     time_abs_area{i} = time(1:length(temp_nana));
%     %time_wv{i} = time(1:length(temp_nana));
% 
% end


for i = 1:N

    Lwv = length(wv{i});
    Lam = length(area_mat{i});

    Lsz = Lam - Lwv;

    if (Lsz > 0)
        wv{i} = [wv{i}; zeros(Lsz,1)];
    end

end






%wv_org = dat_wv(:,[8:-1:3]);

   
% i = 2;
% 
% sz = 20;
% msz = 11;
% for t = 1 : N
% 
%      %plot(time_mat_area{t}, movmean(area_mat{t}, 1), '.', 'MarkerSize', msz)
%      %hold on
%      plot(time, wv_org(:,t), '.', 'MarkerSize', msz)
%      hold on
% %     plot(time_abs_area{t}, area_abs{t}, '.', 'MarkerSize', msz)
% %     hold on
% 
% end
% xlabel('Time', 'FontSize', sz)
% ylabel('MAT Area', 'FontSize', sz)
% ylabel('Wavenumber', 'FontSize', sz)
% %title('Smoothed (5 MA points)', 'FontSize', sz)
% set(gca, 'FontSize', 15)
% legend( temps_strings, 'FontSize', sz)



% Save all data
save('Temps/T6.mat','area_mat', 'time_mat_area', 'time_wv', 'time', 'temps_strings', 'N', 'wv', 'wv_dat')
