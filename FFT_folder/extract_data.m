clear all
close all
clc


% Read in data
dat = readcell('New_All_Average.xlsx', 'Sheet','Peaks');
new_dat = readcell('New_All_Average.xlsx', 'Sheet','Area');

% Row and Column lengths
i = 8;
dr = length(dat(:,i));
time = dat(2:dr, 2);
wv = dat(2:end, i);


for k = 1:dr-1
    if (isnumeric(wv{k}) == 0)
        wv{k} = [];
    end
end

wv = cell2mat(wv);
len_wv = length(wv);
time = cell2mat(time(1:len_wv));

area = cell2mat(new_dat(2:len_wv+1, i));

%save('490K.mat', 'wv', 'area', 'time')