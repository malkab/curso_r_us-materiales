# Cargar librerías
library(dplyr)
library(lwgeom)
library(raster)
library(rjson)
library(sf)
library(units)
library(readxl)

# Leer formatos externos
st_read("data/13_01_TerminoMunicipal.shp")
st_read("data/barcelona_sscc.gpkg", layer = "grid_250m")
raster("data/b_1-ultrablue.tif")
read_excel("data/excel.xlsx", sheet = "Hoja B", col_names = FALSE)
