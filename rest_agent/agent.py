import random
import numpy as np
import os
import torch
from torch import nn
from torch.distributions import Normal


class Actor(nn.Module):
    def __init__(self, state_dim, action_dim):
        super().__init__()
        # Advice: use same log_sigma for all states to improve stability
        # You can do this by defining log_sigma as nn.Parameter(torch.zeros(...))
        self.model = nn.Sequential(
            nn.Linear(state_dim, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
        )
        self.mean = nn.Linear(256, action_dim)
        self.sigma = nn.Sequential(
            nn.Linear(256, action_dim),
            nn.ELU()
        )
        # self.sigma = torch.zeros(action_dim)

    def compute_proba(self, state, action):
        # Returns probability of action according to current policy and distribution of actions
        _, pa, distribution = self.act(state)
        proba = distribution.log_prob(action).sum(-1)
        return proba, distribution

    def act(self, state):
        # Returns an action (with tanh), not-transformed action (without tanh) and distribution of non-transformed actions
        # Remember: agent is not deterministic, sample actions from distribution (e.g. Gaussian)
        latent = self.model(state)
        mean = self.mean(latent)
        sigma = torch.exp(-self.sigma(latent))
        distribution = Normal(mean, sigma)
        action = distribution.sample()
        tanh_action = torch.tanh(action)
        log_prob = distribution.log_prob(action).sum(-1)
        return tanh_action, action, log_prob


class Agent:
    def __init__(self, state_dim=22, action_dim=6, load=False):
        self.actor = Actor(state_dim=state_dim, action_dim=action_dim)
        if load:
            self.actor.load_state_dict(torch.load(__file__[:-8] + "/best_agent.pth"))

    def load(self, name="agent.pth"):
        # self.actor.load_state_dict(torch.load(name))
        self.actor = torch.load(name)
        
    def act(self, state):
        with torch.no_grad():
            state = torch.tensor(np.array(state)).float()
            return self.actor.act(state)

    def reset(self):
        pass