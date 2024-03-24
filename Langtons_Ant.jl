using Plots
gr()

# Начальные параметры
field_size = 100  # Размер поля
steps = 30000     # Количество шагов
field = falses(field_size, field_size)
directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]  # Вверх, вправо, вниз, влево
x, y = field_size ÷ 2, field_size ÷ 2  # Начальное положение муравья
direction = 2  # Начальное направление (вверх = 0, вниз = 2, вправо = 1, влево =3 )

# Определение переменной matrice
matrice = [field]

# Функция для обновления поля
function update(frame, matrice)
    global x, y, direction, field
    if field[mod1(x+1, field_size), mod1(y+1, field_size)]  # Если белая клетка
        direction = mod(direction + 1, 4)  # Поворот направо
    else  # Если чёрная клетка
        direction = mod(direction - 1, 4)  # Поворот налево
    end
    field[mod1(x+1, field_size), mod1(y+1, field_size)] = !field[mod1(x+1, field_size), mod1(y+1, field_size)]  # Смена цвета клетки
    x, y = x + directions[direction+1][1], y + directions[direction+1][2] # Движение вперёд
    x, y = mod1(x, field_size), mod1(y, field_size)  # Обработка выхода за границы
    push!(matrice, copy(field))
    return matrice
end

# Подготовка анимации
anim = @animate for i in 1:steps
    global matrice
    matrice = update(i, matrice)
    heatmap(matrice[i], c=:Greys, axis=false, legend=false)
end

gif(anim, "langtons_ant.gif", fps = 60)