import requests


AGENT_ADDRESS = "127.0.0.1:8001"
POSTFIX = "/predict/"

response = requests.post("http://" + AGENT_ADDRESS + POSTFIX,
                          json = pyJsonText)
