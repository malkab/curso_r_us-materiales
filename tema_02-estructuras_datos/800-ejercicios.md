# Ejercicios tema 02

Utilizaremos en estos ejercicios los datos contenidos en el espacio de trabajo R
"datos/vectores.RData".


## Unidad 010 - Vectores

1.  Encontrar los municipios con los 5 valores máximos y mínimos en los datos de
    renta del 2018, almacenarlos en memoria.

2.  A estos subconjuntos de datos, calcularles la media.

3.  Calcular la variación de renta entre ambos periodos para todos los
    municipios.

4.  Ver qué 3 municipios han incrementado más su renta y cuáles menos.

5.  Calcular las medias, los cuantiles principales y el rango intercuartil de
    estas medidas de incremento.

6.  Calcular el coeficiente de variación de los incrementos (desviación típica /
    media).


## Unidad 030 - DataFrames

1.  Montar un DataFrame con las columnas nom_mun, renta_2018 y renta_2021,
    asignándole por nombres "nombre", "r_18" y "r_21".

2.  Calcula la media de ambas rentas, pero usando esta vez los datos del
    DataFrame.

3.  Crear una nueva columna con el incremento de la renta en miles de euros,
    redondeando a 1 decimal.

4.  Extraer del DataFrame un nuevo DataFrame sólo con la columna nombre y el
    incremento de la renta y los municipios que tengan ese incremento por encima
    de 1.

5.  Del nuevo DataFrame anterior, extraer un vector con nombres de elementos
    asignados a los nombres de los municipios con el dato de incremento de
    renta.