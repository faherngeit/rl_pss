from dataclasses import dataclass
import json


@dataclass
class AgentDescription:
    actionSize: int
    stateSize: int
    agentHost: str
    agentPort: int
    predictPostfix: str
    trainPostfix: str
    actionScaler: list

    @staticmethod
    def from_file(path: str):
        with open(path, "r") as f:
            data = json.load(f)['Python']
            return AgentDescription(
                actionSize=data["actionSize"],
                stateSize=data["stateSize"],
                agentHost=data["agentHost"],
                agentPort=data["agentPort"],
                predictPostfix=data["predictPostfix"],
                trainPostfix=data["trainPostfix"],
                actionScaler=data["actionScaler"]
            )

