function py_results = handleParsimResults(simoutputs, reward_type, penalty, scenarios)

% Для каждого эксперимента
for sampnum = size(simoutputs,2):-1:1  
    % Расчет полной траектории награды
    raw_reward  = get_reward(simoutputs(sampnum), true, reward_type); 
    % Получение награды без агента
    reward_0    = scenarios(sampnum).reward_0;
    % Определение пользовательского времени окончания расчета
    simStopTime = simoutputs(sampnum).SimulationMetadata.ModelInfo.StopTime;

    % Инициализация массиво наград с агнетом и без агента
    rewards         = zeros(1,size(simoutputs(sampnum).A_state,3));
    rewards_noagent = zeros(1,size(simoutputs(sampnum).A_state,3));

    % Если расчет прервался из-за нарушения устойчивости
    if (simoutputs(sampnum).ErrorMessage ~= "") || (simoutputs(sampnum).t(size(simoutputs(sampnum).t,1)) < simStopTime)       
        
        % Хочется награду распределить пропорционально квадрату номера
        % действия. Сложно скзаать, как это скажется, но представляется,
        % что так меньшие штрафы на первых этапах не будут сбивать процесс
        % обучения. В итоге штраф будет распределяться близко к тому, как
        % это должно быть, если расчет не прерывается.
        % Для этого нужно посчитать сумму квадратов индексов действий.
        sumsq = 0;
        for actionnum = 1:size(simoutputs(sampnum).A_state,3)
            sumsq = sumsq + actionnum * actionnum;
        end       

        for actionnum = 1:size(simoutputs(sampnum).A_state,3)            
            rewards(actionnum) = -penalty * actionnum^2 / sumsq;
        end 

        % Если расчет прервался, то в принципе не имеет значения, какая 
        % была награда без агента. Поэтому итоговая награда для расчета
        % без агента просто записывается в последний элемент массива.
        rewards_noagent(size(simoutputs(sampnum).A_state,3)) = reward_0(size(reward_0,1));

    % Если не прервался
    else
        
        % Расчет времени между действиями агента
        actionTimeStep = simStopTime / size(simoutputs(sampnum).A_state,3);

        for actionnum = 1:size(simoutputs(sampnum).A_state,3)
            % Поиск индекса момента времени, которому соответствует
            % момент действия агента
            rewardIndex = find(simoutputs(sampnum).t>=actionnum * actionTimeStep,1,'first');
            % В список наград по найденному индексу добавляется значение из
            % общего массива raw_reward
            rewards(actionnum) = raw_reward(rewardIndex);
            rewards_noagent(actionnum) = reward_0(rewardIndex);
        end 

        % Это спорный момент.
        % Награда в raw_reward считается интегрально для всего периода.
        % На последнем совещании договорились, что наоборот она должна
        % расчитываться за последнюю секунду.
        % Можно закомментить если что и будет, как в первом случае.
        new_rewards = rewards;
        for rewnum = 2:size(simoutputs(sampnum).A_state,3)
            new_rewards(rewnum) = rewards(rewnum) - rewards(rewnum - 1);
        end
        rewards = new_rewards;
        %
        new_rewards = rewards_noagent;
        for rewnum = 2:size(simoutputs(sampnum).A_state,3)
            new_rewards(rewnum) = rewards_noagent(rewnum) - rewards_noagent(rewnum - 1);
        end
        rewards_noagent = new_rewards;
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