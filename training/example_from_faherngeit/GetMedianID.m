function id = GetMedianID(res)
med = median(res);
dif = (res - med) .^ 2;
[~,id] = min(dif);
