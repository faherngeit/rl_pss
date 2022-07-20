function params = GetParamCTchg()

params = GetParamBasic();

% Interdomain coupling
params.CT.alpha = 3e-5; 
% Sat. Anhyst. Magnetization
params.CT.Ms = 1.7e6 * [0.9:0.02:1.1] ; 
%Domainf pinning paramter
params.CT.k = 4e-5 * [0.9:0.02:1.1];
% Domaing Flexing Parameter
params.CT.c = 0.08; 
% Adjusting K with M
params.CT.beta = 0.96;

params.fault_rate = [30];
params.fault_angle = [0:45:180];
params.fault_angle_shift = [0:45:90];

params.folder = 'image_CTchng/';
params.savefig = 1;
params.desc = 'Тестирование алгоритма при искажении кривой намагничивания';