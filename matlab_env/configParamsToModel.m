function configParamsToModel(model)
config = jsonDataExtract("../general_config.json");
load_system(model)

% Параметры подсистемы агента
set_param([model, '/RL-Agent on timestamp'], 'period', ...
    num2str(config.Matlab.Model.AgentModel.agentTs_num));
set_param([model, '/RL-Agent on timestamp'], 'Ns', ...
    num2str(config.Matlab.Model.AgentModel.agentTs_den));
set_param([model, '/RL-Agent on timestamp'], 'swi_threshlod', ...
    num2str(config.Matlab.Model.AgentModel.threshold));
set_param([model, '/RL-Agent on timestamp'], 'initPSSParams', ...
    "[" + num2str(config.Matlab.Model.AgentModel.initPSSParams') + "]");

% Параметры подсистемы custom PSS1
set_param([model, '/Area 1/M1: Turbine & Regulators/Custom PSS1'], 'limits', ...
    "[" + num2str([config.Matlab.Model.CustomPSS1.LowerLimit config.Matlab.Model.CustomPSS1.UpperLimit]) + "]");
set_param([model, '/Area 1/M1: Turbine & Regulators/Custom PSS1'], 'Ts', ...
    num2str(config.Matlab.Model.CustomPSS1.Ts));
set_param([model, '/Area 1/M1: Turbine & Regulators/Custom PSS1'], 'Tw', ...
    num2str(config.Matlab.Model.CustomPSS1.Tw));

save_system(model);
end

