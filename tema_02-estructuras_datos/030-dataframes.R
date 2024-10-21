# ----------------------------------------
#
# DataFrames.
#
# ----------------------------------------

# Los DataFrames son estructuras de datos bidimensionales, tablas. Estos son los
# DataFrames "nativos" de R, más adelante abundaremos mucho en otro tipo de
# DataFrame más capaz proporcionado por el paquete "tibble" del "tidyverse".

# Los DataFrames están compuestos por vectores internamente. Cada vector
# corresponde a una columna de datos. Utilizaremos los vectores de los
# municipios que ya hemos utilizado previamente:

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

df <- data.frame(
  nom_municipio = nom_municipio,
  renta = renta,
  provincia = c("Almería"),
  row.names = NULL
)

df

# Hemos creado un DataFrame con tres columnas: "nom_municipio", "renta" y
# "provincia". El valor de esta última lo hemos fijado a "Almería" para todas
# las filas.

# Podemos explorar los nombres de las columnas y las filas del DataFrame:

colnames(df)

rownames(df)

# colnames() devuelve el nombre de las columnas, mientras que rownames()
# devuelve el de las filas. Al igual que en los vectores, tener nombres en las
# filas es opcional pero tremendamente útil. Se le puede asignar un vector como
# tal. Utilizaremos el propio vector de nombres de municipios:

rownames(df) <- nom_municipio

df

# Podemos acceder a las columnas del DataFrame usando la notación "$":

df$renta

is.vector(df$renta)

df$renta[3]


# ----------------------------------------
#
# Indexación.
#
# ----------------------------------------

# Al ser una estructura bidimensional y tabular la indexación se produce a múltiples
# niveles:

# Por índices: fila 1, columna 2 (renta de Abla)

df[1, 2]
is.atomic(df[1, 2])

# Por nombres: fila "Abla", columna "renta"

df["Abla", "renta"]

# O toda una fila, por nombre:

df["Abla", ]

# Por rangos:

df[2:4, c("provincia", "renta")]

# Por máscaras lógicas:

df[df$renta > 9000, c("provincia", "renta")]

# Obteniendo todas las columnas:

df[df$renta > 9000, ]

# O todas las filas:

df[, c("provincia", "renta")]


# ----------------------------------------
#
# Operaciones sobre DataFrames.
#
# ----------------------------------------

# Al ser las columnas de los DataFrames vectores, podemos operar con ellos de la
# forma usual:

round(df$renta / 1000.0, 1)

# Y crear a partir de ellos nuevas columnas:

df$renta_miles <- round(df$renta / 1000.0, 1)

df

# Se pueden eliminar columnas:

df$renta_miles <- NULL

df

# Y añadir nuevas filas:

df <- rbind(
  df,
  data.frame(
    nom_municipio = "Almería",
    renta = 12345,
    provincia = "Almería"
  )
)

df

rownames(df) <- df$nom_municipio

df

# Sin embargo, todo esto es un poco engorroso, por lo que veremos en próximos
# temas una aproximación al trabajo con esta importantísima estructura de datos
# más eficiente y cómoda.