from dataclasses import dataclass
from os import path
import json


@dataclass
class AgentDescription:
    actionSize: int
    stateSize: list
    agentHost: str
    agentPort: int
    predictPostfix: str
    trainPostfix: str
    reloadPostfix: str
    actionScaler: list
    agentPath: str
    logPath: str
    agentNamePrefix: str
    device: str
    default_path: str = path.normpath(path.join("..", "general_config.json"))
    matlabLogPath: str = ""

    @staticmethod
    def from_file(path: str):
        with open(path, "r") as f:
            data = json.load(f)['Python']
            return AgentDescription(**data)

    @staticmethod
    def default_config():
        return AgentDescription.from_file(AgentDescription.default_path)

    def get_predict_url(self):
        return "http://" + self.agentHost + ":" + str(self.agentPort) + self.predictPostfix

    def get_train_url(self):
        return "http://" + self.agentHost + ":" + str(self.agentPort) + self.trainPostfix

    def get_reload_url(self, path: str = ""):
        if path == "":
            return "http://" + self.agentHost + ":" + str(self.agentPort) + self.reloadPostfix
        else:
            return "http://" + self.agentHost + ":" + str(self.agentPort) + self.reloadPostfix + "?path=" + path
#%%
