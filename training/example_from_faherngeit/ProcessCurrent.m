function Data = ProcessCurrent(current, params)    
if params.cons
    Data = ProcessingConsCurrent(current, params);
else
    Data = ProcessStepCurrent(current, params);
end
end


function Data = ProcessStepCurrent(current, params)
window_time = params.cycles * params.period;
window_sample = window_time / params.Ts;
data = containers.Map;
time = current.Time;
exp_data = current.Data;
for i = 1:length(params.amps) - 1
    st_id = 1 + window_sample * (2 * i - 2);
    en_id = window_sample * (2 * i);
    time_int = time(st_id:en_id) - window_time * (2 * i - 1);
    data_int = exp_data(st_id:en_id, :);
    ts_int = timeseries(data_int, time_int);
    data(sprintf('%i',params.amps(i+1))) = ts_int;
end
Data = data;
end


function Data = ProcessingConsCurrent(current, params)
window_time = params.cycles * params.period;
window_sample = window_time / params.Ts;
data = containers.Map;
time = current.Time;
exp_data = current.Data;
for i = 1:length(params.amps) - 1
    st_id = 1 + window_sample * (i - 1);
    en_id = window_sample * (i + 1);
    time_int = time(st_id:en_id) - window_time * i;
    data_int = exp_data(st_id:en_id, :);
    ts_int = timeseries(data_int, time_int);
    data(sprintf('%i',params.amps(i+1))) = ts_int;
end
Data = data;
end
