# Cargamos la librería Terra.
library(terra)

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

scene

# Vamos a extraer una región de la escena en coordenadas proyectadas.
extension <- ext(741269, 790930, 4025777, 4051872)
zona_ext <- crop(scene, extension)

zona_ext

# Calculamos el kmeans de la zona, con 2 clústeres en este caso
kmeans <- k_means(zona_ext, 8)

plot(kmeans)

# Añadimos el kmeans al raster original.
zona_ext$kmeans <- kmeans

# Creamos un boxplot de los píxeles extraídos, totales.
# Convertimos zona_ext a un data frame para facilitar la creación del boxplot.
zona_ext_df <- as.data.frame(zona_ext, xy = FALSE)

head(zona_ext_df)

# Hacemos un melt conservando los valores de la clusterización.
zona_ext_df <- melt(zona_ext_df, id.vars = "kmeans")

# Convertimos los clústeres en factor para visualizar el boxplot.
zona_ext_df$kmeans <- as.factor(zona_ext_df$kmeans)

head(zona_ext_df)

levels(zona_ext_df$kmeans)

# Creamos el boxplot de los valores radiométricos por cluster.
# Creamos el boxplot de las signaturas comparadas.
ggplot(zona_ext_df, aes(x = variable, y = value)) +
  geom_boxplot(aes(fill = kmeans)) +
  labs(title = "Signaturas comparadas",
       x = "Bandas", y = "Valores de Píxel")
