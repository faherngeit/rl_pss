from fastapi import FastAPI
import uvicorn
import json
import torch
import os
from pydantic import BaseModel
import json

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
    state = torch.tensor(request.state, dtype=torch.float32)
    action, pure_action, distribution = agent.act(state)
    return PredictionEntity(action=action.tolist(), pure_action=pure_action.tolist())


if __name__ == "__main__":
    uvicorn.run("app:app", host=configuration.agentHost, port=os.getenv("PORT", configuration.agentPort))
#%%
