function events = prepareEvents_2phSCg_AB_line(model, config, rp_type)
% Инициализируется множество сценариев нормальных режимов.
% События в этих сценариях не успеют произойти до окончания сценария.
for i = 1:7
    events(i).model = model;
    % [tF(s), tB(s)] [phA, phB, phC, ground]
    %
    events(i).KZ_A1_G1_LV.Times  = [200];
    events(i).KZ_A1_G1_LV.PhaseA = 'off';
    events(i).KZ_A1_G1_LV.PhaseB = 'off';
    events(i).KZ_A1_G1_LV.PhaseC = 'off';
    events(i).KZ_A1_G1_LV.PhaseG = 'on';
    %
    events(i).KZ_A1_G2_LV.Times  = [200];
    events(i).KZ_A1_G2_LV.PhaseA = 'off';
    events(i).KZ_A1_G2_LV.PhaseB = 'off';
    events(i).KZ_A1_G2_LV.PhaseC = 'off';
    events(i).KZ_A1_G2_LV.PhaseG = 'on';
    %
    events(i).KZ_A1_G1_HV.Times  = [200];
    events(i).KZ_A1_G1_HV.PhaseA = 'off';
    events(i).KZ_A1_G1_HV.PhaseB = 'off';
    events(i).KZ_A1_G1_HV.PhaseC = 'off';
    events(i).KZ_A1_G1_HV.PhaseG = 'on';
    %
    events(i).KZ_A1_G2_HV.Times  = [200];
    events(i).KZ_A1_G2_HV.PhaseA = 'off';
    events(i).KZ_A1_G2_HV.PhaseB = 'off';
    events(i).KZ_A1_G2_HV.PhaseC = 'off';
    events(i).KZ_A1_G2_HV.PhaseG = 'on';
    %
    events(i).KZ_A2_G3_LV.Times  = [200];
    events(i).KZ_A2_G3_LV.PhaseA = 'off';
    events(i).KZ_A2_G3_LV.PhaseB = 'off';
    events(i).KZ_A2_G3_LV.PhaseC = 'off';
    events(i).KZ_A2_G3_LV.PhaseG = 'on';
    %
    events(i).KZ_A2_G4_LV.Times  = [200];
    events(i).KZ_A2_G4_LV.PhaseA = 'off';
    events(i).KZ_A2_G4_LV.PhaseB = 'off';
    events(i).KZ_A2_G4_LV.PhaseC = 'off';
    events(i).KZ_A2_G4_LV.PhaseG = 'on';
    %
    events(i).KZ_A2_G3_HV.Times  = [200];
    events(i).KZ_A2_G3_HV.PhaseA = 'off';
    events(i).KZ_A2_G3_HV.PhaseB = 'off';
    events(i).KZ_A2_G3_HV.PhaseC = 'off';
    events(i).KZ_A2_G3_HV.PhaseG = 'on';
    %
    events(i).KZ_A2_G4_HV.Times  = [200];
    events(i).KZ_A2_G4_HV.PhaseA = 'off';
    events(i).KZ_A2_G4_HV.PhaseB = 'off';
    events(i).KZ_A2_G4_HV.PhaseC = 'off';
    events(i).KZ_A2_G4_HV.PhaseG = 'on';
    %
    events(i).KZ_Lb.Times  = [200];
    events(i).KZ_Lb.PhaseA = 'off';
    events(i).KZ_Lb.PhaseB = 'off';
    events(i).KZ_Lb.PhaseC = 'off';
    events(i).KZ_Lb.PhaseG = 'on';
    %
    events(i).KZ_Lm.Times  = [200];
    events(i).KZ_Lm.PhaseA = 'off';
    events(i).KZ_Lm.PhaseB = 'off';
    events(i).KZ_Lm.PhaseC = 'off';
    events(i).KZ_Lm.PhaseG = 'on';
    %
    events(i).KZ_Le.Times  = [200];
    events(i).KZ_Le.PhaseA = 'off';
    events(i).KZ_Le.PhaseB = 'off';
    events(i).KZ_Le.PhaseC = 'off';
    events(i).KZ_Le.PhaseG = 'on';

    % [tS(s), phA, phB, phC]
    %
    events(i).A1_Br_L.Times  = [200];
    events(i).A1_Br_L.PhaseA = 'on';
    events(i).A1_Br_L.PhaseB = 'on';
    events(i).A1_Br_L.PhaseC = 'on';
    %
    events(i).A2_Br_L.Times  = [200];
    events(i).A2_Br_L.PhaseA = 'on';
    events(i).A2_Br_L.PhaseB = 'on';
    events(i).A2_Br_L.PhaseC = 'on';
    %
    events(i).A1_Br_SCB.Times  = [200];
    events(i).A1_Br_SCB.PhaseA = 'on';
    events(i).A1_Br_SCB.PhaseB = 'on';
    events(i).A1_Br_SCB.PhaseC = 'on';
    %
    events(i).A2_Br_SCB.Times  = [200];
    events(i).A2_Br_SCB.PhaseA = 'on';
    events(i).A2_Br_SCB.PhaseB = 'on';
    events(i).A2_Br_SCB.PhaseC = 'on';
    %
    events(i).Br_Line_begin.Times  = [200];
    events(i).Br_Line_begin.PhaseA = 'on';
    events(i).Br_Line_begin.PhaseB = 'on';
    events(i).Br_Line_begin.PhaseC = 'on';
    %
    events(i).Br_Line_end.Times  = [200];
    events(i).Br_Line_end.PhaseA = 'on';
    events(i).Br_Line_end.PhaseB = 'on';
    events(i).Br_Line_end.PhaseC = 'on';

    % [P(W), Q(var)]
    events(i).Area1_AddLoad = [200, 1];
    events(i).Area2_AddLoad = [200, 1];
end

% Момент возмущения
dist_moment = round(config.Matlab.Scenario_Generation.disturb_tmin,3);

% Для основной защиты
if rp_type == 1
    t_breaking = round(config.Matlab.Scenario_Generation.sc_breaking_time_main,3);
% Для резервной защиты
else
    t_breaking = round(config.Matlab.Scenario_Generation.sc_breaking_time_rsrv,3);
end  

% Описание события
events(1).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB на ВН Г1. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на ВН Г1
events(1).KZ_A1_G1_HV.Times  = [dist_moment, dist_moment + t_breaking];
events(1).KZ_A1_G1_HV.PhaseA = 'on';
events(1).KZ_A1_G1_HV.PhaseB = 'on';
events(1).KZ_A1_G1_HV.PhaseC = 'off';
events(1).KZ_A1_G1_HV.PhaseG = 'on';

% Описание события
events(2).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB на ВН Г2. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на ВН Г2
events(2).KZ_A1_G2_HV.Times  = [dist_moment, dist_moment + t_breaking];
events(2).KZ_A1_G2_HV.PhaseA = 'on';
events(2).KZ_A1_G2_HV.PhaseB = 'on';
events(2).KZ_A1_G2_HV.PhaseC = 'off';
events(2).KZ_A1_G2_HV.PhaseG = 'on';

% Описание события
events(3).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB на ВН Г3. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на ВН Г3
events(3).KZ_A2_G3_HV.Times  = [dist_moment, dist_moment + t_breaking];
events(3).KZ_A2_G3_HV.PhaseA = 'on';
events(3).KZ_A2_G3_HV.PhaseB = 'on';
events(3).KZ_A2_G3_HV.PhaseC = 'off';
events(3).KZ_A2_G3_HV.PhaseG = 'on';

% Описание события
events(4).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB на ВН Г4. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на ВН Г4
events(4).KZ_A2_G4_HV.Times  = [dist_moment, dist_moment + t_breaking];
events(4).KZ_A2_G4_HV.PhaseA = 'on';
events(4).KZ_A2_G4_HV.PhaseB = 'on';
events(4).KZ_A2_G4_HV.PhaseC = 'off';
events(4).KZ_A2_G4_HV.PhaseG = 'on';

% Описание события
events(5).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB в начале ВЛ-1. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ в начале ВЛ1
events(5).KZ_Lb.Times  = [dist_moment, dist_moment + t_breaking];
events(5).KZ_Lb.PhaseA = 'on';
events(5).KZ_Lb.PhaseB = 'on';
events(5).KZ_Lb.PhaseC = 'off';
events(5).KZ_Lb.PhaseG = 'on';
events(5).Br_Line_begin.Times  = [dist_moment + t_breaking];
events(5).Br_Line_begin.PhaseA = 'on';
events(5).Br_Line_begin.PhaseB = 'on';
events(5).Br_Line_begin.PhaseC = 'on';
events(5).Br_Line_end.Times    = [dist_moment + t_breaking];
events(5).Br_Line_end.PhaseA = 'on';
events(5).Br_Line_end.PhaseB = 'on';
events(5).Br_Line_end.PhaseC = 'on';

% Описание события
events(6).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB в середине ВЛ-1. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ в середине ВЛ1
events(6).KZ_Lm.Times  = [dist_moment, dist_moment + t_breaking];
events(6).KZ_Lm.PhaseA = 'on';
events(6).KZ_Lm.PhaseB = 'on';
events(6).KZ_Lm.PhaseC = 'off';
events(6).KZ_Lm.PhaseG = 'on';
events(6).Br_Line_begin.Times  = [dist_moment + t_breaking];
events(6).Br_Line_begin.PhaseA = 'on';
events(6).Br_Line_begin.PhaseB = 'on';
events(6).Br_Line_begin.PhaseC = 'on';
events(6).Br_Line_end.Times    = [dist_moment + t_breaking];
events(6).Br_Line_end.PhaseA = 'on';
events(6).Br_Line_end.PhaseB = 'on';
events(6).Br_Line_end.PhaseC = 'on';

% Описание события
events(7).EventDescription = "Событие: \n" + ...
                             "2фКЗ на землю ф.АB в конце ВЛ-1. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ в конце ВЛ1
events(7).KZ_Le.Times  = [dist_moment, dist_moment + t_breaking];
events(7).KZ_Le.PhaseA = 'on';
events(7).KZ_Le.PhaseB = 'on';
events(7).KZ_Le.PhaseC = 'off';
events(7).KZ_Le.PhaseG = 'on';
events(7).Br_Line_begin.Times  = [dist_moment + t_breaking];
events(7).Br_Line_begin.PhaseA = 'on';
events(7).Br_Line_begin.PhaseB = 'on';
events(7).Br_Line_begin.PhaseC = 'on';
events(7).Br_Line_end.Times    = [dist_moment + t_breaking];
events(7).Br_Line_end.PhaseA = 'on';
events(7).Br_Line_end.PhaseB = 'on';
events(7).Br_Line_end.PhaseC = 'on';

end