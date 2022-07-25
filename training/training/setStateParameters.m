function [simParam, simDesc] = setStateParameters(state)
model = state.model;

simParam = Simulink.SimulationInput(model);
%% Параметры режима
% Режимы генераторов
simParam = simParam.setBlockParameter([model, '/Area 1/M1 900 MVA'],'InitialConditions', num2str(state.InitCond_M1));
simParam = simParam.setBlockParameter([model, '/Area 1/M2 900 MVA'],'InitialConditions', num2str(state.InitCond_M2));
simParam = simParam.setBlockParameter([model, '/Area 2/M3 900 MVA'],'InitialConditions', num2str(state.InitCond_M3));
simParam = simParam.setBlockParameter([model, '/Area 2/M4 900 MVA'],'InitialConditions', num2str(state.InitCond_M4));
% Режимы нагрузок
simParam = simParam.setBlockParameter([model, '/Area 1/Area1_MainLoad'],'ActivePower',     num2str(state.InitCond_L1(1)));
simParam = simParam.setBlockParameter([model, '/Area 1/Area1_MainLoad'],'CapacitivePower', num2str(state.InitCond_L1(2)));
simParam = simParam.setBlockParameter([model, '/Area 2/Area2_MainLoad'],'ActivePower',     num2str(state.InitCond_L2(1)));
simParam = simParam.setBlockParameter([model, '/Area 2/Area2_MainLoad'],'CapacitivePower', num2str(state.InitCond_L2(2)));
% Положение выключателей
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'InitialState', state.InitCond_A1_Br_SCB);
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'InitialState', state.InitCond_A2_Br_SCB);
simParam = simParam.setBlockParameter([model, '/Br_Line_begin'],   'InitialState', state.Br_Line_begin);
simParam = simParam.setBlockParameter([model, '/Br_Line_end'],     'InitialState', state.Br_Line_end);

simDesc = 0;
end