function events = prepareEvents_2phSC_gen(model, config)
% Инициализируется множество сценариев нормальных режимов.
% События в этих сценариях не успеют произойти до окончания сценария.
for i = 1:4
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
t_breaking = round(config.Matlab.Scenario_Generation.sc_breaking_time_main,3);

% Описание события
events(1).EventDescription = "Событие: \n" + ...
                             "2фКЗ ф.АB на НН Г1. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на НН Г1
events(1).KZ_A1_G1_LV.Times  = [dist_moment, dist_moment + t_breaking];
events(1).KZ_A1_G1_LV.PhaseA = 'on';
events(1).KZ_A1_G1_LV.PhaseB = 'on';
events(1).KZ_A1_G1_LV.PhaseC = 'off';
events(1).KZ_A1_G1_LV.PhaseG = 'off';

% Описание события
events(2).EventDescription = "Событие: \n" + ...
                             "2фКЗ ф.АB на НН Г2. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на НН Г2
events(2).KZ_A1_G2_LV.Times  = [dist_moment, dist_moment + t_breaking];
events(2).KZ_A1_G2_LV.PhaseA = 'on';
events(2).KZ_A1_G2_LV.PhaseB = 'on';
events(2).KZ_A1_G2_LV.PhaseC = 'off';
events(2).KZ_A1_G2_LV.PhaseG = 'off';

% Описание события
events(3).EventDescription = "Событие: \n" + ...
                             "2фКЗ ф.АB на НН Г3. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на НН Г3
events(3).KZ_A2_G3_LV.Times  = [dist_moment, dist_moment + t_breaking];
events(3).KZ_A2_G3_LV.PhaseA = 'on';
events(3).KZ_A2_G3_LV.PhaseB = 'on';
events(3).KZ_A2_G3_LV.PhaseC = 'off';
events(3).KZ_A2_G3_LV.PhaseG = 'off';

% Описание события
events(4).EventDescription = "Событие: \n" + ...
                             "2фКЗ ф.АB на НН Г4. T_кз = " + dist_moment + " с, " + "T_откл = " + t_breaking + " с, \n";
% 2ф КЗ на НН Г4
events(4).KZ_A2_G4_LV.Times  = [dist_moment, dist_moment + t_breaking];
events(4).KZ_A2_G4_LV.PhaseA = 'on';
events(4).KZ_A2_G4_LV.PhaseB = 'on';
events(4).KZ_A2_G4_LV.PhaseC = 'off';
events(4).KZ_A2_G4_LV.PhaseG = 'off';

end