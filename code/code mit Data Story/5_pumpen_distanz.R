library(data.table)
library(sf)
library(dplyr)
library(stringr)
library(tidyr)
library(nngeo)


# --- pumpen_mit_bezirk minimieren ---
pumpen_mit_bezirk_full <- st_read("data/pumpen_mit_bezirk.geojson")

pumpen_mit_bezirk <- pumpen_mit_bezirk_full %>%
  select(pump, pump.style, pump.status, bezirk, geometry, man_made, id)

st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk_minimal.geojson",
         driver = "GeoJSON", delete_dsn = TRUE)

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


# write.csv2(df_merged_sum, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand.csv", row.names = FALSE, fileEncoding = "UTF-8")
write.csv2(df_merged_sum, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", row.names = FALSE, fileEncoding = "UTF-8")


  
  
  
# 
#   df_merged_sum_mit_distanzen <- read.csv("data/df_merged_sum_mit_distanzen.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
#  df_merged_sum_mit_distanzen <- read.csv("data/df_merged_sum_mit_distanzen_gesamter_Baumbestand.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
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
#  write.csv2(df_merged_sum_mit_distanzen, "data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand.csv", row.names = FALSE)
  write.csv2(df_merged_sum_mit_distanzen, "data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv", row.names = FALSE)
