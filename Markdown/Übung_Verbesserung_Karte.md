# Karte verbesseren

#### Ausgangssituation

```{figure} _images/R_Karte.png
---
name: screenshot der Karte
alt: Ein Screenshot, der die Karte des Dashboards zeigt.
---
Dashboard Karte.
```

#### Geplante Verbesserungen

**Ziele:**
- Verbessertes Layout für Filter
- Baumbestand einbinden (vollständige Darstellung aller relevanten Bäume)
- Farbliche Anpassung der Marker basierend auf der Gesamtbewässerung (Orange → Blau)
- Popup-Erweiterung um zusätzliche Baumdaten (Gattung, Standort, Intervall)
- Performanceoptimierung beim Datenladen und Filtern
- df_merged_sum in eingener CSV (Performanz)
- Pumpen auf der Karte anzeigen

#### Layout-Anpassung der Filter

**Vorher:**

```bash
fluidRow(
  box(title = "Filter", ...,
    selectInput(...),
    selectInput(...),
    ...
  )
)
```

**Nachher – Neue Struktur mit Spalten:**

```bash
fluidRow(
  box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
    column(width = 6,
      selectInput("map_bezirk", "Bezirk auswählen:", ...)
    ),
    column(width = 6,
      selectInput("map_year", "Jahr auswählen:", ...)
    ),
    column(width = 6,
      selectInput("map_saison", "Saison auswählen:", ...)
    ),
    column(width = 6,
      selectInput("map_baumgattung", "Baumgattung auswählen:", ...)
    )
  )
)
```

```{figure} _images/R_Karte_Layout_ändern.png
---
name: screenshot der Karteseite mit geändertem Layout
alt: Ein Screenshot, der die Karteseite des Dashboards zeigt mit geändertem Layout.
---
Dashboard Karteseite mit geändertem Layout.
```
Gesamter Codeabschnitt zur Kontrolle: 

```bash
      tabItem(tabName = "map",
              fluidRow(
                box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    column(width = 6,
                      selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
                    ),
                    column(width = 6,
                      selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
                    ),
                    column(width = 6,
                      selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE),
                    ),
                    column(width = 6,
                      selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df$gattung_deutsch)), selected = "Alle", multiple = TRUE)
                    ),
                )
              ),
              leafletOutput("map", height = "800px")
      ),
```

#### Baumbestand + neue Darstellung

Neuer Datenfilter mit vollständigem Baumbestand:
```bash
df_merged_sum <- df_merged %>%
  group_by(pitid) %>%
  summarise(
    gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  left_join(df_merged, by = "pitid")

```

Reaktive Filterfunktion filtered_data_map:
- Berücksichtigt Bezirk, Baumgattung, Jahr, Saison
- Entfernt Datensätze ohne Koordinaten

```bash
filtered_data_map <- reactive({
    data <- df_merged_sum
    
    # Bezirk
    if (!is.null(input$map_bezirk) && !("Alle" %in% input$map_bezirk)) {
      data <- data %>% filter(bezirk %in% input$map_bezirk)
    }
    
    # Baumgattung
    if (!is.null(input$map_baumgattung) && !("Alle" %in% input$map_baumgattung)) {
      data <- data %>% filter(gattung_deutsch %in% input$map_baumgattung)
    }
    
    # Jahr (nur wenn timestamp vorhanden und als Date/Year formatiert)
    if (!is.null(input$map_year) && !("2020-2024" %in% input$map_year)) {
      data$timestamp <- as.Date(data$timestamp)
      data <- data %>%
        filter(lubridate::year(timestamp) %in% as.numeric(input$map_year))
    }
    
    # Saison
    if (!is.null(input$map_saison) && !("Alle" %in% input$map_saison)) {
      data$monat <- lubridate::month(as.Date(data$timestamp))
      data$saison <- case_when(
        data$monat %in% c(12, 1, 2) ~ "Winter",
        data$monat %in% c(3, 4, 5) ~ "Frühling",
        data$monat %in% c(6, 7, 8) ~ "Sommer",
        data$monat %in% c(9, 10, 11) ~ "Herbst",
        TRUE ~ "Unbekannt"
      )
      data <- data %>% filter(saison %in% input$map_saison)
    }
    
    # Koordinaten check
    data <- data %>% filter(!is.na(lat), !is.na(lng))
    
    return(data)
  })
  
  output$map <- renderLeaflet({
    color_palette <- colorNumeric(palette = "Blues", domain = c(0, max(df_merged_sum$gesamt_bewaesserung, na.rm = TRUE)))
    
    data <- filtered_data_map()
    
    leaflet(data = data) %>%
      addTiles() %>% 
      addCircleMarkers(
        lng = ~lng,
        lat = ~lat,
        radius = 4,
        stroke = FALSE,
        fillOpacity = 0.7,
        color = ~color_palette(gesamt_bewaesserung),
        popup = ~paste0(
          "<strong>Baumart: </strong>", art_dtsch, "<br>",
          "<strong>Gattung: </strong>", gattung_deutsch, "<br>",
          "<strong>Standort: </strong>", strname, " ", hausnr, "<br>",
          "<strong>Gesamtbewässerung: </strong>", round(gesamt_bewaesserung, 1), " Liter"
        )
      ) %>%
      addLegend(
        "bottomright",
        pal = color_palette,
        values = data$gesamt_bewaesserung,
        title = "Gesamtbewässerung (Liter)",
        opacity = 1
      )
  })
```

#### Neue Farbskala: Orange → Blau

```bash
color_palette <- colorNumeric(
  palette = colorRampPalette(c("#FFA500", "#0000FF"))(100),  # Orange → Blau
  domain = c(0, 2500),
  na.color = "#CCCCCC"
)
```

Legende anpassen:

```bash
addLegend(
  position = "bottomright",
  pal = color_palette,
  values = c(0, 2500),
  title = "Gesamtbewässerung (Liter)",
  labFormat = labelFormat(suffix = " L", digits = 0),
  opacity = 1
)
```

**Hinweis zur Skalierung:**

Bei Farbzuweisungen außerhalb des definierten Bereichs (domain) erscheint die Warnung:

Some values were outside the color scale...

Lösung: Deckeln mit pmin(...):

```bash
color = ~color_palette(pmin(gesamt_bewaesserung, 2500))
```

```{figure} _images/R_Karte_mit_Baumbestand_und_Farbe.png
---
name: screenshot der Kartes mit erweitertem Baumbestand und anderem Farbverlauf
alt: Ein Screenshot, der die Karteseite mit dem erweitertem Baumbestand und anderem Farbverlauf zeigt.
---
Dashboard Karteseite mit erweitertem Baumbestand und anderem Farbverlauf.
```

#### Performanceoptimierung

CSV effizienter laden mit fread():
```bash
library(data.table)
df_merged <- fread("data/df_merged.csv", sep = ";", encoding = "UTF-8")
````

Nur relevante Spalten laden:

```bash
df_merged <- df_merged[, .(pitid, lat, lng, gattung_deutsch, art_dtsch, hausnr, strname,
                           bewässerungsmenge_in_liter, bezirk, timestamp, pflanzjahr)]
```

#### Intervallberechnung für jeden Baum

df_merged_sum in einer CSV speichern damit das durchschnitts_intervall nur einmal berechnet wrd und danach nur noch aufgerufen werden muss 

```bash
# 1. Intervall berechnen
bewässerungs_frequenz <- df_merged %>%
  group_by(pitid) %>%
  filter(n() > 1) %>%
  arrange(pitid, timestamp) %>%
  mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
  summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
  ungroup()

# 2. Mit df_merged zusammenführen
df_merged <- df_merged %>%
  left_join(bewässerungs_frequenz, by = "pitid")

# 3. Inf setzen für fehlende Intervalle
df_merged$durchschnitts_intervall[is.na(df_merged$durchschnitts_intervall)] <- 0

# 4. df_merged_sum mit allen nötigen Infos bauen
df_merged_sum <- df_merged %>%
  group_by(pitid) %>%
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
    timestamp = first(timestamp),
    .groups = "drop"
  )

```

##### df_merged_sum in Eigner CSV (Performanz)

df_merged_sum in einer CSV speichern damit das durchschnitts_intervall nur einmal berechnet wrd und danach nur noch aufgerufen werden muss 

```bash
library(data.table)
library(sf)
library(dplyr)

df_merged_full <- fread("data/df_merged.csv", sep = ";", encoding = "UTF-8")

# 1. Intervall berechnen
bewässerungs_frequenz <- df_merged %>%
  group_by(pitid) %>%
  filter(n() > 1) %>%
  arrange(pitid, timestamp) %>%
  mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
  summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
  ungroup()

# 2. Mit df_merged zusammenführen
df_merged <- df_merged %>%
  left_join(bewässerungs_frequenz, by = "pitid")

# 3. Inf setzen für fehlende Intervalle
df_merged$durchschnitts_intervall[is.na(df_merged$durchschnitts_intervall)] <- 0

# 4. df_merged_sum mit allen nötigen Infos bauen
df_merged_sum <- df_merged %>%
  group_by(pitid) %>%
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
    timestamp = first(timestamp),
    .groups = "drop"
  )

  write.csv2(df_merged_sum, file = "data/df_merged_sum.csv", sep = ";")
```

In der global.R Datei dann die Zeile hinzufügen: 

```bash
df_merged_sum <- read.csv("data/df_merged_sum.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
```

df Auskommentieren oder rausnehmen 
```bash
# In df_merged und df_merged_sum enthalten  
# df <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
```
df_clean anpassen

Vorher: 
```bash
df_clean <- df %>% drop_na(lng, lat, bewaesserungsmenge_in_liter)  %>% 
  mutate(timestamp = ymd_hms(timestamp)) %>% 
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]")) 
```
Nachher: 
```bash
df_clean <- df_merged %>% drop_na(lng, lat)  %>% 
  mutate(timestamp = ymd_hms(timestamp)) %>% 
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]")) 
```

- bewaesserungsmenge_in_liter aus dem drop_na entnommen, weil zu viele Bäume icht bewässert wurden und wenn man die drop hat man wieder den Datensatz df und der merge hätte nichts gebracht

In der ui.R Datei muss jede stelle wo df steht mit df_clean ersetzt werden da sonst Probleme entstehen weil df nicht mehr existiert
Beispiel
Vorher: 
```bash
 column(width = 6,
                           selectInput("start_year", "Jahr auswählen:", 
                                       choices = c("2020-2024", unique(year(df$timestamp))), 
                                       selected = "2020-2024", multiple = TRUE)
                    ),
```

Nachher: 

```bash
 column(width = 6,
                           selectInput("start_year", "Jahr auswählen:", 
                                       choices = c("2020-2024", unique(year(df_clean$timestamp))), 
                                       selected = "2020-2024", multiple = TRUE)
                    ),
```

#### Pumpen auf der Karte anzeigen

Hinzufügen: 
```bash
icon_pumpe <- makeIcon(
    iconUrl = "icons/water-pump-icon-14.jpg",
    iconWidth = 15,
    iconHeight = 15
  )
```

Map anpassen: 

```bash
  output$map <- renderLeaflet({
    data <- filtered_data_map()
    
    color_palette <- colorNumeric(
      palette = colorRampPalette(c("#FFA500", "#0000FF"))(100),
      domain = c(0, 2500),
      na.color = "#CCCCCC"
    )
    
    leaflet(data = data) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~lng,
        lat = ~lat,
        radius = 4,
        stroke = FALSE,
        fillOpacity = 0.7,
        color = ~color_palette(pmin(gesamt_bewaesserung, 2500)),
        popup = ~paste0(
          "<strong>Baumart: </strong>", art_dtsch, "<br>",
          "<strong>Gattung: </strong>", gattung_deutsch, "<br>",
          "<strong>Standort: </strong>", strname, " ", hausnr, "<br>",
          "<strong>Gesamtbewässerung: </strong>", round(as.numeric(gesamt_bewaesserung), 1), " Liter", "<br>", # zu numeric konvertieren damit man die Funktion round anwenden kann
          "Ø <strong>Bewässerungsintervall: </strong>",
          ifelse(is.infinite(durchschnitts_intervall), "Keine Daten",
                 paste(round(durchschnitts_intervall, 1), " Tage")), "<br><br>"
        )
      ) %>%
      addMarkers(       # Hier Pumpen integrieren
        data = pumpen_mit_bezirk,
        icon = icon_pumpe,
        group = "Pumpen"
      ) %>%
      addLayersControl(
        overlayGroups = c("Pumpen"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      addLegend(
        position = "bottomright",
        pal = color_palette,
        values = c(0, 2500),
        title = "Gesamtbewässerung (Liter)",
        labFormat = labelFormat(suffix = " L", digits = 0),
        opacity = 1
      ) %>%
      hideGroup("Pumpen")  # Anfangs ausblenden
  })
```

Die lng und lat in das richtige Format bringen für leaflet
```bash
 df_merged_sum$lng <- as.numeric(gsub(",", ".", df_merged_sum$lng))
 df_merged_sum$lat <- as.numeric(gsub(",", ".", df_merged_sum$lat))
```

Für den Zoom für die Pumpen muss in der ui.R folgendes hinzugefügt werden: 

```bash
 tags$script(HTML("
      $(document).ready(function() {
        var map = $('#map').find('div.leaflet-container')[0];
        if (map) {
          var leafletMap = $(map).data('leaflet-map');
          leafletMap.on('zoomend', function() {
            Shiny.setInputValue('map_zoom', leafletMap.getZoom());
          });
        }
      });
    ")),
```


