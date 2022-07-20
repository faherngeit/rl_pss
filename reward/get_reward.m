function [reward, reward_list] = get_reward(reward_type, time_gain, penalty, time_step, simStopTime, inertia_consts, delta_matrix, w_matrix)
    % Метод расчета награды по относительным углам и скоростям генераторов системы.
    % Ввод:
    %   reward_type - вид награды:
    %       'IntMaxDeltaD'  - Интеграл максимальной по модулю разницы углов между 
    %                         генераторами
    %       'IntMaxDeltaWs' - Интеграл максимальной по модулю разницы между скоростями
    %                         скоростями генератора и центра масс системы
    %       'IntSW'         - Интеграл СКО скоростей генераторов
    %       'IntKappa'      - Интеграл показателя динамической учтойчивости системы Каппа: 
    %                         сумма произведений относительных углов генераторов на
    %                         разницу между их скоростью и скоростью центра
    %                         масс системы.
    %       'IntGamma'      - Интеграл показателя динамической учтойчивости системы Гамма: 
    %                         сумма произведений скоростей генераторов на разницу 
    %                         между их относительным углом и относительным углом центра
    %                         масс системы.
    %   time_gain - [true false] домножать или нет функцию награды на время
    %               расчета при интегрировании? Предполагается, что добавление
    %               множителя обеспечивает больший вклад в итоговый штраф от
    %               малых колебаний на большем удалении от момента возмущения в
    %               сети: чем дольше длятся колебания, тем сильнее возрастет
    %               штраф (может и сработает).
    %   time_step - Шаг времени расчета в модели Simulink.
    %   simStopTime    - Продолжительность моделирования процесса в модели.
    %   inertia_consts - вектор постоянных инерации генераторов системы,
    %                    необходимый для расчета скорости и отноистельного угла
    %                    центра масс.
    %   delta_matrix   - матрица углов генераторов из workspace по результатам
    %                    моделирования. Столбец соответствует генератору
    %                    системы (в будущем - точке измерения).
    %   w_matrix       - матрица углов генераторов из workspace по результатам
    %                    моделирования. Столбец соответствует генератору
    %                    системы (в будущем - точке измерения).
    %   w_matrix       - матрица углов генераторов из workspace по результатам
    %                    моделирования. Столбец соответствует генератору
    %                    системы (в будущем - точке измерения).
    %   penalty        - штраф за нарушение устойчиовтси или остановку расчета
    %                    из-за ошибки
    %

    % Инициализируется переменная награды и список её значения по
    % моментам времени
    reward = 0;
    reward_list = eye(size(w_matrix,1)-1,1);
    % Массив возможных комбинаций генераторов для расчета максимальной
    % разницы углов.
    combos = nchoosek(1:size(w_matrix,2), 2);

    % Для всех моментов времени в матрице скоростей генераторов
    for t = 2:(size(w_matrix,1))
        rew = 0;

        % В зависимости от выбранного вида награды
        switch reward_type

            % Максимальная разница углов
            case 'IntMaxDeltaD'
                delta_delta = eye(size(combos,1),1);
                % По комбинациям генераторов
                for combnum = 1:(size(combos,1))
                    % Расчет модуля наибольшей разницы углов роторов
                    % генераторов в системе
                    delta_delta(combnum) = abs(delta_matrix(t,combos(combnum,1))-...
                                               delta_matrix(t,combos(combnum,2)));             
                end
                rew = max(delta_delta);      

            % Максимальная разница скорости генератора и центра масс
            case 'IntMaxDeltaWs'
                % Скорость центра масс
                ds = 0;
                ms = 0;

                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    ds = ds + inertia_consts(1,gennum) * w_matrix(t, gennum);
                    ms = ms + inertia_consts(1,gennum);
                end
                % Скорость центра масс, как средневзвешенная скорость по
                % постоянным инцерции генераторов
                ds = ds/ms;
                
                delta_w = eye(size(w_matrix,2),1);
                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    delta_w(gennum) = abs(w_matrix(t, gennum) - ds);
                end

                rew = max(delta_w);

            % СКО скоростей
            case 'IntSW'
                m_w = 0;
                s_w = 0;
                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    m_w = m_w + w_matrix(t, gennum);             
                end
                % Рассчитывается среднее значение скорости.
                m_w = m_w / gennum;
                
                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    s_w = s_w + (w_matrix(t, gennum) - m_w)^2;                    
                end
                % Рассчитывается СКО скорости.
                s_w = sqrt(s_w/gennum);

                rew = s_w;

            case 'IntKappa'
                % Скорость центра масс
                ws = 0;
                ms = 0;

                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    ws = ws + inertia_consts(1,gennum) * w_matrix(t, gennum);
                    ms = ms + inertia_consts(1,gennum);
                end
                % Скорость центра масс, как средневзвешенная скорость по
                % постоянным инцерции генераторов
                ws = ws/ms;
                
                kappa = 0;
                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    kappa = kappa + delta_matrix(t, gennum) * (w_matrix(t, gennum) - ws);
                end

                rew = abs(kappa);

            case 'IntGamma'
                % Угол центра масс
                ds = 0;
                ms = 0;

                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    ds = ds + inertia_consts(1,gennum) * delta_matrix(t, gennum);
                    ms = ms + inertia_consts(1,gennum);
                end
                % Скорость центра масс, как средневзвешенная скорость по
                % постоянным инцерции генераторов
                ds = ds/ms;
                
                gamma = 0;
                % Для всех генераторов в момент времени t
                for gennum = 1:(size(w_matrix,2))
                    gamma = gamma + w_matrix(t, gennum) * (delta_matrix(t, gennum) - ds);
                end

                rew = abs(gamma);
        end

        % Обновление значения награды
        % Если сказано использовать множитель времени при расчете
        % награды, то
        if time_gain
            reward = reward - rew * (t * time_step) * time_step;                   
        else
            reward = reward - rew * time_step;
        end
        % Текущее значения награды вносится в список
        reward_list(t-1) = reward;
    end

    % Если расчет прервался из-за нарушения устойчивости, то
    % прибавляется заданный пользователем штраф.
    if size(reward_list,1) < simStopTime / time_step
        % Сразу добавляется штраф заданный в начале расчета, для всех таких
        % случаев.
        reward = reward - penalty;       
        % (не реализовано) линейная экстраполяция траектории награды 
%         r1 = reward_list(1);
%         r2 = reward_list(size(reward_list,1));     
%         t1 = 0;
%         t2 = time_step * (size(reward_list,1));
%         k = (r2-r1) / (t2-t1);
%         a = r1 - k * t1;
%         
%         t = size(reward_list,1) + 1;
%         while size(reward_list,1) < simStopTime / time_step
%             
%             reward = k * time_step * t + a; 
%             % Текущее значения награды вносится в список
%             reward_list(t) = reward;
%             t = t + 1;
%         end
    end
end

%simOut = sim("power_KundurTwoAreaSystem.slx");
%
% 
%load_system("power_KundurTwoAreaSystem.slx");
% Экспорт характеристик генераторов
% Для расчета скорости центра масс системы требуются постоянные инерации
% генераторов.
%Mech1_1 = str2num(get_param('power_KundurTwoAreaSystem/Area 1/M1 900 MVA','Mechanical'));
%Mech2_1 = str2num(get_param('power_KundurTwoAreaSystem/Area 1/M2 900 MVA','Mechanical'));
%Mech3_2 = str2num(get_param('power_KundurTwoAreaSystem/Area 2/M3 900 MVA','Mechanical'));
%Mech4_2 = str2num(get_param('power_KundurTwoAreaSystem/Area 2/M4 900 MVA','Mechanical'));
%inertia_consts = [Mech1_1(1) Mech2_1(1) Mech3_2(1) Mech4_2(1)];
%[reward, reward_list] = get_reward1('IntGamma', false, Ts, inertia_consts, D, W);