# Cargamos la librería Terra
library(terra)

# Cargamos la escena
scene <- rast("datos/030-resultados/escena.tif")

scene

# Calculamos el NDVI y lo guardamos como una nueva capa en la escena.
scene$ndvi <- (scene$nir - scene$red) / (scene$nir + scene$red)

scene$ndvi

# Visualizamos el NDVI.
plot(
  scene$ndvi,
  col = terrain.colors(100),
  main = "NDVI",
  legend = TRUE
)

# Vamos a aplicar una máscara para separar el NDVI en tierra y agua.
scene$ndvi_mascara <- scene$ndvi > 0

# Creamos nuevas capas para tierra y agua.
scene$ndvi_tierra <- mask(
  scene$ndvi, scene$ndvi_mascara, maskvalue = FALSE)

scene$ndvi_agua <- mask(
  scene$ndvi, scene$ndvi_mascara, maskvalue = TRUE)

names(scene)

# Visualizamos.
plot(
  scene$ndvi_tierra,
  col = terrain.colors(100),
  main = "NDVI",
  legend = TRUE
)

# Generamos un histograma del NDVI.
hist(
  values(scene$ndvi_tierra),
  breaks = 50,
  col = "grey",
  main = "Histograma del NDVI",
  xlab = "NDVI",
  ylab = "Frecuencia"
)

# Generamos un boxplot del NDVI.
boxplot(
  values(scene$ndvi_tierra),
  main = "Boxplot del NDVI",
  ylab = "NDVI",
  col = "grey"
)

# Vamos a reclasificar los valores del NDVI en clases temáticas.
reclasificacion <-
  matrix(
    c(
      -Inf, 0, 1,  # Agua
      0, 0.2, 2,   # Suelo desnudo
      0.2, 0.5, 3, # Vegetación rala
      0.5, 0.8, 4, # Vegetación media
      0.8, Inf, 5  # Vegetación vigorosa
    ),
  ncol = 3,
  byrow = TRUE)

reclasificacion

# Aplicamos.
scene$ndvi_reclas <- classify(scene$ndvi, reclasificacion)

scene$ndvi_reclas

# Vamos a definir nombres para la leyenda.
legend_labels <- c(
  "Agua",
  "Suelo desnudo",
  "Vegetación rala",
  "Vegetación media",
  "Vegetación vigorosa"
)

# Mostramos el resultado, con una leyenda temática.
plot(
  scene$ndvi_reclas,
  col = c("blue", "yellow", "lightgreen", "green", "darkgreen"),
  main = "Reclassified NDVI",
  legend = FALSE
)

# Add the legend to the plot
legend(
  "bottomleft",
  legend = legend_labels,
  fill = c("blue", "yellow", "lightgreen", "green", "darkgreen"),
  title = "NDVI Classes",
  inset = c(0.025, 0),
  bg = "white"
)

# Contamos el número de píxeles en cada clase.
ndvi_clas_n <- freq(scene$ndvi_reclas)

# Calculamos el área en km2 de cada clase, en función de la resolución del pixel
# de la escena.
ndvi_clas_n$ext_km2 <-
  ndvi_class_counts$count *
  res(scene)[1] *
  res(scene)[2] /
  1000000

ndvi_clas_n
