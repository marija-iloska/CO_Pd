function [wv_padded, time_padded] = pad_zeros(wv, area, time, N)


% Pad 0s to WV for easier processing later
for i = 1:N

    % Length of WV and AR data for each Temp
    Lwv = length(wv{i});
    Lam = length(area{i});

    % Difference in lengths (number of data points)
    Lsz = Lam - Lwv;

    % If there are more AREA points, pad 0s to WV points
    if (Lsz > 0)
        wv_padded{i} = [wv{i}; zeros(Lsz,1)];
    end
    % Make appropriate time variable for it
    time_padded{i} = time(1:length(wv_padded{i}));

end


end