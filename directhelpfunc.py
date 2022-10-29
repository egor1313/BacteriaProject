



def direct_of_seeing(rotation):
    if rotation >= 0.5:
        return (1, 1)
    elif rotation >= 0.375:
        return (1, 0)
    elif rotation >= 0.125:
        return (1, -1)
       
    elif rotation >= -0.125:
        return (0, -1)

    elif rotation >= -0.375:
        return (-1, -1)
    elif rotation >= -0.5:
        return (-1, 0)
    elif rotation >= -0.75:
        return (-1, 1)

    elif rotation < -0.75:
        return (0, 1)
