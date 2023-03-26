clear all
close all
clc

% Read in
dat_area = table2array(readtable('../area_latest.xlsx'));

% Strings of temps in data
temps_strings = {'450', '460', '470', '480', '490'};

% Number of Temps
N = length(temps_strings);


% Extract all areas
for i = 3:N+2

    % Extract column and clear NaNs
    temp_nan = dat_area(3:length(dat_area(:,i)), i);
    temp_nan(isnan(temp_nan)) = [];

    % Store area
    area{N-(i-3)} = temp_nan;

end


% Extract all WV peak and Time
dat_wv = table2array(readtable('../peaks_latest.xlsx'));

% Get time
time = dat_wv(:,2);
min_temp = min(min(dat_wv(:,3:end)));

% Get wv peaks
for i = 3:N+2

    % Clear nans
    temp_nan = dat_wv(:, i);
    %min_temp = min(temp_nan);
    nan_indx = isnan(temp_nan);
    if (nan_indx(2))
        temp_nan(1:2) = min_temp;
        temp_nan(nan_indx(3:end))= [];
    elseif (nan_indx(1))
        temp_nan(1) = min_temp;
        temp_nan(nan_indx(2:end))= [];
    else
        temp_nan(isnan(temp_nan)) = [];
    end

    wv{N-(i-3)} = temp_nan;
end


% Save all data
save('Temps/all_temps.mat', 'area', 'wv', 'time', 'temps_strings', "N")
