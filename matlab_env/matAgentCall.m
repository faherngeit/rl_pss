function [action, pureAction, probability, receivedID] = matAgentCall(state, ID)
%     [actionList, pureActionList, probabilityList, receivedID_pyInt] = pyrunfile('agent_act.py', ...
%         ["action", "pure_action", "probability", "received_ID"], pystate = state, pyID = ID);
%     action = pyList_to_mArray(actionList);
%     pureAction = pyList_to_mArray(pureActionList);
%     probability = pyList_to_mArray(probabilityList);
%     receivedID = double(receivedID_pyInt);
    

config = jsonDataExtract("../general_config.json");
link = ['http://', config.Python.agentHost,':', num2str(config.Python.agentPort), config.Python.predictPostfix];

request = matlab.net.http.RequestMessage('POST',[], matlab.net.http.io.JSONProvider(struct('state',state, 'ID', ID)));
uri = matlab.net.URI(link);
r = send(request,uri);

action = r.Body.Data.action';
pureAction = r.Body.Data.pure_action';
probability = r.Body.Data.log_prob';
receivedID = r.Body.Data.rID;

end

