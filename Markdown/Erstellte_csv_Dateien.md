



```bash
library(data.table)
library(sf)
library(dplyr)

df <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

baum_strasse_df <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")

df_clean <- df %>% drop_na(lng, lat)  %>% 
  mutate(timestamp = ymd_hms(timestamp)) %>% 
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]")) 

baum_strasse_df <- st_transform(baum_strasse_df, crs = 4326)

#Extrahieren der Koordinaten aus der Geometry-Spalte
coords <- st_coordinates(baum_strasse_df$geom)
baum_strasse_df$lng <- coords[, "X"]
baum_strasse_df$lat <- coords[, "Y"]

baum_strasse_df <- st_drop_geometry(baum_strasse_df)

df_merged <- baum_strasse_df %>%
  left_join(df_clean %>% select(id, bewaesserungsmenge_in_liter, timestamp),
            by = c("pitid" = "id"))


write.csv2(df_merged, "data/df_merged.csv", row.names = FALSE, fileEncoding = "UTF-8")
```