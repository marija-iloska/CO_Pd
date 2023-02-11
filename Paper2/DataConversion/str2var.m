function var = str2var(str)
var_list = evalin('caller', ['whos(''', str, ''')']);
[var_names{1:length(var_list)}] = deal(var_list(:).name);
var_names(2,:) = {','};
var_names(2,end) = {''};
var = evalin('caller', ['[', sprintf('%s', var_names{:}), ']']);