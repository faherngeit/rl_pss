function simOutData = getScenarioSimOutData(scenarios_file, reward_type, penalty)
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
% из пула выбирается 1 случайный сценарий
%scen = getRandomScenarios(1, scens.scenarios);
scen = scens.scenarios(1);
% моделирование и запись результата
simoutput = sim(scen);
% расчет суммарной награды и траектории её изменения
% да да, скорее всего суммарная награда не потребуется, но ни к чему лишний
% раз менять уже написанную функцию
% ! в результатах обязательно должны быть массивы W, D и t
[reward, reward_list] = get_reward(simoutput, true, reward_type);

% передаваемый в питон объект, в который нужно добавить награды
simOutData = simoutput.A_simOutData;

simStopTime = simoutput.SimulationMetadata.ModelInfo.StopTime;
% время между действиями агента
actionTimeStep = simStopTime / size(simOutData,3);

simOutData(1, size(simOutData,2)+1, 1) = 0;
for actionnum = 2:size(simOutData,3)
    %
    action_moment = actionnum * actionTimeStep;
    %
    rewardIndex = find(simoutput.t>=action_moment,1,'first');
    %
    simOutData(1, size(simOutData,2), actionnum) = reward_list(rewardIndex);

end

% Если расчет прервался из-за нарушения устойчивости, то
% прибавляется заданный пользователем штраф.
if simoutput.t(size(simoutput.t,1)) < simStopTime
    % Сразу добавляется штраф заданный в начале расчета, для всех таких
    % случаев.
    simOutData(1, size(simOutData,2), size(simOutData,3)) = ...
        simOutData(1, size(simOutData,2), size(simOutData,3)) - penalty;
    reward_list(size(t_list,1)) = reward - penalty;
    reward = reward - penalty; 
end
end