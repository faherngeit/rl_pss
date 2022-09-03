function [result, simLog] = getScenarioSimOutData(scenarios_file, scen_quan, reward_type, penalty, results_directory)
% Функция выполняет загрузку пула сценариев, выбор случайного,
% моделирование процесса, расчета награды и возвращает 3-хмерный массив для
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
% моделирование и запись результатов для каждого отобранного сценария
for scennum = size(scenarios, 2):-1:1
    simoutput(scennum) = sim(scenarios(scennum).SimInput);

    % Массив объектов результатов моделирования:
    % result_.A_simOutData
    % result_.A_state
    % result_.Reward
    result(scennum) = handleParsimResults(simoutput(scennum), reward_type, penalty);

    % Запись результатов испытания в файл
    simLog(scennum) = saveSampleResults(scenarios(scennum), result(scennum), ...
                      simoutput(scennum), reward_type, results_directory);
end
end