function py_results = handleParsimResults(simoutputs, reward_type, penalty, scenarios)
% Файл конфигурации
config = jsonDataExtract("../general_config.json");

% Для каждого эксперимента
for sampnum = size(simoutputs,2):-1:1  
    % Определение пользовательского времени окончания расчета
    simStopTime = simoutputs(sampnum).SimulationMetadata.ModelInfo.StopTime;
    % Расчет полной траектории награды
    raw_reward  = get_reward(simoutputs(sampnum), true, reward_type);
    % Получение награды без агента
    reward_0    = scenarios(sampnum).reward_0;
    % Инициализация массиво наград с агнетом и без агента
    rewards         = zeros(1,size(simoutputs(sampnum).A_state,3));
    rewards_noagent = zeros(1,size(simoutputs(sampnum).A_state,3));
                
    % Расчет времени между действиями агента
    actionTimeStep = 1.0 / config.Matlab.Model.AgentModel.agentTs_den;

    for actionnum = 1:size(simoutputs(sampnum).A_state,3)
        % Поиск индекса момента времени, которому соответствует
        % момент действия агента
        rewardIndex = find(simoutputs(sampnum).t>=actionnum * actionTimeStep,1,'first');
        % В список наград по найденному индексу добавляется значение из
        % общего массива raw_reward
        rewards(actionnum) = raw_reward(rewardIndex);
        rewards_noagent(actionnum) = reward_0(rewardIndex);
    end 

    % Награда в raw_reward считается интегрально для всего периода.
    % На последнем совещании договорились, что наоборот она должна
    % расчитываться за последнюю шаг.
    new_rewards = rewards;
    for rewnum = 2:size(simoutputs(sampnum).A_state,3)
        new_rewards(rewnum) = rewards(rewnum) - rewards(rewnum - 1);
    end
    rewards = new_rewards;
    % То же самое, но для случая, когда система работает без агента
    new_rewards = rewards_noagent;
    for rewnum = 2:size(simoutputs(sampnum).A_state,3)
        new_rewards(rewnum) = rewards_noagent(rewnum) - rewards_noagent(rewnum - 1);
    end
    rewards_noagent = new_rewards;

    % Если расчет прервался из-за нарушения устойчивости
    if (simoutputs(sampnum).t(size(simoutputs(sampnum).t,1)) < simStopTime)               
        % В последний элемент вектора награды вносится весь штраф
            rewards(size(rewards,2)) = rewards(size(rewards,2)) - penalty;        
    end 
    
    % В объект результатов по индексу записываются actions,state и
    % найденный reward
    py_results(sampnum).A_simOutData   = simoutputs(sampnum).A_simOutData;
    py_results(sampnum).A_state        = simoutputs(sampnum).A_state;
    py_results(sampnum).Reward         = rewards;
    py_results(sampnum).Reward_noAgent = rewards_noagent;
    py_results(sampnum).A_ID           = simoutputs(sampnum).A_ID(1);
end
end