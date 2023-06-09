min = [scenarios(1).reward_0(1201), 1];
for i = 1 : size(scenarios, 2)
    rewardSize = size(scenarios(i).reward_0, 1);
    if (scenarios(i).reward_0(rewardSize) < min(1))
        min = [scenarios(i).reward_0(rewardSize), i];
    end
end

min(1)
min(2)
