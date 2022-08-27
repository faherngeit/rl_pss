function serverResponse = simWrapper(scenarios_file, reward_type, penalty)
% Выбор сценария, моделирование, расчет награды
result = getScenarioSimOutData(scenarios_file, reward_type, penalty);

% Запакова в JSON и отправка на сервер-агент
serverResponse = sendResultWrapper(result);
end