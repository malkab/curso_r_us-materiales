# ----------------------------------------
#
# Ejercicios 001
#
# ----------------------------------------

# 1. Escribir una expresión que pruebe (TRUE) que 5 dividido entre 2 es mayor
#    que 1 más 1

5 / 2 > 1 + 1

# 2. Escribir una expresión que pruebe (TRUE) que 7 es un número impar

7 %% 2 == 1



# ----------------------------------------
#
# Ejercicios 002
#
# ----------------------------------------

# 1. Demostrar (TRUE) que la tangente del ángulo pi/4 se define como el cociente
#    del seno y el coseno de ese mismo ángulo.

tan(pi / 4) == sin(pi / 4) / cos(pi / 4)

# 2. La esfericidad de un polígono (lo "redondito" o compacto que es) se define
#    como el cociente entre 2 veces la raíz cuadrada del producto de pi por el
#    área del polígono y el perímetro del propio polígono.

#    Este índice está normalizado entre 0 y 1, siendo 1 el valor que corresponde
#    a un círculo perfecto y los valores cercanos a 0 polígonos muy poco
#    compactos, muy alargados o irregulares.

#    Calcular la esfericidad de estos dos municipios, redondeada a dos
#    decimales:
#
#      - Cádiz:       área 12.31 km2, perímetro 52.03 km
#      - Villablanca: área 98.58 km2, perímetro 38.32 km

round((2 * sqrt(pi * 12.31)) / 52.03, 2)
round((2 * sqrt(pi * 98.58)) / 38.32, 2)



# ----------------------------------------
#
# Ejercicios 003
#
# ----------------------------------------

# 1. Reescribir el ejercicio 2 del script 002 (el de la esfericidad) pero usando
#    variables en la expresión de cálculo, de forma que en lugar de tener que
#    reescribir la fórmula para cada municipio, se pueda hacer una sola vez y
#    luego cambiar los valores de las variables para cada municipio.

area <- 12.31
perimetro <- 52.03

esfericidad <- round((2 * sqrt(pi * area)) / perimetro, 2)

# 2. Crear variables para las áreas de estos tres municipios:
#
#    - Cádiz:        12.31 km2
#    - Villablanca:  98.58 km2
#    - Sevilla:     142.13 km2
#
#    Calcular la media de estos valores usando variables.

area_cadiz <- 12.31
area_villablanca <- 98.58
area_sevilla <- 142.13

area_media <- (area_cadiz + area_villablanca + area_sevilla) / 3
