# Cargamos la librería Terra.
library(terra)

# Para vectorial.
library(sf)

# reshape2 es una librería para modificar la estructura de un data frame.
library(reshape2)

# ggplot.2
library(ggplot2)

# dplyr.
library(dplyr)

# tibble.
library(tibble)

# Cargamos la librería randomForest.
library(randomForest)

# Para crear paletas de colores.
library(RColorBrewer)

# Cargamos la zona de estudio
zona_ext <- rast("datos/030-resultados/zona_ext.tif")

# Cargamos las zonas de entrenamiento
entrenamiento <-
  st_read(
    "datos/900-copia_resultados/resultados.gpkg",
    layer = "zonas_entrenamiento")

zona_ext

entrenamiento

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
ext_ent <- extract(zona_ext, entrenamiento, ID = TRUE)

head(ext_ent)

str(ext_ent)

# Le hacemos un autojoin de vuelta con los datos de los polígonos de entrenamiento.
ext_ent <- ext_ent |> inner_join(entrenamiento, by = "ID")

head(ext_ent)

# Pero le quitamos la columna ID y la columna geometry porque ya no las
# necesitamos y molestarán en algunos procesos posteriores.
ext_ent <- ext_ent |> select(-ID, -geometry)

head(ext_ent)

# Hacemos un melt de los datos, para poder visualizarlos en un boxplot.
ext_ent_melt <- melt(ext_ent, id.vars = "clase")

ext_ent_melt$clase <- as.factor(ext_ent_melt$clase)

head(ext_ent_melt)

str(ext_ent_melt)

levels(ext_ent_melt$clase)

levels(ext_ent_melt$variable)

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

# Convertimos los datos de entrenamiento en un data frame.
datos_entrenamiento <- as.data.frame(ext_ent)

head(datos_entrenamiento)

levels(as.factor(datos_entrenamiento$clase))

# Definimos la fórmula para el modelo Random Forest.
formula_rf <- clase ~ .

# Entrenamos el modelo Random Forest.
modelo_rf <- randomForest(
  formula_rf,
  data = datos_entrenamiento,
  ntree = 100
)

# Mostramos el resumen del modelo.
modelo_rf

# Predecimos las clases para la zona de estudio.
predicciones <- predict(
  modelo_rf,
  as.data.frame(zona_ext)
)

head(predicciones)

# Convertimos las predicciones en un SpatRaster utilizando una de las capas de
# la zona de estudio original como plantilla.
predicciones_raster <- rast(zona_ext["ubl"])

predicciones_raster

# Cargamos los valores predichos por el modelo en el SpatRaster.
# Nótese que los valores predichos son probabilidades, no categorías.
values(predicciones_raster) <- predicciones

# Redondeamos a la categoría más cercana.
predicciones_cat <- round(predicciones_raster)

# Definimos una paleta de colores categórica.
paleta_colores <- brewer.pal(n = length(unique(predicciones_cat[])), name = "Set3")

paleta_colores

# Asignamos la paleta de colores al raster de predicciones.
plot(
  predicciones_cat,
  main = "Predicciones Random Forest",
  col = paleta_colores
)

# Escribimos el raster.
writeRaster(
  predicciones_cat,
  "datos/030-resultados/predicciones_cat.tif",
  overwrite = TRUE
)

# Vamos a ver los boxplots.
zona_ext$clusters <- predicciones_cat

zona_ext_df <- as.data.frame(zona_ext, xy = FALSE)

head(zona_ext_df)

# Hacemos el melt.
zona_ext_melt <- melt(zona_ext_df, id.vars = "clusters")

head(zona_ext_melt)

str(zona_ext_melt)

zona_ext_melt$clusters <- as.factor(zona_ext_melt$clusters)

# Creamos el boxplot de las signaturas comparadas.
ggplot(zona_ext_melt, aes(
    x = variable,
    y = value,
    fill = clusters
  )) +
  geom_boxplot() +
  labs(
    title = "Signaturas comparadas",
    x = "Bandas",
    y = "Valores radiométricos",
    fill = "Clase"
  )
