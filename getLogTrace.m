function RewardTable = getLogTrace(folder)
% Метод возвращает таблицу, в которую сведены по столбцам: 
% - номера сценариев 
% - награда для регулятора в отсутствие агента
% - награда с агентом.
% folder - пусть к папке (на конце \).

% Чтение всех файлов в указанном каталоге
files = dir(folder + "*.mat");

% Создаются пустые списки для сохранения значений наград и прочего
index	    = zeros(length(files), 1);
rew_noagent = zeros(length(files), 1);
rew_wiagent = zeros(length(files), 1);

% По всем файлам
for i=1:length(files)
    % Загружется файл по индексу i
    file = load(files(i).folder + "\" + files(i).name);
    % Записывается индекс результата
    index(i) = i;
    % Записывается награда без агента
    rew_noagent(i) = file.simLog.reward_0(size(file.simLog.reward_0, 1));
    % Записывается награда с агентом
    rew_wiagent(i) = file.simLog.reward_agent(size(file.simLog.reward_agent, 1));

end    

% Создаётся таблица с результатами анализа логов
RewardTable = table(index, rew_noagent, rew_wiagent);

end

