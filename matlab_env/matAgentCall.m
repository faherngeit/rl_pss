function [action, pureAction, probability] = matAgentCall(state)
%     [actionList, pureActionList, probabilityList] = pyrunfile('agent_act.py', ...
%         ["action", "pure_action", "probability"], pystate = state);
%     action = pyList_to_mArray(actionList);
%     pureAction = pyList_to_mArray(pureActionList);
%     probability = pyList_to_mArray(probabilityList);

config = jsonDataExtract("../general_config.json");
link = ['http://', config.Python.agentHost,':', num2str(config.Python.agentPort), config.Python.predictPostfix];

request = matlab.net.http.RequestMessage('POST',[], jsonencode(struct('state',state)));
uri = matlab.net.URI(link);
r = send(request,uri);

action = r.Body.Data.action';
pureAction = r.Body.Data.pure_action';
probability = r.Body.Data.log_prob';

end

