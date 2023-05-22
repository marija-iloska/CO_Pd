clear all
close all
clc

% Read in WV and AREA excel
dat_wv = table2array(readtable('../peaks_latest.xlsx'));
dat_marea = table2array(readtable('../mat_area_latest.xlsx', 'Sheet', 'Area'));

% Remove NaN rows and 500 K column
dat_wv(1:3, :) = [];
dat_wv(:,3) = [];

% Get length of Area and WV file to read in backwards
Lw = length(dat_wv(1,:));
La = length(dat_marea(1,:));

% Get time
time = dat_wv(:,2);

% Strings of temps in data
temps_strings = { '450', '460', '470', '475', '480', '490'};

% Number of Temps
N = length(temps_strings);


% FREQUENCY________________________________________________________
% Replace first rows Nans with 0s (all weights will be on area)
%min_temp = min(min(dat_wv(:,3:end)));
min_temp = 0;

% Get wv peaks
for i = 1:N

    % Find all NaNs
    temp_nan = dat_wv(:, Lw+1-i);
    nan_indx = isnan(temp_nan);

    % Replace NaNs in first rows with 0s
    if (nan_indx(2))
        temp_nan(1:2) = min_temp;
    elseif (nan_indx(1))
        temp_nan(1) = min_temp;
    end

    % Clear rest of NaNs
    temp_nan(isnan(temp_nan))= [];
    wv{i} = temp_nan;

    % Get time length of WV data points
    time_wv{i} = time(1:length(temp_nan));

end

% Remove outliers in 460K at the end
rm = find(wv{2}(end - 20: end) > 1840);
wv{2}(end-21 + rm) = [];
time_wv{2}(end-21 + rm) = [];

% Save raw WV without any 0 padding
wv_dat = wv;
time_dat = time_wv;
for i = 1:N
    wv_dat{i}(1:2, :) = [];
    time_dat{i}(1:2, :) = [];
end


% Get areas and remove NaNs
for i = 1:N
    
    % Take column and remove NaNs
    temp_nan = dat_marea(:, La+1-i);
    temp_nan(isnan(temp_nan)) = [];

    % Store clean Area and Time length
    area_mat{i} = temp_nan;
    time_mat_area{i} = time(1:length(temp_nan));

end


% Pad 0s to WV for easier processing later
for i = 1:N

    % Length of WV and AR data for each Temp
    Lwv = length(wv{i});
    Lam = length(area_mat{i});

    % Difference in lengths (number of data points)
    Lsz = Lam - Lwv;

    % If there are more AREA points, pad 0s to WV points
    if (Lsz > 0)
        wv{i} = [wv{i}; zeros(Lsz,1)];
    end

end



% Save all data
%save('Temps/T6.mat','area_mat', 'time_mat_area', 'time_wv', 'time_dat', 'time', 'temps_strings', 'N', 'wv', 'wv_dat')
