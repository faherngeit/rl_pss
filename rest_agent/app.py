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

class ResultEntity(BaseModel):
    result: str

@app.on_event(event_type="startup")
def load_services():
    global agent
    # agent = Agent(state_dim=configuration.stateSize, action_dim=configuration.actionSize)
    agent = Agent(state_dim=STATE_SIZE, action_dim=ACTION_SIZE)
    agent.load("./" + configuration.agentPath + configuration.agentNamePrefix + "_last.pth")

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
    data = json.loads(result)
    with open("new_log.txt", 'w') as f:
        f.write(json.dumps({"time": datetime.now().isoformat(), "result": result}, indent=4))
    return("OK")

@app.get(configuration.reloadPostfix)
async def reload():
    agent.load("./" + configuration.agentPath + configuration.agentNamePrefix + "_last.pth")
    return("Reloaded")

if __name__ == "__main__":
    uvicorn.run("app:app", host=configuration.agentHost, port=os.getenv("PORT", configuration.agentPort))
#%%
