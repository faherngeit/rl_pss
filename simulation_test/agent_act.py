from agent import Agent
import requests

STATE_SIZE = 4
ACTION_SIZE = 5
DEFAULT_PATH = "matlab_sample.pth"
REST_MODE = True

if REST_MODE:
    data = [x for x in pystate]
    response = requests.post(
        "http://127.0.0.1:8001/predict/",
        json={"state": data},
    )
    res = response.json()
    action = res['action']
    pure_action = res['pure_action']
else:
    agent = Agent(state_dim=STATE_SIZE, action_dim=ACTION_SIZE)
    agent.load(DEFAULT_PATH)
    action, pure_action, distribution = agent.act(pystate)


# Due to transfer to matlab
    action = action.tolist()
    pure_action = pure_action.tolist()

action = [0.01 for x in range(ACTION_SIZE)]
pure_action = [0.01 for x in range(ACTION_SIZE)]

print(action)