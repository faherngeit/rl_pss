from fastapi import FastAPI
import uvicorn
import json
import torch
import os
from pydantic import BaseModel

from agent import Agent

AGENT_PATH = "simulation_test/matlab_sample.pth"
STATE_SIZE = 4
ACTION_SIZE = 7

app = FastAPI()
agent = None


class StateEntity(BaseModel):
    state: list


class PredictionEntity(BaseModel):
    action: list
    pure_action: list


@app.on_event(event_type="startup")
def load_agent():
    global agent
    agent = Agent(state_dim=STATE_SIZE, action_dim=ACTION_SIZE)
    agent.load(AGENT_PATH)

@app.get("/")
def root():
    return("Hello! This is main page of RL PSS agent! \n For prediction, please, visit /predict")


@app.post("/predict/")
async def predict(request: StateEntity):
    try:
        state = torch.tensor(json.loads(request.state), dtype=torch.float32)
    except:
        state = torch.tensor([0.1, 0.2, 0.3, 0.4], dtype=torch.float32)
    action, pure_action, distribution = agent.act(state)
    return PredictionEntity(action=action.tolist(), pure_action=pure_action.tolist())


if __name__ == "__main__":
    uvicorn.run("app:app", host="127.0.0.1", port=os.getenv("PORT", 8001))