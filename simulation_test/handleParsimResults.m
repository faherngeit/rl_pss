function py_results = handleParsimResults(simoutputs, reward_type, penalty)

% Для каждого эксперимента
for sampnum = 1:size(simoutputs,2)  
    % Расчет полной траектории награды
    raw_reward = get_reward(simoutputs(sampnum), true, reward_type);    
    % Определение пользовательского времени окончания расчета
    simStopTime = simoutputs(sampnum).SimulationMetadata.ModelInfo.StopTime;

    % Если расчет прервался из-за нарушения устойчивости
    if simoutputs(sampnum).t(size(simoutputs(sampnum).t,1)) < simStopTime
        %
        rewards = eye(1,size(simoutputs(sampnum).A_state,3));
        
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
            rewards(actionnum) = penalty * actionnum^2 / sumsq;
        end        
    % Если не прервался
    else
        
        % Расчет времени между действиями агента
        actionTimeStep = simStopTime / size(simoutputs(sampnum).A_state,3);

        % Инициализируется возвращаемый массив наград
        rewards = zeros(1,size(simoutputs(sampnum).A_state,3));
        for actionnum = 1:size(simoutputs(sampnum).A_state,3)
            % Поиск индекса момента времени, которому соответствует
            % момент действия агента
            rewardIndex = find(simoutputs(sampnum).t>=actionnum * actionTimeStep,1,'first');
            % В список наград по найденному индексу добавляется значение из
            % общего массива raw_reward
            rewards(actionnum) = raw_reward(rewardIndex);
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
    end   
    
    % В объект результатов по индексу записываются actions,state и
    % найденный reward
    py_results(sampnum).A_simOutData = simoutputs(sampnum).A_simOutData;
    py_results(sampnum).A_state      = simoutputs(sampnum).A_state;
    py_results(sampnum).Reward       = rewards;

end
end