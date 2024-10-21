# ----------------------------------------
#
# Listas.
#
# ----------------------------------------

# Las listas se parecen a los vectores, pero tienen una propiedad que los
# distingue radicalmente de éstos: pueden contener elementos de distinto tipo.

l <- list(
  "a",
  1,
  TRUE,
  c(1, 2, 3),
  list("a", "b", 2)
)

l

class(l)
typeof(l)

# Son indexables, como los vectores, pero hay que tener muy en cuenta su
# estructura interna, que puede ser bastante caótica.

l[1]

class(l[1])
typeof(l[1])

l[2]

class(l[2])
typeof(l[2])

# Como se puede observar, internamente, las listas contienen listas en sí mismas.

# Para acceder al elemento en sí hay que hacer doble indexación:

l[[2]]

class(l[[2]])
typeof(l[[2]])

# Y por supuesto, si el elemento es otra lista u otro vector, entonces hay
# indexaciones en cascada:

l[4]

l[[4]]

l[[4]][2]

is.atomic(l[5])

is.atomic(l[[5]])

a <- l[[5]][[1]]

is.atomic(a)

# Al igual que los vectores, las listas pueden tener nombres:

l <- list(
  a = "a",
  b = 1,
  c = TRUE,
  d = c(1, 2, 3),
  e = list(
    e1 = "a",
    e2 = "b",
    e3 = 2
  )
)

names(l)

# La indexación de listar por nombre se puede hacer como la de los vectores:a

l["a"]

is.atomic(l["a"])

l[["a"]]

is.atomic(l[["a"]])

# o con el operador, más limpio, "$", ya que nos devuelve directamente el valor
# contenido en la lista, como si hiciéramos una doble indexación [[]]:

l$e

is.atomic(l$e)

l$e$e2

is.atomic(l$e$e2)
