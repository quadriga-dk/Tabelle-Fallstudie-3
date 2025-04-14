# Übung Baumstatistik

In dieser Übung lernen Sie, wie man mit Hilfe der Bibliothek plotly zwei interaktive Diagramme erstellt:

- Eine Balkengrafik zeigt die Verteilung der gegossenen Bäume nach Berliner Bezirken.

- Ein Kreisdiagramm (Tortendiagramm) visualisiert die häufigsten Baumarten – mit der Möglichkeit, nach Bezirk zu filtern.

### Teil 1: Die Benutzeroberfläche
In der ui definieren wir eine neue Tab-Seite namens "stats" mit zwei Diagrammfeldern:

```bash
tabItem(tabName = "stats",
  fluidRow(
    box(title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
                        div(actionButton("info_btn", label = "", icon = icon("info-circle")), 
                            style = "position: absolute; right: 15px; top: 5px;")),
        status = "primary", solidHeader = TRUE, width = 12,
        plotlyOutput("tree_distribution")
    ),
    box(title = tagList("Häufigste gegossene Baumarten", 
                        div(actionButton("info_btn_hb", label = "", icon = icon("info-circle")), 
                            style = "position: absolute; right: 15px; top: 5px;")),
        status = "primary", solidHeader = TRUE, width = 12, 
        selectInput("pie_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
        plotlyOutput("tree_pie_chart")
    )
  )
)
```
#### Erklärung der Elemente:
- ``box(...)``: Ein Kasten-Layout für die Diagramme mit Titel.

- ``plotlyOutput(...)``: Platzhalter für das interaktive Diagramm.

- ``selectInput(...)``: Erlaubt die Auswahl eines oder mehrerer Bezirke.

- ``actionButton(...)``: Fügt einen kleinen Info-Button mit Icon ein.

- ``tagList(...)``: Kombiniert Text und HTML-Elemente im Titel.


### Teil 2: Baumverteilung nach Bezirk (Balkendiagramm)

Ziel:
Zeigen, in welchen Bezirken wie viele Bäume gegossen wurden.

```bash
output$tree_distribution <- renderPlotly({
  plot <- df_clean %>%
    group_by(bezirk) %>%
    summarise(tree_count = n_distinct(id)) %>% 
    ggplot(aes(x = reorder(bezirk, tree_count), y = tree_count, fill = bezirk)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    labs(title = "Baumverteilung nach Bezirk", x = "Bezirk", y = "Anzahl Bäume") + 
    scale_fill_discrete(name = "Bezirk") +
    theme_minimal() +
    theme(legend.position = "none")
  
  ggplotly(plot, tooltip = "y")
})

```

#### Erklärung:
- ``group_by(bezirk)``: Gruppiert die Daten nach Bezirk.

- ``n_distinct(id)``: Zählt einzigartige Baum-IDs – damit Bäume nicht doppelt gezählt werden.

- ``reorder(...)``: Sortiert die Bezirke nach Baumanzahl (von wenig nach viel).

- ``coord_flip()``: Dreht das Diagramm horizontal – besser lesbar.

- ``ggplotly(...)``: Wandelt das ggplot-Diagramm in eine interaktive Version um.

- ``tooltip = "y"``: Beim Hover zeigt es die Anzahl der Bäume an.

### Teil 3: Die häufigsten Baumarten (Kreisdiagramm)

Ziel:
Welche Baumarten wurden am häufigsten gegossen? Optional gefiltert nach Bezirk.

```bash
output$tree_pie_chart <- renderPlotly({
  tree_data <- df_clean %>%
    filter((input$pie_bezirk == "Alle" | bezirk %in% input$pie_bezirk)) %>%
    filter(!str_detect(gattung_deutsch, "^[0-9]+$")) %>% 
    distinct(id, gattung_deutsch) %>%  
    count(gattung_deutsch, sort = TRUE) %>%
    top_n(10)
```

##### Erklärung:
- ``input$pie_bezirk``: Nutzt die Auswahl aus dem Dropdown-Menü.

- ``str_detect(...)``: Filtert ungültige Gattungen raus (z. B. Einträge mit nur Zahlen).

- ``distinct(id, gattung_deutsch)``: Zählt jeden Baum nur einmal, auch wenn mehrfach gegossen.

- ``count(...)``: Zählt die Anzahl der Bäume je Gattung.

- ``top_n(10)``: Zeigt die Top 10 Baumarten.

**Jetzt erstellen wir das Diagramm:**

```bash
fig <- plot_ly(
  tree_data,
  labels = ~gattung_deutsch,
  values = ~n,
  type = 'pie',
  textinfo = 'label+percent',
  hoverinfo = 'label+value+percent',
  marker = list(colors = RColorBrewer::brewer.pal(10, "Set3"))
)
```

- ``plot_ly(...)``: Erzeugt ein plotly-Diagramm.

- ``type = 'pie``': Kreisdiagramm

- ``labels``: Baumart

- ``values``: Anzahl

- ``textinfo``: Zeigt Label + Prozent an

- ``hoverinfo``: Zeigt beim Hover auch absolute Zahlen

- ``brewer.pal(...)``: Farbpalette aus der RColorBrewer-Bibliothek

Dann folgt das Layout:

```bash
fig <- fig %>% layout(
  title = list(
    text = paste("Top 10 häufigste Baumarten im Bezirk:", paste(input$pie_bezirk, collapse=", ")),
    font = list(size = 16, color = "#333", family = "Arial")
  ),
  showlegend = TRUE
)
```


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

      tabItem(tabName = "stats",
              fluidRow(
                box(title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
                                   div(actionButton("info_btn", label = "", icon = icon("info-circle")),  # Info-Button 
                                       style = "position: absolute; right: 15px; top: 5px;")),
                  status = "primary", solidHeader = TRUE, width = 12,
                    plotlyOutput("tree_distribution")
                ),
                box(title = tagList("Häufigste gegossene Baumarten", 
                                    div(actionButton("info_btn_hb", label = "", icon = icon("info-circle")),  # Info-Button 
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12, height = "auto", 
                    selectInput("pie_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
                    plotlyOutput("tree_pie_chart"),
                    fill = TRUE
                )
              )
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



  # Baumstatistik

  output$tree_distribution <- renderPlotly({
    plot <- df_clean %>%
      group_by(bezirk) %>%
      summarise(tree_count = n_distinct(id)) %>% 
      ggplot(aes(x = reorder(bezirk, tree_count), y = tree_count, fill = bezirk)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Baumverteilung nach Bezirk", x = "Bezirk", y = "Anzahl Bäume") + 
      scale_fill_discrete(name = "Bezirk") +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(plot, tooltip = "y")
  })

  output$tree_pie_chart <- renderPlotly({
    tree_data <- df_clean %>%
      filter((input$pie_bezirk == "Alle" | bezirk %in% input$pie_bezirk)) %>%
      filter(!str_detect(gattung_deutsch, "^[0-9]+$")) %>%  # Entfernt Einträge mit Zahlen
      distinct(id, gattung_deutsch) %>%  # Stellt sicher, dass jede ID nur einmal gezählt wird
      count(gattung_deutsch, sort = TRUE) %>%
      top_n(10)
    
    if (nrow(tree_data) == 0) {
      return(plotly_empty())
    }
    
    fig <- plot_ly(
      tree_data,
      labels = ~gattung_deutsch,
      values = ~n,
      type = 'pie',
      textinfo = 'label+percent',  # Zeigt Name + Prozentsatz an
      hoverinfo = 'label+value+percent',  # Zeigt auch absolute Werte beim Hover an
      marker = list(colors = RColorBrewer::brewer.pal(10, "Set3"))  # Schöne Farbpalette
    ) 
    
    fig <- fig %>% layout(
      title = list(
        text = paste("Top 10 häufigste Baumarten im Bezirk:", paste(input$pie_bezirk, collapse=", ")),
        font = list(size = 16, color = "#333", family = "Arial")
      ),
      showlegend = TRUE
    )
    
    fig
  })
}

```