clear all
close all
clc

% TESTING area myself
temp_strings = {'450K', '460K', '470K', '475K', '480K', '490K'};

% Number of temperatures
N = length(temp_strings);

for n = 1:N


    clear area_temp area_raw
    str = join(['Paper2_data/',temp_strings{n}, '.xlsx']);

    % Read in data
    dat = table2array(readtable(str));
    
    % Entire range
    range = 2: length(dat(2:end,1));
    
    % Index of frequency data
    wv_idx = 1;
    
    % Number of time points
    T = length(dat(1, 2:end));
    
    % Frequency data
    wv = dat(2: end, wv_idx);
    
    % Find indices between 1700 < wv < 2100 cm^-1
    idx0 = find(wv>1750);
    idx0 = idx0(end);
    
    idx1 = find(wv< 2025);
    idx1 = idx1(1);
    
    % Get range of interest 1700 < wv < 2100 cm^-1
    range_idx = idx1:idx0;
    range_mean = idx1-475 : idx0 + 475;
    range_mean = setdiff(range_mean, range_idx);

    
    % Plot and compute area for each time point
    figure(1)
    for i = 1:T
    
       subplot(2,3,n)
        %Shift to 0 by subtracting mean
        mean_plot =  mean(dat(range_mean,i+1));
        peak_plot = dat(range_idx,i+1) -mean_plot;
        peak_test = dat(2:end,i+1) - mean_plot;
        %temp = dat(range_idx,i) - mean(dat(range,i));
        %test = dat(range_idx, i) - mean(dat(idx1-300 : idx0 + 300,i));


        if (mod(i,2) == 0)
%             plot(dat(range_idx, wv_idx), peak_plot, 'linewidth', 1.5)
%             hold on
              plot(dat(2:end, wv_idx), peak_test, 'linewidth', 1.5)
              hold on
        end
        yline(0)
        xline(1750, 'k', 'linewidth',1, 'linestyle','--')
        hold on
        xline(2025, 'k', 'linewidth',1, 'linestyle','--')
        hold on
        xline(range_mean(1), 'b', 'linewidth',1, 'linestyle','--')
        hold on
        xline(range_mean(2), 'b', 'linewidth',1, 'linestyle','--')
        xlim([1200, 3200])
        set(gca, 'FontSize', 15)
        xlabel('Wavenumber [cm^-^1]', 'FontSize', 20)
        ylabel('Absorbance', 'FontSize', 20)
    
    
        % Compute area
         area_temp(i) = trapz(abs(peak_plot));
         area_raw(i) = trapz(peak_plot);
    end
    disp('Temp done')
    
    area{n} = area_temp;
    area_mat{n} = area_raw;




end





col = {[194, 4, 131]/256,  [206, 14, 227]/256,  [3, 3, 150]/256,  [6, 212, 201]/256, [9, 173, 91]/256, [98, 235, 7]/256};

% Absolute area
figure;
for n = 1:N
    area{n} = area{n} - mean(area{n}(end-4:end));
    plot(area{n}, 'Color', col{n}, 'Linewidth',1.5)
    hold on
end
yline(0, 'linewidth',2)
legend(temp_strings, 'FontSize', 20)
title('Absolute Area', 'FontSize',15)


%Mathematical Area
figure;
for n = 1:N
    area_mat{n} = area_mat{n} - mean(area_mat{n}(end-8:end));
    plot(area_mat{n} - mean(area_mat{n}(end-4:end)), 'Color', col{n}, 'Linewidth',1.5)
    hold on
end
yline(0, 'linewidth',2)
legend(temp_strings)
title('Mathematical Area', 'FontSize',15)


% for n = 1:N
% 
% 
%     figure(3)
%     subplot(N,1, n)
%     [X,Y] = meshgrid(x{n},y{n});
%     surf(X,Y,Z{n})
% 
% 
%     view(2)
%     %colormap('hot');
%     colormap('turbo')
%     %colormap('cool')
%     colorbar
%     xlim([0, 12])
%     ylim([1750, 2000])
%     xline(3, 'color', 'w', 'linewidth',3, 'linestyle','--')
%     set(gca, 'FontSize', 15)
%     title(temp_strings{n}, 'FontSize',15)
%     xlabel('Time [s]', 'FontSize', 12)
%     ylabel('Wavenumber [cm^{-1}]', 'FontSize', 12)
% 
% end
% 


%area_mat{n} = area_mat{n} - mean(area_mat{n}(end-5:end));
save('Paper2_data/my_areas.mat', 'area_mat', 'area')

