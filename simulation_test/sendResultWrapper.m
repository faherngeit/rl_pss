function jsonText = sendResultWrapper(state, simOutData)
% state [4,F,t], F - phasor frequency = 50(60) Гц

ACTION_SIZE = 5;

jsonArray = [];
for i = 1 : size(state,3)
    jsonObject.t = i;
    jsonObject.action = simOutData(1, 1:ACTION_SIZE, i);
    jsonObject.pureAction = simOutData(1, (ACTION_SIZE+1):(ACTION_SIZE*2) , i);
    jsonObject.reward = simOutData(1, (ACTION_SIZE*2 + 1) , i);
    jsonObject.state = state(:,:,i);

    jsonArray = [jsonArray jsonObject];
end

% jsonText = jsonencode(jsonArray, PrettyPrint = true);
jsonText = jsonencode(jsonArray);
agentServerResponse = pyrunfile('send_result.py', "response", pyJsonText = jsonText);

end
