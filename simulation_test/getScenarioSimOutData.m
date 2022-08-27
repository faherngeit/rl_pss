function results = getScenarioSimOutData(scenarios_file, scen_quan, reward_type, penalty)
% Функция выполняет загрузку пула сценариев, выбор случайного,
% моделирование процесса, расчета награды и возвращает 3-хмерный массив для
% обучения с добавлением рассчитанной награды.
%   scenarios_file - пусть к файлу пула сценариев, хранящему
%                    сгенерированные заранее объекты SimulationInput
%   reward_type    - тип рассчитываемой награды 
%                    (пиши 'IntMaxDeltaWs' - не   ошибешься)
%   penalty        - штраф за нарушение устойчивости

% загрузка файла сценариев
scens = load(scenarios_file);
% из пула выбирается n случайных сценариев
scen = getRandomScenarios(scen_quan, scens.scenarios);
% моделирование и запись результатов
simoutputs = sim(scen);

% Массив объектов результатов моделирования:
% result_.A_simOutData
% result_.A_state
% result_.Reward
results = handleParsimResults(simoutputs, reward_type, penalty);

end