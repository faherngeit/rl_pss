function agentServerResponse = sendResultWrapper(result)
% state [4,F,t], F - phasor frequency = 50(60) Гц

config = jsonDataExtract("../general_config.json");
ACTION_SIZE = config.Python.actionSize;

jsonGlobalArray = [];
for i = 1 : size(result, 2)
    jsonInternalEpisodeArray = [];
    for j = 1 : size(result(i).A_state, 3)
        jsonObject.t = j;
        jsonObject.action = result(i).A_simOutData(1, 1:ACTION_SIZE, j);
        jsonObject.pureAction = result(i).A_simOutData(1, (ACTION_SIZE+1):(ACTION_SIZE*2) , j);
        jsonObject.reward = result(i).reward(j);
        jsonObject.state = result(i).A_state(:,:,j);

        jsonInternalEpisodeArray = [jsonInternalEpisodeArray jsonObject];
    end
    episode.data = jsonInternalEpisodeArray;
    jsonGlobalArray = [jsonGlobalArray episode];
end

% jsonText = jsonencode(jsonGlobalArray, PrettyPrint = true)
jsonText = jsonencode(jsonGlobalArray);
agentServerResponse = pyrunfile('send_result.py', "response", pyJsonText = jsonText);

end
