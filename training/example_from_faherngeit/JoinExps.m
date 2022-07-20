function simout = JoinExps(res, param, options)
arguments
    res
    param
    options.exp_num double = -1
    options.Ts double = 1 / 50 / 80
    options.Delay double = 1
    options.curve_per_exp double = 10
    options.history double = 20
    options.future double = 30
    options.Frequency double = 50
    options.Timp double = 0.1
end

if options.history > param.count_pred || options.future > param.count_post
    error('There is not enough data in time series object!');
end

if options.exp_num == -1
    limit = length(res);
else
    limit = options.exp_num;
end

freq = options.Frequency;
Timp = options.Timp;


Nominal = initzerosts(options.Delay, options.Ts);
Saturated = initzerosts(options.Delay, options.Ts);
Restored = initzerosts(options.Delay, options.Ts);
Control =  initzerosts(options.Delay, options.Ts);

% [t, val] = stairs([0, options.history / freq, options.history / freq + Timp, (options.history + options.future)/options.Frequency], [0, 1, 0, 0]);
imp_ts = timeseries([0, 0, 1, 1, 0, 0], [options.Ts, options.history / freq - options.Ts, options.history / freq, options.history / freq + Timp, options.history / freq + Timp + options.Ts,  (options.history + options.future)/options.Frequency]);

for i = 1:limit
    if mod(i - 1, options.curve_per_exp) == 0
        if i > 1
            time = [options.Ts:options.Ts: options.Delay * (options.history + options.future)/options.Frequency];
            ts = timeseries(zeros(size(time)),time);
            Control = smartappend(Control, ts);
            Nominal = smartappend(Nominal, ts);
            Saturated = smartappend(Saturated, ts);
            Restored = smartappend(Restored, ts);
        end
        Control = smartappend(Control, imp_ts);
    else
        ts = timeseries([0,0],[options.Ts, (options.history + options.future)/options.Frequency]);
        Control = smartappend(Control, ts);
    end
    Nominal = smartappend(Nominal, NormAndCut(res{i}.Nominal, history=options.history, future=options.future));
    Saturated = smartappend(Saturated, NormAndCut(res{i}.Saturated, history=options.history, future=options.future));
    wsh_id = GetMedianID([res{i}.win_shft.RestErr]);
    Restored = smartappend(Restored, NormAndCut(res{i}.win_shft(wsh_id).Data, history=options.history, future=options.future));
end

simout.Nominal = Nominal;
simout.Saturated = Saturated;
simout.Restored = Restored;
cntr_data = interp1(Control.Time, Control.Data(1,:)', Nominal.Time,'previous');
simout.Control = timeseries(cntr_data, Nominal.Time);




function tseries = smartappend(tseriesL, tseriesS)
arguments
    tseriesL timeseries
    tseriesS timeseries
end
tseriesS.Time = tseriesS.Time + max(tseriesL.Time);
tseries = append(tseriesL, tseriesS);

function tseries = initzerosts(delay, Ts)
tseries = timeseries(zeros(size([0:Ts:delay])), [0:Ts:delay]);