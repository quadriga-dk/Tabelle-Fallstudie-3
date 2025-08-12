---
lang: de-DE
---

(watering)=
# Einfügen Bewässerungsanalyse


## Die Benutzeroberfläche
In der ui definieren wir eine neue Tab-Seite namens "stats" mit zwei Diagrammfeldern:

```bash
tabItem(tabName = "analysis", 
        fluidRow(
          box(title = tagList("Bewässerung pro Bezirk (2020-2024)", div(actionButton("info_btn_hbpb", label = "", icon = icon("info-circle")), style = "position: absolute; right: 15px; top: 5px;")), 
              status = "primary", solidHeader = TRUE, width = 12,
              radioButtons("water_mode", "Anzeige wählen:", 
                           choices = c("Durchschnittliche Bewässerung" = "avg", 
                                       "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                           selected = "avg", inline = TRUE),
              conditionalPanel(
                condition = "input.water_mode == 'avg'",
                plotOutput("hist_bewaesserung_pro_bezirk")
              ),
              conditionalPanel(
                condition = "input.water_mode == 'ratio'",
                plotlyOutput("hist_bewaesserung_verhaeltnis")
              )
          )
        )
)
```

**Erklärung der Elemente:**

- ``tabItem``: Dieser Abschnitt definiert einen einzelnen Tab (Reiter) in der Benutzeroberfläche der Anwendung. In diesem Fall geht es um die Bewässerung in den Jahren 2020 bis 2024.

- ``fluidRow``: Eine Methode, die verwendet wird, um Elemente in einer flexiblen Zeilenstruktur anzuordnen.

- ``box``: Eine Box, die Inhalte wie Diagramme und Steuerelemente umfasst. Hier wird der Titel der Box gesetzt ("Bewässerung pro Bezirk"), und es wird ein Info-Button hinzugefügt, der eine Erklärung zur Anzeige gibt.

- ``actionButton``: Ein interaktives Element, das einen Button erzeugt. Der Button hat die ID ``"info_btn_hbpb"`` und wird später verwendet, um eine Erklärung zur Grafik anzuzeigen.

- ``radioButtons``: Ein Auswahlfeld, das dem Benutzer erlaubt, zwischen der Anzeige der "durchschnittlichen Bewässerung" und dem "Verhältnis Bewässerung / Anzahl Bäume" zu wählen.

- ``conditionalPanel``: Ein bedingtes Panel, das je nach Auswahl des Benutzers angezeigt wird. Wenn der Benutzer "Durchschnittliche Bewässerung" wählt, wird das Diagramm ``hist_bewaesserung_pro_bezirk`` angezeigt, und wenn "Verhältnis Bewässerung / Anzahl Bäume" gewählt wird, wird h``ist_bewaesserung_verhaeltnis`` angezeigt.

## Berechnung der Bewässerung

Der erste Teil des Codes, der die **durchschnittliche Bewässerung pro Bezirk** darstellt, berechnet, wie viel Wasser insgesamt in jedem Bezirk verbraucht wurde.

```bash
output$hist_bewaesserung_pro_bezirk <- renderPlot({
  df_agg <- df_clean %>%
    group_by(bezirk) %>%
    summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
    ungroup()  
  
  df_agg <- df_agg %>%
    mutate(
      converted = purrr::map(total_water, convert_units),  # Umrechnung der Einheit
      value = sapply(converted, `[[`, "value"),  # Extrahiert den numerischen Wert
      unit = sapply(converted, `[[`, "unit")  # Extrahiert die Einheit
    )
  
  ggplot(df_agg, aes(x = bezirk, y = value, fill = bezirk)) +
    geom_bar(stat = "identity", color = "white", alpha = 0.7) +
    labs(
      title = "Bewässerung pro Bezirk",
      x = "Bezirke in Berlin",
      y = paste("Gesamte Bewässerungsmenge (", unique(df_agg$unit), ")", sep = "")
    ) +
    theme_light() +
    theme(legend.position = "bottom", axis.text.x = element_text(angle = 55, hjust = 1)) +
    scale_fill_discrete(name = "Bezirk")
})

```

**Erklärung der Elemente:** 

- ``df_clean``: Hier handelt es sich um einen bereinigten Datensatz, der alle relevanten Daten zu Bewässerung und Bezirken enthält.

- ``group_by(bezirk)``: Diese Funktion gruppiert die Daten nach den verschiedenen Bezirken. Dies ermöglicht es, für jeden Bezirk die Gesamtbewässerungsmenge zu berechnen.

- ``summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE))``: Diese Zeile summiert die Bewässerungsmengen pro Bezirk und erstellt eine neue Variable ``total_water``.

- ``mutate()``: Hier wird die Funktion ``purrr::map() ``verwendet, um jede Bewässerungsmenge in die passende Einheit umzuwandeln (z.B. von Litern in Milliliter oder Kubikmeter).

- ``ggplot``: Erzeugt ein Balkendiagramm, das die gesammelten Daten visualisiert. Es zeigt die Gesamtbewässerungsmenge pro Bezirk an.

## Interaktive Auswahl und Trenddiagramme

Ein weiterer Abschnitt des Codes ermöglicht es den Benutzern, einen Zeitraum oder bestimmte Bezirke auszuwählen, um Trends in der Bewässerung zu sehen.


```bash
output$trend_water <- renderPlotly({
  plot <- df_clean %>%
    filter(input$trend_bezirk_pj == "Alle" | bezirk %in% input$trend_bezirk_pj) %>%
    filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2]) %>%
    group_by(pflanzjahr) %>%
    summarize(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
    ggplot(aes(x = pflanzjahr, y = total_water)) +
    geom_line(color = "blue") +
    geom_point(aes(text = paste("Summe:", total_water, "l")), size = 0.2, color = "blue") + 
    theme_minimal() +
    labs(title = "Trend der Bewässerung je nach Pflanzjahr", x = "Pflanzjahr", y = "Gesamtbewässerung (Liter)")
  
  ggplotly(plot, tooltip = "text") # Aktiviert den Hover-Effekt für "text"
})
```

**Erklärung:**

- ``filter()``: Wählt nur Daten aus, die dem Benutzerfilter entsprechen. Hier kann der Benutzer zum Beispiel nach Bezirken oder nach bestimmten Jahren filtern.

- ``group_by(pflanzjahr)``: Gruppiert die Daten nach Pflanzjahr (Jahr der Baumsetzung), um die Gesamtbewässerung pro Jahr zu berechnen.

- ``ggplot``: Stellt die Daten als Liniendiagramm dar, das den Trend der Bewässerung über die Jahre hinweg zeigt. Der Tooltip zeigt zusätzliche Informationen an, wenn der Benutzer über die Datenpunkte fährt.

<details>
<summary><strong>Hier der gesamte Code zur Kontrolle</strong></summary>

```r
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

            tabItem(tabName = "analysis",
              fluidRow(
                box(title = tagList("Bewässerung pro Bezirk (2020-2024)", 
                                    div(actionButton("info_btn_hbpb", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12,
                    radioButtons("water_mode", "Anzeige wählen:", 
                                 choices = c("Durchschnittliche Bewässerung" = "avg", 
                                             "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                                 selected = "avg", inline = TRUE),
                    
                    conditionalPanel(
                      condition = "input.water_mode == 'avg'",
                      plotOutput("hist_bewaesserung_pro_bezirk")
                    ),
                    
                    conditionalPanel(
                      condition = "input.water_mode == 'ratio'",
                      plotlyOutput("hist_bewaesserung_verhaeltnis")
                    )
                ),
                # box(title = "Verhältnis von Bäumen zu durchschnittlicher Bewässerung pro Bezirk", status = "primary", solidHeader = TRUE, width = 6,
                #     plotOutput("bar_water_vh")
                # )
              ),
              fluidRow(
                box(title = tagList("Trend der Bewässerung je Pflanzjahr", 
                                    div(actionButton("info_btn_tdbjp", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("trend_year", "Jahre filtern:", 
                                min = 1900, 
                                max = max(df$pflanzjahr, na.rm = TRUE), 
                                value = c(min(df$pflanzjahr, na.rm = TRUE), max(df$pflanzjahr, na.rm = TRUE)), 
                                step = 1),
                    
                    selectInput("trend_bezirk_pj", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    plotlyOutput("trend_water")
                )
              ), 
              fluidRow(
                box(title = tagList("Trend der Bewässerung", 
                                    div(actionButton("info_btn_tdb", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                  status = "primary", solidHeader = TRUE, width = 12, 
                    radioButtons("trend_mode", "Anzeige wählen:", 
                                 choices = c("Monatsweise (pro Jahr)" = "month", "Jahresweise (2020-2024)" = "year"),
                                 selected = "month", inline = TRUE),
                    
                    conditionalPanel(
                      condition = "input.trend_mode == 'month'",
                      selectInput("trend_year_ts", "Jahr auswählen:", 
                                  choices = unique(year(df_clean$timestamp)), 
                                  selected = max(year(df_clean$timestamp)))
                    ),
                    selectInput("trend_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    selectInput("trend_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df$gattung_deutsch)), selected = "Alle", multiple = TRUE),
                    
                    plotlyOutput("trend_water_ts")
                )
              ),
              fluidRow(
                box(title = "Ranking",status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("bar_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE),
          
                    box(title = tagList("Top 10 Straßen mit höchster Bewässerung (2020-2024)", 
                                        div(actionButton("info_btn_top", label = "", icon = icon("info-circle")),  # Info-Button 
                                            style = "position: absolute; right: 15px; top: 5px;")),
                        status = "primary", solidHeader = TRUE, width = 6,
                        radioButtons("water_mode_Top", "Anzeige wählen:", 
                                     choices = c("Durchschnittliche Bewässerung" = "avg", 
                                                 "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                                     selected = "avg", inline = TRUE),
                        
                        conditionalPanel(
                          condition = "input.water_mode_Top == 'avg'",
                          plotOutput("hist_Top_10_best")
                        ),
                        
                        conditionalPanel(
                          condition = "input.water_mode_Top == 'ratio'",
                          plotOutput("hist_Top_10_best_verhaeltnis_baum")
                        )
                    ),
                    box(title = tagList("Bottom 10 Straßen mit geringster Bewässerung (2020-2024)", 
                                        div(actionButton("info_btn_bottom", label = "", icon = icon("info-circle")),  # Info-Button 
                                            style = "position: absolute; right: 15px; top: 5px;")),
                        
                        status = "primary", solidHeader = TRUE, width = 6,
                        radioButtons("water_mode_Bottom", "Anzeige wählen:", 
                                     choices = c("Durchschnittliche Bewässerung" = "avg", 
                                                 "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                                     selected = "avg", inline = TRUE),
                        conditionalPanel(
                          condition = "input.water_mode_Bottom == 'avg'",
                          plotOutput("hist_Top_10_worst")   
                        ),
                        
                        conditionalPanel(
                          condition = "input.water_mode_Bottom == 'ratio'",
                          plotOutput("hist_Top_10_worst_verhaeltnis_baum")
                        )
                    )
                )
              )
      )
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









  # Bewässerungsanalyse

   output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_clean %>%
      group_by(bezirk) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      ungroup() 
    
    
    df_agg <- df_agg %>%
      mutate(
        converted = purrr::map(total_water, convert_units), 
        value = sapply(converted, `[[`, "value"),  
        unit = sapply(converted, `[[`, "unit")  
      )
    
    ggplot(df_agg, aes(x = bezirk, y = value, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      labs(
        title = "Bewässerung pro Bezirk",
        x = "Bezirke in Berlin",
        y = paste("Gesamte Bewässerungsmenge (", unique(df_agg$unit), ")", sep = "")
      ) +
      theme_light() +
      theme(legend.position = "bottom",
            axis.text.x = element_text(angle = 55, hjust = 1)) +
      scale_fill_discrete(name = "Bezirk")
  })

output$hist_bewaesserung_verhaeltnis <- renderPlotly({
    plot <- df_clean %>%
      group_by(bezirk) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        tree_count = n_distinct(id)  # Anzahl eindeutiger Bäume pro Bezirk
      ) %>%
      mutate(water_sum_trees = total_water / tree_count) %>%  # Verhältnis berechnen
      ggplot(aes(x = reorder(bezirk, water_sum_trees), y = water_sum_trees, fill = bezirk)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(
        title = "Verhältnis Bewässerung / Anzahl Bäume nach Bezirk", 
        x = "Bezirk", 
        y = "Bewässerung pro Baum (Liter)"
      ) +
      theme_minimal() +
      theme(legend.position = "none")
    
    ggplotly(plot, tooltip = "y")  # Hover-Tooltip für `water_per_tree`
  })

  output$trend_water <- renderPlotly({
    plot <- df_clean %>%
      filter(input$trend_bezirk_pj == "Alle" | bezirk %in% input$trend_bezirk_pj) %>%
      filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2]) %>%
      group_by(pflanzjahr) %>%
      summarize(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      ggplot(aes(x = pflanzjahr, y = total_water)) +
      geom_line(color = "blue") +
      geom_point(aes(text = paste("Summe:", total_water, "l")),size = 0.2, color = "blue") + 
      theme_minimal() +
      labs(title = "Trend der Bewässerung je nach Pflanzjahr", x = "Pflanzjahr", y = "Gesamtbewässerung (Liter)")
    
    ggplotly(plot, tooltip = "text") # Aktiviert den Hover-Effekt für "text"
  })

 # Top 10 und Bottom 10 Straßen auswählen
  top_streets <- reactive({
      barFilteredData() %>%
      group_by(strname) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(desc(total_water)) %>%
      head(10)  # Top 10 auswählen
  })
  
  bottom_streets <- reactive({
      barFilteredData()%>%
      group_by(strname) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(desc(total_water)) %>%
      tail(10)  
  })
  
  
  output$hist_Top_10_best <- renderPlot({
    df_top <- top_streets()
    ggplot(df_top, aes(x = reorder(strname, total_water), y = total_water, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top 10 Straßen mit höchster Bewässerung", x = "Straße", y = "Gesamte Bewässerung (Liter)") +
      scale_fill_discrete(name = "Straßennamen") +  # Ändert den Titel der Legende
      theme_minimal()
  })
  
  output$hist_Top_10_worst <- renderPlot({
    df_bottom <- bottom_streets() 
    ggplot(df_bottom, aes(x = reorder(strname, total_water), y = total_water, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Bottom 10 Straßen mit geringster Bewässerung", x = "Straße", y = "Gesamte Bewässerung (Liter)") +
      scale_fill_discrete(name = "Straßennamen") +  # Ändert den Titel der Legende
      theme_minimal() 
  })
  
  streetWaterRatio <- reactive({
      barFilteredData() %>%
      group_by(strname) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        tree_count = n_distinct(id),
        water_per_tree = total_water / tree_count
      ) %>%
      arrange(desc(water_per_tree))
  })
  
  output$hist_Top_10_best_verhaeltnis_baum <- renderPlot({
    ggplot(streetWaterRatio() %>% head(10), aes(x = reorder(strname, water_per_tree), y = water_per_tree, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top 10 Straßen nach Bewässerung pro Baum", x = "Straße", y = "Liter pro Baum") +
      scale_fill_discrete(name = "Straßennamen") +
      theme_minimal()
  })
  
  output$hist_Top_10_worst_verhaeltnis_baum <- renderPlot({
    ggplot(streetWaterRatio() %>% tail(10), aes(x = reorder(strname, water_per_tree), y = water_per_tree, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Bottom 10 Straßen nach Bewässerung pro Baum", x = "Straße", y = "Liter pro Baum") +
      scale_fill_discrete(name = "Straßennamen") +
      theme_minimal()
  })
  
  filtered_trend_data <- reactive({
    df_agg <- df_clean %>%
      mutate(timestamp = ymd_hms(timestamp),
             year = year(timestamp),
             month = month(timestamp, label = TRUE)) %>%
      filter(
        (input$trend_mode == "month" & year == input$trend_year_ts) | 
          (input$trend_mode == "year" & year >= 2020 & year <= 2024),
        (input$trend_bezirk == "Alle" | bezirk %in% input$trend_bezirk),
        (input$trend_baumgattung == "Alle" | gattung_deutsch %in% input$trend_baumgattung)
      ) %>%
      group_by(!!sym(input$trend_mode)) %>%  # Dynamische Gruppierung
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(!!sym(input$trend_mode))  # Dynamische Sortierung
    
      # Einheit umrechnen
      conversion_result <- convert_units(max(df_agg$total_water, na.rm = TRUE))
      df_agg <- df_agg %>%
        mutate(
          converted_value = total_water / (ifelse(conversion_result$unit == "ML", 1e6, 
                                                  ifelse(conversion_result$unit == "m³", 1e3, 1))),
          unit = conversion_result$unit
        )
      
      return(df_agg)
  })
  
  output$trend_water_ts <- renderPlotly({
    df_plot <- filtered_trend_data()
    
    plot <- ggplot(df_plot, 
                   aes(x = get(names(df_plot)[1]), y = converted_value, group = 1)) +
      geom_line(color = "blue") + 
      geom_point(aes(text = paste("Summe:", converted_value, df_plot$unit)), size = 0.2, color = "blue") +
      labs(
        title = ifelse(input$trend_mode == "month", 
                       paste("Bewässerungstrend für das Jahr", input$trend_year_ts), 
                       "Bewässerungstrend (2020 - 2024)"),
        x = ifelse(input$trend_mode == "month", "Monat", "Jahr"),
        y = paste("Gesamtbewässerung (", unique(df_plot$unit), ")", sep = "")
      ) +
      theme_minimal()
    
    ggplotly(plot, tooltip = "text")
  })

# Anzahl der Bäume, Gesamtbewässerung und durchschnittliche Bewässerung pro Bezirk berechnen
  baum_bewaesserung_daten <- df_clean %>%
    group_by(bezirk) %>%
    summarise(
      baum_anzahl = n(),
      gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
      durchschnittliche_bewaesserung = mean(bewaesserungsmenge_in_liter, na.rm = TRUE)
    ) %>%
    mutate(baum_anzahl_pro_durchschnitt = durchschnittliche_bewaesserung / baum_anzahl ) %>%
    arrange(desc(baum_anzahl_pro_durchschnitt))
  
  # Daten umwandeln für gruppiertes Balkendiagramm
  baum_bewaesserung_long <- baum_bewaesserung_daten %>%
    pivot_longer(cols = c(baum_anzahl_pro_durchschnitt), 
                 names_to = "Kategorie", 
                 values_to = "Wert")

 # Bewässerung pro Bezirk (2020-2024)
  observeEvent(input$info_btn_hbpb, {
    if (input$water_mode == "avg") {
      showModal(modalDialog(
        title = "Erklärung: Durchschnittliche Bewässerung pro Bezirk",
        p("Dieses Diagramm zeigt, wie viel Wasser im Durchschnitt in jedem Bezirk über den Zeitraum 2020-2024 verbraucht wurde."),
        easyClose = TRUE,
        footer = NULL
      ))
    } else if (input$water_mode == "ratio") {
      showModal(modalDialog(
        title = "Erklärung: Verhältnis Bewässerung zu Baumanzahl",
        p("Dieses Diagramm stellt die Gesamtmenge an Wasser pro Bezirk ins Verhältnis zur Anzahl der gegossenen Bäume."),
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
  
  
  # Ranking Top 
  observeEvent(input$info_btn_top, {
    if (input$water_mode_Top == "avg") {
      showModal(modalDialog(
        title = "Erklärung: Top 10 Straßen mit höchster Bewässerung",
        p("Dieses Diagramm zeigt die zehn Straßen mit der höchsten Gesamtbewässerung im Zeitraum 2020-2024."),
        easyClose = TRUE,
        footer = NULL
      ))
    } else if (input$water_mode_Top == "ratio") {
      showModal(modalDialog(
        title = "Erklärung: Top 10 Straßen mit höchster Bewässerung (Verhältnis)",
        p("Hier wird die gesamte Bewässerungsmenge pro Straße ins Verhältnis zur Anzahl der gegossenen Bäume gesetzt."),
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
  
  
  # Ranking Bottom 
  observeEvent(input$info_btn_bottom, {
    if (input$water_mode_Bottom == "avg") {
      showModal(modalDialog(
        title = "Erklärung: Bottom 10 Straßen mit geringster Bewässerung",
        p("Dieses Diagramm zeigt die zehn Straßen mit der geringsten Gesamtbewässerung im Zeitraum 2020-2024."),
        easyClose = TRUE,
        footer = NULL
      ))
    } else if (input$water_mode_Bottom == "ratio") {
      showModal(modalDialog(
        title = "Erklärung: Bottom 10 Straßen mit geringster Bewässerung (Verhältnis)",
        p("Hier wird die gesamte Bewässerungsmenge pro Straße ins Verhältnis zur Anzahl der gegossenen Bäume gesetzt."),
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })              
}

```
</details>