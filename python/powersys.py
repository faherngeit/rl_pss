import gym
import matlab.engine


class PowerSystem(gym):
    def __init__(self, model: str):
        self.model = model
        self.state = None

    def step(self):

