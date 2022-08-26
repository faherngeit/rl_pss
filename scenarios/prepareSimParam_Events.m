function scenarios = prepareSimParam_Events(statesNorm, events)
    % Для набора нормальных режимов генерируются сценарии с событиями в
    % системе
    scenario_id = 1; 
    %
    for statenum = 1:size(statesNorm,2)
        for eventnum = 1:size(events,2)
            state = setStateParameters(statesNorm(statenum));
            scenarios(scenario_id) = setEventParameters(events(eventnum), state);
            scenario_id = scenario_id + 1;
        end
    end
end