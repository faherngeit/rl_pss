#!/usr/bin/env python3
from fastapi import FastAPI
import uvicorn
import json
import torch
import os
from pydantic import BaseModel
import json
from datetime import datetime
import time

from agent import Agent
from train import PPO
from utils import AgentDescription

CONFIG_PATH = "general_config.json"
STATE_SIZE = 4
ACTION_SIZE = 5

app = FastAPI()
agent = None
configuration = AgentDescription.from_file(CONFIG_PATH)


class StateEntity(BaseModel):
    state: list


class PredictionEntity(BaseModel):
    action: list
    pure_action: list
    log_prob: list

class ResultEntity(BaseModel):
    result: str

@app.on_event(event_type="startup")
def load_services():
    global agent
    # agent = Agent(state_dim=configuration.stateSize, action_dim=configuration.actionSize)
    # agent = Agent(state_dim=STATE_SIZE, action_dim=ACTION_SIZE)
    agent = PPO(state_dim=STATE_SIZE, action_dim=ACTION_SIZE)
    agent.perform()
    # agent.load("./" + configuration.agentPath + configuration.agentNamePrefix + "_last.pth")

@app.get("/")
def root():
    return("Hello! This is main page of RL PSS agent! \n For prediction, please, visit /predict")


@app.post(configuration.predictPostfix)
async def predict(request: StateEntity):
    start = time.time()
    data = [x[-1] for x in request.state]
    state = torch.tensor(data, dtype=torch.float32)
    action, pure_action, log_prob = agent.act(state)
    value = agent.get_value(state)
    end = time.time()
    log_prob_ls = [log_prob.tolist(), value, 0.0, 0.0, 0.0]
    log_prob_ls[1] = value
    log_msg = json.dumps({"time": datetime.now().isoformat(),
                          "duration": end - start,
                          "state": state.tolist(),
                          "action": action.tolist(),
                          "pure_action": pure_action.tolist(),
                          "log_prob": log_prob_ls}, indent=4)
    with open("state_log.txt", 'a') as f:
        f.write(log_msg + "\n")
    return PredictionEntity(action=action.tolist(), pure_action=pure_action.tolist(), log_prob=log_prob_ls)


@app.post(configuration.trainPostfix)
async def train(request: ResultEntity):
    result = request.result
    result = json.loads(result)
    with open("new_log.txt", 'w') as f:
        f.write(json.dumps({"time": datetime.now().isoformat(), "result": result}, indent=4))
    with open("trajectory_log.txt", 'w') as f:
        json.dump(result, f, indent=4)
    return("OK")


@app.get(configuration.reloadPostfix)
async def reload():
    agent.load("./" + configuration.agentPath + configuration.agentNamePrefix + "_last.pth")
    return("Reloaded")

if __name__ == "__main__":
    uvicorn.run("app:app", host=configuration.agentHost, port=os.getenv("PORT", configuration.agentPort))
#%%
