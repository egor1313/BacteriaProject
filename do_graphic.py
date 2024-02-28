import pandas as pd
import matplotlib.pyplot as plt
import mplcyberpunk
import numpy as np

# Загрузить данные из CSV файла
folder = "1BEOO40715"
L = 50
R = -1
data = pd.read_csv(folder + "/stats/table.csv")
opa = {
    'Epoch_count': data['Epoch_count'][L:R],
    "Agent's size": data["Agent's size"][L:R],
    'Size of predators': data["Size of predators"][L:R],
    'Size of sun eaters': data["Size of sun eaters"][L:R],
    'Size of organics eaters': data["Size of organics eaters"][L:R],
}
df = pd.DataFrame(opa)
#plt.style.use('seaborn-v0_8-dark-palette')

# Создать график
with plt.style.context('cyberpunk'):
    fig = plt.figure(figsize=(7, 4))
    
    ax = fig.add_subplots(4, 1)
    ax[0].plot(df['Epoch_count'], df["Agent's size"], 'w',
            lw=0.6)
    plt.xlabel('Количество эпох')
    plt.ylabel('Количество агентов')
    plt.grid()
    ax[1].plot(df['Epoch_count'], df['Size of predators'], 'r', 
            lw=0.6)
    plt.xlabel('Количество эпох')
    plt.ylabel('Количество агентов')
    plt.grid()
    ax[2].plot(df['Epoch_count'], df['Size of sun eaters'], 'g',
            lw=0.6)
    plt.xlabel('Количество эпох')
    plt.ylabel('Количество агентов')
    plt.grid()
    ax[3].plot(df['Epoch_count'], df["Size of organics eaters"], 'b',
            lw=0.6)
    plt.xlabel('Количество эпох')
    plt.ylabel('Количество агентов')
    plt.grid()
    #df.plot(x='Epoch_count', kind='line',
    #        lw=1,marker='', ms=20,
    #        figsize=(17,11))
    #mplcyberpunk.make_lines_glow()
    #mplcyberpunk.add_gradient_fill(alpha_gradientglow=0.4)
    #plt.plot(data['Epoch_count'], data["Agent's size"])

    #plt.xlabel('Количество эпох')
    #plt.ylabel('Количество агентов')
    #plt.title('Количественная характеристика численности агентов')
    plt.savefig(folder + "/agents_count_graphic.png")
    plt.show()
    #plt.savefig(folder + "/agents_count_graphic.png")
