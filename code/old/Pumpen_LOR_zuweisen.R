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


pumpen <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"

pumpen <- pumpen %>%
  filter(pump.status == "ok")

lor <- st_read(lor_url) %>%
  select(bzr_id, bzr_name, geom) %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
  st_transform(4326)  # Zu WGS84 transformieren

pumpen <- st_transform(pumpen, crs = 4326)

pumpen_mit_lor <- st_join(pumpen, lor[, c("bzr_name", "bzr_id")], left = TRUE)


st_write(pumpen_mit_lor, "data/pumpen_mit_lor.geojson", driver = "GEOJSON", delete_dsn = TRUE)