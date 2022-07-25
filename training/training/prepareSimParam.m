function [simParams, simDescs] = prepareSimParam(stageNum)
% В зависимости от ступени обучения набирается своя группа сценариев
switch stageNum
    case 1
        %
        scenario_id = 1;
        %
        states = prepareStates();
        for statenum = 1:size(states,2)
            [simParams(scenario_id), simDescs(scenario_id)] = setStateParameters(states(statenum));
            scenario_id = scenario_id + 1;
        end
    case 2
        %
        scenario_id = 1;
        %
        states = prepareStates();
        %
        events = prepareEvents_Load();

        %
        for statenum = 1:size(states,2)
            for eventnum = 1:size(events,2)
                [simParams(scenario_id), simDescs(scenario_id)] = setStateParameters(states(statenum));
                [simParams(scenario_id), simDescs(scenario_id)] = setEventParameters(events(eventnum), simParams(scenario_id), simDescs(scenario_id));
                scenario_id = scenario_id + 1;
            end            
        end
end
end