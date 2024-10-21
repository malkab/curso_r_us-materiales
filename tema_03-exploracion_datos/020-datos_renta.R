library(dplyr)
library(readr)
library(stringr)
library(ggplot2)
library(ggrepel)

# Cargamos los datos de renta, esta vez de un CSV.
rentas <- read_csv("datos/010-originales/ieca_renta.csv")

# Exploramos la estructura de los datos cargados.
spec(rentas)
str(rentas)
colnames(rentas)
rownames(rentas)

rentas

# El primer problema que nos encontramos es que el código municipal se ha
# perdido. Por un lado, hay una columna cod_prov con el código de la provincia,
# y otro con el nombre de la provincia.

# Para más problemas, estos dos datos han pasado por un proceso (una carga
# descuidada de los datos en Excel, por ejemplo) que ha hecho que dichos códigos
# pasen a ser de tipo numérico, y no de tipo character, perdiendo los necesarios
# ceros a la izquierda.

# Hay que restaurar estos códigos a su forma natural si queremos poder unirlos a
# los datos de educación, que sí tienen los códigos municipales completos.

# Para ello, tenemos que trabajar con cadenas de caracteres. Existen multitud de
# funciones para modificarlas, sobre todo en el excelente paquete stringr.

# stringr tiene la función perfecta para este trabajo: str_pad. Esta función
# añade un determinado carácter a una cadena de caracteres por la izquierda
# hasta que esta tenga una longitud determinada, justo lo que necesitamos. La
# transformación de los códigos de la provincia, por tanto, implica los
# siguientes pasos.

# 1. Convertir la columna cod_prov y cod_mun a character.

n4 <- as.character(4)
n1 <- as.character(1)

n4
n1

# 2. Añadir ceros a la izquierda hasta que la longitud sea de 2 caracteres.

n4 <- str_pad(n4, width = 2, pad = "0")
n1 <- str_pad(n1, width = 3, pad = "0")

n4
n1

# 3. Unir ambas cadenas modificadas para obtener el código completo. Para ello
# utilizaremos la función paste0, que une cadenas de caracteres sin añadir
# ningún separador.

cod_final <- paste0(n4, n1)
cod_final

# Ahora, todo junto, aplicado al DataFrame rentas completo:

rentas <- rentas |>
  mutate(
    cod_prov = str_pad(as.character(cod_prov), width = 2, pad = "0"),
    cod_mun = paste0(
      cod_prov,
      str_pad(as.character(cod_mun), width = 3, pad = "0")
    )
  )

rentas

# Dejamos de todas formas el campo cod_prov para más adelante, por si queremos
# hacer cálculos agrupados por provincia.

# Obtenemos ahora distintos DataFrames para cada año, filtrando por la columna
# de año:

# Como recordatorio, los años presentes en la columna anyo:
unique(rentas$anyo)

r_2018 <- rentas |>
  filter(anyo == 2018)

r_2019 <- rentas |>
  filter(anyo == 2019)

r_2020 <- rentas |>
  filter(anyo == 2020)

r_2021 <- rentas |>
  filter(anyo == 2021)

r_2021

# Utilizaremos los datos del año 2018, que son los que tenemos más cerca de los
# de educación (2011).

# Vamos ahora a crear un pequeño DataFrame con los nombres de las provincias
# para poder añadirlos a los datos de renta de 2018. Esto será de utilidad para
# la fase de visualización de los datos.

nombre_provincias <- tibble(
  cod_prov = c("04", "11", "14", "18", "21", "23", "29", "41"),
  provincia = c("Almería", "Cádiz", "Córdoba", "Granada",
                "Huelva", "Jaén", "Málaga", "Sevilla")
)

nombre_provincias

# Unimos con un left_join los datos de renta con los nombres de las provincias y
# nos quedamos con las columnas que nos interesan.

r_2018 <- r_2018 |>
  left_join(nombre_provincias, by = "cod_prov") |>
  select(
    nombre,
    provincia,
    cod_mun,
    renta_neta_media_persona
  )

r_2018

# Cargamos los datos de educación que preparamos antes:
educacion <- read_csv("datos/030-resultados/ieca_educacion_2011.csv")

spec(educacion)

r_2018

educacion

dim(r_2018)
dim(educacion)

# Tenemos un problema: hay más municipios en los datos de 2018 que en los de
# 2011. Esto siempre tiene que ser investigado utilizando la pertinente función
# anti_join.

# Comprobamos que hay 14 nuevos municipios en 2018 que no existían en 2011:
r_2018 |>
  anti_join(educacion, by = "cod_mun")

# Mientras que todos los municipios de 2011 están en 2018:
educacion |>
  anti_join(r_2018, by = "cod_mun")

# Así que nos olvidaremos de esos 14 municipios y seguiremos adelante con los
# del 2011 exclusivamente. Para eso usamos el inner_join:
data <- r_2018 |>
  inner_join(educacion, by = "cod_mun") |>
  select(
    nombre = nombre.x,
    everything(),
    -nombre.y
  )

data

# Ya tenemos todo lo que necesitamos. Vamos a crear una nueva columna que sea la
# suma total de los efectivos educativos, para la visualización:

data <- data |>
  mutate(
    total_educacion =
      sin_educacion_basica +
      educacion_basica +
      fp +
      universitaria
  )

summary(data)

data |>
  group_by(provincia) |>
  summarise(
    mean = mean(renta_neta_media_persona, na.rm = TRUE),
    min = min(renta_neta_media_persona, na.rm = TRUE),
    max = max(renta_neta_media_persona, na.rm = TRUE),
    range = diff(range(renta_neta_media_persona, na.rm = TRUE)),
    sd = sd(renta_neta_media_persona, na.rm = TRUE),
    q_10 = quantile(renta_neta_media_persona, probs =
                      c(0.10, 0.25, 0.5, 0.75, 0.90), na.rm = TRUE)[1],
    q_25 = quantile(renta_neta_media_persona, probs =
                      c(0.10, 0.25, 0.5, 0.75, 0.90), na.rm = TRUE)[2],
    q_50 = quantile(renta_neta_media_persona, probs =
                      c(0.10, 0.25, 0.5, 0.75, 0.90), na.rm = TRUE)[3],
    q_75 = quantile(renta_neta_media_persona, probs =
                      c(0.10, 0.25, 0.5, 0.75, 0.90), na.rm = TRUE)[4],
    q_90 = quantile(renta_neta_media_persona, probs =
                      c(0.10, 0.25, 0.5, 0.75, 0.90), na.rm = TRUE)[5],
    iqr = IQR(renta_neta_media_persona, na.rm = TRUE)
  ) |>
  ungroup()

# Guardamos el DataFrame en un fichero CSV.
write.csv(
  data,
  "datos/030-resultados/datos_finales.csv",
  row.names = FALSE
)

# Comenzamos con los gráficos. Primero vamos a ver histogramas de la renta media
# para cada provincia.

# Histograma para toda Andalucía
options(scipen = 999)

# Histograma para toda Andalucía
ggplot(data, aes(x = renta_neta_media_persona)) +
  # geom_histogram(bins = 40, fill = "darkgrey") +
  geom_density(color = "darkgrey", fill = "darkgrey", alpha = 0.5) +
  geom_point(
    aes(
      y = 0,
      size = total_educacion / 1000,
      color = indice_educacion
    ),
    alpha = 0.5
  ) +
  scale_size_continuous(range = c(2, 12)) +
  scale_color_viridis_c(option = "magma") +
  labs(
    title = "Distribución de la renta neta media por persona en Andalucía",
    x = "Renta neta media por persona",
    y = "Frecuencia",
    color = "Índice de educación",
    size = "Total de efectivos educativos (en miles)"
  )

# Histogramas por provincia
ggplot(data, aes(x = renta_neta_media_persona)) +
  # geom_histogram(bins = 40, fill = "darkgrey") +
  geom_density(color = "darkgrey", fill = "darkgrey", alpha = 0.5) +
  geom_point(
    aes(
      y = 0,
      size = total_educacion / 1000,
      color = indice_educacion
    ),
    alpha = 0.5
  ) +
  scale_size_continuous(range = c(2, 12)) +
  scale_color_viridis_c(option = "magma") +
  facet_wrap(~provincia) +
  labs(
    title = "Distribución de la renta neta
             media por persona en Andalucía, por provincias",
    x = "Renta neta media por persona",
    y = "Frecuencia",
    color = "Índice de educación",
    size = "Total de efectivos educativos (en miles)"
  )

# Análisis con BoxPlots
ggplot(data, aes(x = provincia, y = indice_educacion)) +
  geom_boxplot(aes(fill = provincia)) +
  labs(
    title = "Distribución de la renta neta media por
    persona en Andalucía, por provincias",
    x = "Provincia",
    y = "Renta neta media por persona"
  )

# Calculamos los municipios que son top en total_educación, indice_educacion,
# y renta_neta_media_por_persona
top_total_educacion <- data |>
  top_n(10, total_educacion)

bottom_total_educacion <- data |>
  top_n(-10, total_educacion)

top_indice_educacion <- data |>
  top_n(10, indice_educacion)

bottom_indice_educacion <- data |>
  top_n(-10, indice_educacion)

top_renta <- data |>
  top_n(10, renta_neta_media_persona)

bottom_renta <- data |>
  top_n(-10, renta_neta_media_persona)

tops <- distinct(
  rbind(
    top_total_educacion,
    bottom_total_educacion,
    top_indice_educacion,
    bottom_indice_educacion,
    top_renta,
    bottom_renta
  )
)

# Scatterplot
ggplot(
  data, # |> filter(provincia %in% c("Sevilla", "Córdoba", "Cádiz", "Huelva")),
  aes(x = renta_neta_media_persona, y = indice_educacion)
) +
  geom_point(
    aes(
      color = provincia,
      size = total_educacion / 1000
    ),
    alpha = 0.5
  ) +
  geom_smooth(
    method = "lm",
    color = "grey",
    se = TRUE,
    fill = "lightblue",
    na.rm = TRUE
  ) +
  # |> filter(provincia %in% c("Sevilla", "Córdoba", "Cádiz", "Huelva")),
  geom_text_repel(
    data = tops,
    aes(
      label = nombre
    ),
    size = 3
  ) +
  scale_size_continuous(range = c(2, 12)) +
  facet_wrap(~provincia) +
  labs(
    title = "Renta neta media por persona
              frente a índice de educación en Andalucía",
    x = "Renta neta media por persona",
    y = "Índice de educación",
    color = "Provincia",
    size = "Total de efectivos educativos (en miles)"
  )
