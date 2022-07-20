function params = GetParamBasic()
params.Znom = 30/25;
params.phi = 0;

% Gridsearch parameters
params.i_nom = 600;
params.fault_rate = [20, 30];
params.fault_angle = [0];
params.fault_angle_shift = [0];
params.aper_time_const = 0.02;
params.Load = [1];

params.model = 'CT_tests';
params.wnd_move = 1;

% Interdomain coupling
params.CT.alpha = 3e-5; 
% Sat. Anhyst. Magnetization
params.CT.Ms = 1.7e6; 
%Domainf pinning paramter
params.CT.k = 4e-5; 
% Domaing Flexing Parameter
params.CT.c = 0.08; 
% Adjusting K with M
params.CT.beta = 0.96;


params.CT.a1 = 2550; 
params.CT.a2 = 3150; 
params.CT.a3 = 15000;
params.CT.b = 2;

params.Ts = 10e-6;
params.freq = 50;
params.Nsmp_per_per = 80;
params.Nsmp_wnd = 20;
params.count_pred = 2;
params.count_post = 4;
params.Nwindow = 3;
params.decimation = 1 / params.Ts / params.freq / params.Nsmp_per_per;
params.WinSamples = params.Nwindow * params.Nsmp_per_per;
params.folder = 'images/';
params.savefig = 0;
params.desc = 'Тестовый набор параметров для отладки цепочки тестирования';


