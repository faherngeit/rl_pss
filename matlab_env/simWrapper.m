function serverResponse = simWrapper(scenarios_file, reward_type, penalty, exp_num)
% Выбор сценария, моделирование, расчет награды
result = getScenarioSimOutData(scenarios_file, exp_num, reward_type, penalty);

% Запакова в JSON и отправка на сервер-агент
serverResponse = sendResultWrapper(result);
end