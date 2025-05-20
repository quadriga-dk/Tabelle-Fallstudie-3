library(sf)
library(dplyr)
library(tidyr)
library(stringr)

# 1. Bäume laden
anlagenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:anlagenbaeume")
strassenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")

# 2. Bewässerungsdaten laden
df_clean <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
  drop_na(lng, lat, bewaesserungsmenge_in_liter) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))

# 3. Bäume zusammenführen
baumbestand <- bind_rows(anlagenbaeume, strassenbaeume) %>%
  st_transform(crs = 4326)

# 4. Geometrie extrahieren
coords <- st_coordinates(baumbestand$geom)
baumbestand$lng <- coords[, "X"]
baumbestand$lat <- coords[, "Y"]

# 5. Geometrie entfernen
baumbestand <- st_drop_geometry(baumbestand)

# 6. gisid anpassen (Unterstrich → Doppelpunkt)
baumbestand$gisid <- str_replace_all(baumbestand$gisid, "_", ":")

# 7. Bäume und Bewässerungsdaten mergen (über gisid = id)
df_merged <- baumbestand %>%
  left_join(df_clean %>% select(id, bewaesserungsmenge_in_liter, timestamp),
            by = c("gisid" = "id"))

# 8. Ergebnis speichern
write.csv2(df_merged, "data/df_merged_final.csv", row.names = FALSE, fileEncoding = "UTF-8")

# 9. Kontrolle: Anzahl der Zeilen
cat("Anzahl Bäume nach Merge:", nrow(df_merged), "\n")
cat("Anzahl eindeutiger Bäume (pitid):", n_distinct(df_merged$pitid), "\n")
cat("Anzahl Bäume mit Bewässerungsdaten:", sum(!is.na(df_merged$bewaesserungsmenge_in_liter)), "\n")
