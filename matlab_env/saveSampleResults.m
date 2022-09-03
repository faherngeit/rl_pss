function simLog = saveSampleResults(scenario,results,simoutputs,reward_type,results_directory,postfix)

% Выходной файл содержит все данные сценария
simLog = scenario;
% Записываются результаты моделирования с агентом
simLog.simOut_agent = simoutputs;
% Вычисляется и записывается награда 
simLog.reward_agent = get_reward(simoutputs, true, reward_type);
% Записывается информция о работе агента (пусть будет): state, actions, reward
simLog.result_agent = results;

if(results_directory ~= "")
    % Сохранение файла результатов с меткой времени
    save(results_directory + "simLog " + replace(datestr(datetime(now,'ConvertFrom','datenum')),':','-') + postfix + ".mat","simLog");
end

end