%==========================================================================
%Восстановление тока путем обратной задачи. При запуске функции "CurrentProcess"
%необходимо в аргумент функции задать исходный массив "current", который
%содержит массив времени и тока.
%==========================================================================
function [Reconstracted, BuffrNext, options] = TheMethod(CurrentSat, Buffer, options)
%     clc
    i_meas = [Buffer; CurrentSat]; %здание массива изм. тока
   
    %----------------------------------------------------------------------
    %Вызов функции "CTParam", которая объявляет параметры ТТ в виде
    %структуры.
    %----------------------------------------------------------------------
    CTParam = ctParam ();
    i_reconstr = i_meas;
   if options.SAT2 == 1
      %-------------------------------------------------------
      %вызов функции восстановления тока
      %-------------------------------------------------------
      [p, i_reconstr, options] = compensate (i_meas, i_reconstr, 40, 40,...
          CTParam, options);
      Reconstracted = i_reconstr(end-19:end);
      
      BuffrNext = i_reconstr(end-39:end);
      
%       figure
%       plot(n, i_reconstr,n,i_meas, n,i_ideal);  grid minor;
      
      %     plot(n, i_reconstr, n, i_meas); 
      return
    end

    Amplitude1 = 0;%Прогнозируемая амплитуда тока
   
    L = 16; %Необходимая длина окна для корректного расчета дисперсий индукции
    
    Th2 = 0.0028; %Порог насыщения.  
        
    nt = CTParam.w2 / CTParam.w1; %Коэффициент трансфорамции
    
    %----------------------------------------------------------------------
    %вызов функции расчета магнитной индукции бе учета начальной индукции
    %----------------------------------------------------------------------
    Flux = flux (i_meas, CTParam);
    
    
    p = 4; %Локальный счетчик
    for h2  = p:length (i_meas)
        
        %------------------------------------------------------------------
        %Вызов функции проверки режима сети
        %------------------------------------------------------------------
        [Amplitude1, Amplitude2] = Apm(p, Amplitude1, i_meas, CTParam);
        
        Th1 = CTParam.I_rated * sqrt(2) * 2 / nt; %Уставка маскимального режима 
        
        if Amplitude2 > Th1 && Amplitude1 > Th1 %Проверка тока КЗ
        
            options.SAT1 = 1;
            p = p + L; %Время задержки детектора
        
            %--------------------------------------------------------------
            %Блок проверки наличия насыщения ТТ, прогнозирования начла 
            %участка насыщения и восстановления тока
            %--------------------------------------------------------------
            for h3 = p:length(i_meas) 

                DENSITY_VAR = var (Flux(p-L:p)); %Дисперсия индукции 

%                 i_filter(p-L,1) = mean(NoisyCurrent(p-L-1:p-L));%Сглаживание тока 

                if DENSITY_VAR <= Th2 %условие возникновения насыщения

                   options.SAT2 = 1;
                   %---------------------------------------------------
                   %Функциz прогнозирования начала искаженного участка
                   %---------------------------------------------------
                   Prognoz = prognoz (p, L, i_meas, CTParam);

                   %---------------------------------------------------
                   %вызов функции поиска начальной индукции
                   %---------------------------------------------------
                   [options, h5, i_reconstr] = initial (options, p, L,...
                           i_meas, Prognoz, CTParam, i_reconstr); 
                   
                   %-------------------------------------------------------
                   %вызов функции восстановления тока
                   %-------------------------------------------------------
                   [p, i_reconstr, options] = compensate (i_meas,...
                       i_reconstr, h5, p, CTParam, options);
   
                end %if DENSITY_VAR

                p = p + 1; %обновление номера счетчика

                if options.SAT1 == 0 || p >= length(i_meas) %определение конца массива данных
                    Reconstracted = i_reconstr(end-19:end);
                    
                    BuffrNext = i_reconstr(end-39:end);

%                     figure
%                     plot(n, i_reconstr, n,i_meas, n,i_ideal);  grid minor;
%                         plot(n(21:60), i_reconstr, n, i_meas); 
                    return
                end
            end %for h3
        end %if amplitude
    
        p = p + 1;% обновление номера счетчика
        
        if p >= length(i_meas)%определение конца массива тока
            Reconstracted = i_meas(end-19:end);
            BuffrNext = i_meas(end-39:end);
%             figure
%             plot(n, i_reconstr, n,i_meas, n,i_ideal);  grid minor;
            %     plot(n, i_reconstr, n, i_meas); 
            return
        end
    end%h2      
end

%==========================================================================
%Функция возвращает параметры ТТ и сети
%==========================================================================
function CTParam = ctParam ()

    %s - поперечное сечение сердечника ТТ, м^2
    %l - средняя длина магнитной пути, м
    %w2 - число витков вторичной обмотки
    %w1 - число витков первичной обмотки
    %I_rated - номинальный ток ТТ, А
    %R2 - активное сопротивление вторичной обмотки, Ом
    %Rn - активное сопротивление нагрузки, Ом
    %L2 - индуктивность вторичной обмотки, Гн
    %Ln - индуктивность нагрузки, Гн 
    %N - плотность измерения, точек/период
    %dt - шаг дискретизации, с
    %t - интервал моделирования, с
    %om - циклическая часота, рад/с
    %b1, b2 - коэффициенты кривой намагничивания, которые получаются в
    %результате апроксимации этой кривой

    CTParam = struct('s', 19.1e-4, 'l', 90e-2, 'w2', 239, 'w1', 2, 'I_rated',...
        600, 'R2', 0.48, 'Rn', 0.96, 'L2', 0, 'Ln', 0, 'N', 80, 'dt',...
        2.5e-4, 'om', 100*pi, 'b2', 13.917, 'b1', 1.761e-08);
%     CTParam = struct('s', 19.1e-4, 'l', 90e-2, 'w2', 239, 'w1', 2, 'I_rated',...
%         600, 'R2', 0.48, 'Rn', 0.96, 'L2', 0, 'Ln', 0, 'N', 80, 'dt',...
%         2.5e-4, 'om', 100*pi, 'b1', 1248, 'b2', -8444, 'b3', 1.608e4,...
%         'b4', -1.347e4, 'b5', 5623, 'b6', -1154, 'b7', 93.78);
end

%==========================================================================
%Функция расчет магнитной индукции без учета начальной. На основе результата 
%этой функции рассчитывается дисперсия и детектируется насыщение.
%==========================================================================
function Flux = flux (i_meas, CTParam)
            
      Flux = zeros (length(i_meas),1);
       
      for h1 = 2:length(i_meas)
          Flux(h1) = Flux(h1-1) + ((CTParam.R2 + CTParam.Rn) * (i_meas(h1)...
              + i_meas(h1-1)) * CTParam.dt / 2 / (CTParam.s * CTParam.w2)...
              + (i_meas(h1) - i_meas(1)) * (CTParam.L2 + CTParam.Ln) /...
              (CTParam.s * CTParam.w2));
      end
%       plot(Flux);
end

%==========================================================================
%Функция проверка наличия КЗ в сети путем прогнозирования амплитуды
%измеренного тока.
%==========================================================================
function [Amplitude1, Amplitude2] = Apm(p, Amplitude1, i_meas, CTParam)
        %------------------------------------------------------------------
        % Проверка Режима Сети
        %------------------------------------------------------------------
        i0 = i_meas(p);%измеренный ток 
        
        v0 = (i_meas(p - 1) - i_meas(p + 1)) / 2 / CTParam.dt;%Производная от тока
        
        Amplitude = sqrt(i0^2 + (v0 / CTParam.om)^2);%Амплитуда тока
        
        Amplitude2 = Amplitude1;
        
        Amplitude1 = Amplitude;
end

%==========================================================================
%Функция прогнозирования начала учаска насыщения. На основе результата 
%этой функции производится посик начальной индукции.
%==========================================================================
function Prognoz = prognoz (p, K, i_filter, CTParam)

      Lack = 2;%этот параметр используется для точного определения 
      %насыщения, т.к. детектор сам точно не видет этот момент.
      ITP = 8; %этот параметр определяет длину массива интервала правильной трансформации
      tt = (p-K-ITP:p-K-Lack)'.* CTParam.dt;% с помощью этой строки индексация преобразуется в временной ряд
            
      A = [sin(100*pi * tt) cos(100*pi * tt)];
                        
      b = i_filter(p-K-ITP:p-K-Lack);
      
      z = A\b;
      
      M = (p-K+1:p-K+3)'; %первые три точки после момента насыщения
      Prognoz = z(1,1) * sin(CTParam.om * M.* CTParam.dt) + z(2,1) * cos(CTParam.om * M.* CTParam.dt);
end

%==========================================================================
%В этой части алгоритма решается задача поиска начальной индукции с помощью
%минимизации целевой функции.
%==========================================================================
function [options, h5, i_reconstr] = initial (options, p, K,...
                           i_meas,Prognoz, CTParam, i_reconstr)
        
        for h4 = 1:40
        
            %Задание начальной индукции
            options.Initial = 1.6 + (h4-1)*0.01; 
            
            %Определение знака начальной индукции
            if i_meas(p-K) < 0
               options.Initial = -1*options.Initial;
            end
            
            %Проверка точности намагничивающего Тока im0
            for h5 = p-K+1:p-K+3
                
                B (h5) = options.Initial + ((CTParam.R2 + CTParam.Rn) * ...
                    (i_meas(h5) + i_meas(h5-1)) * CTParam.dt / 2 /...
                    (CTParam.s * CTParam.w2) + (i_meas(h5) - i_meas(h5-1))*...
                    (CTParam.L2 + CTParam.Ln) / (CTParam.s * CTParam.w2));
                
                options.Initial = B (h5);
            end
            B1 = B (p-K+1:p-K+3)';
            %намагничивающий ток
            im0 = (CTParam.l * CTParam.b1 * sinh(CTParam.b2 * B1)) / CTParam.w2;
            
            %восстановленный по кривой намагничивания ток
            i_curve = i_meas(p-K+1:p-K+3) + im0;

%             plot(n, i_meas, 'r-', n, i_ideal, 'k-', n(p-K+1:p-K+3), Prognoz, 'o-', ...
%                 n(p-K+1:p-K+3), i_curve, '-x','linewidth',1.2); grid minor;
            
            %погрешность восстановленного с помощью кривой намаг-я тока
            resudal = abs(Prognoz - i_curve) ./ abs(Prognoz) .* 100;
            
            error = norm(resudal);
            
            if error < 10% && sum(abs(i_curve)) > sum(abs(Prognoz))
                i_reconstr (p-K+1:p-K+3,1) = i_curve;
                break
            end
        end%h4
end

%==========================================================================
%Функция восстановления тока на каждом полупериоде.
%==========================================================================
function [p, i_reconstr, options] = compensate (i_meas, i_reconstr, h5, p,...
                                    CTParam, options)
                   
    Compensated = zeros (length(i_meas),1);
    for h6 = h5+1:length(i_meas)
            Flux = options.Initial + ((CTParam.R2 + CTParam.Rn) * ...
                (i_meas(h6) + i_meas(h6-1)) * CTParam.dt/2/...
                 (CTParam.s * CTParam.w2) + (i_meas(h6) - i_meas(h6-1))*...
                 (CTParam.L2 + CTParam.Ln) / (CTParam.s * CTParam.w2));
             
            options.Initial = Flux;
            
            %Намагничивающий ток
            im0 = (CTParam.l * CTParam.b1 * sinh(CTParam.b2 * Flux)) / CTParam.w2; 
            
            Compensated(h6) = i_meas(h6) + im0; %Восстановление тока
            i_reconstr (h6,1) = Compensated(h6);%Замена неправильных измерений
%             plot(t, Compensated, t, i_ideal);
            if h6 > p
                p = p + 1; %Обновление счетчика
            end
            % Детекция Перехода Через Ноль По Восст-ному Току
            aa = sign(Compensated(h6-1)) + sign(Compensated(h6)); 
            if aa == 0
                i_reconstr(h6+1:end) = i_meas(h6+1:end);
%                 figure
%                 plot(1:length(i_reconstr),i_reconstr,1:length(i_reconstr),i_meas,1:length(i_reconstr),Compensated,'--'); grid minor;
%                 i_reconstr = [i_reconstr(1:h6); i_meas(h6+1:end)];
                
                options.SAT1 = 0;
                options.SAT2 = 0;
                options.Initial = 0;
               break
            elseif p >= length(i_meas)
                break
           end
    end
   
end

%==========================================================================
%Функция сниятия графиков и замена искаженных измеренний восстановленными
%==========================================================================
function Plot(n, i_reconstr, i_ideal, i_meas)
                   
    plot(n, i_reconstr, '--', n, i_ideal, '-', n, i_meas);
end