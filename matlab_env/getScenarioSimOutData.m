function result = getScenarioSimOutData(scenarios_file, scen_quan, reward_type, penalty,result_directory)
% Функция выполняет загрузку пула сценариев, выбор случайного,
% моделирование процесса, расчета награды и возвращает 3-хмерный массив для
% обучения с добавлением рассчитанной награды.
%   scenarios_file - пусть к файлу пула сценариев, хранящему
%                    сгенерированные заранее объекты SimulationInput
%   scen_quan      - число рассматриваемых сценариев. Выставляем: 1
%   reward_type    - тип рассчитываемой награды 
%                    (пиши 'IntMaxDeltaWs' - не   ошибешься)
%   penalty        - штраф за нарушение устойчивости

% загрузка файла сценариев
scens = load(scenarios_file);
% из пула выбирается n случайных сценариев
scenario = getRandomScenarios(scen_quan, scens.scenarios);
% моделирование и запись результатов
simoutput = sim(scenario.SimInput);

% Массив объектов результатов моделирования:
% result_.A_simOutData
% result_.A_state
% result_.Reward
result = handleParsimResults(simoutput, reward_type, penalty);

% Запись результатов испытания в файл
saveSampleResults(scenario,result,simoutput,reward_type,result_directory);
end