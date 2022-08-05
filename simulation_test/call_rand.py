import random


def a_vec(state):
    action = [random.random()]*7
    pureAction = [action[1]+1]*7
    return action, pureAction

action, pureAction = a_vec(pyState)