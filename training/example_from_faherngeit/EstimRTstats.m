function stats = EstimRTstats(ExpArr, options)
arguments
    ExpArr
    options.err_lim double = [1601:1921]
end
stats = [];
for exp = 1:length(ExpArr)
    errAg = [];
    for chn = 1:4
        err.meanNorm = GetLastMean(ExpArr(exp).Data(chn,1), lim=options.err_lim);
        err.meanSat = GetLastMean(ExpArr(exp).Data(chn,2), lim=options.err_lim);
        err.meanRest = GetLastMean(ExpArr(exp).Data(chn,3), lim=options.err_lim);
        err.meanArrSat = (err.meanNorm - err.meanSat) / (err.meanNorm ) * 100;
        err.meanArrRest = (err.meanNorm - err.meanRest) / (err.meanNorm ) * 100;
        errAg = [errAg, err];
    end
    stats = [stats;errAg];
end

function mn = GetLastMean(data, options)
arguments
    data
    options.lim double = [2500, 3500]
end
mn = mean(data.Data(options.lim));