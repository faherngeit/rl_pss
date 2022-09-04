function [result, simLog] = getScenarioSimOutData(scenarios_file, scen_quan, reward_type, penalty, results_directory)
% Функция выполняет загрузку пула сценариев, выбор случайного,
% моделирование процесса, расчета награды и возвращает 3-хмерный массив для
% 
% обучения с добавлением рассчитанной награды.
%   scenarios_file   - пусть к файлу пула сценариев, хранящему
%                      сгенерированные заранее объекты SimulationInput
%   scen_quan        - число рассматриваемых сценариев.
%   reward_type      - тип рассчитываемой награды 
%                      (пиши 'IntMaxDeltaWs' - не   ошибешься)
%   penalty          - штраф за нарушение устойчивости
%   result_directory - директория сохранения результатов. Если указано "",
%                      то файлы не сохраняются.

% загрузка файла сценариев
scens = load(scenarios_file);
% из пула выбирается n случайных сценариев
scenarios = getRandomScenarios(scen_quan, scens.scenarios);

for scennum = size(scenarios, 2):-1:1
    simInputs(scennum) = scenarios(scennum).SimInput;
end

% Выполняется моделирование
simoutput = sim(simInputs);

% Массив объектов результатов моделирования:
% result_.A_simOutData
% result_.A_state
% result_.Reward
result = handleParsimResults(simoutput, reward_type, penalty, scenarios);

% Запись результатов испытаний в файлы
for scennum = size(scenarios, 2):-1:1  
    simLog(scennum) = saveSampleResults(scenarios(scennum), result(scennum), ...
                                        simoutput(scennum), reward_type, results_directory, "_" + num2str(scennum));
end
end