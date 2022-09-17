function scenarios = prepareOutputData(model,scenarios,saveOutPut)
    % Модель нужно сохранить для parsim
    save_system(model);
    % Из набора сценариев выделяется список SimInput
    for scennum = size(scenarios,2):-1:1
        scens(scennum) = scenarios(scennum).SimInput;
    end
    
    
    % Сбор результатов для сценариев.
    results_0 = sim(scens);
    
    % По всем сценариеям записываются результаты и награды
    for scennum = 1:size(scenarios,2)
        if saveOutPut
            scenarios(scennum).simOut_0 = results_0(scennum);
        else
            scenarios(scennum).simOut_0 = [];
        end
    
        scenarios(scennum).reward_0 = get_reward(results_0(scennum), false, 'IntMaxDeltaWs');
    end
end