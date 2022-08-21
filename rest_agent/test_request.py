import numpy as np
import pandas as pd
import requests

if __name__ == "__main__":
    data = [0.1, 0.2, 0.3, 0.4]
    for i in range(1):
        request_data = data
        print(request_data)
        response = requests.post(
            "http://127.0.0.1:8001/predict/",
            json={"state": request_data},
        )
        print(response.status_code)
        res = response.json()
        print(res)
        print(res['action'])
        print(res['pure_action'])
