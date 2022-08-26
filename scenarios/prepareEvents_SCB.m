function events = prepareEvents_SCB(model, config)
% Инициализируется множество сценариев нормальных режимов.
% События в этих сценариях не успеют произойти до окончания сценария.
for i = 1:2
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
% Отключение/включение БСК в Район-1
events(1).A1_Br_SCB.Times = [dist_moment];
% Описание события
events(1).EventDescription = "Событие: \n" + ...
                             "Отключение БСК. Район 1. T_откл = " + dist_moment + " с \n";

% Отключение/включение БСК в Район-2
events(2).A2_Br_SCB.Times = [dist_moment];
% Описание события
events(2).EventDescription = "Событие: \n" + ...
                             "Отключение БСК. Район 2. T_откл = " + dist_moment + " с \n";

end