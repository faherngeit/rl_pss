function [scenarios] = prepareScenarios(states_quantity,model)
% Метод формирует список сценариев для моделирования при обучении

config = jsonDataExtract("../general_config.json");

% Формируется перечень случайных нормальных режимов
statesNorm = prepareStates(states_quantity,model,config);
scenarios_NormStates = prepareSimParam_NormStates(statesNorm);
scenarios_NormStates = prepareOutputData(model,scenarios_NormStates, true); 
% Отключение ВЛ
Events_Line = prepareEvents_Line(statesNorm(1).model, config);
scenarios_line = prepareSimParam_Events(statesNorm, Events_Line);
scenarios_line = prepareOutputData(model,scenarios_line, true); 
scenarios_LinesSCB = [scenarios_NormStates, scenarios_line];
% Переключения БСК
Events_SCB = prepareEvents_SCB(statesNorm(1).model, config);
scenarios_SCB = prepareSimParam_Events(statesNorm, Events_SCB);
scenarios_SCB = prepareOutputData(model,scenarios_SCB, true);
scenarios_LinesSCB = [scenarios_LinesSCB, scenarios_SCB];
for i = 1:size(scenarios_LinesSCB,2)
    scenarios_LinesSCB(i).SimInput.UserString = num2str(1) + ";" + num2str(i);
end
scenarios = scenarios_LinesSCB;
save("scenarios_1.mat","scenarios");

% 1ф КЗ на ВЛ, время отключения ОЗ
Events_1phSCg_line_main = prepareEvents_1phSCg_A_3ph_line(statesNorm(1).model, config, 1);
scenarios_1phSCg_line_main = prepareSimParam_Events(statesNorm, Events_1phSCg_line_main);
scenarios_1phSCg_line_main = prepareOutputData(model,scenarios_1phSCg_line_main, true); 
scenarios_1phSCg = scenarios_1phSCg_line_main;
% 1ф КЗ на ВЛ, время отключения РЗ
Events_1phSCg_line_rsrv = prepareEvents_1phSCg_A_3ph_line(statesNorm(1).model, config, 2);
scenarios_1phSCg_line_rsrv = prepareSimParam_Events(statesNorm, Events_1phSCg_line_rsrv);
scenarios_1phSCg_line_rsrv = prepareOutputData(model,scenarios_1phSCg_line_rsrv, true); 
scenarios_1phSCg = [scenarios_1phSCg, scenarios_1phSCg_line_rsrv];
for i = 1:size(scenarios_1phSCg,2)
    scenarios_1phSCg(i).SimInput.UserString = num2str(2) + ";" + num2str(i);
end
scenarios = [scenarios_LinesSCB, scenarios_1phSCg];
save("scenarios_2.mat","scenarios");

% 2ф КЗ на ВЛ, время отключения ОЗ
Events_2phSC_AB_line_main = prepareEvents_2phSC_AB_line(statesNorm(1).model, config, 1);
scenarios_2phSC_AB_line_main = prepareSimParam_Events(statesNorm, Events_2phSC_AB_line_main);
scenarios_2phSC = scenarios_2phSC_AB_line_main;
% 2ф КЗ на Г, время отключения ОЗ
Events_2phSC_gen = prepareEvents_2phSC_gen(statesNorm(1).model,config);
scenarios_2phSC_gen = prepareSimParam_Events(statesNorm, Events_2phSC_gen);
scenarios_2phSC     = [scenarios_2phSC, scenarios_2phSC_gen];
% 2ф КЗ на ВЛ, время отключения РЗ
Events_2phSC_AB_line_rsrv = prepareEvents_2phSC_AB_line(statesNorm(1).model, config, 2);
scenarios_2phSC_AB_line_rsrv = prepareSimParam_Events(statesNorm, Events_2phSC_AB_line_rsrv);
scenarios_2phSC = [scenarios_2phSC, scenarios_2phSC_AB_line_rsrv];
for i = 1:size(scenarios_2phSC,2)
    scenarios_2phSC(i).SimInput.UserString = num2str(3) + ";" + num2str(i);
end
scenarios_2phSC = prepareOutputData(model,scenarios_2phSC, true); 
scenarios = [scenarios, scenarios_2phSC];
save("scenarios_3.mat","scenarios");

% 2ф на землю КЗ на ВЛ, время отключения ОЗ
Events_2phSCg_AB_line_main = prepareEvents_2phSCg_AB_line(statesNorm(1).model, config, 1);
scenarios_2phSCg_AB_line_main = prepareSimParam_Events(statesNorm, Events_2phSCg_AB_line_main);
scenarios_2phSCg = scenarios_2phSCg_AB_line_main;
% 2ф на землю КЗ Г, время отключения ОЗ
Events_2phSCg_gen = prepareEvents_2phSCg_gen(statesNorm(1).model,config);
scenarios_2phSCg_gen = prepareSimParam_Events(statesNorm, Events_2phSCg_gen);
scenarios_2phSCg = [scenarios_2phSCg, scenarios_2phSCg_gen];
% 2ф на землю КЗ на ВЛ, время отключения РЗ
Events_2phSCg_AB_line_rsrv = prepareEvents_2phSCg_AB_line(statesNorm(1).model, config, 2);
scenarios_2phSCg_AB_line_rsrv = prepareSimParam_Events(statesNorm, Events_2phSCg_AB_line_rsrv);
scenarios_2phSCg = [scenarios_2phSCg, scenarios_2phSCg_AB_line_rsrv];
for i = 1:size(scenarios_2phSCg,2)
    scenarios_2phSCg(i).SimInput.UserString = num2str(4) + ";" + num2str(i);
end
scenarios_2phSCg = prepareOutputData(model,scenarios_2phSCg, true); 
scenarios = [scenarios, scenarios_2phSCg];
save("scenarios_4.mat","scenarios");

% 3ф на землю КЗ на ВЛ, время отключения ОЗ
Events_3phSC_line_main = prepareEvents_3phSC_line(statesNorm(1).model, config, 1);
scenarios_3phSC_main   = prepareSimParam_Events(statesNorm, Events_3phSC_line_main);
scenarios_3phSC = scenarios_3phSC_main;
% 3ф на землю КЗ на ВЛ, время отключения РЗ
Events_3phSC_line_rsrv = prepareEvents_3phSC_line(statesNorm(1).model, config, 2);
scenarios_3phSC_rsrv   = prepareSimParam_Events(statesNorm, Events_3phSC_line_rsrv);
scenarios_3phSC = [scenarios_3phSC, scenarios_3phSC_rsrv];
% 3ф КЗ на Г, время отключения ОЗ
Events_3phSC_gen_main = prepareEvents_3phSC_gen(statesNorm(1).model, config);
scenarios_3phSC_main  = prepareSimParam_Events(statesNorm, Events_3phSC_gen_main);
scenarios_3phSCgen    = [scenarios_3phSC, scenarios_3phSC_main];
for i = 1:size(scenarios_3phSCgen,2)
    scenarios_3phSCgen(i).SimInput.UserString = num2str(5) + ";" + num2str(i);
end
scenarios_3phSCgen = prepareOutputData(model,scenarios_3phSCgen, true); 
scenarios = [scenarios, scenarios_3phSCgen];
save("scenarios_5.mat","scenarios");