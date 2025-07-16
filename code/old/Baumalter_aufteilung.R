# Daten laden
df_merged <- read.csv("data/df_merged_final.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

# Sicherstellen, dass 'Pflanzjahr' numerisch ist
df_merged$pflanzjahr <- as.numeric(df_merged$pflanzjahr)

# Aktuelles Jahr
aktuelles_jahr <- as.numeric(format(Sys.Date(), "%Y"))

# Alter berechnen
df_merged$Alter <- aktuelles_jahr - df_merged$pflanzjahr

# Altersklasse zuweisen
df_merged$Altersklasse <- cut(df_merged$Alter,
                                  breaks = c(-Inf, 20, 80, Inf),
                                  labels = c("jung", "mittelalt", "alt"),
                                  right = TRUE)

# Anzahl je Altersklasse
table(df_merged$Altersklasse)
