import numpy as np
import cv2

X = np.load('X.npy')
print(X.shape)

k = 10
_i = 0
if len(X.shape) == 5:
    _i = 1

W = X[0].shape[_i + 0] * k
H = X[0].shape[_i + 1] * k
for i in range(1, X.shape[0]):
    y = X[i].reshape((X[i].shape[_i + 0], X[i].shape[_i + 1]))
    # print(y.shape)
    y = cv2.resize(y, (H, W))
    cv2.imshow('win', y)
    cv2.waitKey(10) 
cv2.destroyAllWindows()