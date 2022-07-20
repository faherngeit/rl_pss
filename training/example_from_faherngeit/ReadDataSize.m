function sz = ReadDataSize(path)

path2cfg = [path, '.cfg'];
cfg_id = fopen(path2cfg);
cfg = textscan(cfg_id, '%s', 'delimiter', '\n');
fclose('all');

cfg_len = length(cfg{1,1});
cfg_string = cell(size(cfg));

for i = 1:cfg_len
    temp_string = char(cfg{1,1}{i});
    cfg_string(i) = textscan(temp_string, '%s', 'Delimiter', ',')';
end

% Channel information: total, analogues and digitals
No_Ch = strread(char(cfg_string{1,2}(1)));

% Data length, i.e. no of samples
dat_len = strread(char(cfg_string{1,5+No_Ch}(2))); 

sz = [No_Ch, dat_len];