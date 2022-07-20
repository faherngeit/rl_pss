function I = Saturate_Current(sim_current)
model = 'CT_tests';
Tsim = sim_current.Time(end);

simParam(1) = Simulink.SimulationInput(model);
simParam(1) = simParam(1).setModelParameter('StopTime',num2str(Tsim));
simParam(1) = simParam(1).setVariable('simin',sim_current);

simParam(2) = Simulink.SimulationInput(model);
simParam(2) = simParam(2).setModelParameter('StopTime',num2str(2 * Tsim));
simParam(2) = simParam(2).setVariable('simin',sim_current);
simout = parsim(simParam);
I = simout;
