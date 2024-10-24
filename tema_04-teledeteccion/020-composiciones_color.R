# Cargamos la librería Terra
library(terra)

# Cargamos la escena
scene <- rast("datos/030-resultados/escena.tif")

# Mostramos la composición de color
plotRGB(
  scene,
  r = "red",
  g = "gre",
  b = "blu",
  stretch = "lin"
)

# Para guardarla en PNG, definimos un fichero de salida.
png(
  filename = "datos/030-resultados/escena_rgb.png",
  width = 2000,
  height = 1000
)

# Volvemos a generar la imagen.
plotRGB(
  scene,
  r = "red",
  g = "gre",
  b = "blu",
  stretch = "lin"
)

# Y finalmente cerramos el fichero PNG.
dev.off()
