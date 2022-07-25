function [simParam, simDesc] = setEventParameters(event, simStateParam, simStateDesc)
model = event.model;
simParam = simStateParam;
simDesc  = simStateDesc;

%% Параметры события
% Точки КЗ
%
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'SwitchTimes', num2str(event.KZ_A1_G1_LV.Times));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'FaultA', event.KZ_A1_G1_LV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'FaultB', event.KZ_A1_G1_LV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'FaultC', event.KZ_A1_G1_LV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'GroungFault', event.KZ_A1_G1_LV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'SwitchTimes', num2str(event.KZ_A1_G2_LV.Times));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'FaultA', event.KZ_A1_G2_LV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'FaultB', event.KZ_A1_G2_LV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'FaultC', event.KZ_A1_G2_LV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'GroungFault', event.KZ_A1_G2_LV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'SwitchTimes', num2str(event.KZ_A1_G1_HV.Times));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'FaultA', event.KZ_A1_G1_HV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'FaultB', event.KZ_A1_G1_HV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'FaultC', event.KZ_A1_G1_HV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'GroungFault', event.KZ_A1_G1_HV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'SwitchTimes', num2str(event.KZ_A1_G2_HV.Times));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'FaultA', event.KZ_A1_G2_HV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'FaultB', event.KZ_A1_G2_HV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'FaultC', event.KZ_A1_G2_HV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'GroungFault', event.KZ_A1_G2_HV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'SwitchTimes', num2str(event.KZ_A2_G3_LV.Times));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'FaultA', event.KZ_A2_G3_LV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'FaultB', event.KZ_A2_G3_LV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'FaultC', event.KZ_A2_G3_LV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'GroungFault', event.KZ_A2_G3_LV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'SwitchTimes', num2str(event.KZ_A2_G4_LV.Times));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'FaultA', event.KZ_A2_G4_LV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'FaultB', event.KZ_A2_G4_LV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'FaultC', event.KZ_A2_G4_LV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'GroungFault', event.KZ_A2_G4_LV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'SwitchTimes', num2str(event.KZ_A2_G3_HV.Times));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'FaultA', event.KZ_A2_G3_HV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'FaultB', event.KZ_A2_G3_HV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'FaultC', event.KZ_A2_G3_HV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'GroungFault', event.KZ_A2_G3_HV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'SwitchTimes', num2str(event.KZ_A2_G4_HV.Times));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'FaultA', event.KZ_A2_G4_HV.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'FaultB', event.KZ_A2_G4_HV.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'FaultC', event.KZ_A2_G4_HV.Phases(3));
simParam = simParam.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'GroungFault', event.KZ_A2_G4_HV.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/KZ_Lb'],'SwitchTimes', num2str(event.KZ_Lb.Times));
simParam = simParam.setBlockParameter([model, '/KZ_Lb'],'FaultA', event.KZ_Lb.Phases(1));
simParam = simParam.setBlockParameter([model, '/KZ_Lb'],'FaultB', event.KZ_Lb.Phases(2));
simParam = simParam.setBlockParameter([model, '/KZ_Lb'],'FaultC', event.KZ_Lb.Phases(3));
simParam = simParam.setBlockParameter([model, '/KZ_Lb'],'GroungFault', event.KZ_Lb.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/KZ_Lm'],'SwitchTimes', num2str(event.KZ_Lm.Times));
simParam = simParam.setBlockParameter([model, '/KZ_Lm'],'FaultA', event.KZ_Lm.Phases(1));
simParam = simParam.setBlockParameter([model, '/KZ_Lm'],'FaultB', event.KZ_Lm.Phases(2));
simParam = simParam.setBlockParameter([model, '/KZ_Lm'],'FaultC', event.KZ_Lm.Phases(3));
simParam = simParam.setBlockParameter([model, '/KZ_Lm'],'GroungFault', event.KZ_Lm.Phases(4));
%
simParam = simParam.setBlockParameter([model, '/KZ_Le'],'SwitchTimes', num2str(event.KZ_Le.Times));
simParam = simParam.setBlockParameter([model, '/KZ_Le'],'FaultA', event.KZ_Le.Phases(1));
simParam = simParam.setBlockParameter([model, '/KZ_Le'],'FaultB', event.KZ_Le.Phases(2));
simParam = simParam.setBlockParameter([model, '/KZ_Le'],'FaultC', event.KZ_Le.Phases(3));
simParam = simParam.setBlockParameter([model, '/KZ_Le'],'GroungFault', event.KZ_Le.Phases(4));
% Работа выключателей
%
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchTimes', num2str(event.A1_Br_L.Times));
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchA', event.A1_Br_L.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchB', event.A1_Br_L.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchC', event.A1_Br_L.Phases(3));
%
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchTimes', num2str(event.A2_Br_L.Times));
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchA', event.A2_Br_L.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchB', event.A2_Br_L.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchC', event.A2_Br_L.Phases(3));
%
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchTimes', num2str(event.A1_Br_SCB.Times));
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchA', event.A1_Br_SCB.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchB', event.A1_Br_SCB.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchC', event.A1_Br_SCB.Phases(3));
%
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchTimes', num2str(event.A2_Br_SCB.Times));
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchA', event.A2_Br_SCB.Phases(1));
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchB', event.A2_Br_SCB.Phases(2));
simParam = simParam.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchC', event.A2_Br_SCB.Phases(3));
%
simParam = simParam.setBlockParameter([model, '/Br_Line_begin'],'SwitchTimes', num2str(event.Br_Line_begin.Times));
simParam = simParam.setBlockParameter([model, '/Br_Line_begin'],'SwitchA', event.Br_Line_begin.Phases(1));
simParam = simParam.setBlockParameter([model, '/Br_Line_begin'],'SwitchB', event.Br_Line_begin.Phases(2));
simParam = simParam.setBlockParameter([model, '/Br_Line_begin'],'SwitchC', event.Br_Line_begin.Phases(3));
%
simParam = simParam.setBlockParameter([model, '/Br_Line_end'],'SwitchTimes', num2str(event.Br_Line_end.Times));
simParam = simParam.setBlockParameter([model, '/Br_Line_end'],'SwitchA', event.Br_Line_end.Phases(1));
simParam = simParam.setBlockParameter([model, '/Br_Line_end'],'SwitchB', event.Br_Line_end.Phases(2));
simParam = simParam.setBlockParameter([model, '/Br_Line_end'],'SwitchC', event.Br_Line_end.Phases(3));
% Режимы нагрузок
%
simParam = simParam.setBlockParameter([model, '/Area 1/Area1_AddLoad'],'ActivePower',     num2str(event.Area1_AddLoad(1)));
simParam = simParam.setBlockParameter([model, '/Area 1/Area1_AddLoad'],'CapacitivePower', num2str(event.Area1_AddLoad(2)));
%
simParam = simParam.setBlockParameter([model, '/Area 2/Area2_AddLoad'],'ActivePower',     num2str(event.Area2_AddLoad(1)));
simParam = simParam.setBlockParameter([model, '/Area 2/Area2_AddLoad'],'CapacitivePower', num2str(event.Area2_AddLoad(2)));
end