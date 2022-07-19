function [action, pureAction] = matAgentCall(state)
    [actionList, pureActionList] = pyrunfile('call_rand.py', ...
        ["action", "pureAction"], pyState = state);
    action = pyList_to_mArray(actionList);
    pureAction = pyList_to_mArray(pureActionList);
end

