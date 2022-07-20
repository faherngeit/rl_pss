function SplitData = SplitData2Exps(Data, options)
arguments
    Data
    options.history double = 20
    options.future double = 30
    options.Nsample double =  80
end

zero_point = find(ismembertol(Data(:,1), 0, 1e-9));
zero_point = zero_point(1);
stpoint = zero_point - floor(options.Nsample * options.history);
endpoint = zero_point + floor(options.Nsample * options.future);
    
exp = 1;
cur_block = 0;
while endpoint < size(Data,1) 
    if sum(Data([stpoint: endpoint],end)) > 0
        cur_block = cur_block + 1;
        if cur_block == 2
            break
        end
    end
    Split(exp) = timeseries(Data([stpoint: endpoint],2:end - 1), Data([stpoint: endpoint],1));
    TWind = Data(endpoint,1) - Data(stpoint,1);
    Data(:,1) = Data(:,1) - TWind;
    zero_point = find(ismembertol(Data(:,1), 0, 1e-3));
    zero_point = zero_point(1);
    stpoint = zero_point - floor(options.Nsample * options.history);
    endpoint = zero_point + floor(options.Nsample * options.future);
    exp = exp + 1;
end
SplitData = Split;


