function learningScenarios = getRandomScenarios(scen_quantity, scenarios)
% Метод возвращает список случайно выбранных сценариев из общего массива 
% вариантов.
%   scen_quantity - количество сценариев в случайной выборке (не может быть
%                   больше, чем общее число сценариев scenarios.
%   scenarios     - общая выборка сценариев, из которых случайным образом 
%                   набирается обучающая выборка.

% Список индексов сценариев
scen_num = 1:size(scenarios,2);
learningScenarios(1) = scenarios(1);

% На случай, если число указанных пользователем сценариев, больше, чем
% имеющаяся выборка
if scen_quantity > size(scenarios,2)
    iternum = size(scenarios,2);
else 
    iternum = scen_quantity;
end

% До тех пор пока не наберется нужное число сценариев
for i = 1:iternum

    doom = randi(size(scen_num,2));
    learningScenarios(i) = scenarios(scen_num(doom));
    
    helper = scen_num(1:doom-1);
    % Отсекается последний элемент
    if size(helper,2) == (size(scen_num,2) - 1)
        scen_num = helper;
    % Отсвекается предпослений элемент
    elseif size(helper,2) == (size(scen_num,2) - 2)
        scen_num = [helper,scen_num(size(scen_num,2))];
    % Все остальное
    else 
        scen_num = [helper,scen_num(doom+1:size(scen_num,2))];
    end
end

end