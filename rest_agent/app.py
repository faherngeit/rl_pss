from fastapi import FastAPI
import uvicorn
import json
import torch
import os
from pydantic import BaseModel
import json
from datetime import datetime

from agent import Agent
from utils import AgentDescription

AGENT_PATH = "simulation_test/matlab_sample.pth"
CONFIG_PATH = "general_config.json"
STATE_SIZE = 4
ACTION_SIZE = 7

app = FastAPI()
agent = None
configuration = AgentDescription.from_file(CONFIG_PATH)


class StateEntity(BaseModel):
    state: list


class PredictionEntity(BaseModel):
    action: list
    pure_action: list

class ResultEntity(BaseModel):
    result: str

@app.on_event(event_type="startup")
def load_services():
    global agent
    agent = Agent(state_dim=configuration.stateSize, action_dim=configuration.actionSize)
    agent.load(AGENT_PATH)

@app.get("/")
def root():
    return("Hello! This is main page of RL PSS agent! \n For prediction, please, visit /predict")


@app.post(configuration.predictPostfix)
async def predict(request: StateEntity):
    data = [x[-1] for x in request.state]
    state = torch.tensor(data, dtype=torch.float32)
    action, pure_action, distribution = agent.act(state)
    log_msg = json.dumps({"time": datetime.now().isoformat(), "state": state.tolist(), "action": action.tolist(), "pure_action": pure_action.tolist()}, indent=4)
    with open("state_log.txt", 'a') as f:
        f.write(log_msg + "\n")
    return PredictionEntity(action=action.tolist(), pure_action=pure_action.tolist())

@app.post(configuration.trainPostfix)
async def train(request: ResultEntity):
    result = request.result
    with open("new_log.txt", 'a') as f:
        f.write(datetime.now().isoformat() + "\n")
        f.write(result.__repr__() + "\n")
        f.write("\n")
    return("OK")

@app.get(configuration.reloadPostfix)
async def reload():
    agent.load(AGENT_PATH)
    return("Reloaded")

if __name__ == "__main__":
    uvicorn.run("app:app", host=configuration.agentHost, port=os.getenv("PORT", configuration.agentPort))
#%%
