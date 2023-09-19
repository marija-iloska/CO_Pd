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
    if n == 1
        Tmax = T;
    end
    
    % Frequency data
    wv = dat(2: end, wv_idx);
    
    % Find indices between 1700 < wv < 2100 cm^-1
    idx0 = find(wv>1750);
    idx0 = idx0(end);
    
    idx1 = find(wv< 2000);
    idx1 = idx1(1);
    
    % Get range of interest 1700 < wv < 2100 cm^-1
    range_idx = idx1:idx0;
    range_mean = idx1-300 : idx0 + 300;

    x{n} = 0.067: 0.067: 0.067*(T-1);
    y{n} = wv(idx1:idx0);
    %[X,Y] = meshgrid(x,y);
%     if (n~=1) && (n~=6)
%         time_pad = T+1:Tmax;
%         for t = 1:length(time_pad)
%             zero_pad(range_idx, time_pad(t)) = dat(range_idx, T-(Tmax-T)-2+t);
%         end
% 
%         %zero_pad = abs(mvnrnd( dat(range_idx, T-1), 0.01*eye(length(range_idx)), length(time_pad)))';
%     else
%         time_pad = [];
%         zero_pad = [];
%     end
% 
%     if n == 6
%         time_pad = T+1:Tmax;
%         for t = 
%             
%     end


    Z{n} = [dat(range_idx, 2:T)];
    %surf(X,Y,Z)


%     view(2)
%     colormap('hot');
%     %colormap('turbo')
%     %colormap('cool')
%     colorbar
    
    % Plot and compute area for each time point
    for i = 2:T
    
       % figure(n)
        %Shift to 0 by subtracting mean
        %peak_plot = dat(range_idx,i) - mean(dat(range_mean,i));
%         temp = dat(range_idx,i) - mean(dat(range,i));
%         %test = dat(range_idx, i) - mean(dat(idx1-300 : idx0 + 300,i));
%         plot(dat(range_idx, wv_idx), peak_plot, 'linewidth', 1.5)
%         hold on
%         yline(0)
%         xlim([1700, 2100])
%         set(gca, 'FontSize', 15)
%         xlabel('Wavenumber [cm^-^1]', 'FontSize', 20)
%         ylabel('Absorbance', 'FontSize', 20)
%     
    
        % Compute area
%          area_temp(i-1) = trapz(abs(peak_plot));
%          area_raw(i-1) = trapz(peak_plot);
    end
    
%     area{n} = area_temp;
%     area_mat{n} = area_raw;


    % Get RAW colormap for all



end





col = {[194, 4, 131]/256,  [206, 14, 227]/256,  [3, 3, 150]/256,  [6, 212, 201]/256, [9, 173, 91]/256, [98, 235, 7]/256};

% % Absolute area
% figure;
% for n = 1:N
%     area{n} = area{n} - mean(area{n}(end-8:end));
%     plot(area{n}, 'Color', col{n}, 'Linewidth',1.5)
%     hold on
% end
% yline(0, 'linewidth',2)
% legend(temp_strings, 'FontSize', 20)
% title('Absolute Area', 'FontSize',15)
% 
% 
% % Mathematical Area
% figure;
% for n = 1:N
%     area_mat{n} = area_mat{n} - mean(area_mat{n}(end-8:end));
%     plot(area_mat{n}, 'Color', col{n}, 'Linewidth',1.5)
%     hold on
% end
% yline(0, 'linewidth',2)
% legend(temp_strings)
% title('Mathematical Area', 'FontSize',15)


for n = 1:N


    figure(3)
    subplot(N,1, n)
    [X,Y] = meshgrid(x{n},y{n});
    surf(X,Y,Z{n})


    view(2)
    %colormap('hot');
    colormap('turbo')
    %colormap('cool')
    colorbar
    xlim([0, 12])
    ylim([1750, 2000])
    xline(3, 'color', 'w', 'linewidth',3, 'linestyle','--')
    set(gca, 'FontSize', 15)
    title(temp_strings{n}, 'FontSize',15)
    xlabel('Time [s]', 'FontSize', 12)
    ylabel('Wavenumber [cm^{-1}]', 'FontSize', 12)

end




%save('Paper2_data/my_areas.mat', 'area_mat', 'area')
