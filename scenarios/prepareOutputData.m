function scenarios = prepareOutputData(model,scenarios,saveOutPut)
    % Модель нужно сохранить для parsim
    save_system(model);
    % Из набора сценариев выделяется список SimInput
    scens(1:size(scenarios,2)) = scenarios(1:size(scenarios,2)).SimInput;
    
    % Сбор результатов для сценариев.
    results_0 = parsim(scens);
    
    % По всем сценариеям записываются результаты и награды
    for scennum = 1:size(scenarios,2)
        if saveOutPut
            scenarios(scennum).simOut_0 = results_0(scennum);
        else
            scenarios(scennum).simOut_0 = [];
        end
    
        scenarios(scennum).reward_0 = get_reward(results_0(scennum), true, 'IntMaxDeltaWs');
    end
end