function [result, simLog] = getScenarioSimOutData(scenarios_file, scen_quan, reward_type, ...
                                                  penalty, results_directory, errors_directory)
% Функция выполняет загрузку пула сценариев, выбор случайного,
% моделирование процесса, расчета награды и возвращает 3-хмерный массив для
% 
% обучения с добавлением рассчитанной награды.
%   scenarios_file   - пусть к файлу пула сценариев, хранящему
%                      сгенерированные заранее объекты SimulationInput
%   scen_quan        - число рассматриваемых сценариев.
%   reward_type      - тип рассчитываемой награды 
%                      ('IntMaxDeltaWs')
%   penalty          - штраф за нарушение устойчивости
%   result_directory - директория сохранения результатов. Если указано "",
%                      то файлы не сохраняются.

% Флаг нужен для проверки того, что хотя бы один сценарий был рассчитан
% успешно
flag = true;
% загрузка файла сценариев
scens = load(scenarios_file);

% В теории может быть такое, что все расчеты выдадут ошибку.
% В таком случае будут отобраны новые случаные сценарии и расчет будет
% выоплняться до тех пор, пока не будет получен хотя бы 1 успешный вариант.
while(flag)
    % из пула выбирается n случайных сценариев
    scenarios = getRandomScenarios(scen_quan, scens.scenarios);
    
    for scennum = size(scenarios, 2):-1:1
        simInputs(scennum) = scenarios(scennum).SimInput;
    end
    
    % Выполняется моделирование
    simoutputs = sim(simInputs);
    
    % Отбор и сохранение всех результатов с ошибкой
    er_indexes = [];
    for scennum = size(simoutputs, 2):-1:1
        if (simoutputs(scennum).ErrorMessage ~= "")
            % Пусть напишет, что случилось сразу.
            disp(simoutputs(scennum).ErrorMessage);
         
            % Сохраняем файл разультатов моделирования в отдельную папку
            simOut.Out  = simoutputs(scennum);
            simOut.Scen = scenarios(scennum);
            name = "errorOutput " + replace(datestr(datetime(now,'ConvertFrom','datenum')),':','-') +  "_" +num2str(scennum) + ".mat";
            save_path = [convertStringsToChars(errors_directory), filesep, convertStringsToChars(name)];
            save(save_path, "simOut");
            er_indexes = [er_indexes; scennum];
        end
    end

    if size(er_indexes, 1) == size(simoutputs, 2)
        
        continue;
    else
        flag = false;
    end
end

% Удаление результатов и сценариев, в которых при моделировании произошли ошибки
for vic = 1:size(er_indexes, 1)
    simoutputs(er_indexes(vic)) = [];
    scenarios(er_indexes(vic)) = [];
end

% Массив объектов результатов моделирования:
% result_.A_simOutData
% result_.A_state
% result_.Reward
result = handleParsimResults(simoutputs, reward_type, penalty, scenarios);

% Запись результатов испытаний в файлы
for scennum = size(scenarios, 2):-1:1  
    simLog(scennum) = saveSampleResults(scenarios(scennum), result(scennum), ...
                                        simoutputs(scennum), reward_type, results_directory, "_" + num2str(scennum));
end

clear scens;
clear scenarios;
clear simInputs;
clear simOutputs;

end