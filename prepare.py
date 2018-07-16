import os
import numpy as np
from tqdm import tqdm
from skimage.io import imread
from skimage.color import rgb2gray
from skimage.transform import resize
from action_keys import Action_Keys


class Sample:
    IMG_W = 80
    IMG_H = 105
    IMG_D = 1


class model_def:
    def __init__(self):
        print('1: Boxing')
        print('2: RiverRaid')
        print('3: Enduro')
        print('4: SeaQuest')
        print('5: Tennis')
        print('6: SpaceInvaders')
        i = input('Please select your game...(1, 2, 3, 4, ...)  ::   ')
        if i == '1':
            self.game = 'Boxing'
            self.gym_name = 'Boxing-v0'
            self.OUT_SHAPE = 18
            self.need_random_action = 0
        elif i == '2':
            self.game = 'Riverraid'
            self.gym_name = 'Riverraid-v0'
            self.OUT_SHAPE = 18
            self.need_random_action = 35
        elif i == '3':
            self.game = 'Enduro'
            self.gym_name = 'Enduro-v0'
            self.OUT_SHAPE = 9
            self.need_random_action = 0
        elif i == '4':
            self.game = 'Seaquest'
            self.gym_name = 'Seaquest-v0'
            self.OUT_SHAPE = 18
            self.need_random_action = 0
        elif i == '5':
            self.game = 'Tennis'
            self.gym_name = 'Tennis-v0'
            self.OUT_SHAPE = 18
            self.need_random_action = 5
        elif i == '6':
            self.game = 'SpaceInvaders'
            self.gym_name = 'SpaceInvaders-v0'
            self.OUT_SHAPE = 6
            self.need_random_action = 0
        
        print('---------------------------')
        print('Game: ', self.game, '( ' + self.gym_name + ' )' + ' Selected.')
        print('---------------------------')

        print()
        print('1: Conv2D')
        print('2: ConvLSTM2D')
        i = input('Please select your model...(1, 2)  ::   ')
        if i == '1':
            self.model = 'Conv2D'
            self.INPUT_SHAPE = (Sample.IMG_H, Sample.IMG_W, Sample.IMG_D)
        elif i == '2':
            self.model = 'ConvLSTM2D'
            self.INPUT_SHAPE = (None, Sample.IMG_H, Sample.IMG_W, Sample.IMG_D)
        
        print('---------------------------')
        print('Model: ', self.model, ' Selected.')
        print('---------------------------')
        self.weights_file = self.model + '_' + self.game + '.h5' 


def resize_image(_model, img):
    if Sample.IMG_D == 3:
        im = resize(img, (Sample.IMG_H, Sample.IMG_W), mode='reflect')
    elif Sample.IMG_D == 1:
        im = rgb2gray(resize(img, (Sample.IMG_H, Sample.IMG_W), mode='reflect'))
    
    if _model == 'Conv2D':
        im_arr = im.reshape((Sample.IMG_H, Sample.IMG_W, Sample.IMG_D))
    elif _model == 'ConvLSTM2D':
        im_arr = im.reshape((1, Sample.IMG_H, Sample.IMG_W, Sample.IMG_D))
        
    return im_arr


def prepare():

    X = []
    Y = []

    Data_folder_path = './prjKeyScreen/Data/'
    folders = os.listdir(Data_folder_path)
    print('Total Folders: ', len(folders))
    for folder in folders:
        print('Folder: ', folder)
        pics = os.listdir(Data_folder_path + folder)
        for pic in tqdm(pics):
            Y.append(_action_keys.action_keys_Convert(pic.split('.')[1]))
            image = imread(Data_folder_path + folder + '/' + pic)
            vec = resize_image(_model_def.model, image)
            X.append(vec)

    X = np.asarray(X)
    Y = np.asarray(Y)

    print('---------------------------')
    print('X.Shape=', X.shape)
    print('Y.Shape=', Y.shape)
    print('---------------------------')

    np.save('X.npy', X)
    np.save('Y.npy', Y)


if __name__ == '__main__':
    _model_def = model_def()
    _action_keys = Action_Keys(_model_def.game)
    prepare()
