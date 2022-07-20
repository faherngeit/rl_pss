function Data = Comtrade2Data(path, options)
arguments
    path char
    options.presave double = 1
end
path2cfg = [path, '.cfg'];
path2dat = [path, '.dat'];

cfg_id = fopen(path2cfg);
% dat_id = fopen(path2dat);

cfg = textscan(cfg_id, '%s', 'delimiter', '\n');
% dat = textscan(dat_id, '%s', 'delimiter', '\n');


fclose('all');

cfg_len = length(cfg{1,1});
cfg_string = cell(size(cfg));

for i = 1:cfg_len
    temp_string = char(cfg{1,1}{i});
    cfg_string(i) = textscan(temp_string, '%s', 'Delimiter', ',')';
end

% Comtrade File Identifier
Title = char(cfg_string{1,1}(1));

% Comtrade Version
if length(cfg_string{1,1}) < 3 %#ok<ISMT>
    Version = '1999';
else
    Version = char(cfg_string{1,1}(3));
end

% Channel information: total, analogues and digitals
No_Ch = strread(char(cfg_string{1,2}(1)));
Ana_Ch = strread(char(cfg_string{1,2}(2)));
Dig_Ch = strread(char(cfg_string{1,2}(3)));

% Data length, i.e. no of samples
dat_len = strread(char(cfg_string{1,5+No_Ch}(2))); 

% Read data
dat_id = fopen(path2dat, 'r', 'ieee-le');
dat = ReadBinDat(dat_id, Analogue=Ana_Ch, Discrete=Dig_Ch, Length=dat_len);

% Nominal frequency 
frequency = strread(char(cfg_string{1,3+No_Ch}(1)));

% Sampling rate
samp_rate = strread(char(cfg_string{1,5+No_Ch}(1)));

% Record started
start_date = char(cfg_string{1,6+No_Ch}(1));
start_time = char(cfg_string{1,6+No_Ch}(2));

% Record ended
end_date = char(cfg_string{1,7+No_Ch}(1));
end_time = char(cfg_string{1,7+No_Ch}(2));

%% Now write the data to the workspace

dat_string = cell(size(dat));
data = zeros(dat_len, No_Ch+2);

% Now extract the data
% for i = 1:dat_len
%     dat_string(i) = textscan(char(dat{1,:}(i)), '%n', 'Delimiter', ',');
%     data(i,:) = (dat_string{:,i});
% end

data = dat;

% extract the timestamps, scaled to seconds from microseconds
t = (data(:,2)) * 1e-6;

% Write the data to the workspace
% assignin('base','t', t);

var_string = cell(No_Ch);

% All channels are extracted here, but the analogues still need scaling
 for i = 1 : No_Ch
 
    j = i + 2;
 
    var_string{i} = char(textscan(char(cfg_string{1,j}(2)),'%c'));
    
    % If the first character is not a letter, replace with an 'x'. This is
    % to satisfy the naming requirements for the workspace.
    if ~isletter(var_string{i}(1))
        var_string{i}(1) = 'x';
    end
    % If any character is not a letter or number, replace with an '_'. This is
    % to satisfy the naming requirements for the workspace.
    for k = 2:length(var_string{i})
        if ~isstrprop(var_string{i}(k), 'alphanum')
            var_string{i}(k) = '_';
        end
    end
    
%     assignin('base', var_string{i}, data(:,j));
 end

%% Write the remainaing config information to the workspace

Data.Title = Title;
Data.Version = Version;
Data.Frequency = frequency;
Data.Sample_rate = samp_rate;
Data.Start_date = start_date;
Data.Start_time = start_time;
Data.End_date = end_date;
Data.End_time = end_time;

%% Now let's post-process the data to produce the final waveforms

hold off;
close all;

if Ana_Ch >= 1

    dat = zeros(dat_len, Ana_Ch+2);
    
    % step through the data configuration
    for i = 1 : Ana_Ch

        j = i + 2;

        % Limit the range of the result
        % The value is scaled by the equation [aX + b]
        multiplier = strread(char(cfg_string{1,j}(6))); % a
        offset = strread(char(cfg_string{1,j}(7)));     % b

        dat(:,i) = data(:,j) * multiplier  + offset;

        % If the Primary and Secondary scaling information is present,
        % apply that too
        if length(cfg_string{1,j}) > 10

            pri_scaling = strread(char(cfg_string{1,j}(11)));
            sec_scaling = strread(char(cfg_string{1,j}(12)));
            pri_sec = char(cfg_string{1,j}(13));

            if pri_sec == 'P' 

                dat(:,i) = dat(:,i) * pri_scaling;

            else

                dat(:,i) = dat(:,i) * sec_scaling;

            end
        end
    end
end

Data = dat(:, [1:3,9:17]);
Data = [t - options.presave, Data, data(:,20)];

% Data.Normal.Inst = timeseries(dat(:,1), t);
% Data.Normal.Mag = timeseries(dat(:,9), t);
% Data.Normal.Phase = timeseries(dat(:,10), t);
% Data.Normal.Freq = timeseries(dat(:,11), t);
% 
% Data.Saturated.Inst = timeseries(dat(:,2), t);
% Data.Saturated.Mag = timeseries(dat(:,12), t);
% Data.Saturated.Phase = timeseries(dat(:,13), t);
% Data.Saturated.Freq = timeseries(dat(:,14), t);
% 
% Data.Restored.Inst = timeseries(dat(:,3), t);
% Data.Restored.Mag = timeseries(dat(:,15), t);
% Data.Restored.Phase = timeseries(dat(:,16), t);
% Data.Restored.Freq = timeseries(dat(:,17), t);


