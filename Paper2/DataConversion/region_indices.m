function [id] = region_indices(wv, wv_splits, R)

% Initialize indices for wv == 0
id{1} = find(wv == 0);

% Get middle regions for all less than wv_split
for r = 1:R
    id{r+1} = find(wv < wv_splits(r));
end

% Get final region greater than last split
id{R+2} = find(wv > wv_splits(R));

% Clean up middle regions
for r = 1:R
    id{R+2-r} = setdiff(id{R+2-r}, id{R+1-r});
end


end