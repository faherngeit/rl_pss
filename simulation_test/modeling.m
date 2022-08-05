M1.CustomPSS1.Upper = 1;
M1.CustomPSS1.Lower = -1;
M1.CustomPSS1.init(1:7) = 3;

tic;
simOut = sim('power_PSS_modif.slx', 'SimulationMode', 'accelerator')
toc;