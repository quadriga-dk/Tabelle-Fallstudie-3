library(shiny)
library(leaflet)          # Interaktive Karten mit OpenStreetMap
library(ggplot2)          # Erstellen von Diagrammen und Visualisierungen
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

# Daten laden
# In df_merged und df_merged_sum enthalten  
# df <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"

lor <- st_read(lor_url) %>%
      select(bzr_id, bzr_name, geom) %>%
      st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
      st_transform(4326)  # Zu WGS84 transformieren

lors <- st_read(lor_url) %>%
  st_transform(4326)  # Zu WGS84 transformieren

# pumpen <- st_read("data/pumpen.geojson")
pumpen_mit_bezirk <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
pumpen_mit_lor <- st_read("data/pumpen_mit_lor.geojson")
# st_layers("https://gdi.berlin.de/services/wfs/lor_2019?REQUEST=GetCapabilities&SERVICE=wfs")
df_merged_sum_distanz_umkreis_pump_ok_lor <- fread("data/df_merged_sum_mit_distanzen_mit_umkreis_gesamter_Baumbestand_nur_Pumpen_ok_lor.csv",sep = ";", encoding = "UTF-8")
df_merged_sum_mit_distanzen_mit_umkreis <- fread("data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv", sep = ";", encoding = "UTF-8")

glimpse(df_merged_sum_distanz_umkreis_pump_ok_lor)
glimpse(lor)

# df_merged <- read.csv("data/df_merged_minimal.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
df_merged <- fread("data/df_merged_final.csv", sep = ";",  , encoding = "UTF-8")
df_merged_mit_lor_sum <- st_read("data/df_merged_mit_lor_und_sum.geojson")
# df_merged_sum_pump_ok <- read.csv("data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# df_merged <- read.csv("data/df_merged_gesamter_baumbestand_minimal.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# df_merged_sum <- read.csv("data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
#df_merged_sum <- read.csv("data/df_merged_gesamter_baumbestand_sum.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# df_merged_sum <- read.csv("data/df_merged_sum.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

# # Zähle die Bäume, die einen NA-Wert in der 'bezirk'-Spalte haben
# na_count <- df_merged %>% filter(is.na(bezirk)) %>% nrow()
# 
# # Ausgabe der Anzahl
# print(paste("Bezirk mit NA:", na_count))
# 
# # Zeilen mit NA in der 'bezirk'-Spalte finden
# na_rows <- df_merged %>% filter(is.na(bezirk))
# 
# # Zeilen mit NA in 'bezirk' und die 'gisid' der betroffenen Bäume anzeigen
# na_gisid <- na_rows %>% select(gisid)
# 
# # Zeilen-Nummern der betroffenen Bäume herausfinden
# na_row_numbers <- which(is.na(df_merged$bezirk))
# 
# # Ausgabe der 'gisid' und Zeilennummern
# print(na_gisid)
# print(na_row_numbers)



# Nicht mehr nötig da der Datensatz auf die angegeben Spalten minimiert wurde
# df_merged <- df_merged[, .(pitid, lat, lng, gattung_deutsch, art_dtsch, hausnr, strname, bewaesserungsmenge_in_liter, bezirk, timestamp, pflanzjahr)]

bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")
# df_merged_sum_mit_distanzen_mit_umkreis <- read.csv("data/df_merged_sum_mit_distanzen_mit_umkreis.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# df_merged_sum_mit_distanzen_mit_umkreis <- read.csv("data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# df_merged_sum_mit_distanzen_mit_umkreis_pump_ok <- read.csv("data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

df_merged_sum_distanz_umkreis_pump_ok_lor_clean <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
  drop_na(timestamp)
print(sum(is.na(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)))
print(str(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp))

df_merged_clean <- df_merged %>%
  drop_na(bezirk, timestamp, gattung_deutsch)

#glimpse(df_merged)


# head(baum_strasse_df)

pumpen_mit_bezirk$label_text <- ifelse(
  as.character(pumpen_mit_bezirk$id)
)

# Zur Fehleranaylse
# print(nrow(df_merged))
# print(df_merged %>% drop_na(lat, lng) %>% nrow())
# print(df_merged %>% filter(strname != "Undefined", strname != "") %>% nrow())
# print(df_merged %>% filter(strname != "Undefined", strname != "", !str_detect(gattung_deutsch, "[0-9]")) %>% nrow())
# print(n_distinct(df_merged$pitid))




# Farbpalette für die Bewässerungsmengen in der Karte definieren
#color_palette <- colorNumeric(palette = "Blues", domain = c(0, 1200))

# Entfernen von fehlenden Werten
# df_clean <- df_merged %>%
#   # filter(str_detect(timestamp, "^\\d{4}-\\d{2}-\\d{2}")) %>%  # Nur gültige ISO-Formate
#   mutate(timestamp = ymd_hms(timestamp)) %>%
#   drop_na(lat, lng) # %>%
#   # filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))

# df_merged_sum$lng <- as.numeric(gsub(",", ".", df_merged_sum$lng))
# df_merged_sum$lat <- as.numeric(gsub(",", ".", df_merged_sum$lat))
# 
# df_merged_sum_pump_ok$lng <- as.numeric(gsub(",", ".", df_merged_sum_pump_ok$lng))
# df_merged_sum_pump_ok$lat <- as.numeric(gsub(",", ".", df_merged_sum_pump_ok$lat))

df_merged_sum_distanz_umkreis_pump_ok_lor$lng <- as.numeric(gsub(",", ".", df_merged_sum_distanz_umkreis_pump_ok_lor$lng))
df_merged_sum_distanz_umkreis_pump_ok_lor$lat <- as.numeric(gsub(",", ".", df_merged_sum_distanz_umkreis_pump_ok_lor$lat))

# df_merged_sum$durchschnitts_intervall <- as.numeric(gsub(",", ".", df_merged_sum$durchschnitts_intervall))
# df_merged_sum_pump_ok$durchschnitts_intervall <- as.numeric(gsub(",", ".", df_merged_sum_pump_ok$durchschnitts_intervall))
df_merged_sum_distanz_umkreis_pump_ok_lor$durchschnitts_intervall <- as.numeric(gsub(",", ".", df_merged_sum_distanz_umkreis_pump_ok_lor$durchschnitts_intervall))

# Datentypen korrigieren in numeric
df_merged$pflanzjahr <- as.numeric(df_merged$pflanzjahr)
df_merged$bewaesserungsmenge_in_liter <- as.numeric(df_merged$bewaesserungsmenge_in_liter)

# baum_strasse_df <- st_transform(baum_strasse_df, crs = 4326)
# 
# #Extrahieren der Koordinaten aus der Geometry-Spalte
# coords <- st_coordinates(baum_strasse_df$geom)
# baum_strasse_df$lng <- coords[, "X"]
# baum_strasse_df$lat <- coords[, "Y"]
# 
# baum_strasse_df <- st_drop_geometry(baum_strasse_df)
# 
# df_merged <- baum_strasse_df %>%
#   left_join(df_clean %>% select(id, bewaesserungsmenge_in_liter, timestamp),
#             by = c("pitid" = "id"))
# 
# 
# write.csv2(df_merged, "data/df_merged.csv", row.names = FALSE, fileEncoding = "UTF-8")


# Zum erstellen der df_merged_sum CSV Datei
#  df_merged_sum <- df_merged %>%
#    group_by(pitid) %>%
#    summarise(
#      gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
#      .groups = "drop"  # Verhindert die Warnung über Gruppierung
#    ) %>%
#    left_join(df_merged, by = "pitid")
# 
# 
# 
# # Wird in df_merged_sum vorberechnet
#  # 1. Intervall berechnen
#  bewässerungs_frequenz <- df_merged %>%
#    group_by(pitid) %>%
#    filter(n() > 1) %>%
#    arrange(pitid, timestamp) %>%
#    mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
#    summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
#    ungroup()
# 
#  # 2. Mit df_merged zusammenführen
#  df_merged <- df_merged %>%
#    left_join(bewässerungs_frequenz, by = "pitid")
# 
#  # 3. Inf setzen für fehlende Intervalle
#  df_merged$durchschnitts_intervall[is.na(df_merged$durchschnitts_intervall)] <- Inf
# 
#  # 4. df_merged_sum mit allen nötigen Infos bauen
#  df_merged_sum <- df_merged %>%
#    group_by(pitid) %>%
#    summarise(
#      gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
#      durchschnitts_intervall = unique(durchschnitts_intervall),
#      lat = first(lat),
#      lng = first(lng),
#      gattung_deutsch = first(gattung_deutsch),
#      art_dtsch = first(art_dtsch),
#      hausnr = first(hausnr),
#      strname = first(strname),
#      bezirk = first(bezirk),
#      bewaesserungsmenge_in_liter = first(bewaesserungsmenge_in_liter),
#      timestamp = first(timestamp),
#      .groups = "drop"
#   )
#  write.csv2(df_merged_sum, file = "data/df_merged_sum.csv", sep = ";")

# Erstellen eines DataFrames mit Bezirksflächen
bezirksflaechen <- data.frame(
  bezirk = c("Mitte", "Friedrichshain-Kreuzberg", "Pankow", "Charlottenburg-Wilmersdorf",
             "Spandau", "Steglitz-Zehlendorf", "Tempelhof-Schöneberg", "Neukölln",
             "Treptow-Köpenick", "Marzahn-Hellersdorf", "Lichtenberg", "Reinickendorf"),
  flaeche_ha = c(3.940, 2.040, 10.322, 6.469, 9.188, 10.256, 5.305, 4.493, 16.773, 6.182, 5.212, 8.932)
)

# Zusammenführen mit deinem bestehenden DataFrame df_merged_sum
df_merged_sum_distanz_umkreis_pump_ok_lor <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
  left_join(bezirksflaechen, by = "bezirk")


# Anzahl gegossener Bäume je Bezirk
baumanzahl_pro_bezirk <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
  group_by(bezirk) %>%
  summarise(baumanzahl = n_distinct(gisid))

# Mit Fläche kombinieren und Bäume pro ha berechnen
baum_dichte <- baumanzahl_pro_bezirk %>%
  left_join(bezirksflaechen, by = "bezirk") %>%
  mutate(baeume_pro_ha = baumanzahl / flaeche_ha)