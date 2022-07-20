function [simParam, simDesc] = EstimSimParam(params)
% Gridsearch parameters
i_nom = params.i_nom;
aper_time_const = params.aper_time_const;
model = params.model;
Ts = params.Ts;
freq = params.freq;
Nsmp_per_per = params.Nsmp_per_per;
count_pred = params.count_pred;
count_post = params.count_post;
Nwindow = params.Nwindow;
decimation = 1 / Ts / freq / Nsmp_per_per;
WinSamples = Nwindow * Nsmp_per_per;

[Data{4}, Data{3}, Data{2}, Data{1}] = ndgrid(params.Load, params.fault_angle_shift, ...
    params.fault_angle, params.fault_rate);
% st_id = 1 + Nsmp_per_per * count_pred;

for i = 1:length(Data)
    Data{i} = reshape(Data{i},1,[]);
end

paramsset = [Data{1}]';
for i = 2:length(Data)
    paramsset = [paramsset, Data{i}'];
end

CTgrid = GetCTgrid(params.CT);

sim_id = 1;
% simParam = [];
% simDesc = [];
for exp = 1:size(paramsset,1)
    for ct_id = 1:size(CTgrid,1)
        fr = paramsset(exp,1);
        fa = paramsset(exp,2);
        fas = paramsset(exp,3);
        z = paramsset(exp,4);
        ct_param = CTgrid(ct_id,:);
        
        simParam(sim_id) = Simulink.SimulationInput(model);
        [smParam, smDesc] = SetModelParams(fr, fa, fas, z, params, ct_param);
        simParam(sim_id) = smParam;
        simDesc(sim_id) = smDesc;
        sim_id = sim_id + 1;
    end
end