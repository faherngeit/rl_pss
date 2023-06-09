tic
% scenarios_1 = scenarios(2001:2500);
scenarios_1 = scenarios(50:250)
for i = 1 : size(scenarios_1, 2)
    simOut_PSS1A = sim(scenarios_1(i).SimInput);
    reward_PSS1A = get_reward(simOut_PSS1A, false, 'IntMaxDeltaWs');

%     disp(['Scen: ', num2str(i), ...
%         ' Old reward: ', num2str(scenarios_1(i).reward_0(1201)), ...
%         ' New reward: ', num2str(reward_PSS1A(1201))]);
    if (size(reward_PSS1A, 1) < 1201)
        reward_PSS1A(size(reward_PSS1A, 1)) = reward_PSS1A(size(reward_PSS1A, 1)) - 1000;
    end

    disp(['Scen: ', num2str(i), ...
        ' New reward: ', num2str(reward_PSS1A(size(reward_PSS1A, 1)))]);

    scenarios_1(i).reward_0 = reward_PSS1A;
end
toc

save('scenarios_2phSC_190-250n_NR.mat', 'scenarios_1');