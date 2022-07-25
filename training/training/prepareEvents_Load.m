function events = prepareEvents_Load()
% Инициализируется множество сценариев нормальных режимов.
% События в этих сценариях не успеют произойти до окончания сценария.
for i = 1:4
    events(i).model = 'power_KundurTwoAreaSystem_1';
    % [tF(s), tB(s)] [phA, phB, phC, ground]
    %
    events(i).KZ_A1_G1_LV.Times  = [200, 200.1];
    events(i).KZ_A1_G1_LV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A1_G2_LV.Times  = [200, 200.1];
    events(i).KZ_A1_G2_LV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A1_G1_HV.Times  = [200, 200.1];
    events(i).KZ_A1_G1_HV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A1_G2_HV.Times  = [200, 200.1];
    events(i).KZ_A1_G2_HV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A2_G3_LV.Times  = [200, 200.1];
    events(i).KZ_A2_G3_LV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A2_G4_LV.Times  = [200, 200.1];
    events(i).KZ_A2_G4_LV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A2_G3_HV.Times  = [200, 200.1];
    events(i).KZ_A2_G3_HV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_A2_G4_HV.Times  = [200, 200.1];
    events(i).KZ_A2_G4_HV.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_Lb.Times  = [200, 200.1];
    events(i).KZ_Lb.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_Lm.Times  = [200, 200.1];
    events(i).KZ_Lm.Phases = ['off', 'off', 'off', 'on'];
    %
    events(i).KZ_Le.Times  = [200, 200.1];
    events(i).KZ_Le.Phases = ['off', 'off', 'off', 'on'];

    % [tS(s), phA, phB, phC]
    %
    events(i).A1_Br_L.Times  = [200];
    events(i).A1_Br_L.Phases = ['on', 'on', 'on'];
    %
    events(i).A2_Br_L.Times  = [200];
    events(i).A2_Br_L.Phases = ['on', 'on', 'on'];
    %
    events(i).A1_Br_SCB.Times  = [200];
    events(i).A1_Br_SCB.Phases = ['on', 'on', 'on'];
    %
    events(i).A2_Br_SCB.Times  = [200];
    events(i).A2_Br_SCB.Phases = ['on', 'on', 'on'];
    %
    events(i).Br_Line_begin.Times  = [200];
    events(i).Br_Line_begin.Phases = ['on', 'on', 'on'];
    %
    events(i).Br_Line_end.Times  = [200];
    events(i).Br_Line_end.Phases = ['on', 'on', 'on'];

    % [P(W), Q(var)]
    events(i).Area1_AddLoad = [200, 1];
    events(i).Area2_AddLoad = [200, 1];
end

% Наброс нагрузки 10%. Район 1
% [tS(s), phA, phB, phC]
events(1).A1_Br_L.Times        = [5];
% [P(W), Q(var)]
events(1).Area1_AddLoad = [0.10e+08, 0.02e+08];

% Сброс нагрузки 10%. Район 1
% [tS(s), phA, phB, phC]
events(2).A1_Br_L.Times        = [5];
% [P(W), Q(var)]
events(2).Area1_AddLoad = [-0.10e+08, -0.02e+08];

% Наброс нагрузки 10%. Район 2
% [tS(s), phA, phB, phC]
events(3).A2_Br_L.Times        = [5];
% [P(W), Q(var)]
events(3).Area2_AddLoad = [0.10e+08, 0.02e+08];

% Сброс нагрузки 10%. Район 2
% [tS(s), phA, phB, phC]
events(4).A2_Br_L.Times        = [5];
% [P(W), Q(var)]
events(4).Area2_AddLoad = [-0.10e+08, -0.02e+08];

end