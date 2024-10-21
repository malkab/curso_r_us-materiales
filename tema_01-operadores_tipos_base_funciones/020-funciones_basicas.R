# ----------------------------------------
#
# Funciones básicas
#
# ----------------------------------------

# Una función en un lenguaje de programación es constructo lógico de computación
# que se encarga de realizar una tarea específica.

# Imitan a las funciones matemáticas, por ejemplo:

# f(x,y) = 2x + 3y + 1

# en el sentido de que, al igual que éstas, admiten una serie de variables
# independientes, a las que se les llama "argumentos" o "parámetros" de la
# función y devuelven un resultado, que se correspondería en el caso de las
# fórmulas matemáticas con lo que se denomina las variables dependientes.

# A diferencia de las funciones matemáticas, que funcionan proporcionando
# números como variables independientes, las funciones de un lenguaje de
# programación pueden recibir cualquier número y tipo de argumentos que requiera
# para llevar a cabo su tarea.

# En última instancia, escribir programas que no sean triviales consiste en
# escribir decenas o cientos de estas pequeñas (o grandes, pero pequeñas quedan
# mejor) funciones que tomando unos datos de entrada los procesan, hacen un
# trabajo específico y devuelven un resultado.

# Un lenguaje como R viene cargado de miles de estas funciones para llevar a
# cabo las tareas más dispares. El principio fundamental de funcionamiento es
# siempre el mismo:

# argumentos -> función -> resultado

# pero los propósitos de las funciones y la naturaleza y número tanto de sus
# argumentos de entrada como de salida son muy específicos a su diseño.



# ----------------------------------------
#
# Funciones básicas aritméticas
#
# ----------------------------------------

# Valor absoluto de un número

abs(-3)

# Raíz cuadrada de un número

sqrt(4)

# Exponente natural (número e)

exp(2)

# Logaritmo natural (e)

log(10)

# Logaritmo en base 10

log10(100)

# Logaritmo en base 2

log2(8)



# ----------------------------------------
#
# Funciones básicas de redondeo
#
# ----------------------------------------

# Redondeo a un número determinado de decimales

round(3.1134, 2)
round(3.1193, 2)

# Redondeo hacia arriba al próximo entero

ceiling(2.1)

# Hacia abajo

floor(2.9)

# truncar la parte entera

trunc(2.75)



# ----------------------------------------
#
# Funciones trigonométricas
#
# ----------------------------------------

# Seno y arcoseno

sin(pi / 2)
asin(1)

# Coseno y arcocoseno

cos(0)
acos(1)

# Tangente y arcotangente

tan(pi / 4)
atan(1)



# ----------------------------------------
#
# Composición de funciones
#
# ----------------------------------------

# Es muy importante entender que las funciones se pueden componer, es decir, se
# pueden utilizar las salidas de unas funciones como entradas de otras
# funciones. Por ejemplo:

round(sin(331 / floor(23.45)), 2)

# Que se compone del resultado de

floor(23.45)

# dividiendo a 331

331 / floor(23.45)

# a cuyo resultado se le calcula el seno

sin(331 / floor(23.45))

# y que acaba, finalmente, siendo redondeado a dos decimales

round(sin(331 / floor(23.45)), 2)



# ----------------------------------------
#
# Consultar la documentación
#
# ----------------------------------------

# R y R Studio vienen con una buena base de documentación aparte de la ingente
# cantidad de la misma que se puede consultar en Internet.

# Para acceder a la documentación de una función se puede buscar directamente en
# el panel "Help" de resultados o usar la función "help":

help("round")
