function [rtrn, next_state] = sim_step(state, action, model, step_size)
arguments
    state
    action
    model string = 'simmodel'
    step_size = 0.1
end

in = Simulink.SimulationInput(model);
in = in.setInitialState(state);
% t = (state.time:0.001:state.time + step_size);
% ds = Simulink.SimulationData.Dataset;
% ds = ds.setElement(1, timeseries(action * ones(size(t)),t));
% in = in.setExternalInput(ds.getElement(1));
in = in.setModelParameter('SimulationMode', 'Normal', 'StopTime', num2str(state.time + step_size));
in = in.setBlockParameter(model + '/K', 'Value', num2str(action));
% in = in.setModelParameter('SimulationMode', 'rapid', 'RapidAcceleratorUpToDateCheck', 'off');
out = sim(in);
rtrn = out.yout.signals.values(2);
next_state = out.xFinal;
