function scenario = setEventParameters(event, scenarioNormState)
model = event.model;
scenario = scenarioNormState;
% В элемент сценарией переносится описание событий
scenario.EventDescription = event.EventDescription;

%% Параметры события
% Точки КЗ
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'SwitchTimes', "[" + num2str(event.KZ_A1_G1_LV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'FaultA', event.KZ_A1_G1_LV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'FaultB', event.KZ_A1_G1_LV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'FaultC', event.KZ_A1_G1_LV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_LV'],'GroundFault', event.KZ_A1_G1_LV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'SwitchTimes', "[" + num2str(event.KZ_A1_G2_LV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'FaultA', event.KZ_A1_G2_LV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'FaultB', event.KZ_A1_G2_LV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'FaultC', event.KZ_A1_G2_LV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_LV'],'GroundFault', event.KZ_A1_G2_LV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'SwitchTimes', "[" + num2str(event.KZ_A1_G1_HV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'FaultA', event.KZ_A1_G1_HV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'FaultB', event.KZ_A1_G1_HV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'FaultC', event.KZ_A1_G1_HV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G1_HV'],'GroundFault', event.KZ_A1_G1_HV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'SwitchTimes', "[" + num2str(event.KZ_A1_G2_HV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'FaultA', event.KZ_A1_G2_HV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'FaultB', event.KZ_A1_G2_HV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'FaultC', event.KZ_A1_G2_HV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/KZ_A1_G2_HV'],'GroundFault', event.KZ_A1_G2_HV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'SwitchTimes', "[" + num2str(event.KZ_A2_G3_LV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'FaultA', event.KZ_A2_G3_LV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'FaultB', event.KZ_A2_G3_LV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'FaultC', event.KZ_A2_G3_LV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_LV'],'GroundFault', event.KZ_A2_G3_LV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'SwitchTimes', "[" + num2str(event.KZ_A2_G4_LV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'FaultA', event.KZ_A2_G4_LV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'FaultB', event.KZ_A2_G4_LV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'FaultC', event.KZ_A2_G4_LV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_LV'],'GroundFault', event.KZ_A2_G4_LV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'SwitchTimes', "[" + num2str(event.KZ_A2_G3_HV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'FaultA', event.KZ_A2_G3_HV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'FaultB', event.KZ_A2_G3_HV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'FaultC', event.KZ_A2_G3_HV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G3_HV'],'GroundFault', event.KZ_A2_G3_HV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'SwitchTimes', "[" + num2str(event.KZ_A2_G4_HV.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'FaultA', event.KZ_A2_G4_HV.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'FaultB', event.KZ_A2_G4_HV.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'FaultC', event.KZ_A2_G4_HV.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/KZ_A2_G4_HV'],'GroundFault', event.KZ_A2_G4_HV.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lb'],'SwitchTimes', "[" + num2str(event.KZ_Lb.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lb'],'FaultA', event.KZ_Lb.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lb'],'FaultB', event.KZ_Lb.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lb'],'FaultC', event.KZ_Lb.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lb'],'GroundFault', event.KZ_Lb.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lm'],'SwitchTimes', "[" + num2str(event.KZ_Lm.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lm'],'FaultA', event.KZ_Lm.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lm'],'FaultB', event.KZ_Lm.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lm'],'FaultC', event.KZ_Lm.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Lm'],'GroundFault', event.KZ_Lm.PhaseG);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Le'],'SwitchTimes', "[" + num2str(event.KZ_Le.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Le'],'FaultA', event.KZ_Le.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Le'],'FaultB', event.KZ_Le.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Le'],'FaultC', event.KZ_Le.PhaseC);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/KZ_Le'],'GroundFault', event.KZ_Le.PhaseG);
% Работа выключателей
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchTimes', "[" + num2str(event.A1_Br_L.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchA', event.A1_Br_L.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchB', event.A1_Br_L.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_L'],'SwitchC', event.A1_Br_L.PhaseC);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchTimes', "[" + num2str(event.A2_Br_L.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchA', event.A2_Br_L.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchB', event.A2_Br_L.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_L'],'SwitchC', event.A2_Br_L.PhaseC);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchTimes', "[" + num2str(event.A1_Br_SCB.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchA', event.A1_Br_SCB.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchB', event.A1_Br_SCB.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/A1_Br_SCB'],'SwitchC', event.A1_Br_SCB.PhaseC);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchTimes', "[" + num2str(event.A2_Br_SCB.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchA', event.A2_Br_SCB.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchB', event.A2_Br_SCB.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/A2_Br_SCB'],'SwitchC', event.A2_Br_SCB.PhaseC);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_begin'],'SwitchTimes', "[" + num2str(event.Br_Line_begin.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_begin'],'SwitchA', event.Br_Line_begin.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_begin'],'SwitchB', event.Br_Line_begin.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_begin'],'SwitchC', event.Br_Line_begin.PhaseC);
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_end'],'SwitchTimes', "[" + num2str(event.Br_Line_end.Times) + "]");
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_end'],'SwitchA', event.Br_Line_end.PhaseA);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_end'],'SwitchB', event.Br_Line_end.PhaseB);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Br_Line_end'],'SwitchC', event.Br_Line_end.PhaseC);
% Режимы нагрузок
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Area1_AddLoad'],'ActivePower',     num2str(event.Area1_AddLoad(1)));
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Area1_AddLoad'],'CapacitivePower', num2str(event.Area1_AddLoad(2)));
%
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/Area2_AddLoad'],'ActivePower',     num2str(event.Area2_AddLoad(1)));
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/Area2_AddLoad'],'CapacitivePower', num2str(event.Area2_AddLoad(2)));
end