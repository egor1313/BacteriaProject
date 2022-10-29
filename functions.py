
import numpy as np

def relu(x):
    ones_and_zeros = (x > 0)
    return x * ones_and_zeros

def sigmoid(x):
    return 1 / (1 + np.exp(-x))

def softmax(x):
    return np.exp(x) / np.exp(x).sum(axis=0)

def tanh(x):
    return np.tanh(x)