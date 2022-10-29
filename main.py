
import pygame
import sys
import numpy as np
import random as rand
from bact_mind import bact_mind
from directhelpfunc import direct_of_seeing


def isCellClass(x):
    if isinstance(x, bact_mind):
        return 1
    else:
        return 0


def start():
    mapa = [[0 for x in range(width_cell)] for y in range(height_cell)]

    for i in range(start_bacteries):
        bacts[i] = bact_mind(layers, len_of_w1, len_of_inp, len_of_out, 0)

        a1 = rand.randint(1, height_cell-1)
        a2 = rand.randint(1, width_cell-1)
        mapa[a1][a2] = bacts[i]

    return mapa


bg_c = (220, 220, 220)
bd_c = (50, 50, 50)

delay = 500

layers = 2
len_of_w1 = 40
len_of_inp = 5  # energy, what_around, cordinate, your turn rotation, percent_of_your_colony
# 6 bool_turn, move, atack, photosintese, multiply, (rotate_count)
len_of_out = 6

start_bacteries = 800
bacts = [None] * start_bacteries


# print(b1.go_toward([0.8, 0.5, 0.99, 0.8]))

width = 1000
height = 1000
len_of_cell = 15
border_cell = 1
width_cell = int(width / len_of_cell)
height_cell = int(height / len_of_cell)


pygame.init()

screen = pygame.display.set_mode((width, height))

flag_pause = False

mapa = start()

while True:

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            pygame.quit()
            sys.exit()
        elif event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:
                flag_pause = not flag_pause
            elif event.key == pygame.K_LEFT:
                delay -= 100
                if delay <= 0:
                    delay = 0
            elif event.key == pygame.K_RIGHT:
                delay += 100
            elif event.key == pygame.K_r:
                mapa = start()

    # Update screen
    pygame.display.flip()
    r = pygame.Rect(0, 0, width, height)
    pygame.draw.rect(screen, bg_c, r)

    for y in range(height_cell):
        for x in range(width_cell):
            if mapa[y][x] != 0:
                if isCellClass(mapa[y][x]):
                    if y == 0 or x == 0 or y == width or x == height:
                        flag = True

                    # energy in iteration
                    if isCellClass(mapa[y][x]):
                        mapa[y][x].energy_za_iter()

                        if mapa[y][x].get_energy() <= 0:
                            mapa[y][x] = 0
                            continue

                    # WHat bacteria want
                    percent_your_colony = 0
                    x1, y1 = direct_of_seeing(mapa[y][x].get_rotation())
                    torward_y = (y + y1) % height_cell
                    torward_x = (x + x1) % width_cell

                    torward_cell_direct = mapa[torward_y][torward_x]

                    if isCellClass(torward_cell_direct) == 1:
                        percent_your_colony = torward_cell_direct.get_sum_of_gen() / \
                            mapa[y][x].get_sum_of_gen()
                    # todo:
                    # SOLVE PROBLEM WITH WALL
                    what_around = 0
                    for i1 in range(-1, 2):
                        for j1 in range(-1, 2):

                            index_y_around = (y + i1) % height_cell
                            index_x_around = (x + j1) % width_cell
                            if i1 == 0 and j1 == 0:
                                continue
                            what_around += isCellClass(
                                mapa[index_y_around][index_x_around])

                    what_around = what_around / 8

                    input_bact = (mapa[y][x].get_energy(), what_around,
                                  mapa[y][x].set_coords(x, y, width_cell, height_cell), mapa[y][x].get_rotation(), percent_your_colony)

                    inp1 = mapa[y][x].go_toward(input_bact)

                    soft_inp, rotate_count = inp1
                    What_should_to_do = np.argmax(soft_inp)

                    # bacteria DO

                    if mapa[y][x].get_energy() <= 0:
                        mapa[y][x] = 0
                        continue

                    if What_should_to_do == 0:  # rotate bacteria
                        mapa[y][x].rotate(rotate_count)

                    if What_should_to_do == 1:  # go toward bacteria
                        if isCellClass(torward_cell_direct) == 1:
                            pass
                        else:
                            mapa[torward_y][torward_x] = mapa[y][x]
                            mapa[y][x] = 0

                    if What_should_to_do == 2:  # eat bacteria
                        if isCellClass(torward_cell_direct):
                            mapa[y][x].energy_up_after_eat()
                            mapa[torward_y][torward_x] = 0

                    if What_should_to_do == 3:  # photosintese
                        mapa[y][x].photosintese()

                    if What_should_to_do == 4:  # multiply
                        if isCellClass(torward_cell_direct):
                            pass
                        else:
                            mapa[torward_y][torward_x] = bact_mind(
                                layers, len_of_w1, len_of_inp, len_of_out, mapa[y][x].get_gen())

                            mapa[y][x].multiply_energy()

                    # DRAW
                    if isCellClass(mapa[y][x]):
                        r0 = pygame.Rect(x * len_of_cell, y *
                                         len_of_cell, len_of_cell, len_of_cell)

                        r = pygame.Rect(x * len_of_cell + border_cell, y * len_of_cell + border_cell,
                                        len_of_cell - (border_cell*2), len_of_cell - (border_cell*2))
                        color = tuple(mapa[y][x].get_color())
                        pygame.draw.rect(screen, bd_c, r0)
                        pygame.draw.rect(screen, color, r)

    pygame.time.delay(delay)
