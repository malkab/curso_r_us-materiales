# ----------------------------------------
#
# Tipos de datos escalares o atómicos
#
# ----------------------------------------

# El concepto de tipo de dato es fundamental en cualquier lenguaje de
# programación. Para ser eficientes en el manejo de la memoria, los ordenadores
# y los lenguajes de programación tienen que tener una idea muy precisa del tipo
# de dato que se está manejando en cada momento, ya que tiene un impacto directo
# en la cantidad de memoria que se usa y cómo la CPU va a operar con ellos.

# Primero vamos a ver los datos escalares o atómicos, que son los más sencillos.
# Se corresponden con un único valor individual.

# R tiene cinco tipos de datos escalares o atómicos:

# - Lógicos
# - Numéricos
# - Enteros
# - Complejos
# - Caracteres

# Los datos lógicos son TRUE y FALSE. Se usan para representar valores de verdad
# o falsedad.

TRUE

FALSE

# Los datos numéricos son los números reales. Se pueden representar con o sin
# decimales.

3.14

-3.14

5

# Los datos enteros son los números enteros. Se pueden representar con o sin
# signo.

-5L

5L

# Los datos complejos son los números complejos. Se representan con la parte
# real y la parte imaginaria.

1 + 2i

# Los datos de caracteres son los textos. Se representan con comillas simples o
# dobles.

"Esto es un texto"

"Esto también es un texto"

# Para saber si un determinado datos es atómico, algo importante en ciertas
# circunstancias y que no siempre es obvio, se puede usar la función is.atomic():
is.atomic(3)
is.atomic("Hola R")

# Los datos no atómicos son datos compuestos.


# ----------------------------------------
#
# Definición de variables
#
# ----------------------------------------

# Las variables son nombres que se utilizan para almacenar valores en la memoria
# del ordenador. Se pueden utilizar para almacenar cualquier tipo de dato. En R,
# las variables se definen con el operador de asignación, "<-", y se les da un
# nombre, que es sensible a las mayúsculas.

# Las variables son fundamentales en programación porque aportan dos ventajas
# fundamentales:

# - abstracción y simbolismo: de una forma similar a las matemáticas, el manejo
#   de símbolos abstractos en lugar de números concretos hace el código más
#   legible y flexible;

# - reutilización: una vez que se ha calculado un valor y se ha almacenado en
#   una variable, se puede utilizar en cualquier parte del código;

# - mutabilidad: las variables pueden ir mutando su valor según se vayan
#   sucediendo las operaciones de cálculo sobre ellas, si se requiere. También
#   pueden duplicarse, eliminarse o permanecer constantes durante toda la
#   ejecución del programa.

# Para crear una variable de tipo numérico, por ejemplo:

a <- 3
b <- 5.6
c <- a + b

# También se pueden crear variables de tipo texto:

texto_a <- "soy un texto"
texto_b <- "yo otro"

# Recordar que los nombres de variables en R son sensibles a las mayúsculas:

texto_a == texto_b

# Se pueden reasignar valores a variables existentes:

texto <- "soy un texto"

texto == Texto

# R es altamente coercitivo en lo que se refiere a los tipos de datos, ojo a
# esto:

a <- 3
b <- 3L
c <- "3"

# Examinamos los tipos y las clases de estas variables con las utilísimas
# funciones class() y typeof(). Estas importantes funciones son críticas cuando
# se tuercen las cosas y tenemos que depurar nuestro programa en busca de
# errores que en R a veces no son nada aparentes:

class(a)
class(b)
class(c)

typeof(a)
typeof(b)
typeof(c)

# Esto es muy de R, cualquier otro lenguaje no lo permitiría:

a == b
a == c
b == c

# La función identical() es muchísimo más estricta ya que comprueba valor y
# tipo:

identical(a, b)
identical(a, c)
identical(b, c)

# Cambiamos el valor de "a" a un 3 entero:

a <- 3L

identical(a, b)



# ----------------------------------------
#
# Guardar y salvar el espacio de trabajo
#
# ----------------------------------------

# En R, el espacio de trabajo es el entorno de trabajo actual, que incluye todas
# las variables y funciones que se han definido en la sesión actual. Cuando se
# cierra R, el espacio de trabajo se pierde, a menos que se guarde
# explícitamente.

# Para guardar el espacio de trabajo, se puede usar la función save.image():

save.image("datos_sesion.RData")

# Para cargar un espacio de trabajo guardado, se puede usar la función load():

load("datos_sesion.RData")
