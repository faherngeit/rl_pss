function [action, pureAction] = matAgentCall(state)
    [actionList, pureActionList] = pyrunfile('agent_act.py', ...
        ["action", "pure_action"], pystate = state);
    action = pyList_to_mArray(actionList);
    pureAction = pyList_to_mArray(pureActionList);
end

