function [next_state] = sim_step(state, action, model)
arguments
    state
    action
    model string = 'simmodel'
end

in = Simulink.SimulationInput(model);
in = in.setInitialState(state);
t = (0:0.001:0.001);
ds = Simulink.SimulationData.Dataset;
ds = ds.setElement(1, timeseries(action * ones(size(t)),t));
in = in.setExternalInput(ds.getElement(1));
in = in.setModelParameter('SimulationMode', 'Normal');
% in = in.setModelParameter('SimulationMode', 'rapid', 'RapidAcceleratorUpToDateCheck', 'off');
out = sim(in);

next_state = out.xFinal;
