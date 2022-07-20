function ExpArray = ProcessExps(split, options)
arguments
    split
    options.zero_id double = 1601
    options.err_shft = 160
    options.err_wnd = 400
end

for i = 1:length(split)
    for k = 1:4
        if k == 1
            for j = 1:3
                arr.Data(k, j) = timeseries(split(i).Data(:, (k - 1) * 3 + j), split(i).Time);
            end
        else
            for j = 1:3
                arr.Data(k, j) = timeseries(split(i).Data(:,  2 + k + (j - 1) * 3), split(i).Time);
            end
        end
        err_lim = [options.zero_id + options.err_shft : options.zero_id + options.err_shft + options.err_wnd];
        dSat = split(i).Data(err_lim, (k - 1) * 3 + 1) - split(i).Data(err_lim, (k - 1) * 3 + 2);
        arr.ErrSat(k) = (dSat' * dSat) / options.err_wnd;
        dRest = split(i).Data(err_lim, (k - 1) * 3 + 1) - split(i).Data(err_lim, (k - 1) * 3 + 3);
        arr.ErrRest(k) = (dRest' * dRest)  / options.err_wnd;
    end        
    ExpArray(i) = arr;
end