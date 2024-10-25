# Cargamos la librería Terra.
library(terra)

# Para vectorial.
library(sf)

# reshape2 es una librería para modificar la estructura de un data frame.
library(reshape2)

# ggplot2
library(ggplot2)

# dplyr
library(dplyr)

# tibble
library(tibble)

# Cargamos la escena
scene <- rast("datos/030-resultados/escena.tif")

# Cargamos las zonas de entrenamiento
entrenamiento <-
  st_read(
    "datos/900-copia_resultados/resultados.gpkg",
    layer = "zonas_entrenamiento")

scene

entrenamiento

# Vamos a extraer una región de la escena en coordenadas proyectadas.
extension <- ext(741269, 790930, 4025777, 4051872)
zona_ext <- crop(scene, extension)

zona_ext

writeRaster(
  zona_ext,
  "datos/030-resultados/zona_ext.tif",
  overwrite = TRUE
)

# Visualizamos.
plot(zona_ext)

# Añadimos el número de fila como columna con el nombre ID, que lo usaremos después.
entrenamiento <- rownames_to_column(entrenamiento, var = "ID")

# Convertimos la columna ID en numérica, lo necesitaremos después para hacer un join.
entrenamiento$ID <- as.numeric(entrenamiento$ID)

str(entrenamiento)

entrenamiento

# Extraemos los píxeles dentro de los polígonos de las zonas de estudio. Nos
# devuelve un dataframe con los valores radiométricos de los píxeles y un campo
# ID con el ID del polígono de muestra donde se encuentra el píxel.
ext_ent <- extract(scene, entrenamiento, ID = TRUE)

head(ext_ent)

str(ext_ent)

# Le hacemos un autojoin de vuelta con los datos de los polígonos de entrenamiento.
ext_ent <- ext_ent |> inner_join(entrenamiento, by = "ID")

head(ext_ent)

# Pero le quitamos la columna ID y la columna geometry porque ya no las
# necesitamos y molestarán en algunos procesos posteriores.
ext_ent <- ext_ent |> select(-ID, -geometry)

head(ext_ent)

# Creamos un boxplot de los píxeles extraídos, totales.
boxplot(
    ext_ent |> select(-clase),
    main = "Signatura completa",
    xlab = "Bandas", ylab = "Valores radiométricos"
  )

# Desentrañamos la estructura columnar para pasar a una estructura de filas más
# sencilla. Esto nos permitirá hacer un boxplot de los valores de los píxeles
# por clase. La función "melt" "disuelve" la estructura de columnas en una
# estructura de filas, de forma que obtenemos una fila por cada valor de
# variable. Esta estructura es útil para hacer gráficos de una forma sencilla en
# estructuras de tablas complejas. De todas formas, no pisar los datos
# originales nunca, ya que esta modificación de la estructura de los datos es
# sólo para visualización.
ext_ent_melt <- melt(ext_ent, id.vars = "clase")

ext_ent_melt$clase <- as.factor(ext_ent_melt$clase)

head(ext_ent_melt)

str(ext_ent_melt)

levels(ext_ent_melt$clase)

levels(as.factor(ext_ent_melt$variable))

# Creamos el boxplot de las signaturas comparadas.
ggplot(ext_ent_melt, aes(
    x = variable,
    y = value,
    fill = clase
  )) +
  geom_boxplot() +
  labs(
    title = "Signaturas comparadas",
    x = "Bandas",
    y = "Valores radiométricos",
    fill = "Clase"
  )
