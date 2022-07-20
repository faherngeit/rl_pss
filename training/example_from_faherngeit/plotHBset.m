function plotHBset(params)
% Interdomain coupling
CT.alpha = 3e-5; 
% Sat. Anhyst. Magnetization
CT.Ms = 1.7e6; 
%Domainf pinning paramter
CT.k = 4e-5; 
% Domaing Flexing Parameter
CT.c = 0.08; 
% Adjusting K with M
CT.beta = 0.96;

CT.a1 = 2550; 
CT.a2 = 3150; 
CT.a3 = 15000;
CT.b = 2;

paramsset = GetCTgrid(params);
for i = 1:size(paramsset,1)
    [H,M,B] = GetSatCurve(paramsset(i,:));
    HB{i} = [H', B'];
end
[H,M,B] = GetSatCurve(CT);
HB{i+1} = [H', B'];
plotHB(HB);