library(dplyr)            # Datenmanipulation und Filterung
library(lubridate)        # Arbeiten mit Datums- und Zeitangaben
library(shinydashboard)
library(plotly)
library(leaflet.extras)
library(tidyr)
library(stringr)
library(shinyBS)
library(sf)
library(data.table)


pumpen <- st_read("data/pumpen.geojson")
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")

pumpen <- st_transform(pumpen, crs = 4326)
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = 4326)

pumpen_mit_bezirk <- st_join(pumpen, bezirksgrenzen[, c("Gemeinde_name")], left = TRUE)

pumpen_mit_bezirk <- pumpen_mit_bezirk %>%
  rename(bezirk = Gemeinde_name)

st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk.geojson", driver = "GEOJSON", delete_dsn = TRUE)