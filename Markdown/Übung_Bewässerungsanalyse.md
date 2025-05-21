# Übung Bewässerungsanalyse

**Ziel**
Ziel ist es, sowohl absolute als auch relative Mengen der Bewässerung darzustellen, Trends im Zeitverlauf zu erkennen und Ranglisten für besonders stark oder schwach bewässerte Straßen zu generieren. Verstehen, wie die App das Bewässerungsverhalten analysiert – auf Bezirks-, Straßen- und Zeit-Ebene. Fokus:
- Vergleich absolute vs. relative Mengen
- Zeitverlauf (nach Pflanzjahr und Jahr)
- Top/Bottom 10 Rankings

### 1. Benutzeroberfläche (UI)
Die Benutzeroberfläche besteht aus zwei Teilen:

- einer Seitenleiste (``sidebarMenu``) mit der Navigation

- einem Inhaltsbereich (``tabItem``) mit:
  - Balkendiagrammen
  - Liniendiagrammen

**Navigation in der Seitenleiste**
```bash
dashboardSidebar(
  sidebarMenu(
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area")),
  )
)
```
- ``sidebarMenu(...)`` ist die Hauptnavigation des Dashboards.
- ``menuItem(...)`` erzeugt einen Menüpunkt:
- ``"Baumstatistik"`` ist der angezeigte Name.
- ``tabName = "stats"`` verbindet den Menüpunkt mit dem Tab.
- ``icon("bar-chart")`` zeigt ein kleines Symbol an.

```{admonition} Merke: 
:class: keypoint 

Mit ``menuItem(...)`` wird ein weiterer Navigationspunkt eingebunden. "stats" als tabName verknüpft ihn mit dem Baumstatistiktab.
```

## 2. UI: Balkendiagrammen und Liniendiagrammen mit Filter-Boxen

```bash
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
                )
              ),
              fluidRow(
                box(title = tagList("Trend der Bewässerung je Pflanzjahr", 
                                    div(actionButton("info_btn_tdbjp", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("trend_year", "Jahre filtern:", 
                                min = 1900, 
                                max = max(df_merged$pflanzjahr, na.rm = TRUE), 
                                value = c(min(df_merged$pflanzjahr, na.rm = TRUE), max(df_merged$pflanzjahr, na.rm = TRUE)), 
                                step = 1, sep = ""),
                    
                    selectInput("trend_bezirk_pj", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
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
                                  choices = unique(year(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)), 
                                  selected = max(year(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)))
                    ),
                    selectInput("trend_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    selectInput("trend_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df_merged$gattung_deutsch)), selected = "Alle", multiple = TRUE),
                    
                    plotlyOutput("trend_water_ts")
                )
              ),
              fluidRow(
                box(title = "Ranking",status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("bar_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
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
      ),
```
- ``box(...)`` ist ein Container mit:
    - ``title`` (Überschrift)
    - ``status = "primary"`` (Farbe)
    - ``solidHeader = TRUE`` (fester Rand)
    - ``width = 12`` (volle Breite – 12 ist die maximale Spaltenanzahl)
- ``fluidRow(...)`` sorgt für eine horizontale Anordnung (z. B. nebeneinander statt untereinander).
- ``multiple = TRUE`` bedeutet, dass man mehrere Optionen gleichzeitig auswählen kann.

**Erklärung:**
Die Benutzeroberfläche erlaubt es, zwischen einer absoluten und einer relativen Darstellung zu wechseln. Dies ermöglicht einen differenzierten Vergleich zwischen Bezirken.

```{admonition} Merke: 
:class: keypoint 

``fluidRow()`` ordnet Inhalte nebeneinander. ``box(...)`` gruppiert UI-Elemente visuell und funktional.
```

## 3. Bewässerung pro Bezirk (2020-2024) im Server: 

```bash
 output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_merged %>%
      drop_na(bewaesserungsmenge_in_liter) %>%
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
    plot <- df_merged %>%
      group_by(bezirk) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        tree_count = n_distinct(gisid)  # Anzahl eindeutiger Bäume pro Bezirk
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
  ```
- ``drop_na(...)`` stellt sicher, dass keine fehlenden Werte im Plot verarbeitet werden, was potenzielle Fehler verhindert.
- ``group_by``: Gruppiert die Daten nach einer bestimmten Spalte – zum Beispiel nach Bezirken oder Baumarten. Damit kann man pro Gruppe Berechnungen durchführen.
- summarise
- ``mutate``: Fügt neue Spalten zu einem Datensatz hinzu oder verändert vorhandene. Beispiel: Berechnung des Anteils gegossener Bäume.
- ``coord_flip()``: Dreht die Achsen – so wird aus einem vertikalen Balkendiagramm ein horizontales. Das ist oft besser lesbar, wenn die Namen lang sind.

## 4. Trend der Bewässerung je Pflanzjahr im Server

```bash
output$trend_water <- renderPlotly({
  df_plot <- df_merged %>%
    filter(input$trend_bezirk_pj == "Alle" | bezirk %in% input$trend_bezirk_pj) %>%
    filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2]) %>%
    group_by(pflanzjahr) %>%
    summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
    ggplot(aes(x = pflanzjahr, y = total_water)) +
    geom_line(color = "blue") +
    geom_point(aes(text = paste("Summe:", total_water, "l")), size = 0.2, color = "blue") +
    labs(title = "Trend: Bewässerung je Pflanzjahr", x = "Pflanzjahr", y = "Gesamt (Liter)") +
    theme_minimal()

  ggplotly(df_plot, tooltip = "text")
})
```
- ``filter(...)``: Filtert die Daten anhand von Bedingungen. Hier z. B.:
  - Nur bestimmte Bezirke (bezirk %in% input$trend_bezirk_pj) oder alle, wenn "Alle" gewählt wurde.
  - Und: Nur Bäume mit einem Pflanzjahr im ausgewählten Bereich (input$trend_year ist ein Jahrbereich/Slider).
- ``==``: Vergleichsoperator, prüft ob zwei Werte gleich sind.
- ``%in%``: Checkt, ob ein Wert in einem Vektor enthalten ist.
- ``na.rm = TRUE``: Ignoriert fehlende Werte beim Summieren (damit R nicht crasht, wenn NAs vorkommen).
- ``>=``: Größer und/oder Gleich
- ``%>%``  (Pipe-Operator)
Leitet das Ergebnis von links an die Funktion rechts weiter. Er sorgt für eine lesbare Verkettung von Operationen.
- ``&``: Und

## 5. Daten filtern im Server für den "Trend der Bewässerung": filtered_trend_data

filtered_trend_data <- reactive({
  df_agg <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
    mutate(timestamp = ymd_hms(timestamp),
           year = year(timestamp),
           month = lubridate::month(timestamp, label = TRUE)) %>%
    filter(
      (input$trend_mode == "month" & year == input$trend_year_ts) | 
      (input$trend_mode == "year" & year >= 2020 & year <= 2024),
      input$trend_bezirk == "Alle" | bezirk %in% input$trend_bezirk,
      input$trend_baumgattung == "Alle" | gattung_deutsch %in% input$trend_baumgattung
    ) %>%
    group_by(!!sym(input$trend_mode)) %>%
    summarise(total_water = sum(gesamt_bewaesserung)) %>%
    mutate(converted_value = total_water / 1e3, unit = "m³")  # Beispiel

  df_agg
})
```
- ``ymd_hms``: Funktion aus lubridate, die einen String oder Faktor in ein Datum mit Uhrzeit konvertiert (Format: "YYYY-MM-DD HH:MM:SS").
- ``!!sym(input$trend_mode)``:  Dynamische Gruppierung nach Monat oder Jahr, je nach Auswahl durch den Benutzer (tidy evaluation).


## 6. Trend der Bewässerung im Server

```bash
output$trend_water_ts <- renderPlotly({
  df_plot <- filtered_trend_data() %>%
    mutate(tooltip = paste("Summe:", round(converted_value, 2), unit))

  plot <- ggplot(df_plot,
      aes(x = get(names(df_plot)[1]), y = converted_value, group = 1)) +
    geom_line(color = "blue") +
    geom_point(aes(text = tooltip), size = 0.2, color = "blue") +
    labs(title = "Trend der Bewässerung",
         x = ifelse(input$trend_mode == "month", "Monat", "Jahr"),
         y = paste("Gesamt (", unique(df_plot$unit), ")", sep = "")) +
    theme_minimal()

  ggplotly(plot, tooltip = "text")
})
```
- ``geom_line``
- ``geom_point``

## 7. Top 10 Straßen mit höchster Bewässerung (2020-2024)

```bash
filteredData <- reactive({
    req(input$stats_baumvt_year)
    
    df <- df_merged %>%
      mutate(year = lubridate::year(timestamp))
    
    # Basisfilter nach Auswahl
    df_filtered <- df %>%
      filter(
        ("Baumbestand Stand 2025" %in% input$start_year & 
           (is.na(timestamp) | year %in% 2020:2024)) |
          
          ("2020-2024" %in% input$start_year & 
             !is.na(timestamp) & year %in% 2020:2024) |
          
          (any(!input$start_year %in% c("2020-2024", "Baumbestand Stand 2025")) & 
             year %in% as.numeric(input$start_year))
      )
    
    # Wenn NUR "2020-2024" ausgewählt ist, dann NA-Drop forcieren
    if (all(input$start_year == "2020-2024")) {
      df_filtered <- df_filtered %>% filter(!is.na(timestamp))
    }
    
    if (!is.null(input$bezirk) && input$bezirk != "Alle") {
      df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
    }
    
    df_filtered
  })
```


```bash
  barFilteredData <- reactive({
    filteredData() %>%
      drop_na(strname) %>%
      filter(input$bar_bezirk == "Alle" | bezirk %in% input$bar_bezirk)
  })
```

```bash
  # Top 10 und Bottom 10 Straßen auswählen
  top_streets <- reactive({
    barFilteredData() %>%
      group_by(strname) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(desc(total_water)) %>%
      head(10)  # Top 10 auswählen
  })
```

```bash
  output$hist_Top_10_best <- renderPlot({
    df_top <- top_streets()
    ggplot(df_top, aes(x = reorder(strname, total_water), y = total_water, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top 10 Straßen mit höchster Bewässerung", x = "Straße", y = "Gesamte Bewässerung (Liter)") +
      scale_fill_discrete(name = "Straßennamen") +  # Ändert den Titel der Legende
      theme_minimal()
  })
```

## 7. Bottom 10 Straßen mit geringster Bewässerung (2020-2024)

```bash
  bottom_streets <- reactive({
    barFilteredData()%>%
      group_by(strname) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(desc(total_water)) %>%
      tail(10)  
  })
```

```bash
  output$hist_Top_10_worst <- renderPlot({
    df_bottom <- bottom_streets() 
    ggplot(df_bottom, aes(x = reorder(strname, total_water), y = total_water, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Bottom 10 Straßen mit geringster Bewässerung", x = "Straße", y = "Gesamte Bewässerung (Liter)") +
      scale_fill_discrete(name = "Straßennamen") +  # Ändert den Titel der Legende
      theme_minimal() 
  })
```

# 8. Top 10 Straßen mit höchster Bewässerung  (2020-2024) im Verhältnis zur Baumanzahl

```bash
  streetWaterRatio <- reactive({
    barFilteredData() %>%
      group_by(strname) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        tree_count = n_distinct(gisid),
        water_per_tree = total_water / tree_count
      ) %>%
      arrange(desc(water_per_tree))
  })
```

```bash
  output$hist_Top_10_best_verhaeltnis_baum <- renderPlot({
    ggplot(streetWaterRatio() %>% head(10), aes(x = reorder(strname, water_per_tree), y = water_per_tree, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Top 10 Straßen nach Bewässerung pro Baum", x = "Straße", y = "Liter pro Baum") +
      scale_fill_discrete(name = "Straßennamen") +
      theme_minimal()
  })
```

# 9. Bottom 10 Straßen mit geringster Bewässerung (2020-2024) im Verhältnis zur Baumanzahl

```bash
  output$hist_Top_10_worst_verhaeltnis_baum <- renderPlot({
    ggplot(streetWaterRatio() %>% tail(10), aes(x = reorder(strname, water_per_tree), y = water_per_tree, fill = strname)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Bottom 10 Straßen nach Bewässerung pro Baum", x = "Straße", y = "Liter pro Baum") +
      scale_fill_discrete(name = "Straßennamen") +
      theme_minimal()
  })
```







Gesamter Code: 

```bash
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
    )
  ),
  dashboardBody(
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
                )
              ),
              fluidRow(
                box(title = tagList("Trend der Bewässerung je Pflanzjahr", 
                                    div(actionButton("info_btn_tdbjp", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("trend_year", "Jahre filtern:", 
                                min = 1900, 
                                max = max(df_merged$pflanzjahr, na.rm = TRUE), 
                                value = c(min(df_merged$pflanzjahr, na.rm = TRUE), max(df_merged$pflanzjahr, na.rm = TRUE)), 
                                step = 1, sep = ""),
                    
                    selectInput("trend_bezirk_pj", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
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
                                  choices = unique(year(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)), 
                                  selected = max(year(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)))
                    ),
                    selectInput("trend_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    selectInput("trend_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df_merged$gattung_deutsch)), selected = "Alle", multiple = TRUE),
                    
                    plotlyOutput("trend_water_ts")
                )
              ),
              fluidRow(
                box(title = "Ranking",status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("bar_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
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
)

## Server Code
output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_merged %>%
      drop_na(bewaesserungsmenge_in_liter) %>%
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
    plot <- df_merged %>%
      group_by(bezirk) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        tree_count = n_distinct(gisid)  # Anzahl eindeutiger Bäume pro Bezirk
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
  df_plot <- df_merged %>%
    filter(input$trend_bezirk_pj == "Alle" | bezirk %in% input$trend_bezirk_pj) %>%
    filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2]) %>%
    group_by(pflanzjahr) %>%
    summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
    ggplot(aes(x = pflanzjahr, y = total_water)) +
    geom_line(color = "blue") +
    geom_point(aes(text = paste("Summe:", total_water, "l")), size = 0.2, color = "blue") +
    labs(title = "Trend: Bewässerung je Pflanzjahr", x = "Pflanzjahr", y = "Gesamt (Liter)") +
    theme_minimal()

  ggplotly(df_plot, tooltip = "text")
})

filtered_trend_data <- reactive({
  df_agg <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
    mutate(timestamp = ymd_hms(timestamp),
           year = year(timestamp),
           month = lubridate::month(timestamp, label = TRUE)) %>%
    filter(
      (input$trend_mode == "month" & year == input$trend_year_ts) | 
      (input$trend_mode == "year" & year >= 2020 & year <= 2024),
      input$trend_bezirk == "Alle" | bezirk %in% input$trend_bezirk,
      input$trend_baumgattung == "Alle" | gattung_deutsch %in% input$trend_baumgattung
    ) %>%
    group_by(!!sym(input$trend_mode)) %>%
    summarise(total_water = sum(gesamt_bewaesserung)) %>%
    mutate(converted_value = total_water / 1e3, unit = "m³")  # Beispiel

  df_agg
})


output$trend_water_ts <- renderPlotly({
  df_plot <- filtered_trend_data() %>%
    mutate(tooltip = paste("Summe:", round(converted_value, 2), unit))

  plot <- ggplot(df_plot,
      aes(x = get(names(df_plot)[1]), y = converted_value, group = 1)) +
    geom_line(color = "blue") +
    geom_point(aes(text = tooltip), size = 0.2, color = "blue") +
    labs(title = "Trend der Bewässerung",
         x = ifelse(input$trend_mode == "month", "Monat", "Jahr"),
         y = paste("Gesamt (", unique(df_plot$unit), ")", sep = "")) +
    theme_minimal()

  ggplotly(plot, tooltip = "text")
})

filteredData <- reactive({
    req(input$stats_baumvt_year)
    
    df <- df_merged %>%
      mutate(year = lubridate::year(timestamp))
    
    # Basisfilter nach Auswahl
    df_filtered <- df %>%
      filter(
        ("Baumbestand Stand 2025" %in% input$start_year & 
           (is.na(timestamp) | year %in% 2020:2024)) |
          
          ("2020-2024" %in% input$start_year & 
             !is.na(timestamp) & year %in% 2020:2024) |
          
          (any(!input$start_year %in% c("2020-2024", "Baumbestand Stand 2025")) & 
             year %in% as.numeric(input$start_year))
      )
    
    # Wenn NUR "2020-2024" ausgewählt ist, dann NA-Drop forcieren
    if (all(input$start_year == "2020-2024")) {
      df_filtered <- df_filtered %>% filter(!is.na(timestamp))
    }
    
    if (!is.null(input$bezirk) && input$bezirk != "Alle") {
      df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
    }
    
    df_filtered
  })

   barFilteredData <- reactive({
    filteredData() %>%
      drop_na(strname) %>%
      filter(input$bar_bezirk == "Alle" | bezirk %in% input$bar_bezirk)
  })

   # Top 10 und Bottom 10 Straßen auswählen
  top_streets <- reactive({
    barFilteredData() %>%
      group_by(strname) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(desc(total_water)) %>%
      head(10)  # Top 10 auswählen
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

bottom_streets <- reactive({
    barFilteredData()%>%
      group_by(strname) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      arrange(desc(total_water)) %>%
      tail(10)  
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
        tree_count = n_distinct(gisid),
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
```