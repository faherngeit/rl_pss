function states = prepareStates()
% Режим 1: максимальные нагрузки, 
%          пропорциональное распределение между G,
%          все в работе
states(1).model = 'power_KundurTwoAreaSystem_1';
% Параметры генераторов
% [dw(%), th(deg), ia,ib,ic(pu)  pha,phb,phc(deg)  Vf(pu)]
states(1).InitCond_M1 = [0 -32.4356 0.783664 0.783664 0.783664 1.92383 -118.076 121.924 1.8267];
states(1).InitCond_M2 = [0 -38.7801 0.934029 0.934029 0.934029 -9.29278 -129.293 110.707 2.09095];
states(1).InitCond_M3 = [0 -51.156 0.801426 0.801426 0.801426 -16.4454 -136.445 103.555 1.81998];
states(1).InitCond_M4 = [0 -61.491 0.778846 0.778846 0.778846 -25.4758 -145.476 94.5242 1.76466];
% Уровень нагрузки
% [P(W), Q(W)]
states(1).InitCond_L1 = [1.190e+09, 8.7000000e+07];
states(1).InitCond_L2 = [1.645e+09, 8.7000000e+07];
% Положения выключателей
% [InitialState]
states(1).InitCond_A1_Br_SCB = 'closed';
states(1).InitCond_A2_Br_SCB = 'closed';
states(1).Br_Line_begin = 'closed';
states(1).Br_Line_end   = 'closed';

% Режим 2: максимальные нагрузки, 
%          пропорциональное распределение между G,
%          ВЛ1 в ремонте
states(2).model = 'power_KundurTwoAreaSystem_1';
% Параметры генераторов
% [dw(%), th(deg), ia,ib,ic(pu)  pha,phb,phc(deg)  Vf(pu)]
states(2).InitCond_M1 = [0 -32.4888 0.786142 0.786142 0.786142 1.29157 -118.708 121.292 1.84827];
states(2).InitCond_M2 = [0 -42.5027 0.866735 0.866735 0.866735 -12.3952 -132.395 107.605 2.02635];
states(2).InitCond_M3 = [0 -69.0698 0.803217 0.803217 0.803217 -34.918 -154.918 85.082 1.84175];
states(2).InitCond_M4 = [0 -80.6933 0.782809 0.782809 0.782809 -46.1095 -166.109 73.8905 1.81834];
% Уровень нагрузки
% [P(W), Q(W)]
states(2).InitCond_L1 = [1.190e+09, 8.7000000e+07];
states(2).InitCond_L2 = [1.645e+09, 8.7000000e+07];
% Положения выключателей
% [InitialState]
states(2).InitCond_A1_Br_SCB = 'closed';
states(2).InitCond_A2_Br_SCB = 'closed';
states(2).Br_Line_begin = 'open';
states(2).Br_Line_end   = 'open';

% % Режим 3: максимальные нагрузки, 
% %          пропорциональное распределение между G
% % [dw(%), th(deg), ia,ib,ic(pu)  pha,phb,phc(deg)  Vf(pu)]
% states(3).InitCond_M1 = [0, -32.3063, 0.784601, 0.784601, 0.784601, 1.82343, -118.177, 121.823, 1.83526];
% states(3).InitCond_M2 = [0, -40.7033, 0.889307, 0.889307, 0.889307, -10.5234, -130.523, 109.477, 2.03703];
% states(3).InitCond_M3 = [0, -57.5136, 0.803057, 0.803057, 0.803057, -23.3168, -143.317, 96.6832, 1.84];
% states(3).InitCond_M4 = [0, -69.0384, 0.782388, 0.782388, 0.782388, -34.3377, -154.338, 85.6623, 1.81398];
% % [P(W), Q(W)]
% states(3).InitCond_L1 = [1.067e+09, 8.7000000e+07];
% states(3).InitCond_L2 = [1.767e+09, 8.7000000e+07];

end