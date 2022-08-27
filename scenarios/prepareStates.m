function states = prepareStates(states_quantity, model, config)    
    
    state_id = 1; 

    % Инициализируется
    for statenum = 1:states_quantity
    
        disp(num2str(statenum()));

        % Случайные мощности нагрузок
        p_l1_a1  = normrnd(config.Matlab.Model.Area_1.LoadParameters.p__l1, ...
                           config.Matlab.Scenario_Generation.p__load_std_pu*config.Matlab.Model.Area_1.LoadParameters.p__l1);
        qi_l1_a1 = normrnd(config.Matlab.Model.Area_1.LoadParameters.qi_l1, ...
                           config.Matlab.Scenario_Generation.qi_load_std_pu*config.Matlab.Model.Area_1.LoadParameters.qi_l1);
        qc_l1_a1 = normrnd(config.Matlab.Model.Area_1.LoadParameters.qc_l1, ...
                           config.Matlab.Scenario_Generation.qc_load_std_pu*config.Matlab.Model.Area_1.LoadParameters.qc_l1);
        p_l1_a2  = normrnd(config.Matlab.Model.Area_2.LoadParameters.p__l1, ...
                           config.Matlab.Scenario_Generation.p__load_std_pu*config.Matlab.Model.Area_1.LoadParameters.p__l1);
        qi_l1_a2 = normrnd(config.Matlab.Model.Area_2.LoadParameters.qi_l1, ...
                           config.Matlab.Scenario_Generation.qi_load_std_pu*config.Matlab.Model.Area_1.LoadParameters.qi_l1);
        qc_l1_a2 = normrnd(config.Matlab.Model.Area_2.LoadParameters.qc_l1, ...
                           config.Matlab.Scenario_Generation.qc_load_std_pu*config.Matlab.Model.Area_1.LoadParameters.qc_l1);
        set_param([model, '/Area 1/Area1_MainLoad'],'ActivePower',     num2str(p_l1_a1));
        set_param([model, '/Area 1/Area1_MainLoad'],'InductivePower',  num2str(qi_l1_a1));
        set_param([model, '/Area 1/Area1_MainLoad'],'CapacitivePower', num2str(qc_l1_a1));
        set_param([model, '/Area 2/Area2_MainLoad'],'ActivePower',     num2str(p_l1_a2));
        set_param([model, '/Area 2/Area2_MainLoad'],'InductivePower',  num2str(qi_l1_a2));
        set_param([model, '/Area 2/Area2_MainLoad'],'CapacitivePower', num2str(qc_l1_a2));
        
        % Случайные мощности генерации
        p_g1_a1 = normrnd(config.Matlab.Model.Area_1.GensParameters.p_g1, ...
                          config.Matlab.Scenario_Generation.p__gens_std_pu*config.Matlab.Model.Area_1.GensParameters.p_g1);
        p_g2_a1 = normrnd(config.Matlab.Model.Area_1.GensParameters.p_g2, ...
                          config.Matlab.Scenario_Generation.p__gens_std_pu*config.Matlab.Model.Area_1.GensParameters.p_g2);
        p_g3_a2 = normrnd(config.Matlab.Model.Area_2.GensParameters.p_g1, ...
                          config.Matlab.Scenario_Generation.p__gens_std_pu*config.Matlab.Model.Area_1.GensParameters.p_g1);
        p_g4_a2 = normrnd(config.Matlab.Model.Area_2.GensParameters.p_g2, ...
                          config.Matlab.Scenario_Generation.p__gens_std_pu*config.Matlab.Model.Area_1.GensParameters.p_g2);
        set_param([model, '/Area 1/M1 900 MVA'],'Pref',     num2str(p_g1_a1));
        set_param([model, '/Area 1/M2 900 MVA'],'Pref',     num2str(p_g2_a1));
        set_param([model, '/Area 2/M3 900 MVA'],'Pref',     num2str(p_g3_a2));
        set_param([model, '/Area 2/M4 900 MVA'],'Pref',     num2str(p_g4_a2));
    
        % Случайные сопротивления
        temp_rnd  = unifrnd(config.Matlab.Scenario_Generation.min_line_temp, config.Matlab.Scenario_Generation.max_line_temp);
        r_km_rnd  = config.Matlab.Model.LineParameters.r1_km * (1.0 + 0.004 * (temp_rnd - 20));
        r_0km_rnd = normrnd(config.Matlab.Model.LineParameters.r0_km, ...
                            config.Matlab.Scenario_Generation.r0_line_std_pu*config.Matlab.Model.LineParameters.r0_km);
        l_km_rnd  = normrnd(config.Matlab.Model.LineParameters.l1_km, ...
                            config.Matlab.Scenario_Generation.l1_line_std_pu*config.Matlab.Model.LineParameters.l1_km);
        l_0km_rnd = normrnd(config.Matlab.Model.LineParameters.l0_km, ...
                            config.Matlab.Scenario_Generation.l0_line_std_pu*config.Matlab.Model.LineParameters.l0_km);
        c_km_rnd  = normrnd(config.Matlab.Model.LineParameters.c1_km, ...
                            config.Matlab.Scenario_Generation.c1_line_std_pu*config.Matlab.Model.LineParameters.c1_km);
        c_0km_rnd = normrnd(config.Matlab.Model.LineParameters.c0_km, ...
                            config.Matlab.Scenario_Generation.c0_line_std_pu*config.Matlab.Model.LineParameters.c0_km);
        set_param([model, '/Area 1/25km Area 1'],'Resistances',   "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Area 1/25km Area 1'],'Inductances',   "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Area 1/25km Area 1'],'Capacitances',  "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        set_param([model, '/Area 1/10 km Area 1'],'Resistances',  "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Area 1/10 km Area 1'],'Inductances',  "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Area 1/10 km Area 1'],'Capacitances', "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        set_param([model, '/Line 1a'],'Resistance',  "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Line 1a'],'Inductance',  "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Line 1a'],'Capacitance', "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        set_param([model, '/Line 1b'],'Resistance',  "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Line 1b'],'Inductance',  "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Line 1b'],'Capacitance', "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        set_param([model, '/Line 2'],'Resistance',  "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Line 2'],'Inductance',  "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Line 2'],'Capacitance', "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        set_param([model, '/Area 2/25km Area 2'],'Resistances',   "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Area 2/25km Area 2'],'Inductances',   "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Area 2/25km Area 2'],'Capacitances',  "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        set_param([model, '/Area 2/10 km Area 2'],'Resistances',  "[" + num2str([r_km_rnd, r_0km_rnd]) + "]");
        set_param([model, '/Area 2/10 km Area 2'],'Inductances',  "[" + num2str([l_km_rnd, l_0km_rnd]) + "]");
        set_param([model, '/Area 2/10 km Area 2'],'Capacitances', "[" + num2str([c_km_rnd, c_0km_rnd]) + "]");
        
        % Решается и инициализируется режим ,'report'
        power_loadflow(model,'solve');
       
        states(state_id).model = model;
        % Параметры генераторов
        % [dw(%), th(deg), ia,ib,ic(pu)  pha,phb,phc(deg)  Vf(pu)]
        states(state_id).M1_Pref     = get_param([model, '/Area 1/M1: Turbine & Regulators/STG'],'ini1');
        states(state_id).M1_Vf       = get_param([model, '/Area 1/M1: Turbine & Regulators/EXCITATION'],'v0');
        states(state_id).InitCond_M1 = get_param([model, '/Area 1/M1 900 MVA'],'InitialConditions');
        states(state_id).M2_Pref     = get_param([model, '/Area 1/M2: Turbine & Regulators/STG'],'ini1');
        states(state_id).M2_Vf       = get_param([model, '/Area 1/M2: Turbine & Regulators/EXCITATION'],'v0');
        states(state_id).InitCond_M2 = get_param([model, '/Area 1/M2 900 MVA'],'InitialConditions');
        states(state_id).M3_Pref     = get_param([model, '/Area 2/M3: Turbine & Regulators/STG'],'ini1');
        states(state_id).M3_Vf       = get_param([model, '/Area 2/M3: Turbine & Regulators/EXCITATION'],'v0');
        states(state_id).InitCond_M3 = get_param([model, '/Area 2/M3 900 MVA']','InitialConditions');
        states(state_id).M4_Pref     = get_param([model, '/Area 2/M4: Turbine & Regulators/STG'],'ini1');
        states(state_id).M4_Vf       = get_param([model, '/Area 2/M4: Turbine & Regulators/EXCITATION'],'v0');
        states(state_id).InitCond_M4 = get_param([model, '/Area 2/M4 900 MVA'],'InitialConditions');
        % Уровень нагрузки
        % [P(W), Q(W)]
        states(state_id).InitCond_L1_P  = get_param([model, '/Area 1/Area1_MainLoad'], 'ActivePower');
        states(state_id).InitCond_L1i_Q = get_param([model, '/Area 1/Area1_MainLoad'],'InductivePower');
        states(state_id).InitCond_L1c_Q = get_param([model, '/Area 1/Area1_MainLoad'],'CapacitivePower');
        states(state_id).InitCond_L2_P  = get_param([model, '/Area 2/Area2_MainLoad'], 'ActivePower');
        states(state_id).InitCond_L2i_Q = get_param([model, '/Area 2/Area2_MainLoad'],'InductivePower');
        states(state_id).InitCond_L2c_Q = get_param([model, '/Area 2/Area2_MainLoad'],'CapacitivePower');
        % Параметры ЛЭП
        states(state_id).R = get_param([model, '/Area 1/25km Area 1'],'Resistances');
        states(state_id).L = get_param([model, '/Area 1/25km Area 1'],'Inductances');
        states(state_id).C = get_param([model, '/Area 1/25km Area 1'],'Capacitances');

        state_id = state_id + 1;
    end
end