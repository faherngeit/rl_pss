import pybullet_envs
# Don't forget to install PyBullet!
from gym import make
import numpy as np
import torch
from torch import nn
from torch.distributions import Normal
from torch.nn import functional as F
from torch.optim import Adam, SGD
import random
from datetime import datetime

ENV_NAME = "Walker2DBulletEnv-v0"

LAMBDA = 0.95
GAMMA = 0.99

ACTOR_LR = 8e-4
CRITIC_LR = 4e-4

CLIP = 0.2
ENTROPY_COEF = 2e-2
BATCHES_PER_UPDATE = 64
BATCH_SIZE = 64

MIN_TRANSITIONS_PER_UPDATE = 2048
MIN_EPISODES_PER_UPDATE = 16

ITERATIONS = 3000


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
        return tanh_action, action, distribution


class Critic(nn.Module):
    def __init__(self, state_dim):
        super().__init__()
        self.model = nn.Sequential(
            nn.Linear(state_dim, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 256),
            nn.ReLU(),
            nn.Linear(256, 1),
        )

    def get_value(self, state):
        return self.model(state)


class PPO:
    def __init__(self, state_dim, action_dim):
        self.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        self.actor = Actor(state_dim, action_dim).to(self.device)
        self.critic = Critic(state_dim).to(self.device)
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

        for _ in range(BATCHES_PER_UPDATE):
            # idx = np.random.randint(0, len(transitions), BATCH_SIZE)  # Choose random batch
            idx = torch.randint(0, len(transitions), (BATCH_SIZE,)).to(self.device)
            s = state[idx]
            a = action[idx]
            op = old_prob[idx]      # Probability of the action in state s.t. old policy
            v = target_value[idx]   # Estimated by lambda-returns
            adv = advantage[idx]    # Estimated by generalized advantage estimation

            # TODO: Update actor here
            log_prob, distribution = self.actor.compute_proba(s, a)
            ratio = torch.exp(log_prob - op)
            surr1 = ratio * adv
            surr2 = torch.clamp(ratio, 1 - CLIP, 1 + CLIP) * adv
            actor_loss = (-torch.min(surr1, surr2)).mean() - ENTROPY_COEF * distribution.entropy().mean()
            self.actor_optim.zero_grad()
            actor_loss.backward()
            self.actor_optim.step()

            # TODO: Update critic here
            critic_value = self.critic.get_value(s)
            critic_loss = nn.MSELoss()(critic_value.squeeze(-1), v)
            self.critic_optim.zero_grad()
            critic_loss.backward()
            self.critic_optim.step()

        # self.critic_scheduler.step()
        # self.actor_scheduler.step()

    def get_value(self, state):
        with torch.no_grad():
            state = torch.FloatTensor(np.array([state])).to(self.device)
            value = self.critic.get_value(state)
        return value.item()

    def act(self, state):
        with torch.no_grad():
            state = torch.FloatTensor(np.array([state])).to(self.device)
            action, pure_action, distr = self.actor.act(state)
            log_prob = distr.log_prob(pure_action).sum(-1)
            # log_prob = distr.log_prob(pure_action)
        return action.cpu().numpy()[0], pure_action.cpu().numpy()[0], log_prob.cpu().item()

    def save(self, name="agent.pkl"):
        torch.save(self.actor.state_dict(), name)
        torch.save(self.critic.state_dict(), 'critic_' + name)


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


def start(load_model=False, colab=False):
    torch.manual_seed(12345)
    np.random.seed(3141592)
    env = make(ENV_NAME)
    ppo = PPO(state_dim=env.observation_space.shape[0], action_dim=env.action_space.shape[0])
    if load_model:
        ppo.actor.load_state_dict(torch.load(__file__[:-8] + "/best_agent_.pth"))
        ppo.critic.load_state_dict(torch.load(__file__[:-8] + "/critic_best_agent_.pth"))

    log_str = []

    splt_str = '\n'
    for _ in range(80):
        splt_str += '#'
    splt_str += '\n'
    log_str.append(splt_str)
    if load_model:
        log_str.append("Pretrained model has been loaded!\n")
    strt_msg = f"Model uses {ppo.device}\n Lambda = {LAMBDA}\nGamma = {GAMMA}\n" \
               f"Actor_lr = {ACTOR_LR}\n" \
               f"Critic_LR = {CRITIC_LR}\n" \
               f"Clip = {CLIP}\n" \
               f"Entropy_coef = {ENTROPY_COEF}\n" \
               f"Batches per update = {BATCHES_PER_UPDATE}\n" \
               f"Batch size = {BATCH_SIZE}\n" \
               f"Min transition per update = {MIN_TRANSITIONS_PER_UPDATE}\n" \
               f"Min episode per update = {MIN_EPISODES_PER_UPDATE}\n" \
               f"Irerations = {ITERATIONS}\n" \
               "\n"
    log_str.append(strt_msg)
    if not colab:
        with open("train_log.txt", "a") as myfile:
            for st in log_str:
                myfile.write(st)

    state = env.reset()
    episodes_sampled = 0
    steps_sampled = 0
    max_reward = 0
    msg = f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Learning on {ppo.device} starts!"

    print(msg)
    if colab:
        log_str.append(msg)
    else:
        with open("train_log.txt", "a") as myfile:
            myfile.write(msg+'\n')

    for i in range(ITERATIONS):
        trajectories = []
        steps_ctn = 0

        while len(trajectories) < MIN_EPISODES_PER_UPDATE or steps_ctn < MIN_TRANSITIONS_PER_UPDATE:
            traj = sample_episode(env, ppo)
            steps_ctn += len(traj)
            trajectories.append(traj)
        episodes_sampled += len(trajectories)
        steps_sampled += steps_ctn

        ppo.update(trajectories)

        if (i + 1) % (ITERATIONS // 100) == 0:
            rewards = evaluate_policy(env, ppo, 20)
            msg = f"[{datetime.now():%Y-%m-%d %H:%M:%S}] Step: {i + 1}, Reward mean: {np.mean(rewards)}, Reward std: {np.std(rewards)}, Episodes: {episodes_sampled}, Steps: {steps_sampled}"
            print(msg)
            if colab:
                log_str.append(msg)
            else:
                with open("train_log.txt", "a") as myfile:
                    myfile.write(msg+'\n')
            ppo.save('agent.pth')
            if np.mean(rewards) > max_reward:
                max_reward = np.mean(rewards)
                ppo.save('best_agent.pth')
    if colab:
        with open("train_log.txt", "a") as myfile:
            for st in log_str:
                myfile.write(st)


if __name__ == "__main__":
    start()
