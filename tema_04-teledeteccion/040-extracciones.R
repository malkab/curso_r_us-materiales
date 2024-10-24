# Cargamos la librería Terra.
library(terra)

# Para vectorial.
library(sf)

# reshape2 es una librería para modificar la estructura de un data frame.
library(reshape2)

# ggplot2
library(ggplot2)

# Cargamos la escena
scene <- rast("datos/030-resultados/escena.tif")

# Cargamos los municipios de Cádiz
municipios <-
  st_read(
    "datos/030-resultados/resultados.gpkg",
    layer = "municipios_cadiz")

scene

municipios

# Vamos a extraer una región de la escena en coordenadas proyectadas.
extension <- ext(741269, 790930, 4025777, 4051872)
zona_ext <- crop(scene, extension)

# Visualizamos.
plot(zona_ext)

# Ahora vamos a extraer por polígonos de la capa de municipios.

# Filtramos el polígono de Chiclana
sel_mun <- municipios |>
  filter(nombre %in%
    c("Chiclana de la Frontera", "Alcalá de los Gazules", "Puerto Real"))

sel_mun

# Añadimos el número de fila como columna con el nombre ID, que lo usaremos después.
sel_mun <- rownames_to_column(sel_mun, var = "ID")

str(sel_mun)

sel_mun

# Extraemos los píxeles dentro de los polígonos de ambos municipios.
ext_mun <- extract(scene, sel_mun, )

head(ext_mun)

str(ext_mun)

summary(ext_mun)

levels(as.factor(ext_mun$ID))

# Unimos los datos extraídos con los de los municipios, y hacemos limpieza de
# columnas.
ext_mun <- ext_mun |>
  mutate(ID = as.character(ID)) |>
  left_join(sel_mun, by = "ID") |>
  select(
    nombre, everything(), -cod_mun, -provincia, -geom, -ID
  )

head(ext_mun)

dim(ext_mun)

# Creamos un boxplot de los píxeles extraídos, totales.
boxplot(
    ext_mun |> select(-nombre),
    main = "Signatura completa",
    xlab = "Bandas", ylab = "Valores radiométricos"
  )

ext_mun

# Desentrañamos la estructura columnar para pasar a una estructura de filas más
# sencilla.
ext_mun <- melt(ext_mun, id.vars = "nombre")

head(ext_mun)

str(ext_mun)

levels(as.factor(ext_mun$nombre))

levels(as.factor(ext_mun$variable))

# Creamos el boxplot de las signaturas comparadas.
ggplot(ext_mun, aes(x = variable, y = value, fill = nombre)) +
  geom_boxplot() +
  labs(title = "Signaturas comparadas",
       x = "Bandas", y = "Valores de Píxel") +
  theme_minimal()
