# Cargamos librerías

# Para información vectorial.
library(sf)

# Tibble, para DataFrames más amigables en información vectorial.
library(tibble)

# dplyr, siempre, para trabajar con la información alfanumérica de la
# información vectorial.
library(dplyr)

# terra, para ráster.
library(terra)

# Para que no nos avasallen con notación científica.
options(scipen = 999)


# ------------------------------
#
# Lectura del shapefile de municipios
#
# ------------------------------

# Cargamos un Shapefile de municipios de Andalucía.
municipios <-
  st_read("datos/010-originales/13_01_TerminoMunicipal.shp")

municipios

# Convertimos su tabla de atributos en un tibble.
municipios <- as_tibble(municipios)

municipios

# Y lo volvemos a convertir en un juego de datos espaciales vectoriales,
# pero con la ventaja de tener la información alfanumérica en un tibble.
municipios <- st_as_sf(municipios)

municipios

# Vemos la estructura de datos de la tabla de atributos.
summary(municipios)

# Utilizamos dplyr para eliminar la columna "id_dera", que no nos interesa.
municipios <- municipios |> select(-id_dera)

municipios

# Vamos a hacer una estadística de cuántos municipios hay por provincia. Por
# el camino, sf nos va a generar los polígonos de las provincias a partir de
# los municipos.
provincias <- municipios |>
  group_by(provincia) |>
  summarise(n = n()) |>
  ungroup()

provincias

# Nos quedamos sólo con los municipios de Cádiz.
municipios <- municipios |>
  filter(provincia == "Cádiz")

municipios

# Guardamos ambos resultados vectoriales, los municipios de Cádiz y las provincias,
# en un GeoPackage nuevo.
st_write(
    municipios,
    "datos/030-resultados/resultados.gpkg",
    layer = "municipios_cadiz",
    delete_layer = TRUE
  )

st_write(
    provincias,
    "datos/030-resultados/resultados.gpkg",
    layer = "provincias",
    delete_layer = TRUE
  )


# ------------------------------
#
# Lectura de las bandas de Landsat 8
#
# ------------------------------

# Leemos con terra una banda de Landsat 8, la UltraBlue.
ubl <- rast("datos/010-originales/b_1-ultrablue.tif")

# Le echamos un vistazo a sus metadatos.
ubl

# Y a sus dimensiones: 133 píxeles de alto (filas) y 2439 píxeles de ancho (columnas),
# con una sóla banda (tercera dimensión).
dim(ubl)

# La visualizamos (aunque también tenemos QGIS, claro), de un vistazo rápido.
plot(
  ubl,
  box = TRUE,
  main = "Banda UltraBlue",
  legend = "bottom"
)

# Un sumario estadístico sobre la banda.
summary(ubl, na.rm = TRUE)

# Uno exhaustivo, viendo cuántos píxeles hay con NA tiene.
global(ubl, na.rm = TRUE, fun = c("min", "max", "mean", "sd", "isNA"))

# Por supuesto, al ser una matriz numérica, podemos indexarla por filas y
# columnas. Aquí una extracción muy parcial del cuadrado que está entre
# 500 y 504 píxeles en ambas dimensiones.
ubl[500:504, 500:504]


# ------------------------------
#
# Composición de bandas en una escena.
#
# ------------------------------

# Leemos otra banda de Landsat 8, la Blue.
blu <- rast("datos/010-originales/b_2-blue.tif")

# Vemos que es geométricamente compatible con la anterior.
blu

# Por lo que podemos "apilarlas", es decir, crear una escena con ambas bandas en
# una estructura de datos tridimensional.
scene <- c(ubl, blu)

scene

# Como los nombres de las bandas que se han añadido al cubo son los de las
# fuentes de datos originales, vamos a crear dos vectores con nombres para las
# mismas, uno largo, para visualizaciones y demás, y otro corto, para poder
# hacer álgebra de capas en el futuro.
bandas_nom_corto <- c(
  "ubl",
  "blu"
)

bandas_nom_largo <- c(
  "UltraBlue",
  "Blue"
)

# Le asignamos a la escena de dos capas el nombre largo.
names(scene) <- bandas_nom_largo

scene

# Visualizamos.
plot(scene, box = TRUE, legend = "bottom")


# ------------------------------
#
# Montaje final de la escena.
#
# ------------------------------

# Cargamos todos los raster individuales.
gre <- rast("datos/010-originales/b_3-green.tif")
red <- rast("datos/010-originales/b_4-red.tif")
nir <- rast("datos/010-originales/b_5-nir.tif")
sw1 <- rast("datos/010-originales/b_6-swir1.tif")
sw2 <- rast("datos/010-originales/b_7-swir2.tif")

# Componemos con las 7 bandas.
scene <- c(ubl, blu, gre, red, nir, sw1, sw2)

# Ahora podemos consultar todas las bandas de un pixel.
scene[500, 500, ]

# U obtener subconjuntos de bandas.
scene[[c("red", "gre", "blu")]]

# Y les asignamos nombres.
bandas_nom_corto <- c(
  "ubl",
  "blu",
  "gre",
  "red",
  "nir",
  "sw1",
  "sw2"
)

bandas_nom_largo <- c(
  "UltraBlue",
  "Blue",
  "Green",
  "Red",
  "Near Infrared",
  "Shortwave Infrared 1",
  "Shortwave Infrared 2"
)

# Le asignamos nombres largos y visualizamos.
names(scene) <- bandas_nom_largo

plot(scene, box = TRUE, legend = FALSE)

# Le asignamos nombres cortos y guardamos la escena en un GeoTIFF multidimensional.

names(scene) <- c("ubl", "blu", "gre", "red", "nir", "sw1", "sw2")

scene

writeRaster(
  scene,
  "datos/030-resultados/escena.tif",
  filetype = "GTiff",
  overwrite = TRUE
)
