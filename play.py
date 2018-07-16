#!/usr/bin/env python
import time
import gym
import numpy as np
from train import create_model_Conv2D, create_model_ConvLSTM2D
from prepare import resize_image
from prepare import Sample, model_def
from action_keys import Action_Keys


class Actor(object):
    
    def __init__(self):
        if _model_def.model == 'Conv2D':
            self.model = create_model_Conv2D(_model_def.INPUT_SHAPE, _model_def.OUT_SHAPE)
        elif _model_def.model == 'ConvLSTM2D':
            self.model = create_model_ConvLSTM2D(_model_def.INPUT_SHAPE, _model_def.OUT_SHAPE)
        self.model.load_weights(_model_def.weights_file)
        print('Weights loaded : ', _model_def.weights_file)

    def get_action(self, obs):
        vec = resize_image(_model_def.model, obs)
        vec = np.expand_dims(vec, axis=0)
        
        joystick = self.model.predict(vec, batch_size=1)[0]
        j = np.argmax(joystick)
        print(_action_keys.action_keys_text(str(j)), np.uint8(joystick * 100.))
        return j

    def get_random_action(self, env):
        joystick = env.action_space.sample()
        print('Random Action: ', joystick)
        return joystick


if __name__ == '__main__':
    _model_def = model_def()
    _action_keys = Action_Keys(_model_def.game)
    env = gym.make(_model_def.gym_name)
    actor = Actor()

    num_episodes = 5
    total_reward = 0

    for episode in range(num_episodes):
        obs = env.reset()
        
        if _model_def.need_random_action > 0:
            for _ in range(_model_def.need_random_action):
                action = actor.get_random_action(env)
                obs, reward, end_episode, info = env.step(action)
            
        episode_reward = 0
        end_episode = False
        while not end_episode:
            action = actor.get_action(obs)
            obs, reward, end_episode, info = env.step(action)
            env.render()
            episode_reward += reward
            # time.sleep(.005)

        print('---------------------------')
        print('End episode: ', episode, ' , ... total Reward: ', str(episode_reward))
        print('---------------------------')
        total_reward += episode_reward

    print('End all episodes , ... average episode Reward: ', str(total_reward / num_episodes))
    print('---------------------------')
    env.close()
