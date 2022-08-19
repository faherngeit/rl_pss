function pyOut = simWrapper(scenarios_file, reward_type, penalty)
 % Выбор сценария, моделирование, расчет награды
 out = getScenarioSimOutData(scenarios_file, reward_type, penalty)

 % Приведение к двумерному массиву для передачи в python без коллизий.
 %
 % Временное решение на время тестов (годится только для вызова 1 сценария),
 % позже нужно будет расширить, чтобы можно было передавать на обучение
 % результаты моделирования сразу нескольких сценариев.
 pyOut = [];
 for i = 1 : size(out, 3)
     pyOut = [pyOut; out(:,:,i)];
 end