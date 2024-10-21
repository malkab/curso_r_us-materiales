# ----------------------------------------
#
# Vectores.
#
# ----------------------------------------

# Los vectores son la estructura de datos más básica en R, pero sin duda una de
# las más potentes y capaces.

# Están muy optimizados por el lenguaje para que las operaciones sobre ellos
# sean muy rápidas. R es un lenguaje vectorial muy capaz, es decir, permite
# operar directamente, con una sintaxis muy limpia y clara, sobre vectores de
# datos, replicando tras las bambalinas las operaciones sobre cada elemento del
# vector, de forma transparente para el usuario, con un rendimiento muy alto.

# Como nada es gratis, el vector consigue esta eficiencia computacional
# imponiendo una restricción: todos los elementos de un vector deben ser del
# mismo tipo de dato. Un vector no puede contener a la vez números y caracteres,
# por ejemplo, y aquí la coerción automática de R entrará en juego, así que hay
# que tener cuidado.

# Para crear un vector se usa la función c() (de "combine" o "concatenate"):

vector_a <- c(2, 3, 4)

class(vector_a)
typeof(vector_a)

# Los vectores son altamente coercitivos, puesto que sólo pueden contener un
# tipo de dato:
coer <- c(3, 2, "A")

class(coer)
typeof(coer)

coer <- c(3, 2, "33")

coer

class(coer)
typeof(coer)

coer <- c(3, 0, 1, TRUE, FALSE)

coer

class(coer)
typeof(coer)

# ¡Ojo! A diferencia de otros lenguajes y de lo que se pudiera pensar, la
# reasignación de un vector a otra variable provoca la COPIA de la estructura de
# datos completa (cuidado si tenéis muchos datos con esta operación):

vector_b <- vector_a

identical(vector_a, vector_b)

# Pero lo bueno es que las variables son mutables, por lo que se pueden
# reutilizar:

vector_a <- c(3, 4, 5)

# R es un lenguaje eminentemente vectorial, capaz de realizar operaciones sobre
# vectores de datos. Por ejemplo:

vector_a + 10

# Como se puede ver, el resultado de una operación de suma de un vector con un
# escalar es la suma de dicho escalar A CADA ELEMENTO del vector, resultando la
# operación en un nuevo vector. Esto es lo que se denomina una operación
# vectorial.

# Por supuesto, también funciona entre vectores:

vector_a + vector_b

# La suma se ha realizado elemento a elemento.

# Podemos reutilizar uno de los vectores para acumular en memoria los cambios:

vector_a <- vector_a + 10
vector_a <- vector_a + vector_b

# Podemos averiguar la longitud de un vector:

length(vector_a)

# R, en su afán de ser un lenguaje legible, hace un uso muy extensivo de una
# característica que se llama el "broadcasting", que es la habilidad de intentar
# ajustar las dimensiones de estructuras de datos que no tienen la misma
# dimensionalidad:

vector_a <- c(1, 2, 3, 4)
length(vector_a)

vector_b <- c(2:1)
length(vector_b)

# En la definición del vector_b se ha usado el operador ":" en su acepción de
# generador de intervalo. Por ejemplo:

vector_2_8 <- 2:8
is.vector(vector_2_8)

vector_10_5 <- seq(10, 5, by = -2)
is.vector(vector_10_5)

# En la definición del vector_10_5 se ha usado la función seq() que es parecida
# al operador : pero más flexible, ya que permite crear secuencias con un paso,
# en este caso, -2. Otros ejemplos:

seq(2, 10, by = 3)
seq(100, 57, by = -13)

# Tanto el operador : como la función seq() son útiles para generar vectores con
# secuencias predefinidas, que tienen muchos usos en programación vectorial.

# Volviendo a la dimensionalidad, tenemos por lo tanto a vector_a y vector_b,
# con longitudes distintas:

length(vector_a)
length(vector_b)

# Pero, contra todo pronóstico, esto funciona perfectamente:

vector_a / vector_b

# R ha hecho "broadcasting" del vector menor vector_b para "estirar",
# repitiendo, sus valores para ajustarse a la longitud de vector_a. En realidad,
# lo que ha hecho R por nosotros es este cálculo implícito:

c(1, 2, 3, 4) / c(2, 1, 2, 1)

# Esto, otra vez contra todo pronóstico, es incluso posible. Redefinimos
# vector_a con tres componentes:

vector_a <- c(1, 2, 3)

vector_a / vector_b

# Al menos esta vez saca un "warning". Pero hacerlo lo hace. De todas formas,
# mucho ojo con estas cosas. Lo normal es operar con vectores de la misma
# dimensión, pero si son múltiplos exactos pues ya veis cómo va la cosa. Si no
# lo son... bueno, quizás habría que replantearse el problema. Sería raro.



# ----------------------------------------
#
# Funciones vectorizadas
#
# ----------------------------------------

# En el núcleo de R están lo que se llaman las funciones vectorizadas. Estas
# funciones son las que proporcionan la capacidad a R de operar eficientemente
# en memoria sobre sets de datos de forma muy rápida.

# Una función vectorizada es aquella que por definición acepta un vector como
# argumento. Estas funciones pueden devolver o bien otro vector o un escalar.

# Las funciones que devuelven escalares a partir de vectores son las que se
# utilizan frecuentemente para calcular medidas estadísticas sobre las
# observaciones contenidas en el vector. Por ejemplo, la función sum() es
# vectorizada y suma todos los elementos del vector argumento:

v <- c(11, 22, 33, 44, 100)

sum(v)

# La función mean(), por su parte, devuelve la media aritmética:
mean(v)

# La función median() devuelve la mediana:
median(v)

# La función sd() devuelve la desviación estándar:
sd(v)

# La función var() devuelve la varianza:
var(v)

# Las funciones min() y max() devuelven el mínimo y el máximo:
min(v)
max(v)

# La función range() devuelve un vector con el mínimo y el máximo:
range(v)

# La función diff() devuelve la diferencia entre cada par de elementos:
diff(v)

# La función sort() devuelve un vector ordenado:
sort(v, decreasing = TRUE)

# La función sample devuelve una muestra aleatoria de un vector:
sample(v, 30, replace = TRUE, prob = c(0.1, 0.2, 0.3, 0.4, 0.5))

# La función IQR devuelve el rango intercuartil:
IQR(v)

# La función quantile devuelve los cuantiles, con un alto grado de
# configuración:
quantile(v, probs = c(0.1, 0.25, 0.5, 0.75, 0.9))



# ----------------------------------------
#
# Indexación de vectores
#
# ----------------------------------------

# Los vectores de R tienen una alta capacidad de indexación, es decir, de
# acceder selectivamente a sus miembros. La indexación en R empieza en 1, no en
# 0 como en la mayoría de otros lenguajes.

nom_municipio <- c(
  "Abla",
  "Abrucena",
  "Adra",
  "Albanchez",
  "Alboloduy",
  "Albox",
  "Alcolea",
  "Alcóntar",
  "Alcudia de Monteagud",
  "Alhabia"
)

renta <- c(
  9556,
  9412,
  7845,
  8875,
  9559,
  8192,
  8449,
  10658,
  13455,
  7971
)

# Los valores en tercer lugar:
nom_municipio[3]
renta[3]

# Elementos del segundo al cuarto, incluidos:
nom_municipio[2:4]
renta[2:4]

# Hay que hacer notar que los que se devuelve es un nuevo vector:
mean(renta[2:4])

# Lo interesante es que la indexación también sirve para filtrar los elementos
# del vector que cumplen una condición:
renta > 9000

# Esto devuelve un vector lógico, que se puede usar para indexar el vector en sí
# mismo:
renta_9000 <- renta[renta > 9000]

# Que por supuesto es un vector:
mean(renta_9000)

# Por ejemplo, dado que nom_municipio y renta son vectores de la misma longitud
# que referencian características distintas de los mismos objetos (municipios),
# uno puede indexar al otro:
nom_municipio[renta > 9000]

# Todo ello porque renta > 9000 genera lo que se llama una "máscara lógica"
# aplicable bien al propio vector de renta o a otro vector que tenga una
# relación lógico-estructural-temática con el primero (basado en el orden
# original de los datos).


# ----------------------------------------
#
# Vectores y nombres
#
# ----------------------------------------

# Los vectores pueden tener nombres asociados a sus elementos. Esto es una
# característica muy extendida en R que es tremendamente útil para tratar datos
# de forma más clara, legible y ágil.

# Volvamos a nuestro ejemplo de los municipios y las rentas:by

nom_municipio

renta

# Si nos fijamos, R nos pasa por consola una sencilla representación de los
# vectores, sin nada que los identifique. Sin embargo, podemos asignar a los
# datos de renta los nombres de los municipios, dado que tienen, y esto es
# importante, la misma dimensión y hay una correspondencia uno a uno entre ambos
# vectores, con correspondencia posicional:

names(renta) <- nom_municipio

renta

# Ahora, R nos muestra en su salida que cada dato de renta lleva asociado un
# nombre. Este nombre es puramente informativo pero tiene también una función
# práctica en la indexación del vector:

renta["Adra"]
renta["Alcolea"]

renta["Adra"] + renta["Alcolea"]

renta[1:3]

# Esta capacidad de R de ponerle nombres a los índices es tremendamente útil y
# se encuentra en casi todos los objetos que maneja el lenguaje, haciendo la
# exploración de los mismos más sencilla y agradable.
