---
lang: de-DE
---

(infrastruktur)=
# Einfügen Infrastruktur

## Ziel der Übung
In diesem Abschnitt entwickeln wir eine interaktive Webanwendung, die das **Bürgerengagement** im Zusammenhang mit der Nutzung von öffentlichen Pumpen und dem Gießverhalten sichtbar macht.

Das **Ziel** ist ein Dashboard, das zeigt:

- Ob ein Zusammenhang zwischen der **Pumpendichte** (Anzahl Pumpen pro Fläche) und dem **Gießverhalten** der Bürger:innen besteht,

- Und das es ermöglicht, die Daten flexibel zu filtern, z. B. nach bestimmten Zeiträumen (z. B. Jahr).

So bekommen die Nutzer:innen einen transparenten Überblick über das Engagement in ihrer Stadt bzw. ihrem Bezirk.

## Grober Aufbau der Anwendung
Das Dashboard wird in zwei Hauptteile gegliedert:

1. **Benutzeroberfläche (UI – User Interface):**
Definiert, welche Elemente die Nutzer:innen sehen und wie sie interagieren können.

2. **Serverlogik (Server):**
Kümmert sich um die Datenverarbeitung, Berechnung und das dynamische Erzeugen der Visualisierungen.

## Datenbasis zusammenstellen

Damit unser Dashboard funktioniert, benötigen wir gut aufbereitete Daten.

### Datenquelle Pumpen mit Bezirkszuordnung
- Wir laden Geodaten zu den Bezirksgrenzen und den Standorten der Pumpen.

- Wichtig: Beide Datensätze müssen im gleichen Koordinatensystem (CRS) vorliegen (z. B. WGS84 / EPSG 4326), damit wir räumlich korrekt arbeiten können.

```bash
# Bezirksgrenzen einlesen
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")

# Pumpen-Daten ins gleiche CRS transformieren
pumpen <- st_transform(pumpen, crs = 4326)
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = 4326)

```
### Räumlicher Join: Jede Pumpe bekommt den Namen ihres Bezirks

Durch einen räumlichen Join weisen wir jeder Pumpe den Bezirk zu, in dem sie liegt.

```bash
pumpen_mit_bezirk <- st_join(pumpen, bezirksgrenzen[, c("Gemeinde_name")], left = TRUE)

# Spalte umbenennen für bessere Lesbarkeit
pumpen_mit_bezirk <- pumpen_mit_bezirk %>%
  rename(bezirk = Gemeinde_name)

# Ergebnisse als GeoJSON speichern (optional)
st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk.geojson", driver = "GeoJSON", delete_dsn = TRUE)
```
**Erklärung:** 
- ``st_join()`` verknüpft zwei Geodatensätze – hier wird jede Pumpe mit dem Bezirk verbunden, in dem sie sich befindet.
- ``left = TRUE`` bedeutet: alle Pumpen bleiben erhalten, auch wenn keine passende Bezirkseintragung gefunden wird.

### Gießverhalten-Daten bereinigen und verknüpfen
- Gießdaten enthalten häufig Koordinaten als Text mit Kommas. Diese müssen in numerische Werte umgewandelt werden.
- Fehlende Werte werden entfernt.
- Die Entfernung jedes Gießpunkts zur nächsten Pumpe wird berechnet, um später zu analysieren, wie die Nähe zu Pumpen das Gießverhalten beeinflusst.


```bash
library(data.table)
library(sf)
library(dplyr)
library(stringr)
library(tidyr)

  pumpen_mit_bezirk <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
 df_merged_sum <- read.csv("data/df_merged_sum.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
 
  
    df_merged_sum <- df_merged_sum %>%
      mutate(
        lat = as.numeric(str_replace(lat, ",", ".")),
        lng = as.numeric(str_replace(lng, ",", "."))
      )
  
    df_merged_sum <- df_merged_sum %>% drop_na(lat, lng)
 
 
  
    # Entfernen CRS-Unterschiede
    pumpen_sf <- st_transform(pumpen_mit_bezirk, crs = 4326)
    df_merged_sum_sf <- st_as_sf(df_merged_sum, coords = c("lng", "lat"), crs = 4326)
  
  
    # Berechnung der Entfernung zur nächsten Pumpe
    dist_matrix <- st_distance(df_merged_sum_sf, pumpen_sf)
    min_dist <- apply(dist_matrix, 1, min)
  
   df_merged_sum$distanz_zur_pumpe_m <- as.numeric(min_dist)
   
   
   write.csv2(df_merged_sum, "data/df_merged_sum_mit_distanzen.csv", row.names = FALSE, fileEncoding = "UTF-8")

```

**Erklärung:**
- ``mutate()`` verändert oder erstellt Spalten.
- ``str_replace()`` ersetzt Zeichen – hier das Komma durch einen Punkt, damit wir korrekt mit Zahlen rechnen können.
- ``st_distance()`` berechnet Distanzen zwischen allen Punkten.
- ``apply(..., min)`` nimmt jeweils den kleinsten Abstand (zur nächsten Pumpe).


### Pumpen im 100 m Umkreis zählen
Um den Einfluss der Pumpendichte auf das Gießverhalten genauer zu untersuchen, ermitteln wir, wie viele Pumpen sich in einem Umkreis von 100 Metern um jeden Gießpunkt befinden.

```bash
df_merged_sum_mit_distanzen <- read.csv("data/df_merged_sum_mit_distanzen.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
  
  df_merged_sum_mit_distanzen$lat <- as.numeric(gsub(",", ".", df_merged_sum_mit_distanzen$lat))
  df_merged_sum_mit_distanzen$lng <- as.numeric(gsub(",", ".", df_merged_sum_mit_distanzen$lng))
  
  
  # 1. Rechnen
  df_giess_sf <- st_as_sf(df_merged_sum_mit_distanzen, coords = c("lng", "lat"), crs = 4326)
  pumpen_sf <- st_transform(pumpen_mit_bezirk, crs = 4326)
  
  df_giess_sf_m <- st_transform(df_giess_sf, 3857)
  pumpen_sf_m <- st_transform(pumpen_sf, 3857)
  
  giess_buffer <- st_buffer(df_giess_sf_m, dist = 100)
  pumpen_im_umkreis <- lengths(st_intersects(giess_buffer, pumpen_sf_m))
  
  df_merged_sum_mit_distanzen$pumpen_im_umkreis_100m <- pumpen_im_umkreis
  
  # 2. Speichern
  write.csv2(df_merged_sum_mit_distanzen, "data/df_merged_sum_mit_distanzen_mit_umkreis.csv", row.names = FALSE)

```
**Erklärung:**
- ``st_buffer()`` erzeugt eine Art "Zone" (Kreis) um jeden Punkt.
- ``st_intersects()`` prüft, welche Pumpen in diesen Zonen liegen.

### Bezirk-Flächen zur Berechnung der Pumpendichte
Um die Pumpendichte zu berechnen, benötigen wir die Fläche jedes Bezirks in Hektar (ha).

Die Information um das Dataframe zu erstellen ziehen wir aus dieser Tabelle:  

```{figure} ../assets/Bezirksfläche.png
---
name: screenshot zeigt eine Tabelle mit der größe der Bezirksfläche in ha
alt: Ein Screenshot, der eine Tabelle mit der größe der Bezirksfläche in ha zeigt.
---
Tabelle zur Bezirksfläche 
```

```bash
bezirksflaechen <- data.frame(
  bezirk = c("Mitte", "Friedrichshain-Kreuzberg", "Pankow", "Charlottenburg-Wilmersdorf",
             "Spandau", "Steglitz-Zehlendorf", "Tempelhof-Schöneberg", "Neukölln",
             "Treptow-Köpenick", "Marzahn-Hellersdorf", "Lichtenberg", "Reinickendorf"),
  flaeche_ha = c(3.940, 2.040, 10.322, 6.469, 9.188, 10.256, 5.305, 4.493, 16.773, 6.182, 5.212, 8.932)
)
```

## Benutzeroberfläche: Dashboard strukturieren

In der Sidebar werden verschiedene Menüpunkte angeboten – darunter unser neuer Bereich **„Bürgerengagement“**, der die Pumpen- und Gießverhaltensdaten visualisiert.

```bash
dashboardSidebar(
  sidebarMenu(
    menuItem("Startseite", tabName = "start", icon = icon("home")),
    menuItem("Karte", tabName = "map", icon = icon("map")),
    menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart")),
    menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area")),
    menuItem("Bürgerengagement", tabName = "engagement", icon = icon("hands-helping"))
  )
)
```

### Tab für Bürgerengagement
Hier definieren wir, welche Diagramme im Tab „Bürgerengagement“ angezeigt werden:

```bash
tabItem(tabName = "engagement",
  fluidRow(
    box(
      title = "Pumpenanzahl und Bewässerung pro Bezirk",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      plotOutput("balken_plot")
    ),
    box(
      title = "Durchschnittliche Gießmenge nach Pumpen-Kategorie im 100 m Umkreis",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      plotOutput("pumpenkategorien_plot", height = "400px")
    )
  )
)
```

## Serverlogik: Daten verarbeiten und visualisieren
Im Serverteil bereiten wir die Daten auf und definieren die Grafiken, die im UI angezeigt werden.

### Datenvorbereitung
Hier stellen wir sicher, dass alle Werte numerisch und vollständig sind.

```bash
df_merged_sum_mit_distanzen_mit_umkreis <- df_merged_sum_mit_distanzen_mit_umkreis %>%
  mutate(
    lat = as.numeric(str_replace(lat, ",", ".")),
    lng = as.numeric(str_replace(lng, ",", "."))
  ) %>%
  drop_na(lat, lng)

```

### Pumpendichte berechnen
Zuerst zählen wir die Pumpen pro Bezirk und berechnen daraus die Pumpendichte (Pumpen pro Hektar).

```bash
pumpen_pro_bezirk <- pumpen_mit_bezirk %>%
  st_drop_geometry() %>%
  group_by(bezirk) %>%
  summarise(pumpenanzahl = n()) 

pumpendichte <- pumpen_pro_bezirk %>%
  left_join(bezirksflaechen, by = "bezirk") %>%
  mutate(pumpen_pro_ha = pumpenanzahl / flaeche_ha)

```
**Erklärung:**
- ``group_by():`` Gruppiert die Daten nach Bezirk.
- ``summarise()``: Zählt die Anzahl Pumpen.
- ``left_join()``: Fügt die Flächen-Daten hinzu (eine Art „Verschmelzen“ der Tabellen).
- ``mutate()``: Rechnet die Dichte aus.

### Gießverhalten pro Bezirk zusammenfassen und mit Pumpendichte verbinden

```bash
giess_pumpen_dichte_df <- df_merged_sum %>%
  group_by(bezirk) %>%
  summarise(
    gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
    durchschnittl_intervall = mean(durchschnitts_intervall[is.finite(durchschnitts_intervall)], na.rm = TRUE),
    .groups = "drop"
  ) %>%
  left_join(pumpendichte, by = "bezirk")

```
### Balkendiagramm: Pumpenanzahl vs. Bewässerung
Wir visualisieren beide Größen zusammen in einem Balkendiagramm mit zwei Y-Achsen (links Bewässerung, rechts Pumpenzahl).

```bash
output$balken_plot <- renderPlot({
  max_bewaesserung <- max(giess_pumpen_dichte_df$gesamt_bewaesserung, na.rm = TRUE)
  max_pumpen <- max(giess_pumpen_dichte_df$pumpenanzahl, na.rm = TRUE)
  scaling_factor <- max_bewaesserung / max_pumpen

  ggplot(giess_pumpen_dichte_df, aes(x = bezirk)) +
    geom_bar(aes(y = gesamt_bewaesserung, fill = "Bewässerung"),
             stat = "identity", position = position_nudge(x = -0.2), width = 0.4) +
    geom_bar(aes(y = pumpenanzahl * scaling_factor, fill = "Pumpenanzahl"),
             stat = "identity", position = position_nudge(x = 0.2), width = 0.4) +
    scale_fill_manual(name = "Kategorie",
                      values = c("Bewässerung" = "steelblue", "Pumpenanzahl" = "seagreen")) +
    scale_y_continuous(
      name = "Gesamtbewässerung (Liter)",
      sec.axis = sec_axis(~ . / scaling_factor, name = "Anzahl Pumpen")
    ) +
    labs(
      title = "Pumpenanzahl und Bewässerung pro Bezirk",
      x = "Bezirk"
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      legend.position = "top"
    )
})
```

### Visualisierung: Gießmenge nach Pumpenkategorie im 100 m Umkreis
Wir kategorisieren Gießpunkte je nach Anzahl Pumpen in der Nähe und zeigen die durchschnittliche Gießmenge pro Kategorie.

```bash
df_merged_sum_mit_distanzen_mit_umkreis <- df_merged_sum_mit_distanzen_mit_umkreis %>%
  mutate(pumpenkategorie = case_when(
    pumpen_im_umkreis_100m == 0 ~ "Keine Pumpe",
    pumpen_im_umkreis_100m == 1 ~ "Eine Pumpe",
    pumpen_im_umkreis_100m >= 2 ~ "Mehrere Pumpen"
  ))

output$pumpenkategorien_plot <- renderPlot({
  df_kategorie_mittelwert <- df_merged_sum_mit_distanzen_mit_umkreis %>%
    group_by(pumpenkategorie) %>%
    summarise(
      durchschnittliche_giessmenge = mean(gesamt_bewaesserung, na.rm = TRUE),
      anzahl_baeume = n(),
      .groups = "drop"
    ) %>%
    mutate(pumpenkategorie_label = paste0(pumpenkategorie, " (Anzahl Bäume = ", anzahl_baeume, ")"))

  ggplot(df_kategorie_mittelwert, aes(x = pumpenkategorie_label, y = durchschnittliche_giessmenge)) +
    geom_col(fill = "seagreen") +
    labs(
      title = "Durchschnittliche Gießmenge nach Pumpen-Kategorie im 100 m Umkreis",
      x = "Pumpenkategorie",
      y = "Durchschnittliche Gießmenge (Liter)"
    ) +
    theme_minimal() +
    theme(
      axis.text = element_text(size = 12),
      axis.title = element_text(size = 13),
      plot.title = element_text(size = 15, face = "bold"),
      panel.grid.major.y = element_line(color = "gray90")
    )
})

```


## Zusammenfassung
Mit diesen Schritten haben wir:

- Die räumliche Verknüpfung von Pumpenstandorten mit Bezirksgrenzen hergestellt,

- Gießverhalten mit Pumpennähe verbunden,

- Die Pumpendichte in Bezug auf die Bezirksfläche berechnet,

- Und zwei aussagekräftige Visualisierungen erstellt, die das Bürgerengagement durch die Nutzung von Pumpen und Gießverhalten anschaulich machen.

Durch das Dashboard können Interessierte einfach erkennen, wie das Engagement in den verschiedenen Bezirken aussieht und wie die Pumpendichte das Gießverhalten beeinflusst.
