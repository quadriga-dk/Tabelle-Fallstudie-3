# Umsetzung mit R Shiny

## Vorbereitung der Daten: Einlesen und Bereinigung

Nachdem die Datenbasis bekannt ist, beginnt der erste praktische Schritt in der Datenverarbeitung: Das Einlesen der Datei in R und das Vorbereiten der Daten für eine spätere Analyse oder Visualisierung, z. B. auf einer Karte.

df_merged_final 
```bash
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

```
Allen Bäumen einen Bezirk zuweisen

```bash
library(sf)
library(dplyr)

# 1. Lade die Bezirkspolygone
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")

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
write.csv2(df_baeume_final, file = "data/df_merged_final.csv", row.names = FALSE)

```

Erstellen von df_merged_sum
```bash
df_merged_full <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")

# 1. Intervall berechnen
bewässerungs_frequenz <- df_merged_full %>%
    group_by(gisid) %>%
    filter(n() > 1) %>%
    arrange(gisid, timestamp) %>%
    mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days))) %>%
    summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
    ungroup()

# 2. Mit df_merged zusammenführen
df_merged_full <- df_merged_full %>%
    left_join(bewässerungs_frequenz, by = "gisid")

# 3. 0 setzen für fehlende Intervalle
df_merged_full$durchschnitts_intervall[is.na(df_merged_full$durchschnitts_intervall)] <- 0

# 4. df_merged_sum <- df_merged_full %>%
group_by(gisid) %>%
summarise(
gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
durchschnitts_intervall = unique(durchschnitts_intervall),
lat = first(lat),
lng = first(lng),
gattung_deutsch = first(gattung_deutsch),
art_dtsch = first(art_dtsch),
hausnr = first(hausnr),
strname = first(strname),
bezirk = first(bezirk),
bewaesserungsmenge_in_liter = first(bewaesserungsmenge_in_liter),
timestamp = first(timestamp),
.groups = "drop"
)

write.csv2(df_merged_sum, file = "data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";")
```

Pumpen Bezirks zuordnung

```bash
pumpen <- st_read("data/pumpen_minimal.geojson")
bezirksgrenzen <- st_read(data/bezirksgrenzen.geojson")

# Sicherstellen, dass beide im selben CRS sind (z.B. WGS84)
pumpen <- st_transform(pumpen, crs = 4326)
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = 4326)

# Räumlicher Join: Pumpen bekommt den Namen des Bezirks, in dem sie liegt
pumpen_mit_bezirk <- st_join(pumpen, bezirksgrenzen[, c(Gemeinde_name")], left = TRUE)

pumpen_mit_bezirk <- pumpen_mit_bezirk %>% 
    rename(bezirk = Gemeinde_name)

# GeoJSON-Datei speichern
st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk.geojson", driver = "GeoJSON", delete_dsn = TRUE)
```

Pumpen Distanz vorberechnung 

```bash
library(data.table)
library(sf)
library(dplyr)
library(stringr)
library(tidyr)
library(nngeo)

# # 1. Daten einlesen
 pumpen_mit_bezirk <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
 df_merged_sum <- read.csv("data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

 pumpen_mit_bezirk_ok <- pumpen_mit_bezirk %>%
   filter(pump.status == "ok")
 
# 2. Koordinaten umwandeln (Komma zu Punkt)
df_merged_sum <- df_merged_sum %>%
  mutate(
    lat = as.numeric(str_replace(lat, ",", ".")),
    lng = as.numeric(str_replace(lng, ",", "."))
  ) %>%
  drop_na(lat, lng)

# 3. sf-Objekte erstellen mit WGS84 (Geodätisch)
df_merged_sum_sf <- st_as_sf(df_merged_sum, coords = c("lng", "lat"), crs = 4326)
pumpen_sf <- st_transform(pumpen_mit_bezirk_ok, crs = 4326)

# 4. In metrisches CRS transformieren (z.B. UTM Zone 33N für Berlin)
df_merged_sum_sf_proj <- st_transform(df_merged_sum_sf, crs = 32633)
pumpen_sf_proj <- st_transform(pumpen_sf, crs = 32633)

# 5. Berechnung der Distanz zur nächsten Pumpe (nur die nächste)
nearest_index <- st_nn(df_merged_sum_sf_proj, pumpen_sf_proj, k = 1, returnDist = TRUE)

# 6. Extrahiere minimale Distanzen (in Meter)
min_dist <- sapply(nearest_index$dist, function(x) x[1])

# 7. Zurück ins ursprüngliche DataFrame
df_merged_sum$distanz_zur_pumpe_m <- as.numeric(min_dist)

write.csv2(df_merged_sum, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", row.names = FALSE, fileEncoding = "UTF-8")

```
Pumpen umkreis vorberechnung
```bash
    library(data.table)
    library(sf)
    library(dplyr)
    library(stringr)
    library(tidyr)
    library(nngeo)

  df_merged_sum_mit_distanzen <- read.csv("data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
  
  df_merged_sum_mit_distanzen$lat <- as.numeric(gsub(",", ".", df_merged_sum_mit_distanzen$lat))
  df_merged_sum_mit_distanzen$lng <- as.numeric(gsub(",", ".", df_merged_sum_mit_distanzen$lng))

  # 1. Rechnen
  df_giess_sf <- st_as_sf(df_merged_sum_mit_distanzen, coords = c("lng", "lat"), crs = 4326)
  pumpen_sf <- st_transform(pumpen_mit_bezirk_ok, crs = 4326)

  df_giess_sf_m <- st_transform(df_giess_sf, 3857)
  pumpen_sf_m <- st_transform(pumpen_sf, 3857)

  giess_buffer <- st_buffer(df_giess_sf_m, dist = 100)
  pumpen_im_umkreis <- lengths(st_intersects(giess_buffer, pumpen_sf_m))

  df_merged_sum_mit_distanzen$pumpen_im_umkreis_100m <- pumpen_im_umkreis

  # 2. Speichern
  write.csv2(df_merged_sum_mit_distanzen, "data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv", row.names = FALSE)

```
LOR Daten zu df_merged und df_merged_sum hinzufügen
```bash
library(sf)
library(dplyr)
library(readr)

# st_layers("https://gdi.berlin.de/services/wfs/lor_2019?REQUEST=GetCapabilities&SERVICE=wfs")

# 1. LOR-Daten korrekt einlesen
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"

lor <- st_read(lor_url) %>%
  st_transform(4326)  # Zu WGS84 transformieren

# 2. Baumdaten einlesen
# df_merged <- read_csv2("data/df_merged_final.csv",
#                       locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "UTF-8"))
# df_merged <- read_csv2("data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv",
#                  locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "UTF-8"))
df_merged <- read_csv2("data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv",
                       locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "UTF-8"))

# 3. Koordinaten bereinigen und konvertieren
df_merged <- df_merged %>%
  mutate(
    lng = as.numeric(gsub(",", ".", lng)),
    lat = as.numeric(gsub(",", ".", lat))
  ) %>%
  filter(!is.na(lng) & !is.na(lat))

# 4. In sf-Objekt umwandeln
trees_sf <- st_as_sf(df_merged, coords = c("lng", "lat"), crs = 4326)

# 5. Räumlichen Join durchführen (mit Fehlerbehandlung)
tryCatch({
  trees_with_lor <- st_join(trees_sf, lor, join = st_within)
  
  # 6. Nicht zugeordnete Bäume entfernen
  trees_with_lor <- trees_with_lor %>%
    filter(!is.na(bzr_id))
  
  # 7. Ergebnis speichern
  # st_write(trees_with_lor, "data/trees_with_lor.geojson", driver = "GeoJSON")
  #st_write(trees_with_lor, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok_lor.geojson", driver = "GeoJSON")
  st_write(trees_with_lor, "data/df_merged_sum_mit_distanzen_mit_umkreis_gesamter_Baumbestand_nur_Pumpen_ok_lor.geojson", driver = "GeoJSON")
  
  # Alternativ als CSV
  trees_csv <- trees_with_lor %>%
    mutate(
      lng = st_coordinates(.)[,1],
      lat = st_coordinates(.)[,2]
    ) %>%
    st_drop_geometry()
  
  #write_csv2(trees_csv, "data/trees_with_lor.csv")
  # write.csv2(trees_csv, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok_lor.csv")
  write.csv2(trees_csv, "data/df_merged_sum_mit_distanzen_mit_umkreis_gesamter_Baumbestand_nur_Pumpen_ok_lor.csv")
  
  message("Verarbeitung erfolgreich abgeschlossen!")
}, error = function(e) {
  message("Fehler bei der Verarbeitung: ", e$message)
  # Debug-Informationen
  message("LOR CRS: ", st_crs(lor)$input)
  message("Bäume CRS: ", st_crs(trees_sf)$input)
  message("Anzahl LOR-Features: ", nrow(lor))
  message("Anzahl Baum-Features: ", nrow(trees_sf))
})

```