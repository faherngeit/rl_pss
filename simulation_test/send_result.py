import requests
import json

# NOTE: Почему-то не работал относительный импорт через __init__.py
# Поэтому пришлось перенести utils сюда
from utils import AgentDescription


CONFIG_PATH = "general_config.json"
config = AgentDescription.from_file(CONFIG_PATH)

AGENT_ADDRESS = config.agentHost + ":" + str(config.agentPort)
POSTFIX = config.trainPostfix

response = requests.post("http://" + AGENT_ADDRESS + POSTFIX,
                          json = pyJsonText)
