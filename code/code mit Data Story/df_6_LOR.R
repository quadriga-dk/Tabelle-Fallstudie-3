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
df_merged <- read_csv2("data/df_letzt.csv",
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
  st_write(trees_with_lor, "data/df_letzt.geojson", driver = "GeoJSON")
  
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
