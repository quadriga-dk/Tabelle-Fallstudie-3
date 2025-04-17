# Karte verbesseren

```{figure} _images/R_Karte.png
---
name: screenshot der Karte
alt: Ein Screenshot, der die Karte des Dashboards zeigt.
---
Dashboard Karte.
```

verbesserungen: 
Was wir einbauen wollen um das Dashboard zu verbessern: 
- Layout ändern
- Baumbestand mit einbinden


```bash
      tabItem(tabName = "map",
              fluidRow(
                box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
                   
                    selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_clean$timestamp))), selected = "2020-2024", multiple = TRUE),

                    selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE),
                    
                    selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df$gattung_deutsch)), selected = "Alle", multiple = TRUE)  
                )
              ),
              leafletOutput("map", height = "800px")
      ),
```


```{figure} _images/R_Karte_Layout_ändern.png
---
name: screenshot der Karteseite mit geändertem Layout
alt: Ein Screenshot, der die Karteseite des Dashboards zeigt mit geändertem Layout.
---
Dashboard Karteseite mit geändertem Layout.
```

ändern zu das: 

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



```bash
mapFilteredData <- reactive({
    
    # Standardmäßig Jahre 2020-2024 setzen
    selected_years <- if (is.null(input$map_year) || input$map_year == "2020-2024") {
      2020:2024  
    } else {
      input$map_year
    }
    
    # Jahreszeiten basierend auf Monaten bestimmen
    df_clean %>%
      mutate(timestamp = ymd_hms(timestamp),
             year = year(timestamp),
             month = month(timestamp),
             saison = case_when(
               month %in% c(12, 1, 2) ~ "Winter",
               month %in% c(3, 4, 5)  ~ "Frühling",
               month %in% c(6, 7, 8)  ~ "Sommer",
               month %in% c(9, 10, 11) ~ "Herbst"
             )) %>%
      filter(
        (input$map_bezirk == "Alle" | bezirk %in% input$map_bezirk) &
          (year %in% selected_years) &
          (input$map_saison == "Alle" | saison %in% input$map_saison) &
          (input$map_baumgattung == "Alle" | gattung_deutsch %in% input$map_baumgattung)
      ) %>%
      group_by(id, lat, lng, gattung_deutsch, pflanzjahr) %>% 
      summarise(
        bewaesserungsmenge_in_liter = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        durchschnitts_intervall = mean(durchschnitts_intervall, na.rm = TRUE)
      ) %>%
      ungroup()
  })

```



```bash
 # Interaktive Karte (openStreetMap) mit Leaflet rendern
  output$map <- renderLeaflet({
    leaflet(mapFilteredData()) %>%
      addTiles() %>% # OpenStreetMap-Hintergrundkarte hinzufügen
      addCircleMarkers(
        ~lng, ~lat, 
        color = ~color_palette(pmin(ifelse(is.na(bewaesserungsmenge_in_liter), 0, bewaesserungsmenge_in_liter), 1200)),
        popup = ~paste("Baumart:", gattung_deutsch, 
                       "<br>Pflanzjahr:", pflanzjahr, 
                       "<br>Bewässerung:", bewaesserungsmenge_in_liter, "Liter",
                       "<br>Ø Bewässerungsintervall:", 
                       ifelse(is.infinite(durchschnitts_intervall), "Keine Daten", 
                              paste(round(durchschnitts_intervall, 1), "Tage"))
        )
      ) %>%
      addLegend(
        position = "bottomright",
        pal = color_palette,
        values = c(0, 1200),
        title = "Bewässerungsmenge (Liter)",
        opacity = 1
      )
  })
```

ändern zu 

```bash
 df_merged_sum <- df_merged %>%
    group_by(pitid) %>%
    summarise(
      gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
      .groups = "drop"  # Verhindert die Warnung über Gruppierung
    ) %>%
    left_join(df_merged, by = "pitid")
  
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

```{figure} _images/R_Karte_mit_Baumbestand_und_Farbe.png
---
name: screenshot der Kartes mit gesamten Baumbestand und anderem Farbverlauf
alt: Ein Screenshot, der die Karteseite mit dem gesamten Baumbestand und anderem Farbverlauf zeigt.
---
Dashboard Karteseite mit gesamten Baumbestand und anderem Farbverlauf.
```

Farbpallete von Blau zu Orange Blau ändern

```bash
    color_palette <- colorNumeric(
      palette = colorRampPalette(c("#FFA500", "#0000FF"))(100),  # Orange nach Blau
      domain = c(0, 1200),  # Fixe Skala von 0 bis 1200 Liter
      na.color = "#CCCCCC"
    )
```

dann muss zusätzlich auch die legende geändert werden damit sie den richtigen Farbverlauf wiederspiegelt

```bash
  addLegend(
        position = "bottomright",
        pal = color_palette,
        values = c(0, 1200),  # Skala von 0 bis 1200 festlegen
        title = "Gesamtbewässerung (Liter)",
        labFormat = labelFormat(suffix = " L", digits = 0),  # Liter-Suffix + keine Nachkommastellen
        opacity = 1
      )
```

```bash
Warnung in color_palette(gesamt_bewaesserung)
  Some values were outside the color scale and will be treated as NA
```

Warnung lösen: 
```bash
addCircleMarkers(
  lng = ~lng,
  lat = ~lat,
  radius = 4,
  stroke = FALSE,
  fillOpacity = 0.7,
  color = ~color_palette(pmin(gesamt_bewaesserung, 2500)),  # hier deckeln!
  popup = ~paste0(
    "<strong>Baumart: </strong>", art_dtsch, "<br>",
    "<strong>Gattung: </strong>", gattung_deutsch, "<br>",
    "<strong>Standort: </strong>", strname, " ", hausnr, "<br>",
    "<strong>Gesamtbewässerung: </strong>", round(gesamt_bewaesserung, 1), " Liter"
  )
)

```

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
df_merged$durchschnitts_intervall[is.na(df_merged$durchschnitts_intervall)] <- Inf

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


  output$map1 <- renderLeaflet({
    color_palette <- colorNumeric(
      palette = colorRampPalette(c("#FFA500", "#0000FF"))(100),  # Orange nach Blau
      domain = c(0, 2500),  # Fixe Skala von 0 bis 2500 Liter
      na.color = "#CCCCCC"
    )


    data <- filtered_data_map()

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
          "<strong>Gesamtbewässerung: </strong>", round(gesamt_bewaesserung, 1), " Liter", "<br>",
          "Ø Bewässerungsintervall: ",
          ifelse(is.infinite(durchschnitts_intervall), "Keine Daten",
                 paste(round(durchschnitts_intervall, 1), "Tage"))
        )
      )%>%
      addLegend(
        position = "bottomright",
        pal = color_palette,
        values = c(0, 2500),  # Skala von 0 bis 1200 festlegen
        title = "Gesamtbewässerung (Liter)",
        labFormat = labelFormat(suffix = " L", digits = 0),  # Liter-Suffix + keine Nachkommastellen
        opacity = 1
      )
  })
```


#### Performanz beim Laden der Daten verbessern

- Ersetze read.csv → fread

- Filtere Spalten gleich beim Einlesen

- Berechne df_merged_sum nur einmal

read.csv ändern zu fread weil fread() ist deutlich schneller als read.csv() und braucht weniger RAM

```bash
library(data.table)
df_merged <- fread("data/df_merged.csv", sep = ";", encoding = "UTF-8")
```

```bash
df_merged <- df_merged[, .(pitid, lat, lng, gattung_deutsch, art_dtsch, hausnr, strname,
                           bewässerungsmenge_in_liter, bezirk, timestamp, pflanzjahr)]
```