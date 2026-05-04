## Code for 3.2. Vorbereitung der Daten: Einlesen und Bereinigung
## Creates the df_merged_final.csv file needed for the dashboard

library(sf)
library(dplyr)
library(tidyr)
library(stringr)

#0 CSV File lokalisieren bzw. laden
local_path <- "data/giessdenkiez_bewässerungsdaten.csv"
url_path <- "https://raw.githubusercontent.com/technologiestiftung/giessdenkiez-de-opendata/main/daten/giessdenkiez_bew%C3%A4sserungsdaten.csv"

if (file.exists(local_path)) {
  csv_data <- local_path
} else {
  csv_data <- url_path
}

# 1. Baumbestandsdaten laden
anlagenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:anlagenbaeume")
strassenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")

# 2. Bewässerungsdaten laden und bereinigen
df_clean <- read.csv(csv_data, sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
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

# 8. Ungültige Pflanzjahre herausfiltern
current_year <- as.integer(format(Sys.Date(), "%Y"))

df_merged <- df_merged %>%
  mutate(pflanzjahr = as.numeric(pflanzjahr)) %>%
  filter(is.na(pflanzjahr) | (nchar(as.character(as.integer(pflanzjahr))) == 4 & pflanzjahr <= current_year)) 

# 9. Ergebnis speichern
if (!dir.exists("data")) dir.create("data")
write.csv2(df_merged, "data/df_merged_final.csv", row.names = FALSE, fileEncoding = "UTF-8")

# 10. Kontrolle: Anzahl der Zeilen
cat("Anzahl Bäume nach Merge:", nrow(df_merged), "\n")
cat("Anzahl eindeutiger Bäume (pitid):", n_distinct(df_merged$pitid), "\n")
cat("Anzahl Bäume mit Bewässerungsdaten:", sum(!is.na(df_merged$bewaesserungsmenge_in_liter)), "\n")

#################2nd part###################

# 1. Lade die Bezirkspolygone
local_geojson <- "data/bezirksgrenzen.geojson"
url_geojson <- "https://raw.githubusercontent.com/quadriga-dk/Tabelle-Fallstudie-3/6cd488f5f4306f9788bda3166d5929ad64312349/data/bezirksgrenzen.geojson"

if (file.exists(local_geojson)) {
  bezirksgrenzen <- st_read(local_geojson)
} else {
  
  if (!dir.exists("data")) {
    dir.create("data")
  }
  
  download.file(url = url_geojson, destfile = local_geojson)
  
  bezirksgrenzen <- st_read(local_geojson)
}

# 2. Lade die Baumdaten
df_baeume <- read.csv("data/df_merged_final.csv", sep = ";", stringsAsFactors = FALSE)

# 3. Koordinaten korrekt umwandeln
df_baeume <- df_baeume %>%
  mutate(
    lng = as.numeric(gsub(",", ".", lng)),
    lat = as.numeric(gsub(",", ".", lat))
  )

# 4. Zerlege in zwei Gruppen
df_mit_bezirk <- df_baeume %>% filter(!is.na(bezirk))
df_ohne_bezirk <- df_baeume %>% filter(is.na(bezirk) & !is.na(lng) & !is.na(lat))

# 5. Konvertiere nur die ohne Bezirk zu sf
df_ohne_bezirk_sf <- st_as_sf(df_ohne_bezirk, coords = c("lng", "lat"), crs = 4326, remove = FALSE)

# 6. Bezirkspolygone vorbereiten
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = st_crs(df_ohne_bezirk_sf)) %>%
  rename(bezirk = Gemeinde_name)

# 7. Räumlicher Join
df_ohne_bezirk_joined <- st_join(df_ohne_bezirk_sf, bezirksgrenzen["bezirk"], left = TRUE)

# 8. In DataFrame zurückwandeln
df_ohne_bezirk_filled <- df_ohne_bezirk_joined %>%
  mutate(bezirk = ifelse(is.na(bezirk.x), bezirk.y, bezirk.x)) %>%
  select(-bezirk.x, -bezirk.y) %>%
  st_drop_geometry()

# 9. Zusammenführen mit ursprünglichen Daten, die bereits einen Bezirk hatten
df_baeume_final <- bind_rows(df_mit_bezirk, df_ohne_bezirk_filled)

# 10. Ergebnis speichern
if (!dir.exists("data")) dir.create("data")
write.csv2(df_baeume_final, file = "data/df_merged_final.csv", row.names = FALSE)