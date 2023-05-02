clear all
close all
clc

% Read in
%dat_area = table2array(readtable('../area_latest.xlsx'));
dat_wv = table2array(readtable('../peaks_latest.xlsx'));
%dat_marea = table2array(readtable('../mat_area_latest.xlsx'));

% Strings of temps in data
temps_strings = {'450', '460', '490'};

% Number of Temps
N = length(temps_strings);





% Get time
time = dat_wv(:,2);
dat_wv(:,5:7) = [];

% This is for file with absolute areas
% % Extract all areas
% for i = 3:N+2
% 
%     % Extract column and clear NaNs
%     temp_nan = dat_marea(3:length(dat_area(:,i)), i);
%     temp_nan(isnan(temp_nan)) = [];
%     temp_nan(temp_nan < 0) = 0;
% 
%     % Store area
%     area{N-(i-3)} = temp_nan;
%     time_area{N-(i-3)} = time(1:length(temp_nan));
% 
% end

% Code for mathematical area
% dat_marea(:, [12, 13]) = [];
% L = length(dat_marea(1,:));
% 
% for i = 1:N
%     temp_nan = dat_marea(:, L+1-i);
%     temp_nan(isnan(temp_nan)) = [];
%     area{i} = temp_nan;
%     time_area{i} = time(1:length(temp_nan));
% end


% Extract all WV peak and Time
min_temp = min(min(dat_wv(:,3:end)));

% Get wv peaks
for i = 4:N+3

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
    wv{N-(i-4)} = temp_nan;

    time_wv{N-(i-4)} = time(1:length(temp_nan));

end



% Get mathematical normalized area
dat_marea = table2array(readtable('../all_area.xlsx', 'Sheet', 'Area_math'));
dat_aarea = table2array(readtable('../all_area.xlsx', 'Sheet', 'Area_absolute'));

% Clean first two rows
L = length(dat_marea(1,:));
La = length(dat_aarea(1,:));
dat_aarea(1:2, :) = [];

for i = 1:N
    if(i==3)
        temp_nan = dat_marea(:, L+1-i -3);
        temp_nana = dat_aarea(:, La+1-i -3);
    else
        temp_nan = dat_marea(:, L+1-i);
        temp_nana = dat_aarea(:, La+1-i);
    end
    temp_nan(isnan(temp_nan)) = [];
    temp_nana(isnan(temp_nana)) = [];
    area_mat{i} = temp_nan;
    time_area{i} = time(1:length(temp_nan));
    area_abs{i} = temp_nana;
    timea_area{i} = time(1:length(temp_nana));

end


for i = 1:N

    Lwv = length(wv{i});
    Laa = length(area_abs{i});
    Lam = length(area_mat{i});

    Lmin = min([Lwv, Lam, Laa]);

    wv{i} = wv{i}(1:Lmin);
    area_abs{i} = area_abs{i}(1:Lmin);
    area_mat{i} = area_mat{i}(1:Lmin);
    time_area{i} = time_area{i}(1:Lmin);
    time_wv{i} = time_wv{i}(1:Lmin);

end

% Save all data
%save('Temps/all_temps.mat', 'area', 'wv', 'time_area', 'time_wv', 'temps_strings', "N")
save('Temps/T3.mat', 'area_abs', "time_area", 'area_mat', 'time_wv', 'time', 'temps_strings', 'N', 'wv')
