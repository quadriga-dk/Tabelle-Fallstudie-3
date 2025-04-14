# Übung Karte

In dieser Übung erstellen wir eine interaktive Karte, auf der alle bewässerten Bäume dargestellt sind. Dabei können verschiedene Filter gesetzt werden, z. B. nach Bezirk, Jahr, Jahreszeit oder Baumart. 

Ziel ist es, mit Hilfe der Leaflet-Bibliothek eine Karte zu generieren, die:

- Bewässerte Bäume als farbige Kreise darstellt

- Informationen zur Bewässerung beim Anklicken anzeigt

- Eine Legende zur Farbskala der Wassermenge enthält

### Teil 1: Die Benutzeroberfläche – Filterelemente & Kartenausgabe

In der Oberfläche (``ui``) definieren wir, **welche Filter angeboten werden** und wo die Karte erscheinen soll:

```bash
tabItem(tabName = "map",
    fluidRow(
        box(title = "Filter", status = "primary", solidHeader = TRUE, width = 4,
            selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
            selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024", unique(year(df_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
            selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE),
            selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df$gattung_deutsch)), selected = "Alle", multiple = TRUE)
        )
    ),
    leafletOutput("map", height = "800px")
)
```

#### Erklärung der UI-Elemente:

- ``selectInput(...)``: Erstellt ein **Dropdown-Menü** mit Auswahloptionen.

- ``multiple = TRUE``: Mehrere Optionen gleichzeitig auswählbar.

- ``unique(df$bezirk)``: Holt alle vorhandenen Bezirke **einmalig** aus der Datenquelle.

- ``leafletOutput("map")``: Platzhalter für die interaktive Karte (sie wird später im Server erzeugt).

- ``height = "800px"``: Bestimmt die Höhe der Karte.

###  Teil 2: Die Daten reaktiv filtern

Damit die Karte nur die **relevanten Daten** anzeigt, definieren wir eine reaktive Funktion:

```bash
mapFilteredData <- reactive({
    selected_years <- if (is.null(input$map_year) || input$map_year == "2020-2024") {
        2020:2024  
    } else {
        input$map_year
    }
    
    df_clean %>%
        mutate(
            timestamp = ymd_hms(timestamp),
            year = year(timestamp),
            month = month(timestamp),
            saison = case_when(
                month %in% c(12, 1, 2) ~ "Winter",
                month %in% c(3, 4, 5) ~ "Frühling",
                month %in% c(6, 7, 8) ~ "Sommer",
                month %in% c(9, 10, 11) ~ "Herbst"
            )
        ) %>%
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

**Begriffserklärungen**:
- ``input$map_bezirk``: Liest den aktuell ausgewählten Bezirk aus dem Filter.

- ``mutate(...)``: Erstellt neue Spalten:

    - ``year``: Jahr der Bewässerung

    - ``month``: Monat

    - ``saison``: Jahreszeit (wird über ``case_when()``zugeordnet)

- ``filter(...)``: Schränkt die Daten auf die gewählten Filteroptionen ein.

- ``group_by(...)``: Gruppiert nach Baum-ID, Koordinaten, Baumart und Pflanzjahr.

- ``summarise(...)``: Fasst die Daten pro Baum zusammen:

    - Gesamtbewässerungsmenge

    - Durchschnittliches Intervall zwischen zwei Bewässerungen

### Teil 3: Die durchschnittliche Bewässerungsfrequenz berechnen

Zusätzlich möchten wir wissen, wie oft ein Baum durchschnittlich gegossen wurde. Dazu berechnen wir die Differenz zwischen Bewässerungszeitpunkten:

```bash
bewässerungs_frequenz <- df_clean %>%
    group_by(id) %>%
    filter(n() > 1) %>% 
    arrange(id, timestamp) %>%
    mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
    summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
    ungroup()

```

- ``difftime(...)``: Gibt die Zeitdifferenz zwischen zwei Datumswerten.

- ``lag(...)``: Holt den vorherigen Wert (z. B. vorheriges Gießdatum).

- ``summarise(...)``: Durchschnittliche Tage zwischen zwei Gießvorgängen.

Dann fügen wir diese Information dem Haupt-Datensatz hinzu:

```bash
df_clean <- df_clean %>%
    left_join(bewässerungs_frequenz, by = "id")

df_clean$durchschnitts_intervall[is.na(df_clean$durchschnitts_intervall)] <- Inf
```

**Bäume mit nur einer Bewässerung erhalten hier den Wert Inf (unendlich), um sie visuell auszugrenzen.**

### Teil 4: Die interaktive Karte mit leaflet

Jetzt erzeugen wir die Karte im Server-Teil:

```bash
output$map <- renderLeaflet({
    leaflet(mapFilteredData()) %>%
        addTiles() %>% 
        addCircleMarkers(
            ~lng, ~lat, 
            color = ~color_palette(pmin(ifelse(is.na(bewaesserungsmenge_in_liter), 0, bewaesserungsmenge_in_liter), 600)),
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
            values = c(0, 600),
            title = "Bewässerungsmenge (Liter)",
            opacity = 1
        )
})
```

#### Was passiert hier?
- ``leaflet(...)``: Erstellt eine neue Leaflet-Karte mit den gefilterten Daten.

- ``addTiles()``: Fügt die Hintergrundkarte hinzu (OpenStreetMap).

- ``addCircleMarkers(...)``: Zeichnet Punkte für jeden Baum:

    - ``~lng, ~lat``: Koordinaten

    - ``color = ...``: Farbe je nach Wassermenge

    - ``popup = ...``: Beim Anklicken erscheint ein Infofenster mit Details

- ``addLegend(...)``: Fügt eine Farbskala hinzu, um die Bedeutung der Farben zu erklären.

Hier der gesamte Code zur Kontrolle: 

```bash
ui <- dashboardPage(
    dashboardHeader(title = "Gieß den Kiez Dashboard"),
    dashboardSidebar(
        sidebarMenu(
        menuItem("Startseite", tabName = "start", icon = icon("home")),
        menuItem("Karte", tabName = "map", icon = icon("map")),
        menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart")),
        menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
        )
  ),
  dashboardBody(
    tabItems(
        tabItem(tabName = "start",
                fluidRow(
                  valueBoxOutput("total_trees"),
                  valueBoxOutput("total_water"),
                  valueBoxOutput("avg_water")  
                ),
                fluidRow(
                    box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE))
                )

        )
    ),
    tabItem(tabName = "map",
              fluidRow(
                box(title = "Filter", status = "primary", solidHeader = TRUE, width = 4,
                    selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
                    
                    selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE),
                    
                    selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df$gattung_deutsch)), selected = "Alle", multiple = TRUE)
                )
              ),
              leafletOutput("map", height = "800px")
      ),
  )

# Server-Logik
server <- function(input, output, session) {

        convert_units <- function(liters) {
    if (liters >= 1e6) {
      return(list(value = round(liters / 1e6, 2), unit = "ML"))
    } else if (liters >= 1e3) {
      return(list(value = round(liters / 1e3, 2), unit = "m³"))
    } else {
      return(list(value = round(liters, 2), unit = "L"))
    }
  }
  
  # Funktion zum Umrechnen von Vektoren
  convert_unit_vector <- function(liters_vector) {
    sapply(liters_vector, function(liters) {
      conversion_result <- convert_units(liters)
      return(list(value = conversion_result$value, unit = conversion_result$unit))
    })
  }
  
  full_unit <- function(unit) {
    if(length(unit) == 1) { 
      switch(unit,
             "ML" = "Mega Liter", 
             "L" = "Liter", 
             "m³" = "Kubikmeter",  
             "kL" = "Kilo Liter",
             unit)  # Default 
    } else {
      return("Unknown unit")  
    }
  }
  
  filteredData <- reactive({
    df_clean %>%
      filter(
        (input$bezirk == "Alle" | bezirk %in% input$bezirk)
      )
  })

   output$total_trees <- renderValueBox({
    valueBox(
      formatC(nrow(filteredData()), big.mark="."),
      "Gesamtzahl der gegossenen Bäume",
      icon = icon("tree"),
      color = "green"
    )
  })


    output$total_water <- renderValueBox({
        # Umrechnung des Werts und Ermittlung der Einheit
        conversion_result <- convert_units(sum(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE))
        
        # Der umgerechnete Wert und die Einheit
        converted_value <- conversion_result$value
        unit <- conversion_result$unit
        
        valueBox(
            paste(format(converted_value, big.mark = "."), unit),
            paste("Gesamtbewässerung (", full_unit(unit), ")", sep=""), 
            icon = icon("tint"),
            color = "blue"
        )
    }) 

    output$avg_water <- renderValueBox({
        valueBox(
            formatC(mean(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE), digits = 2, big.mark="."),
            "Durchschnittliche Bewässerung pro gegossenen Baum (Liter)",
            icon = icon("chart-line"),
            color = "aqua"
        )
    })





    # Karte 
    # Bewässerungsfrequenz berechnen
    bewässerungs_frequenz <- df_clean %>%
        group_by(id) %>%
        filter(n() > 1) %>% # Nur Bäume mit mehreren Bewässerungen behalten
        arrange(id, timestamp) %>%
        mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
        summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
        ungroup()
    
    # Die berechneten Daten mit den ursprünglichen Baumdaten zusammenführen
    df_clean <- df_clean %>%
        left_join(bewässerungs_frequenz, by = "id")
    
    # Falls ein Baum nur einmal bewässert wurde, setzen wir das Intervall auf NA oder einen hohen Wert
    df_clean$durchschnitts_intervall[is.na(df_clean$durchschnitts_intervall)] <- Inf


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

  # Interaktive Karte (openStreetMap) mit Leaflet rendern
  output$map <- renderLeaflet({
    leaflet(mapFilteredData()) %>%
      addTiles() %>% # OpenStreetMap-Hintergrundkarte hinzufügen
      addCircleMarkers(
        ~lng, ~lat, 
        color = ~color_palette(pmin(ifelse(is.na(bewaesserungsmenge_in_liter), 0, bewaesserungsmenge_in_liter), 600)),
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
        values = c(0, 600),
        title = "Bewässerungsmenge (Liter)",
        opacity = 1
      )
  })

}

```