function params = GetCTCpatams()

params = GetParamBasic();

% Interdomain coupling
params.CT.alpha = 3e-5; 
% Sat. Anhyst. Magnetization
params.CT.Ms = 1.7e6 * [0.95:0.1:1.05] ; 
%Domainf pinning paramter
params.CT.k = 4e-5 * [0.9:0.1:1.1]; 
% Domaing Flexing Parameter
params.CT.c = 0.08; 
% Adjusting K with M
params.CT.beta = 0.96;

params.CT.a1 = 2550; 
params.CT.a2 = 3150; 
params.CT.a3 = 15000;
params.CT.b = 2;