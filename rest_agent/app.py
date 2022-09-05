#!/usr/bin/env python3
from fastapi import FastAPI
import uvicorn
import json
import torch
import os
from os import path
from pydantic import BaseModel
import json
from datetime import datetime
import time


from train import PPO
from utils import AgentDescription

CONFIG_PATH = "general_config.json"
STATE_SIZE = 4
ACTION_SIZE = 5

app = FastAPI()
configuration = AgentDescription.from_file(CONFIG_PATH)
agent = PPO(action_dim=configuration.actionSize, action_scaler=configuration.actionScaler)


class StateEntity(BaseModel):
    state: list
    ID: float


class PredictionEntity(BaseModel):
    action: list
    pure_action: list
    log_prob: list
    rID: float

class ResultEntity(BaseModel):
    result: str

@app.on_event(event_type="startup")
def load_services():
    global agent
    agent.perform()
    print(f"USER:     New Agent was initialized! To load last update please visit {configuration.reloadPostfix}")

@app.get("/")
def root():
    return("Hello! This is main page of RL PSS agent! \n For prediction, please, visit /predict")


@app.post(configuration.predictPostfix)
async def predict(request: StateEntity):
    start = time.time()
    # data = [x[-1] for x in request.state]
    # state = torch.tensor(data, dtype=torch.float32)
    state = torch.tensor(request.state, dtype=torch.float32)
    action, pure_action, log_prob = agent.act(state.unsqueeze(0))
    value = agent.get_value(state.unsqueeze(0))
    end = time.time()
    log_prob_ls = [torch.squeeze(log_prob).item(), value, 0.0, 0.0, 0.0]
    log_prob_ls[1] = value
    log_msg = json.dumps({"time": datetime.now().isoformat(),
                          "duration": end - start,
                          "state": torch.squeeze(state).tolist(),
                          "action": torch.squeeze(action).tolist(),
                          "pure_action": torch.squeeze(pure_action).tolist(),
                          "log_prob": log_prob_ls}, indent=4)
    with open(path.normpath(path.join(configuration.logPath,"state_log.txt")), 'a') as f:
        f.write(log_msg + "\n")
    return PredictionEntity(action=torch.squeeze(action).tolist(),
                            pure_action=torch.squeeze(pure_action).tolist(),
                            log_prob=log_prob_ls,
                            rID=1.)


@app.post(configuration.trainPostfix)
async def train(request: ResultEntity):
    result = request.result
    result = json.loads(result)
    with open(path.normpath(path.join(configuration.logPath,"new_log.txt")), 'w') as f:
        f.write(json.dumps({"time": datetime.now().isoformat(), "result": result}, indent=4))
    with open(path.normpath(path.join(configuration.logPath, "trajectory_log.txt")), 'w') as f:
        json.dump(result, f, indent=4)
    return("OK")


@app.get(configuration.reloadPostfix)
async def reload():
    agent.load(name=configuration.agentNamePrefix + '_last.pth', folder=configuration.agentPath)
    path = configuration.agentPath + configuration.agentNamePrefix + '_last.pth'
    print(f"USER:     New agent version was successfully reloaded from: {path}")
    return("Reloaded")

if __name__ == "__main__":
    uvicorn.run("app:app", host=configuration.agentHost, port=os.getenv("PORT", configuration.agentPort))
#%%
