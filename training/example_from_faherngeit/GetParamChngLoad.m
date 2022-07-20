function params = GetParamChngLoad()
params = GetParamBasic();

% Gridsearch parameters
params.fault_rate = [15 30 45];
params.fault_angle = [0:30:180];
params.fault_angle_shift = [0:15:90];
params.Load = [0.6:0.1:1.2];

params.savefig = 1;
params.folder = 'images_chngload/';
params.desc = 'Тестирование алгоритма при изменении нагрузки вторичной цепи';


