from os import path
import numpy as np
import torch
from torch import nn
from torch.distributions import Normal
from torch.nn import functional as F
from torch.optim import Adam, SGD
import random
from datetime import datetime
import matlab.engine
import json
import requests
import argparse

from utils import AgentDescription

CONFIG_PATH = "general_config.json"
configuration = AgentDescription.from_file(CONFIG_PATH)

CONFIG_PATH = "general_config.json"

LAMBDA = 0.95
GAMMA = 0.99

ACTOR_LR = 8e-4
CRITIC_LR = 4e-4

CLIP = 0.2
ENTROPY_COEF = 2e-2
BATCHES_PER_UPDATE = 16
BATCH_SIZE = 32

EPISODES_PER_UPDATE = 20
ITERATIONS = 200

def get_arguments():
    """
    Get arguments from command line
    Returns
    -------
    Dictionary with arguments
    """
    parser = argparse.ArgumentParser("Train RL PSS agent")
    parser.add_argument(
        "--telegram",
        dest="telegram",
        default=None,
        type=str,
        help="should logs be sent to telegram",
    )
    parser.add_argument(
        "--load",
        dest="load_model",
        default=False,
        action="store_true",
        help="Allows to load pretrained model from a file",
    )
    args = parser.parse_args()
    return args

def log_both_telegram(message, config):
    if config is None:
        return
    url = f"https://api.telegram.org/bot{config['token']}/sendMessage?chat_id={config['chat_id']}&text={message}"
    response = requests.get(url)
    if response.status_code != 200:
        print(f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Error sending telegram message")
    return

def compute_lambda_returns_and_gae(trajectory):
    lambda_returns = []
    gae = []
    last_lr = 0.
    last_v = 0.
    for _, _, r, _, v in reversed(trajectory):
        ret = r + GAMMA * (last_v * (1 - LAMBDA) + last_lr * LAMBDA)
        last_lr = ret
        last_v = v
        lambda_returns.append(last_lr)
        gae.append(last_lr - v)

    # Each transition contains state, action, old action probability, value estimation and advantage estimation
    return [(s, a, p, v, adv) for (s, a, _, p, _), v, adv in zip(trajectory, reversed(lambda_returns), reversed(gae))]


class Actor(nn.Module):
    def __init__(self, action_dim, action_scaler):
        super().__init__()
        # Advice: use same log_sigma for all states to improve stability
        # You can do this by defining log_sigma as nn.Parameter(torch.zeros(...))
        self.short_window = torch.nn.Sequential(
            torch.nn.Conv1d(4, 8, kernel_size=3, padding=1),
            torch.nn.ReLU(),
            torch.nn.Conv1d(8, 8, kernel_size=3, padding=1),
            torch.nn.ReLU(),
        )
        self.agg_window = torch.nn.Sequential(
            torch.nn.Conv1d(16, 8, kernel_size=5, padding=2),
            torch.nn.ReLU(),
            torch.nn.Conv1d(8, 4, kernel_size=5, padding=2),
            torch.nn.ReLU(),
            torch.nn.Conv1d(4, 1, kernel_size=5, padding=2),
            torch.nn.ReLU(),
        )
        self.long_window = torch.nn.Sequential(
            torch.nn.Conv1d(4, 8, kernel_size=11, padding=5),
            torch.nn.ReLU(),
            torch.nn.Conv1d(8, 8, kernel_size=11, padding=5),
            torch.nn.ReLU(),
        )
        self.mean = torch.nn.Sequential(
            torch.nn.Linear(60, 60),
            torch.nn.ReLU(),
            torch.nn.Linear(60, 32),
            torch.nn.ReLU(),
            torch.nn.Linear(32, 16),
            torch.nn.ReLU(),
            torch.nn.Linear(16, action_dim),
            torch.nn.ReLU(),
        )
        # self.sigma = nn.Sequential(
        #     nn.Linear(256, action_dim),
        #     nn.ELU()
        # )
        self.action_scaler = torch.tensor(action_scaler, dtype=torch.float32)
        self.sigma = nn.Parameter(torch.zeros(action_dim))

    def compute_proba(self, state, action):
        # Returns probability of action according to current policy and distribution of actions
        _, pa, distribution = self.act(state)
        proba = distribution.log_prob(action).sum(-1)
        return proba, distribution

    def act(self, state):
        # Returns an action (with tanh), not-transformed action (without tanh) and distribution of non-transformed actions
        # Remember: agent is not deterministic, sample actions from distribution (e.g. Gaussian)
        short_rep = self.short_window(state)
        long_rep = self.long_window(state)
        latent = self.agg_window(torch.cat([short_rep, long_rep], dim=1))
        mean = self.mean(latent)
        # sigma = torch.exp(-self.sigma(latent))
        sigma = torch.exp(self.sigma)
        distribution = Normal(mean, sigma)
        action = distribution.sample()
        tanh_action = torch.sigmoid(action) * self.action_scaler
        # tanh_action = torch.sigmoid(action)
        return tanh_action, action, distribution


class Critic(nn.Module):
    def __init__(self):
        super().__init__()
        self.short_window = torch.nn.Sequential(
            torch.nn.Conv1d(4, 8, kernel_size=3, padding=1),
            torch.nn.ReLU(),
            torch.nn.Conv1d(8, 8, kernel_size=3, padding=1),
            torch.nn.ReLU(),
        )
        self.agg_window = torch.nn.Sequential(
            torch.nn.Conv1d(16, 8, kernel_size=5, padding=2),
            torch.nn.ReLU(),
            torch.nn.Conv1d(8, 4, kernel_size=5, padding=2),
            torch.nn.ReLU(),
            torch.nn.Conv1d(4, 1, kernel_size=5, padding=2),
            torch.nn.ReLU(),
        )
        self.long_window = torch.nn.Sequential(
            torch.nn.Conv1d(4, 8, kernel_size=11, padding=5),
            torch.nn.ReLU(),
            torch.nn.Conv1d(8, 8, kernel_size=11, padding=5),
            torch.nn.ReLU(),
        )
        self.mean = torch.nn.Sequential(
            torch.nn.Linear(60, 60),
            torch.nn.ReLU(),
            torch.nn.Linear(60, 32),
            torch.nn.ReLU(),
            torch.nn.Linear(32, 16),
            torch.nn.ReLU(),
            torch.nn.Linear(16, 1),
            torch.nn.ReLU(),
        )

    def get_value(self, state):
        short_rep = self.short_window(state)
        long_rep = self.long_window(state)
        latent = self.agg_window(torch.cat([short_rep, long_rep], dim=1))
        return self.mean(latent)


class PPO:
    def __init__(self, action_scaler, action_dim, device='cpu'):
        self.device = device
        self.actor = Actor(action_dim, action_scaler).to(self.device)
        self.critic = Critic().to(self.device)
        self.actor_optim = Adam(self.actor.parameters(), ACTOR_LR, amsgrad=True)
        self.critic_optim = Adam(self.critic.parameters(), CRITIC_LR, amsgrad=True)

        # self.actor_scheduler = torch.optim.lr_scheduler.CyclicLR(self.actor_optim, base_lr=1e-3,
        #                                                          max_lr=1e-2, step_size_up=100, mode='triangular2',
        #                                                          cycle_momentum=False)
        # self.critic_scheduler = torch.optim.lr_scheduler.CyclicLR(self.critic_optim, base_lr=5e-4,
        #                                                           max_lr=5e-3, step_size_up=100, mode='triangular2',
        #                                                           cycle_momentum=False)

    def update(self, trajectories):
        transitions = [t for traj in trajectories for t in traj]  # Turn a list of trajectories into list of transitions
        state, action, old_prob, target_value, advantage = zip(*transitions)
        state = torch.FloatTensor(np.array(state)).to(self.device)
        action = torch.FloatTensor(np.array(action)).to(self.device)
        old_prob = torch.FloatTensor(np.array(old_prob)).to(self.device)
        target_value = torch.FloatTensor(np.array(target_value)).to(self.device)
        advantage = np.array(advantage)
        advantage = torch.FloatTensor((advantage - advantage.mean()) / (advantage.std() + 1e-8)).to(self.device)

        actor_loss_ls = []
        critic_loss_ls = []

        for _ in range(BATCHES_PER_UPDATE):
            # idx = np.random.randint(0, len(transitions), BATCH_SIZE)  # Choose random batch
            idx = torch.randint(0, len(transitions), (BATCH_SIZE,)).to(self.device)
            s = state[idx]
            a = action[idx]
            op = old_prob[idx]  # Probability of the action in state s.t. old policy
            v = target_value[idx]  # Estimated by lambda-returns
            adv = advantage[idx]  # Estimated by generalized advantage estimation

            # Update actor here
            log_prob, distribution = self.actor.compute_proba(s, a)
            ratio = torch.exp(log_prob - op)
            surr1 = ratio * adv
            surr2 = torch.clamp(ratio, 1 - CLIP, 1 + CLIP) * adv
            actor_loss = (-torch.min(surr1, surr2)).mean() - ENTROPY_COEF * distribution.entropy().mean()
            actor_loss_ls.append(actor_loss.item())
            self.actor_optim.zero_grad()
            actor_loss.backward()
            self.actor_optim.step()

            # Update critic here
            critic_value = self.critic.get_value(s)
            critic_loss = nn.MSELoss()(torch.squeeze(critic_value), v)
            critic_loss_ls.append(critic_loss.item())
            self.critic_optim.zero_grad()
            critic_loss.backward()
            self.critic_optim.step()
        # self.critic_scheduler.step()
        # self.actor_scheduler.step()
        return np.mean(actor_loss_ls), np.mean(critic_loss_ls)


    def get_value(self, state):
        with torch.no_grad():
            state.to(self.device)
            value = self.critic.get_value(state)
        return value.item()

    def act(self, state):
        with torch.no_grad():
            state.to(self.device)
            action, pure_action, distr = self.actor.act(state)
            log_prob = distr.log_prob(pure_action).sum(-1)
            # log_prob = distr.log_prob(pure_action)
        return action, pure_action, log_prob

    def save(self, name="agent.pkl", folder=""):
        torch.save(self.actor.state_dict(), path.join(folder, name))
        torch.save(self.critic.state_dict(), path.join(folder, 'critic_' + name))

    def load(self, name="agent.pkl", folder=""):
        self.actor.load_state_dict(torch.load(path.join(folder, name)))
        self.critic.load_state_dict(torch.load(path.join(folder, 'critic_' + name)))
        self.actor.eval()
        self.critic.eval()
        self.actor.to(self.device)
        self.critic.to(self.device)

    def perform(self):
        self.actor.to('cpu')
        self.critic.to('cpu')
        self.actor.eval()
        self.critic.eval()

    def train_(self):
        self.actor.to(self.device)
        self.critic.to(self.device)
        self.actor.train()
        self.critic.train()


def evaluate_policy(env, agent, episodes=5):
    returns = []
    for _ in range(episodes):
        done = False
        state = env.reset()
        total_reward = 0.

        while not done:
            state, reward, done, _ = env.step(agent.act(state)[0])
            total_reward += reward
        returns.append(total_reward)
    return returns


def sample_episode(env, agent):
    s = env.reset()
    d = False
    trajectory = []
    while not d:
        a, pa, p = agent.act(s)
        v = agent.get_value(s)
        ns, r, d, _ = env.step(a)
        trajectory.append((s, pa, r, p, v))
        s = ns
    return compute_lambda_returns_and_gae(trajectory)


def create_trajectory(data: list):
    trajectories = []
    for exp in data:
        traj = []
        for ep in exp['data']:
            state = [x for x in ep['state']]
            traj.append((state, ep['pureAction'], ep['reward'], ep['probability'][0], ep['probability'][1]))
        trajectories.append(compute_lambda_returns_and_gae(traj))
    return trajectories


def update_agent_remote(config):
    response = requests.get(config.get_reload_url())
    if response.status_code == 200:
        print(f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Agent updated")
    else:
        print(f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Error reloading agent")
    return


def start(load_model=False, telegram=None):
    torch.manual_seed(12345)
    np.random.seed(3141592)
    config = AgentDescription.from_file(CONFIG_PATH)
    eng = matlab.engine.start_matlab()
    eng.cd("./matlab_env/")

    log_both_telegram("Start new education with logging to Telegram!", telegram)
    ppo = PPO(action_dim=config.actionSize, action_scaler=config.actionScaler)
    if load_model:
        ppo.load(name=config.agentNamePrefix + "_last.pth", folder=config.agentPath)
        msg = f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Agent was loaded from {path.join(config.agentPath, config.agentNamePrefix + '_last.pth')}"
        log_both_telegram(msg, telegram)
        print(msg)
    else:
        ppo.save(name=config.agentNamePrefix + "_last.pth", folder=config.agentPath)
        msg = f"[{datetime.now():%Y-%m-%d %H:%M:%S}] New agent was saved in {path.join(config.agentPath, config.agentNamePrefix + '_last.pth')}"
        log_both_telegram(msg, telegram)
        print(msg)
    log_str = []

    splt_str = '\n' + '#' * 80 + '\n'
    log_str.append(splt_str)
    update_agent_remote(config)
    if load_model:
        log_str.append("Pretrained model has been loaded!\n")
    strt_msg = f"Model uses {ppo.device}\n Lambda = {LAMBDA}\nGamma = {GAMMA}\n" \
               f"Actor_lr = {ACTOR_LR}\n" \
               f"Critic_LR = {CRITIC_LR}\n" \
               f"Clip = {CLIP}\n" \
               f"Entropy_coef = {ENTROPY_COEF}\n" \
               f"Batches per update = {BATCHES_PER_UPDATE}\n" \
               f"Batch size = {BATCH_SIZE}\n" \
               f"Episode per update = {EPISODES_PER_UPDATE}\n" \
               f"Irerations = {ITERATIONS}\n" \
               "\n"
    log_str.append(strt_msg)
    log_both_telegram(strt_msg, telegram)

    with open(path.join(configuration.logPath, "train_log.txt"), "a") as myfile:
        myfile.write('\n'.join(log_str))

    msg = f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Learning on {ppo.device} starts!"

    log_both_telegram(msg, telegram)
    print(msg)

    with open(path.join(configuration.logPath, "train_log.txt"), "a") as myfile:
        myfile.write(msg + '\n')

    for i in range(ITERATIONS):
        request = eng.simWrapper('scenarios_LineSCB', 'IntMaxDeltaWs', 1.0e+06, EPISODES_PER_UPDATE, path.normpath("./log/"))
        with open(path.join(configuration.logPath, "trajectory_log.txt"), 'r') as f:
            data = json.load(f)
        trajectories = create_trajectory(data)

        actor_loss, critic_loss = ppo.update(trajectories)
        ppo.save(name=config.agentNamePrefix + "_last.pth", folder=config.agentPath)
        update_agent_remote(config)
        sum_reward = sum([x['reward'] for y in data for x in y['data']]) / len(data)
        reference_reward = sum([x['reward_noAgent'] for y in data for x in y['data']]) / len(data)
        msg = f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Step: {i + 1}, Reward mean: {sum_reward:.4f}, No agent reward: {reference_reward:.4f}, Actror loss: {actor_loss:.4f}, Critic loss: {critic_loss:.4f}"

        log_both_telegram(msg, telegram)
        print(msg)


if __name__ == "__main__":
    args = get_arguments()
    telegram = None
    if args.telegram:
        with open(args.telegram, 'r') as f:
            telegram = json.load(f)
    start(load_model=args.load_model, telegram=telegram)

#%%

