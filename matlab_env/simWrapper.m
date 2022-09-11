function serverResponse = simWrapper(scenarios_file, reward_type, penalty, exp_num, result_directory, errors_directory)
% Загрузка конфига в модель
configParamsToModel('power_PSS_modif');

% Выбор сценария, моделирование, расчет награды
result = getScenarioSimOutData(scenarios_file, exp_num, reward_type, penalty, result_directory, errors_directory);

% Запакова в JSON и отправка на сервер-агент
serverResponse = sendResultWrapper(result);

clear result;
end