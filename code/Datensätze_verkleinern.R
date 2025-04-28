library(data.table)
library(sf)
library(dplyr)
library(tidyr)
library(stringr)


# df_merged_full <- fread("data/df_merged.csv", sep = ";", encoding = "UTF-8")
# df_merged_full <- fread("data/df_merged_gesamter_baumbestand.csv", sep = ";", encoding = "UTF-8")
df_merged_full <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")

# 1. Intervall berechnen
bewässerungs_frequenz <- df_merged_full %>%
  group_by(gisid) %>%
  filter(n() > 1) %>%
  arrange(gisid, timestamp) %>%
  mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
  summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
  ungroup()

# 2. Mit df_merged zusammenführen
df_merged_full <- df_merged_full %>%
  left_join(bewässerungs_frequenz, by = "gisid")

# 3. Inf setzen für fehlende Intervalle
df_merged_full$durchschnitts_intervall[is.na(df_merged_full$durchschnitts_intervall)] <- 0

# 4. df_merged_sum mit allen nötigen Infos bauen
df_merged_sum <- df_merged_full %>%
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

# # --- df_merged_gesamter_baumbestand minimieren ---
# df_merged_full <- fread("data/df_merged_final.csv",
#                         sep = ";", encoding = "UTF-8")
# 
# df_merged <- df_merged_full[, .(
#   gml_id, gisid,pitid, lat, lng, gattung_deutsch, art_dtsch,
#   hausnr, strname, bewaesserungsmenge_in_liter,
#   bezirk, timestamp, pflanzjahr
# )]
# 
# write.csv2(df_merged, file = "data/df_merged_gesamter_baumbestand_minimal1.csv", sep = ";")
#write.csv2(df_merged, file = "data/df_merged_gesamter_baumbestand_minimal.csv", sep = ";")

# # --- wetter minimieren ---
# df_wetter_monatlich_full <- read.csv("C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/Wetterdaten/Filtered_Wetterdaten/combined_monthly_daten_2020_2024.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# 
# df_wetter_monatlich <- df_wetter_monatlich_full[, c("MESS_DATUM_BEGINN", "MO_RR", "MO_TT")]
# 
# 
# write.csv2(df_wetter_monatlich, file = "C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/combined_monthly_daten_2020_2024_minimal.csv")
# 
# 
# 
# # --- df_merged minimieren ---
# df_merged_full <- fread("data/df_merged.csv",
#                         sep = ";", encoding = "UTF-8")
# 
# df_merged <- df_merged_full[, .(
#   pitid, lat, lng, gattung_deutsch, art_dtsch,
#   hausnr, strname, bewaesserungsmenge_in_liter,
#   bezirk, timestamp, pflanzjahr
# )]
# 
# write.csv2(df_merged, file = "data/df_merged_minimal.csv", sep = ";")
# 
# # --- wetter minimieren ---
# df_wetter_monatlich_full <- read.csv("C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/Wetterdaten/Filtered_Wetterdaten/combined_monthly_daten_2020_2024.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
# 
# df_wetter_monatlich <- df_wetter_monatlich_full[, c("MESS_DATUM_BEGINN", "MO_RR", "MO_TT")]
# 
# 
# write.csv2(df_wetter_monatlich, file = "C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/combined_monthly_daten_2020_2024_minimal.csv")
# 
# 
# # --- pumpen minimieren ---
# pumpen_full <- st_read("C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/pumpen.geojson")
# 
# pumpen <- pumpen_full %>% 
#   select(pump, pump.style, geometry, man_made, id)
# 
# st_write(pumpen, "C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/pumpen_minimal.geojson", 
#          driver = "GeoJSON", delete_dsn = TRUE)
# 
# # --- pumpen_mit_bezirk minimieren ---
# pumpen_mit_bezirk_full <- st_read("C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/pumpen_mit_bezirk.geojson")
# 
# pumpen_mit_bezirk <- pumpen_mit_bezirk_full %>% 
#   select(pump, pump.style, Gemeinde_name, geometry, man_made, id)
# 
# st_write(pumpen_mit_bezirk, "C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/pumpen_mit_bezirk_minimal.geojson", 
#          driver = "GeoJSON", delete_dsn = TRUE)
# 
# # --- df (Nutzungsdaten GiessDenKiez) minimieren ---
# df_full <- fread("C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/nutzungsdatenGiessDenKiez.csv", 
#                  sep = ";", encoding = "UTF-8")
# 
# df <- df_full[, .(
#   id, lng, lat, bezirk, gattung_deutsch, strname, pflanzjahr, timestamp, bewaesserungsmenge_in_liter
# )]
# 
# saveRDS(df, file = "C:/Users/cahid/Documents/Studium/Bachelorarbeit/data/nutzungsdatenGiessDenKiez_minimal.rds")
