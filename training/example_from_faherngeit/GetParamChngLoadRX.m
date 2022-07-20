function params = GetParamChngLoadRX()
params = GetParamChngLoad();
params.phi = acos(0.8);

% Gridsearch parameters
params.fault_angle = [0:60:180];
params.fault_angle_shift = [0:30:90];

params.savefig = 1;
params.folder = 'images_chngload_rx/';
params.desc = 'Тестирование алгоритма при изменении нагрузки вторичной цепи при номинальном угле нагрузки';


