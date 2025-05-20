library(dplyr)
library(sf)
library(data.table)

# Daten einlesen
df_merged <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")

# Falls df_merged keine sf ist
df_merged <- st_as_sf(df_merged, coords = c("lng", "lat"), crs = 4326)

# LOR-Geometrien laden
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"
lor <- st_read(lor_url) %>%
  select(bzr_id, bzr_name, geom) %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
  st_transform(4326)

# Join: Punkte mit LOR verknüpfen
df_merged_mit_lor <- st_join(df_merged, lor[, c("bzr_id", "bzr_name")], left = TRUE)

# Summe je LOR berechnen
df_merged_mit_lor_sum <- df_merged_mit_lor %>%
  group_by(bzr_id, bzr_name) %>%
  summarise(gesamt_bewaesserung_lor = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
  ungroup()

# Geometrien hinzufügen
df_merged_sum_with_geom <- lor %>%
  left_join(st_drop_geometry(df_merged_mit_lor_sum), by = "bzr_id")

# Optional: speichern
st_write(df_merged_sum_with_geom, "data/df_merged_mit_lor_und_sum.geojson", driver = "GEOJSON", delete_dsn = TRUE)
