function [action, pureAction, probability] = matAgentCall(state)
    [actionList, pureActionList, probabilityList] = pyrunfile('agent_act.py', ...
        ["action", "pure_action", "probability"], pystate = state);
    action = pyList_to_mArray(actionList);
    pureAction = pyList_to_mArray(pureActionList);
    probability = pyList_to_mArray(probabilityList);
end

