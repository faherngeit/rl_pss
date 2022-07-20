function [simParam, simDesc] = SetModelParams(fr, fa, fas, z, params, CTparams)
 [i_sim, t_switch] = SimCurrent(params.i_nom, fr, fa, fas, ...
     params.aper_time_const, params.count_pred, params.count_post);
 
 WinSamples = params.Nwindow * params.Nsmp_per_per;
 decimation = 1 / params.Ts / params.freq / params.Nsmp_per_per;
 st_id = round(t_switch * params.Nsmp_per_per * params.freq);
 en_id = st_id + WinSamples - 1;
 
 R = params.Znom * z * cos(params.phi);
 X = params.Znom * z * sin(params.phi);
 
 model = params.model;
%% Basic model params
 simParam = Simulink.SimulationInput(model);
 simParam = simParam.setModelParameter('StopTime',num2str(i_sim.Time(end)));
 simParam = simParam.setModelParameter('FixedStep',num2str(params.Ts));
 simParam = simParam.setBlockParameter([model, '/Iprim2space'], 'Decimation', num2str(decimation));
 simParam = simParam.setBlockParameter([model, '/Isec2space'], 'Decimation', num2str(decimation));
 simParam = simParam.setVariable('simin',i_sim);
 simParam = simParam.setBlockParameter([model, '/RL'], 'Resistance', num2str(R));
 simParam = simParam.setBlockParameter([model, '/RL'], 'Inductance', num2str(X  / (2 * params.freq * pi)));
 
 %% CT params
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'ALFA', num2str(CTparams(1)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'Ms', num2str(CTparams(2)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'k', num2str(CTparams(3)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'c', num2str(CTparams(4)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'BETA1', num2str(CTparams(5)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'a1', num2str(CTparams(6)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'a2', num2str(CTparams(7)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'a3', num2str(CTparams(8)));
 simParam = simParam.setBlockParameter([model, '/CTcore'], 'b', num2str(CTparams(9)));
 
 %% Description
 ct_struct = struct('alpha', CTparams(1), 'Ms', CTparams(2), 'k',  CTparams(3), ...
     'c', CTparams(4), 'beta', CTparams(5), 'a1',  CTparams(6), ...
     'a2',  CTparams(7), 'a3', CTparams(8), 'b',  CTparams(9));
 
 desc_ = struct('Fault_rate',fr, ...
     'Fault_angle', fa, ...
     'Fault_angle_shift', fas, ...
     'Aper_time', params.aper_time_const, ...
     'Nsample', params.Nsmp_per_per, ...
     'Window', params.Nwindow, ...
     'R',R, 'X', X, 'P', z, ...
     'st', st_id, 'en',en_id, 'CT', ct_struct);
 
 simDesc = desc_;