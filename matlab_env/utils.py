from dataclasses import dataclass
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
    agentNamePrefix: str
    device: str
    default_path: str = "../general_config.json"

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
#%%
