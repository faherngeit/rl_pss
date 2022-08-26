function scenario = setStateParameters(state)
model = state.model;
gen_area1 = round((str2double(state.M1_Pref) + str2double(state.M2_Pref)) * 900, 3);
ldP_area1 = round(str2double(state.InitCond_L1_P) / 1.0e+06, 3);
ldQ_area1 = round(str2double(state.InitCond_L1i_Q) / 1.0e+06 - str2double(state.InitCond_L1c_Q) / 1.0e+06, 3);
gen_area2 = round((str2double(state.M3_Pref) + str2double(state.M4_Pref)) * 900, 3);
ldP_area2 = round(str2double(state.InitCond_L2_P)  / 1.0e+06, 3);
ldQ_area2 = round(str2double(state.InitCond_L2i_Q)  / 1.0e+06 - str2double(state.InitCond_L2c_Q)  / 1.0e+06, 3);
tie_flow  = ldP_area2 - gen_area2;

scenario.StateDescription = "Режимные условия: \n" + ...
                            "Нагрузка  ЭЭС1: " + ldP_area1 + "+j"       + ldQ_area1 + " МВА \n" + ...
                            "Генерация ЭЭС1: " + gen_area1 + " МВт \n" + ...
                            "Нагрузка  ЭЭС2: " + ldP_area2 + "+j"       + ldQ_area2 + " МВА \n" + ...
                            "Генерация ЭЭС2: " + gen_area2 + " МВт \n" + ...
                            "Межсистемный переток: " + tie_flow + " МВт";

scenario.EventDescription = "Событие: \n" + ...
                            "Отсутствует.\n";

%scenario.State    = state;
scenario.SimInput = Simulink.SimulationInput(model);

%% Параметры режима
% Режимы генераторов
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Pref1'],   'Value', state.M1_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/M1: Turbine & Regulators/STG'],   'ini1', state.M1_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/M1: Turbine & Regulators/EXCITATION'], 'v0', state.M1_Vf);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/M1 900 MVA'],'InitialConditions', state.InitCond_M1);

scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Pref2'],   'Value', state.M2_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/M2: Turbine & Regulators/STG'],   'ini1', state.M2_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/M2: Turbine & Regulators/EXCITATION'], 'v0', state.M2_Vf);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/M2 900 MVA'],'InitialConditions', state.InitCond_M2);

scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/Pref3'],    'Value', state.M3_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/M3: Turbine & Regulators/STG'],   'ini1', state.M3_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/M3: Turbine & Regulators/EXCITATION'], 'v0', state.M3_Vf);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/M3 900 MVA'],'InitialConditions', state.InitCond_M3);

scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/Pref4'],    'Value', state.M4_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/M4: Turbine & Regulators/STG'],   'ini1', state.M4_Pref);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/M4: Turbine & Regulators/EXCITATION'], 'v0', state.M4_Vf);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/M4 900 MVA'],'InitialConditions', state.InitCond_M4);

% Режимы нагрузок
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Area1_MainLoad'],'ActivePower',     state.InitCond_L1_P);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Area1_MainLoad'],'InductivePower',  state.InitCond_L1i_Q);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Area1_MainLoad'],'CapacitivePower', state.InitCond_L1c_Q);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/Area2_MainLoad'],'ActivePower',     state.InitCond_L2_P);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/Area1_MainLoad'],'InductivePower',  state.InitCond_L2i_Q);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/Area2_MainLoad'],'CapacitivePower', state.InitCond_L2c_Q);

% Сопротивления ЛЭП
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/25km Area 1'],'Resistances',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/25km Area 1'],'Inductances',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/25km Area 1'],'Capacitances', state.C);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/10 km Area 1'],'Resistances',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/10 km Area 1'],'Inductances',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 1/10 km Area 1'],'Capacitances', state.C);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 1a'],'Resistance',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 1a'],'Inductance',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 1a'],'Capacitance', state.C);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 1b'],'Resistance',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 1b'],'Inductance',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 1b'],'Capacitance', state.C);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 2'],'Resistance',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 2'],'Inductance',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Line 2'],'Capacitance', state.C);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/25km Area 2'],'Resistances',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/25km Area 2'],'Inductances',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/25km Area 2'],'Capacitances', state.C);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/10 km Area 2'],'Resistances',  state.R);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/10 km Area 2'],'Inductances',  state.L);
scenario.SimInput = scenario.SimInput.setBlockParameter([model, '/Area 2/10 km Area 2'],'Capacitances', state.C);

end