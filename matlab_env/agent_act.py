#!/usr/bin/env python3
import requests
import numpy as np

from utils import AgentDescription

def return_action(pystate):
    data = np.asarray(pystate, dtype='float').tolist()
    config = AgentDescription.default_config()
    response = requests.post(
        config.get_predict_url(),
        json={"state": data},
    )
    res = response.json()
    action = res['action']
    pure_action = res['pure_action']
    return action[:config.actionSize], pure_action[:config.actionSize]

action, pure_action = return_action(pystate)


# action = [0.01 for x in range(ACTION_SIZE)]
# pure_action = [0.01 for x in range(ACTION_SIZE)]
# probability = [0.01 for x in range(ACTION_SIZE)]

# print(action)