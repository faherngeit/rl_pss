function params = GetParamAperiodic()
params = GetParamBasic();

% Gridsearch parameters
params.i_nom = 600;
params.fault_rate = [15 30 45];
params.fault_angle = [10:10:180];
params.fault_angle_shift = [5:5:90];


params.folder = 'image_aperiodic/';
params.savefig = 1;
params.desc = 'Тестирование алгоритма для разных моменто возникновения КЗ и сдвига фаз периодической составляющей';

