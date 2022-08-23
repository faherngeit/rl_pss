import requests


AGENT_ADDRESS = "127.0.0.1:8001"

response = requests.post("http://" + AGENT_ADDRESS + "/predict/",
                          json = pyJsonText)
