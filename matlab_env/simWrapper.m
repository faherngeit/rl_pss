function serverResponse = simWrapper(scenarios_file, reward_type, penalty, exp_num, result_directory, errors_directory)
% Выбор сценария, моделирование, расчет награды
result = getScenarioSimOutData(scenarios_file, exp_num, reward_type, penalty, result_directory, errors_directory);

% Запакова в JSON и отправка на сервер-агент
serverResponse = sendResultWrapper(result);
end