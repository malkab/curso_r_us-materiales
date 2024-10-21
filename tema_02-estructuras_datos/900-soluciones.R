# Pasos previos preparatorios

# Cargamos los datos
load("datos/vectores.RData")

# Vemos lo que viene en el paquete de datos con la función `ls()`, que nos muestra
# los objetos cargados actualmente en la memoria del kernel:
ls()

# Exploramos
renta_2018

renta_2021

nom_mun

# Ya que tenemos los nombres de los municipios, podemos asignarlos a los vectores:

names(renta_2018) <- nom_mun

names(renta_2021) <- nom_mun

renta_2018

renta_2021


# ----------------------------------------
#
# Soluciones 010 - Vectores
#
# ----------------------------------------

# 1

min_5 <- sort(renta_2018)[1:5]

min_5

max_5 <- sort(renta_2018, decreasing = TRUE)[1:5]

max_5

# 2

mean(min_5)

mean(max_5)

# 3

delta_renta <- renta_2021 - renta_2018

delta_renta

# 4

dr_min <- sort(delta_renta)[1:3]

dr_max <- sort(delta_renta, decreasing = TRUE)[1:3]

# 5

mean(dr_min)
quantile(dr_min, probs = c(0.1, 0.25, 0.5, 0.75, 0.9))
IQR(dr_min)

mean(dr_max)
quantile(dr_max, probs = c(0.1, 0.25, 0.5, 0.75, 0.9))
IQR(dr_max)

# 6

sd(delta_renta) / mean(delta_renta) * 100


# ----------------------------------------
#
# Soluciones 030 - DataFrames
#
# ----------------------------------------

# 1

# row.names en la creación del DataFrame asigna directamente los nombres de las
# filas.

df <- data.frame(
  nombre = nom_mun,
  r_18 = renta_2018,
  r_21 = renta_2021,
  row.names = nom_mun
)

df

# 2

mean(df$r_18)
mean(df$r_21)

# 3

df$r_delta <- round((df$r_21 - df$r_18) / 1000.0, 1)

df

# 4

sub_df <- df[df$r_delta > 1, c("nombre", "r_delta")]

sub_df

# 5

r_delta_v <- sub_df$r_delta

r_delta_v

names(r_delta_v) <- rownames(sub_df)

r_delta_v

is.vector(r_delta_v)
