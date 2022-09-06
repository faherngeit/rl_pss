function agentServerResponse = sendResultWrapper(result)
% state [4,F,t], F - phasor frequency = 50(60) Гц

config = jsonDataExtract("../general_config.json");
link = ['http://', config.Python.agentHost,':', num2str(config.Python.agentPort), config.Python.trainPostfix];
ACTION_SIZE = config.Python.actionSize;

jsonGlobalArray = {};
for i = 1 : size(result, 2)
    jsonInternalEpisodeArray = [];
    for j = 1 : size(result(i).A_state, 3)
        jsonObject.t = j;
        jsonObject.action = result(i).A_simOutData(1, 1:ACTION_SIZE, j);
        jsonObject.pureAction  = result(i).A_simOutData(1, (ACTION_SIZE+1):(ACTION_SIZE*2) , j);
        jsonObject.probability = result(i).A_simOutData(1, (ACTION_SIZE*2 + 1):(ACTION_SIZE*3) , j);
        jsonObject.reward = result(i).Reward(j);
        jsonObject.reward_noAgent = result(i).Reward_noAgent(j);
        jsonObject.state = result(i).A_state(:,:,j);

        jsonInternalEpisodeArray = [jsonInternalEpisodeArray jsonObject];
    end
    episode.ID = result(i).A_ID;
    episode.data = jsonInternalEpisodeArray;
    jsonGlobalArray = [jsonGlobalArray episode];
end

% jsonText = jsonencode(jsonGlobalArray, PrettyPrint = true)
jsonText = jsonencode(jsonGlobalArray);

request = matlab.net.http.RequestMessage('POST',[], matlab.net.http.io.JSONProvider(struct('result',jsonText)));
uri = matlab.net.URI(link);
agentServerResponse = send(request,uri);

% agentServerResponse = pyrunfile('send_result.py', "response", pyJsonText = jsonText);
end
