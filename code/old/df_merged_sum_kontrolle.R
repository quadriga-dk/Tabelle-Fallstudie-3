library(tidyr)
library(dplyr)


df_merged_sum <- read.csv("data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

# Duplikate nach gisid, timestamp und gesamt_bewaesserung finden
duplicates <- df_merged_sum %>%
  group_by(gisid, timestamp, gesamt_bewaesserung) %>%
  filter(n() > 1) %>%
  arrange(gisid, timestamp)

# Zeige die Duplikate
print(duplicates)
