clear all
close all
clc

% Read in
%dat_area = table2array(readtable('../area_latest.xlsx'));
dat_wv = table2array(readtable('../peaks_latest.xlsx'));
%dat_marea = table2array(readtable('../mat_area_latest.xlsx'));

% Strings of temps in data
%temps_strings = {'450', '460', '490'};
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

wv_dat = wv;

% Get mathematical normalized area
dat_marea = table2array(readtable('../all_area.xlsx', 'Sheet', 'Area_math'));
dat_aarea = table2array(readtable('../all_area.xlsx', 'Sheet', 'Area_absolute'));

% Clean first two rows
L = length(dat_marea(1,:));
La = length(dat_aarea(1,:));
dat_aarea(1:2, :) = [];

for i = 1:N
%     if(i==3)
%         temp_nan = dat_marea(:, L+1-i -3);
%         temp_nana = dat_aarea(:, La+1-i -3);
%     else
        temp_nan = dat_marea(:, L+1-i);
        temp_nana = dat_aarea(:, La+1-i);
    %end
    temp_nan(isnan(temp_nan)) = [];
    temp_nana(isnan(temp_nana)) = [];
    area_mat{i} = temp_nan;
    time_mat_area{i} = time(1:length(temp_nan));
    area_abs{i} = temp_nana;
    time_abs_area{i} = time(1:length(temp_nana));
    %time_wv{i} = time(1:length(temp_nana));

end


for i = 1:N

    Lwv = length(wv{i});
    Laa = length(area_abs{i});
    Lam = length(area_mat{i});

    Lsz = Laa - Lwv;

    if (Lsz > 0)
        wv{i} = [wv{i}; zeros(Lsz,1)];
    end
%     Lmin = min([Lwv, Lam, Laa]);
% 
%     wv{i} = wv{i}(1:Lmin);
%     area_abs{i} = area_abs{i}(1:Lmin);
%     area_mat{i} = area_mat{i}(1:Lmin);
%     time_area{i} = time_area{i}(1:Lmin);
%     time_wv{i} = time_wv{i}(1:Lmin);

end


% Save all data
%save('Temps/all_temps.mat', 'area', 'wv', 'time_area', 'time_wv', 'temps_strings', "N")
save('Temps/T3.mat', 'area_abs','area_mat', "time_abs_area", 'time_mat_area', 'time_wv', 'time', 'temps_strings', 'N', 'wv', 'wv_dat')
