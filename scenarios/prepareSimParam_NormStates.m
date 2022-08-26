function scenarios = prepareSimParam_NormStates(statesNorm)
    % В зависимости от ступени обучения набирается своя группа сценариев
    scenario_id = 1;
    
    for statenum = size(statesNorm,2):-1:1
        scenarios(scenario_id) = setStateParameters(statesNorm(statenum));
        % В элемент сценарией переносится описание событий
%         Scenarios(scenario_id).EventDescription = "Событие: \n" + ...
%                                                   "Отсутствует.\n";
        scenario_id = scenario_id + 1;
    end
end