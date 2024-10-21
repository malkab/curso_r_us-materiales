library(readxl)
library(dplyr)
library(ggplot2)

# Cargamos los datos desde el Excel
ed_2011 <- read_excel("datos/020-preprocesados/ieca_educacion_2011.xls")

# Lo exploramos
str(ed_2011)
dim(ed_2011)
colnames(ed_2011)
rownames(ed_2011)

ed_2011

# Es evidente que el Excel tiene un problema de estructura, ya que se le han
# añadido varias filas de metadatos al principio y al final del fichero. Se
# limpian manualmente en Excel. Se eliminan las primeras 14 líneas. Se eliminan
# también las últimas en las que se describen la fuente de los datos y los
# significados de los no-data * y -. Repetimos la importación y la exploración
# de la misma.

# Vemos sin embargo que aún con esos cambios la estructura del DataFrame (un
# Tibble, en realidad) es un poco confusa puesto que ha tomado los nombres de
# las columnas de la primera fila de datos. Además, los tipos de datos no son
# los, ya que la presencia de los valores * y - en las columnas de datos para
# denotar diferentes circunstancias de no-data han cohercitado a estas columnas
# a ser de tipo character.

# Además, el productor de los datos ha incluido filas para totales para toda la
# CA de Andalucía y sus provincias. Estas filas no nos sirven, puesto que
# queremos trabajar a nivel de municipio.

# Afortunadamente, el productor ha incluido tres columnas con códigos INE: uno
# para la CA (CODIGO_INE1), otro para la provincia (CODIGO_INE2) y otro para el
# municipio (CODIGO_INE3).

# Por lo tanto, utilizando, dplyr, vamos a eliminar esas filas de síntesis.
# Utilizamos la negación (!) de la función is.na, que devuelve T o F dependiendo
# de si el valor es NA o no.

is.na(NA)
is.na(3)
!is.na(NA)
!is.na(3)

ed_2011 <- ed_2011 |>
  filter(!is.na(CODIGO_INE3))

# Ahora ya tenemos sólo las filas que nos interesan. Vemos que ya hay columnas
# que no necesitamos, como la de CODIGO_INE1 y CODIGO_INE2. Las eliminamos y
# renombramos las columnas que nos interesan con dplyr::select.

# Vemos las columnas con sus nombres completos, para referencia.
colnames(ed_2011)

ed_2011 <- ed_2011 |>
  select(
    nombre = Territorio,
    cod_mun = CODIGO_INE3,
    analf = "No sabe leer o escribir",
    no_primaria = "Fue a la escuela 5 o más años pero no llegó al último curso de ESO, EGB o Bachiller Elemental",
    primaria = "Llegó al último curso de ESO, EGB o Bachiller Elemental o tiene el Certificado de Escolaridad o de Estudios Primarios",
    bachillerato = "Bachiller (LOE, LOGSE), BUP, Bachiller Superior, COU, PREU",
    fp_medio = "FP grado medio, FP I, Oficialía industrial o equivalente, Grado Medio de Música y Danza, Certificados de Escuelas Oficiales de Idiomas",
    fp_superior = "FP grado superior, FP II, Maestría industrial o equivalente",
    diplomatura = "Diplomatura universitaria, Arquitectura Técnica, Ingeniería Técnica o equivalente",
    grado_univ = "Grado Universitario o equivalente",
    lic_univ = "Licenciatura, Arquitectura, Ingeniería o equivalente",
    master = "Máster oficial universitario (a partir de 2006), Especialidades Médicas o análogos",
    doctorado = "Doctorado"
  )

# Ahora hay que procesar los nulos * y - y convertirlos en NA. Hay muchas formas de
# hacerlo, desde la más simple, a otras extremadamente convolutas.

# La forma más simple es operar columna a columna con la función na_if.
# La función na_if devuelve NA si el primer argumento es igual al segundo.
ifelse(3 > 7 & 3 == 3, "X", "Y")

# Para tener las columnas frescas.
colnames(ed_2011)

# Declaramos una variable con el valor que queremos convertir en NA.
valor_na <- c("*", "-")

ifelse("*f" %in% valor_na, "X", "Y")

ed_2011 <- ed_2011 |>
  mutate(
    analf           = ifelse(analf %in% valor_na, 0, analf),
    no_primaria     = ifelse(no_primaria %in% valor_na, 0, no_primaria),
    primaria        = ifelse(primaria %in% valor_na, 0, primaria),
    bachillerato    = ifelse(bachillerato %in% valor_na, 0, bachillerato),
    fp_medio        = ifelse(fp_medio %in% valor_na, 0, fp_medio),
    fp_superior     = ifelse(fp_superior %in% valor_na, 0, fp_superior),
    diplomatura     = ifelse(diplomatura %in% valor_na, 0, diplomatura),
    grado_univ      = ifelse(grado_univ %in% valor_na, 0, grado_univ),
    lic_univ        = ifelse(lic_univ %in% valor_na, 0, lic_univ),
    master          = ifelse(master %in% valor_na, 0, master),
    doctorado       = ifelse(doctorado %in% valor_na, 0, doctorado),
  )

ed_2011

# Ahora que tenemos las columnas como queremos y los NA en su sitio, tenemos que generar
# los números.

ed_2011 <- ed_2011 |>
  mutate(
    analf           = round(as.numeric(analf)),
    no_primaria     = round(as.numeric(no_primaria)),
    primaria        = round(as.numeric(primaria)),
    bachillerato    = round(as.numeric(bachillerato)),
    fp_medio        = round(as.numeric(fp_medio)),
    fp_superior     = round(as.numeric(fp_superior)),
    diplomatura     = round(as.numeric(diplomatura)),
    grado_univ      = round(as.numeric(grado_univ)),
    lic_univ        = round(as.numeric(lic_univ)),
    master          = round(as.numeric(master)),
    doctorado       = round(as.numeric(doctorado))
  )

ed_2011

# Ahora vamos a agrupar las cifras de los efectivos de educación en 3 categorías:

# - Sin educación básica: analf, no_primaria
# - Educación básica: primaria, bachillerato
# - FP: fp_medio, fp_superior
# - Universitaria: diplomatura, grado_univ, lic_univ, master, doctorado

ed_2011 <- ed_2011 |>
  mutate(
    sin_educacion_basica = analf + no_primaria,
    educacion_basica = primaria + bachillerato,
    fp = fp_medio + fp_superior,
    universitaria = diplomatura + grado_univ + lic_univ + master + doctorado
  )

ed_2011

# Nos quedamos con las columnas que nos interesan.

colnames(ed_2011)

ed_2011 <- ed_2011 |>
  select(
    nombre,
    cod_mun,
    sin_educacion_basica,
    educacion_basica,
    fp,
    universitaria
  )

ed_2011

# Vamos a calcular la media ponderada de la educación global de cada municipio.
# Para ello, vamos a utilizar la función weighted.mean de R.
# Primero tenemos que definir un vector de pesos para cada categoría de educación.
# A cada categoría le damos un peso según lo importante que lo consideramos para
# la educación global de un municipio.
pesos_educacion <- c(
  sin_educacion_basica = 0.00,
  educacion_basica     = 0.25,
  fp                   = 0.25,
  universitaria        = 0.50
)

# La función weighted.mean de R toma dos argumentos: el vector de valores al que calcularle
# la media ponderada y el vector de pesos.

# Nótese que, para que la función weighted.mean funcione fila a fila en el DataFrame
# tenemos que usar la función rowwise de dplyr.
# Esta función hace que las operaciones se hagan fila a fila, en lugar de columna a columna,
# parándole al cálculo de weighted.mean un vector con los valores de cada fila de la tabla.
# De esta manera, weighted.mean, que necesita un vector para operar,

weighted.mean(c(0, 5), w = c(0.25, 0.75))

# Dividimos la media ponderada por la suma de los efectivos educativos para normalizar
# por habitante.

ed_2011 <- ed_2011 |>
  rowwise() |>
  mutate(
    indice_educacion = round(
      weighted.mean(
        c(sin_educacion_basica, educacion_basica, fp, universitaria),
        w = pesos_educacion,
        na.rm = TRUE
      ) / sum(sin_educacion_basica, educacion_basica, fp, universitaria),
      3
    )
  ) |>
  ungroup()

ed_2011 |>
  arrange(indice_educacion)

ed_2011 |>
  arrange(desc(indice_educacion))

top_50 <- ed_2011 |>
  top_n(50, indice_educacion) |>
  arrange(desc(indice_educacion))

print(top_50, n = 50)

bottom_50 <- ed_2011 |>
  top_n(-50, indice_educacion) |>
  arrange(desc(indice_educacion))

print(bottom_50, n = 100)

# Vamos a analizar un poco los datos generados para Andalucía.
ie <- ed_2011$indice_educacion

# El sumario de la variable:
summary(ie)

# Tenemos uno:
ed_2011 |> filter(is.na(indice_educacion))

# La media
mean(ie, na.rm = TRUE)

# Rango de la variable y su extensión
range(ie, na.rm = TRUE)
diff(range(ie, na.rm = TRUE))

# Cuantiles
quantile(ie, probs = c(0.1, 0.25, 0.5, 0.75, 0.90), na.rm = TRUE)

# Rango intercuartil (entre el Q1 y el Q3)
IQR(ie, na.rm = TRUE)

# La mediana
median(ie, na.rm = TRUE)

# Guardamos el DataFrame en un fichero CSV.
write.csv(
  ed_2011,
  "datos/030-resultados/ieca_educacion_2011.csv",
  row.names = FALSE
)
