function [scenarios_NormStates, ...
          scenarios_1phSCg]   = prepareScenarios(states_quantity,model)
% Метод формирует список сценариев для моделирования при обучении
% , ...
%           scenarios_LinesSCB
%           scenarios_1phSCg, ...
%           scenarios_2phSCg_gen, ...
%           scenarios_3phSCgen

config = jsonDataExtract("../general_config.json");

% Формируется перечень случайных нормальных режимов
statesNorm = prepareStates(states_quantity,model,config);
scenarios_NormStates = prepareSimParam_NormStates(statesNorm);
% scenarios_NormStates = prepareOutputData(model,scenarios_NormStates, false); 
for i = 1:size(scenarios_NormStates,2)
    scenarios_NormStates(i).SimInput.UserString = num2str(1) + ";" + num2str(i);
end
scenarios = scenarios_NormStates;
save("scenarios_NormalStates.mat","scenarios");

% % Отключение ВЛ
% Events_Line = prepareEvents_Line(statesNorm(1).model, config);
% scenarios_line = prepareSimParam_Events(statesNorm, Events_Line);
% scenarios_line = prepareOutputData(model,scenarios_line, false); 
% scenarios_LinesSCB = [scenarios_NormStates, scenarios_line];
% % Переключения БСК
% Events_SCB = prepareEvents_SCB(statesNorm(1).model, config);
% scenarios_SCB = prepareSimParam_Events(statesNorm, Events_SCB);
% scenarios_SCB = prepareOutputData(model,scenarios_SCB, false);
% scenarios_LinesSCB = [scenarios_LinesSCB, scenarios_SCB];
% scenarios = scenarios_LinesSCB;
% save("scenarios_LineSCB.mat","scenarios");

% % 1ф КЗ на ВЛ, время отключения ОЗ
% Events_1phSCg_line_main = prepareEvents_1phSCg_A_3ph_line(statesNorm(1).model, config, 1);
% scenarios_1phSCg_line_main = prepareSimParam_Events(statesNorm, Events_1phSCg_line_main);
% % scenarios_1phSCg_line_main = prepareOutputData(model,scenarios_1phSCg_line_main, false); 
% scenarios_1phSCg = [scenarios_NormStates, scenarios_1phSCg_line_main];

% % 1ф КЗ на ВЛ, время отключения РЗ
% Events_1phSCg_line_rsrv = prepareEvents_1phSCg_A_3ph_line(statesNorm(1).model, config, 2);
% scenarios_1phSCg_line_rsrv = prepareSimParam_Events(statesNorm, Events_1phSCg_line_rsrv);
% % scenarios_1phSCg_line_rsrv = prepareOutputData(model,scenarios_1phSCg_line_rsrv, false); 
% scenarios_1phSCg = [scenarios_1phSCg, scenarios_1phSCg_line_rsrv];

% scenarios = scenarios_1phSCg;
% save("scenarios_1phSC.mat","scenarios");


% % % 
% % % 2ф КЗ на ВЛ, время отключения ОЗ
% % Events_2phSC_AB_line_main = prepareEvents_2phSC_AB_line(statesNorm(1).model, config, 1);
% % scenarios_2phSC_AB_line_main = prepareSimParam_Events(statesNorm, Events_2phSC_AB_line_main);
% % % scenarios_2phSC = [scenarios_1phSCg, scenarios_2phSC_AB_line_main];
% % scenarios_2phSC = scenarios_2phSC_AB_line_main;

% % % 
% % % 2ф КЗ на ВЛ, время отключения РЗ
% % Events_2phSC_AB_line_rsrv = prepareEvents_2phSC_AB_line(statesNorm(1).model, config, 2);
% % scenarios_2phSC_AB_line_rsrv = prepareSimParam_Events(statesNorm, Events_2phSC_AB_line_rsrv);
% % scenarios_2phSC = [scenarios_2phSC, scenarios_2phSC_AB_line_rsrv];
% % % 
% % % 2ф КЗ на Г, время отключения ОЗ
% % Events_2phSC_gen = prepareEvents_2phSC_gen(statesNorm(1).model,config);
% % scenarios_2phSC_gen = prepareSimParam_Events(statesNorm, Events_2phSC_gen);
% % scenarios_2phSC_gen = [scenarios_2phSC, scenarios_2phSC_gen];
% % 
% % scenarios = scenarios_2phSC_gen;
% % save("scenarios_2phSC.mat","scenarios");

% % 2ф на землю КЗ на ВЛ, время отключения ОЗ
% Events_2phSCg_AB_line_main = prepareEvents_2phSCg_AB_line(statesNorm(1).model, config, 1);
% scenarios_2phSCg_AB_line_main = prepareSimParam_Events(statesNorm, Events_2phSCg_AB_line_main);
% scenarios_2phSCg = [scenarios_2phSC, scenarios_2phSCg_AB_line_main];
% % 2ф на землю КЗ на ВЛ, время отключения РЗ
% Events_2phSCg_AB_line_rsrv = prepareEvents_2phSCg_AB_line(statesNorm(1).model, config, 2);
% scenarios_2phSCg_AB_line_rsrv = prepareSimParam_Events(statesNorm, Events_2phSCg_AB_line_rsrv);
% scenarios_2phSCg = [scenarios_2phSCg, scenarios_2phSCg_AB_line_rsrv];
% 
% % 2ф на землю КЗ Г, время отключения ОЗ
% Events_2phSCg_gen = prepareEvents_2phSCg_gen(statesNorm(1).model,config);
% scenarios_2phSCg_gen = prepareSimParam_Events(statesNorm, Events_2phSCg_gen);
% scenarios_2phSCg_gen = [scenarios_2phSC_gen, scenarios_2phSCg_gen];
% 
% 3ф на землю КЗ на ВЛ, время отключения ОЗ
Events_3phSC_line_main = prepareEvents_3phSC_line(statesNorm(1).model, config, 1);
scenarios_3phSC_main   = prepareSimParam_Events(statesNorm, Events_3phSC_line_main);
% scenarios_3phSC = [scenarios_2phSCg_gen, scenarios_3phSC_main];
scenarios_3phSC = [scenarios_3phSC_main];
% 3ф на землю КЗ на ВЛ, время отключения РЗ
Events_3phSC_line_rsrv = prepareEvents_3phSC_line(statesNorm(1).model, config, 2);
scenarios_3phSC_rsrv   = prepareSimParam_Events(statesNorm, Events_3phSC_line_rsrv);
scenarios_3phSC = [scenarios_3phSC, scenarios_3phSC_rsrv];

% 3ф КЗ на Г, время отключения ОЗ
Events_3phSC_gen_main = prepareEvents_3phSC_gen(statesNorm(1).model, config);
scenarios_3phSC_main  = prepareSimParam_Events(statesNorm, Events_3phSC_gen_main);
scenarios_3phSCgen   = [scenarios_3phSC, scenarios_3phSC_main];

scenarios = scenarios_3phSCgen;
save("scenarios_3phSC.mat","scenarios");