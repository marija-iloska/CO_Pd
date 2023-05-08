function [id] = region_indices(wv, wv_splits, N)

    id{1} = find(wv < wv_splits(1));
%     for n = 2:N
%         % Get indices UP to split
%         id{n} = find(wv < wv_splits(n-1));
%     end


    % Last index
    id{N+1} = find(wv > wv_splits(end));
    id{N+2} = find(wv == 0);


    % Remove repeating coeffs
    for n = 2:N
        id{N-n+1} = setdiff(id{N-n+1}, id{N-n});
    end

end