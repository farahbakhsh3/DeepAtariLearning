#!/usr/bin/env python
import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Dropout, Flatten
from keras.layers import Conv2D, ConvLSTM2D
from keras.utils import to_categorical
from prepare import Sample, model_def

def create_model_ConvLSTM2D(INPUT_SHAPE, OUT_SHAPE, dropout_prob=0.1):
    
    model = Sequential()
    model.add(ConvLSTM2D(24, kernel_size=(5, 5), return_sequences=True, strides=(2, 2), activation='relu', input_shape=INPUT_SHAPE))
    model.add(ConvLSTM2D(36, kernel_size=(5, 5), return_sequences=True, strides=(2, 2), activation='relu'))
    model.add(ConvLSTM2D(48, kernel_size=(5, 5), return_sequences=True, strides=(2, 2), activation='relu'))
    model.add(ConvLSTM2D(64, kernel_size=(3, 3), return_sequences=True, strides=(1, 1), activation='relu'))
    model.add(ConvLSTM2D(64, kernel_size=(2, 2), return_sequences=False, strides=(1, 1), activation='relu'))
    model.add(Flatten())
    model.add(Dense(1164, activation='relu'))
    model.add(Dropout(dropout_prob))
    model.add(Dense(100, activation='relu'))
    model.add(Dropout(dropout_prob))
    model.add(Dense(50, activation='relu'))
    model.add(Dropout(dropout_prob))
    model.add(Dense(OUT_SHAPE, activation='sigmoid'))
    print(model.summary())

    return model


def create_model_Conv2D(INPUT_SHAPE, OUT_SHAPE, dropout_prob=0.1):

    model = Sequential()
    model.add(Conv2D(24, kernel_size=(5, 5), strides=(2, 2), activation='relu', input_shape=INPUT_SHAPE))
    model.add(Conv2D(36, kernel_size=(5, 5), strides=(2, 2), activation='relu'))
    model.add(Conv2D(48, kernel_size=(5, 5), strides=(2, 2), activation='relu'))
    model.add(Conv2D(64, kernel_size=(3, 3), activation='relu'))
    model.add(Conv2D(64, kernel_size=(2, 2), activation='relu'))
    model.add(Flatten())
    model.add(Dense(1164, activation='relu'))
    model.add(Dropout(dropout_prob))
    model.add(Dense(100, activation='relu'))
    model.add(Dropout(dropout_prob))
    model.add(Dense(50, activation='relu'))
    model.add(Dropout(dropout_prob))
    model.add(Dense(OUT_SHAPE, activation='sigmoid'))
    print(model.summary())
    
    return model


if __name__ == '__main__':

    _model_def = model_def()
    x_train = np.load("X.npy")
    y_train = np.load("Y.npy")
    y_train = to_categorical(y_train, num_classes=_model_def.OUT_SHAPE)

    print('X_Train Shape: ', x_train.shape)
    print('Y_Train Shape: ', y_train.shape)
    print('---------------------------')
    
    epochs = 100
    batch_size = 50

    if _model_def.model == 'Conv2D':
        model = create_model_Conv2D(_model_def.INPUT_SHAPE, _model_def.OUT_SHAPE)
    elif _model_def.model == 'ConvLSTM2D':
        model = create_model_ConvLSTM2D(_model_def.INPUT_SHAPE, _model_def.OUT_SHAPE)

    if input('Train from zero: <z>  ,  Retrain by load prev weights: <r>  ::   ') == 'r':
        model.load_weights(_model_def.weights_file)
        print('Model weights loaded : ', _model_def.weights_file) 
    else:
        print('Train from zero.')
    print('---------------------------')
        
    model.compile(loss='categorical_crossentropy', optimizer='adam', metrics=['accuracy'])
    
    model.fit(x_train, y_train, batch_size=batch_size, epochs=epochs, shuffle=True, validation_split=0.05)

    model.save_weights(_model_def.weights_file)
    print('Weights saved. ', _model_def.weights_file)
    print('---------------------------')
