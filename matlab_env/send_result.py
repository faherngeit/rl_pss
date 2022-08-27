import requests
import json

from utils import AgentDescription


config = AgentDescription.default_config()

response = requests.post(config.get_train_url(), json={'result': pyJsonText})
