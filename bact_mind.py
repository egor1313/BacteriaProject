import random as rand
import numpy as np
import functions as f


class bact_mind:
    def __init__(self, layers, len_of_w1, len_of_inp, len_of_out, k):
        if k != 0:
            w1, w2, b1, c = k

            self.b1 = b1
            self.w1 = w1
            self.w2 = w2
            self.color = c

            if rand.randint(0, 3) == 2:
                for i in range(3):
                    bi = rand.randint(0, len(b1)-1)
                    zluka = len_of_inp - 1
                    wi1 = rand.randint(0, zluka)
                    wii1 = rand.randint(0, len(w1[1])-1)
                    wi2 = rand.randint(0, len(w2[0])-1)
                    wii2 = rand.randint(0, len(w2[1])-1)
                    self.b1[bi] += ((rand.random() - 0.5) / 4)
                    self.w1[wi1][wii1] += ((rand.random() - 0.5) / 4)
                    self.w2[wi2][wii2] += ((rand.random() - 0.5) / 4)

                self.color[i] += rand.randint(-5, 5)
                for i in range(len(self.color)):
                    if self.color[i] >= 254:
                        self.color[i] = 254
                    if self.color[i] < 0:
                        self.color[i] = 0

            self.energy = 0.6  # every iteration -0.05 energy and ...

        else:
            self.b1 = np.random.rand(len_of_w1) / 5 - 0.1
            self.w1 = np.random.rand(len_of_inp, len_of_w1) / 2 + 0.25
            self.w2 = np.random.rand(len_of_w1, len_of_out) / 2 + 0.25
            self.energy = 1  # every iteration -0.05 energy and ...
            color = [rand.randint(100, 255), rand.randint(
                100, 255), rand.randint(100, 255)]
            self.color = color

        self.layers = layers
        self.len_of_w1 = len_of_w1
        self.len_of_inp = len_of_inp
        self.len_of_out = len_of_out

        self.energy_in_iter = 0.08
        self.energy_za_photosintese = 0.2
        self.energy_after_eating = 0.6
        self.energy_za_multiply = 0.7

        # 1 - -0.75 - , | -0.5 - -0.375 - < | -0.125 - +0.125 - ^ | +0.375 - +0.5 - > |
        self.rotation = rand.random() / 2 - 0.5
        self.coords = 0  # ? y * x / weight * height

    def go_toward(self, inp):  # maybe i should to add some layers for bacterial mind (6)
        x = inp @ self.w1
        x = f.tanh(x + self.b1)
        x = x @ self.w2
        l = x[-1]
        x = f.sigmoid(x[0:len(inp) - 1])
        x = f.softmax(x)
        return x, l

    def get_color(self):
        return self.color

    def set_coords(self, x, y, weight, height):
        self.coords = ((x * y) - (weight * height / 2)) / (weight * height)
        return self.coords

    def get_energy(self):
        return self.energy

    def get_rotation(self):
        return self.rotation

    def energy_za_iter(self):
        self.energy -= self.energy_in_iter

    def rotate(self, x):  # 2 sposob
        #self.rotation += x
        self.rotation = x

    def energy_up_after_eat(self):
        self.energy += self.energy_after_eating

    def photosintese(self):
        self.energy += self.energy_za_photosintese

    def get_sum_of_gen(self):
        return (sum(self.b1) + sum(self.w1.ravel()) + sum(self.w2.ravel())) / (len(self.b1) + len(self.w2.ravel()) + len(self.w1.ravel()))

    def get_gen(self):
        return (self.w1, self.w2, self.b1, self.color)

    def multiply_energy(self):
        self.energy -= self.energy_za_multiply
