dfile ='NightLog.txt';
if exist(dfile, 'file')
    delete(dfile); 
end

diary(dfile)
diary on


param = GetParamPeriodic();
fprintf('[%s] %s \n',datetime(now,'ConvertFrom','datenum'), param.desc);
[res, desc, restore] = TestRestoration(param);
save([param.folder, 'DataRes.mat'], 'param', 'res', 'desc', 'restore');
clear res desc restore
ParamProceedScript

param = GetParamAperiodic();
fprintf('[%s] %s \n',datetime(now,'ConvertFrom','datenum'), param.desc);
[res, desc, restore] = TestRestoration(param);
save([param.folder, 'DataRes.mat'], 'param', 'res', 'desc', 'restore');
clear res desc restore
ParamProceedScript

param = GetParamChngLoad();
fprintf('[%s] %s \n',datetime(now,'ConvertFrom','datenum'), param.desc);
[res, desc, restore] = TestRestoration(param);
save([param.folder, 'DataRes.mat'], 'param', 'res', 'desc', 'restore');
clear res desc restore
ParamProceedScript

param = GetParamChngLoadRX();
fprintf('[%s] %s \n',datetime(now,'ConvertFrom','datenum'), param.desc);
[res, desc, restore] = TestRestoration(param);
save([param.folder, 'DataRes.mat'], 'param', 'res', 'desc', 'restore');
clear res desc restore

param = GetParamCTchg();
fprintf('[%s] %s \n',datetime(now,'ConvertFrom','datenum'), param.desc);
[res, desc, restore] = TestRestoration(param);
save([param.folder, 'DataRes.mat'], 'param', 'res', 'desc', 'restore');
clear res desc restore
ParamProceedScript

diary off
clear dfile