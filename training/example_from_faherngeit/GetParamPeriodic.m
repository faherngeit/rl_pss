function params = GetParamPeriodic()
params = GetParamBasic();

% Gridsearch parameters

params.fault_rate = [2 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75];

params.folder = 'image_periodic/';
params.savefig = 1;
params.desc = 'Тестирование алгоритма без апериодики при различной степени насыщения';


