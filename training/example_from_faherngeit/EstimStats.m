function stats = EstimStats(restore)
stats.AccSat = zeros(1,length(restore));
stats.MeanAccRest  = zeros(1,length(restore));
stats.MedAccRest = zeros(1,length(restore));
stats.MinAccRest  = zeros(1,length(restore));
stats.MacAccRest = zeros(1,length(restore));
stats.Full = [];

for i = 1:length(restore)
    stats.AccSat(i) = restore{i}.AccSat;
    stats.MeanAccRest(i)  = restore{i}.MeanErr;
    stats.MedAccRest(i) = restore{i}.MedianErr;
    stats.MinAccRest(i)  = restore{i}.MinErrVal;
    stats.MaxAccRest(i) = restore{i}.MaxErrVal;
    stats.Full = [stats.Full, [restore{i}.win_shft.RestErr] ./ restore{i}.AccSat];
end

stats.RelMean = stats.MeanAccRest ./ stats.AccSat;
stats.RelMed = stats.MedAccRest ./ stats.AccSat;
stats.RelMin = stats.MinAccRest ./ stats.AccSat;
stats.RelMax = stats.MaxAccRest ./ stats.AccSat;


