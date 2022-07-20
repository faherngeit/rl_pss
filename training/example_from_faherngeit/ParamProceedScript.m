fprintf('[%s] %s \n',datetime(now,'ConvertFrom','datenum'), 'Подгтовка данных для ПАК РВ');
param = param2RTparam(param);
[simParam, desc] = EstimSimParam(param);
res = parsim(simParam);
restore = check_restoration(res, desc, param);
simLab = JoinExps(restore, param, curve_per_exp = 30);
opalVar = Data2Opal(simLab, save=1, folder=param.folder);
save([param.folder, 'DescResParam.mat'], 'param', 'res', 'desc');
save([param.folder, 'Restore.mat'], 'restore');
save([param.folder, 'SimLab.mat'], 'simLab');
clear param res desc restore simLab opalVar simParam