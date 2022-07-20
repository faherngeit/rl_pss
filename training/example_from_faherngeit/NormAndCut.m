function ts = NormAndCut(tseries, options)
arguments
    tseries timeseries
    options.history double = 20
    options.future double = 30
    options.Nsample double =  80
end

zero_point = find(ismember(tseries.Time, 0)) + 1;

min_id = max(zero_point - options.history * options.Nsample, 1);
max_id = min(zero_point + options.future * options.Nsample, length(tseries.Time));

ts = getsamples(tseries, (min_id:max_id));
ts.Time = ts.Time - min(ts.Time);
