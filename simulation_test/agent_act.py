from agent import Agent

STATE_SIZE = 4
ACTION_SIZE = 7
DEFAULT_PATH = "matlab_sample.pth"

agent = Agent(state_dim=STATE_SIZE, action_dim=ACTION_SIZE)
# agent.load(DEFAULT_PATH)
action, pure_action, distribution = agent.act(pystate)

# Due to transfer to matlab
action = action.tolist()
pure_action = pure_action.tolist()

print(action)