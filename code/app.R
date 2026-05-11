## Code für 5. Dashboard - Einzelelemente
## Contains the complete code for the Shiny Dashboard
## including UI and Server components from chapter 5.2 to 5.6

library(shiny)
library(shinydashboard)
library(leaflet)
library(dplyr)
library(htmltools)
library(stringr)
library(sf)
library(tidyr)
library(ggplot2)
library(plotly)

# Bezirksgrenzen laden (Falls Sie die Daten nicht haben, laden Sie sie zuerst aus 3.1 herunter)
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson", quiet = TRUE)

# Bewässerungsdaten laden (Der gesamte Prozess für df_merged_final befindet sich in 3.2)
df_merged <- read.csv2("data/df_merged_final.csv", fileEncoding = "UTF-8")

# Bezirksgrenzen vorbereiten
berlin_bezirke_sf <- bezirksgrenzen %>%
  rename(bezirk = Gemeinde_name) %>%     # Spalte vereinheitlichen
  mutate(bezirk = str_to_title(bezirk))  # gleiche Schreibweise wie in df_merged

# GLOBALE FARBPALETTE  - Einheitliches Farbschema für alle Grafiken
GDK_PALETTE_BASE <- c(
  "#3C6E97", "#6894B5", "#95BBD4", "#C8E0EF",
  "#3E8395", "#67A7B6", "#98CBD6", "#D0EDF2",
  "#508B71", "#7AB097", "#A5D2BC", "#D6EFE5",
  "#4F626E", "#8D9FA9", "#B2C2CC", "#DCE6EB"
  
)

GDK_ACCENT <- "#95BBD4"

options(ggplot2.discrete.fill = function() scale_fill_manual(
  values = colorRampPalette(GDK_PALETTE_BASE)(16)
))

# UI-Definition
ui <- dashboardPage(
  # 1. HEADER: Titelbereich des Dashboards
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  
  # 2. SIDEBAR: Seitliche Navigationsleiste mit Menüeinträgen
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      # Navigation für die Karte
      menuItem("Karte", tabName = "map", icon = icon("map")),
      # Navigation für den Zeitverlauf
      menuItem("Zeitverlauf", tabName = "stats", icon = icon("bar-chart")),
      # Navigation für die Baumstatistik
      menuItem("Baumstatistik", tabName = "engagement", icon = icon("hands-helping")),
      # Navigation für die Bewässerungsanalyse
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
    )
  ),
  
  # 3. BODY: Inhaltsbereich
  dashboardBody(
    tabItems(
      # 5.2: Inhaltsbereich für Start
      tabItem(
        tabName = "start",
        fluidRow(
          box(width = 12,
              # Label: Einfacher Text, Zahl hervorgehoben
              div(style = "padding: 10px 15px 0 15px;",
                  p(style = "font-size: 15px; margin-bottom: 2px;",
                    "Gesamter Baumbestand in Berlin:"),
                  span(style = "font-size: 28px; font-weight: bold; color: #3C6E97; margin-top: 0;",
                    textOutput("total_trees_label"))
              ),
          
              # Dropdown-Filter in voller Breite darüber
              fluidRow(
                column(width = 12,
                       div(style = "padding: 10px 15px;", 
                           selectInput("bezirk", "Bezirk auswählen (Mehrfachauswahl möglich):", 
                                       choices = c("Alle Bezirke", sort(na.omit(unique(df_merged$bezirk)))), 
                                       selected = "Alle Bezirke", multiple = TRUE)
                       )
                )
              ),
            
              # Zwei dynamische Kacheln nebeneinander
              fluidRow(
                valueBoxOutput("total_trees_filtered", width = 6),
                valueBoxOutput("total_tree_watered", width = 6)
              )
          )
        )
      ),
      # 5.3: Inhaltsbereich für die Karte
      tabItem(
        tabName = "map",
        fluidRow(
          box(
            title = "Anteil bewässerter Bäume nach Bezirk",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            leafletOutput("map", height = "800px")
          )
        )
      ),
      
      # 5.4: Inhaltsbereich für den Zeitverlauf
      tabItem(
        tabName = "stats",
        fluidRow(
          box(
            title = tagList(
              "Trend der Bewässerung je Pflanzjahr",
              div(
                actionButton("info_btn_tdbjp", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            
            fluidRow(
              column(
                width = 6,
                sliderInput(
                  "trend_year",
                  "Pflanzjahre filtern:",
                  min = 1800,
                  max = max(df_merged$pflanzjahr, na.rm = TRUE),
                  value = c(1800,
                            max(df_merged$pflanzjahr, na.rm = TRUE)),
                  step = 1,
                  sep = ""
                )
              ),
              column(
                width = 6,
                selectInput(
                  "trend_bezirk_pj",
                  "Bezirk auswählen:",
                  choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
                  selected = "Alle Bezirke",
                  multiple = TRUE
                )
              )
            ),
            
            plotlyOutput("trend_water", height = "500px")
          )
        )
      ),
      # 5.5: Inhaltsbereich für die Baumstatistik
      tabItem(
        tabName = "engagement",
        fluidRow(
          box(
            title = tagList(
              "Baumverteilung nach Bezirken (mit Baumgattungen)",
              div(
                actionButton("info_btn_bvnb", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            sliderInput(
              "top_n_species",
              "Top N Baumgattungen anzeigen:",
              min = 3,
              max = 15,
              value = 8,
              step = 1
            ),
            plotOutput("tree_distribution_stacked", height = "500px")
          )
        ),
        fluidRow(
          box(
            title = tagList(
              "Verteilung der Baumgattungen",
              div(
                actionButton("info_btn_vdb", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            selectInput(
              "pie_bezirk",
              "Bezirk auswählen:",
              choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
              selected = "Alle Bezirke"
            ),
            plotOutput("tree_species_pie", height = "500px")
          ),         
          box(
            title = tagList(
              "Baumdichte pro km²",
              div(
                actionButton("info_btn_bdpf", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotOutput("tree_density_area", height = "500px")
          )
        ),       
        fluidRow(
          box(
            title = tagList(
              "Top 10 gegossene Baumgattungen",
              div(
                actionButton("info_btn_hgb", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            selectInput(
              "engagement_bezirk",
              "Bezirk auswählen:",
              choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
              selected = "Alle Bezirke"
            ),
            plotOutput("top_watered_species", height = "500px")
          )
        )
      ),
      # 5.6: Inhaltsbereich für die Bewässerungsanalyse
      tabItem(
        tabName = "analysis",
        fluidRow(
          box(
            title = tagList(
              "Bewässerung pro Bezirk (2020-2024)",
              div(
                actionButton("info_btn_hbpb", label = "", icon = icon("info-circle")), 
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ), 
            status = "primary", 
            solidHeader = TRUE, 
            width = 12,
            plotOutput("hist_bewaesserung_pro_bezirk", height = "500px")
          )
        ),
        fluidRow(
          box(
            title = tagList(
              "Durchschnittliche Bewässerung pro gegossenem Baum",
              div(
                actionButton("info_btn_hbpb2", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotOutput("hist_bewaesserung_pro_baum", height = "500px")
          )
        )
      )
    )
  )
)

# 4. SERVER: Backend-Logik, die Daten verarbeitet und an die UI generiert
server <- function(input, output, session) {
  
  # ------------ 5.2 ------------
  
  # Hilfsfunktion für Einheiten
  convert_units <- function(liters) {
    if (liters >= 1e6) {
      return(list(value = round(liters / 1e6, 2), unit = "ML"))
    } else if (liters >= 1e3) {
      return(list(value = round(liters / 1e3, 2), unit = "m³"))
    } else {
      return(list(value = round(liters, 2), unit = "L"))
    }
  }
  
  full_unit <- function(unit) {
    switch(unit,
           "ML" = "Mega Liter", 
           "L" = "Liter", 
           "m³" = "Kubikmeter",
           unit)
  }
  
  # ---- Automatisches Abwwählen ----
  prev_bezirk <- reactiveVal("Alle Bezirke")
  
  observeEvent(input$bezirk, {
    if (is.null(input$bezirk)) {
      updateSelectInput(session, "bezirk", selected = "Alle Bezirke")
      prev_bezirk("Alle Bezirke")
      return()
    }
    
    curr_bezirk <- input$bezirk
    prev <- prev_bezirk()
    
    if ("Alle Bezirke" %in% curr_bezirk && !("Alle Bezirke" %in% prev)) {
      updateSelectInput(session, "bezirk", selected = "Alle Bezirke")
      prev_bezirk("Alle Bezirke")
    } else if ("Alle Bezirke" %in% curr_bezirk && length(curr_bezirk) > 1) {
      new_selection <- curr_bezirk[curr_bezirk != "Alle Bezirke"]
      updateSelectInput(session, "bezirk", selected = new_selection)
      prev_bezirk(new_selection)
    } else {
      prev_bezirk(curr_bezirk)
    }
  }, ignoreNULL = FALSE, ignoreInit = TRUE)
  
  # ---- Gefilterte Daten ----
  filteredData <- reactive({
    req(input$bezirk)
    
    df <- df_merged
    df_filtered <- df
    
    if (!("Alle Bezirke" %in% input$bezirk)) {
      df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
    }
    
    df_filtered
  })
  
  # ---- ValueBoxes ----
  
  # Label 1: Gesamtzahl (Immer ganz Berlin)
  output$total_trees_label <- renderText({
    formatC(n_distinct(df_merged$gisid), format = "d", big.mark = ".")
  })
  
  # Box 2: Gefilterte Zahl (Reagiert auf den Filter)
  output$total_trees_filtered <- renderValueBox({
    valueBox(
      formatC(n_distinct(filteredData()$gisid), format = "d", big.mark = "."),
      "erfasste Bäume (Bezirksauswahl)",
      icon = icon("tree"),
      color = "olive" 
    )
  })
  
  # Box 3: Gegossene Bäume (Reagiert auf den Filter)
  output$total_tree_watered <- renderValueBox({
    valueBox(
      formatC(n_distinct(filteredData()$gisid[!is.na(filteredData()$timestamp)]), 
              format = "d", big.mark = "."),
      "bewässerte Bäume (Bezirksauswahl)",
      icon = icon("tint"),
      color = "blue"
    )
  })
  
  
  # ------------ 5.3 ------------
  
  # Reaktive Datenberechnung: Bewässerungsstatistik pro Bezirk
  data_by_bezirk <- reactive({
    df_merged %>%
      group_by(bezirk) %>%
      summarise(
        n_total = n_distinct(gisid),
        n_watered = n_distinct(gisid[!is.na(timestamp)]),
        pct_watered = round((n_watered / n_total) * 100, 1)
      ) %>%
      ungroup()
  })
  
  # Rendering der Leaflet-Karte
  output$map <- renderLeaflet({
    data_stats <- data_by_bezirk()
    
    # Verbinde Bezirksgeometrien mit Statistiken, ersetze NA durch 0
    map_data <- berlin_bezirke_sf %>%
      left_join(data_stats, by = "bezirk") %>%
      mutate(
        n_total = replace_na(n_total, 0),
        n_watered = replace_na(n_watered, 0),
        pct_watered = replace_na(pct_watered, 0)
      )
    
    # Erstelle Farbskala: Blues-Palette basierend auf Bewässerungsanteil
    pal <- colorNumeric(
      palette = "Blues",
      domain = map_data$pct_watered,
      na.color = "transparent"
    )
    
    # Baue Karte: Basiskarte + Bezirkspolygone + Legende
    leaflet(map_data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(pct_watered),  # Färbe Bezirke nach Bewässerungsanteil
        weight = 1,
        color = "white",
        opacity = 0.7,
        fillOpacity = 0.8,
        smoothFactor = 0.3,
        highlightOptions = highlightOptions(
          weight = 2,
          color = "black",
          fillOpacity = 0.9,
          bringToFront = TRUE
        ),
        # Zeige Tooltip mit Bezirksnamen und Statistiken beim Hover
        label = ~lapply(
          paste0(
            "<b>", bezirk, "</b><br>",
            "Gesamtbäume: ", formatC(n_total, format = "d", big.mark = " "),
            "<br>",
            "Bewässert: ", formatC(n_watered, format = "d", big.mark = " "),
            "<br>",
            "Anteil bewässert: ", pct_watered, "%"
          ),
          HTML
        ),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "13px",
          direction = "auto"
        )
      ) %>%
      # Füge Legende hinzu: erklärt Farbe = Bewässerungsanteil
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~pct_watered,
        title = "Anteil bewässerter Bäume (%)",
        opacity = 1
      )
  })
  
  
  # ------------ 5.4 ------------
  
  # Trend: Bewässerung nach Pflanzjahr
  output$trend_water <- renderPlotly({
    filtered_data <- df_merged %>%
      filter(!is.na(bewaesserungsmenge_in_liter)) %>%  
      filter(!is.na(pflanzjahr))
    
    if (!"Alle Bezirke" %in% input$trend_bezirk_pj && length(input$trend_bezirk_pj) > 0) {
      filtered_data <- filtered_data %>%
        filter(bezirk %in% input$trend_bezirk_pj)
    }
    
    filtered_data <- filtered_data %>%
      filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2])
    
    plot_data <- filtered_data %>%
      group_by(pflanzjahr) %>%
      summarize(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        count_trees = n_distinct(gml_id)
      ) %>%
      ungroup()
    
    plot <- ggplot(plot_data, aes(x = pflanzjahr, y = total_water)) +
      geom_line(color = "#2E86AB", size = 1) +
      geom_point(
        aes(text = paste0("Pflanzjahr: ", pflanzjahr,
                          "<br>Gesamtwasser: ", format(total_water, big.mark = ".", decimal.mark = ","), " L",
                          "<br>Anzahl Bäume: ", count_trees)),
        size = 2, color = "#2E86AB"
      ) +
      theme_minimal() +
      labs(
        x = "Pflanzjahr",
        y = "Gesamtbewässerung (Liter)"
      ) +
      theme(panel.grid.minor = element_blank())
    
    ggplotly(plot, tooltip = "text") %>%
      layout(hovermode = "closest")
  })
  
  # Info button observer
  observeEvent(input$info_btn_tdbjp, {
    showModal(modalDialog(
      title = "Information: Trend der Bewässerung je Pflanzjahr",
      HTML("
      <p>Diese Grafik zeigt die <strong>Gesamtbewässerungsmenge nach Pflanzjahr</strong> der Bäume.</p>
      <p><strong>Hintergrund:</strong> Junge und sehr alte Bäume benötigen typischerweise mehr Wasser als Bäume mittleren Alters.</p>
      <ul>
        <li>Junge Bäume (kürzlich gepflanzt) haben noch flache Wurzelsysteme</li>
        <li>Sehr alte Bäume können geschwächt sein und mehr Unterstützung brauchen</li>
        <li>Bäume mittleren Alters sind oft selbstständiger</li>
      </ul>
      <p><strong>Verwendung:</strong></p>
      <ul>
        <li>Nutzen Sie die Filter, um bestimmte Jahrgänge oder Bezirke zu analysieren</li>
        <li>Bewegen Sie die Maus über die Punkte für Details</li>
        <li>Mehrere Bezirke können gleichzeitig ausgewählt werden</li>
      </ul>
      <p><strong>Ergebnis:</strong> Die Daten zeigen keine wesentlichen Auffälligkeiten - das Pflanzjahr scheint kein entscheidender Faktor für das Bewässerungsengagement zu sein.</p>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
  
  
  # ------------ 5.5 ------------
  
  # 1. Stacked Bar Chart - Baumverteilung mit Gattungen
  output$tree_distribution_stacked <- renderPlot({
    n_gen <- input$top_n_species
    
    top_genera <- df_merged %>%
      filter(!is.na(gattung_deutsch)) %>%
      count(gattung_deutsch, sort = TRUE) %>%
      head(n_gen) %>%
      pull(gattung_deutsch)
    
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%
      mutate(gattung_grouped = ifelse(gattung_deutsch %in% top_genera,
                                      gattung_deutsch, "Sonstige")) %>%
      group_by(bezirk, gattung_grouped) %>%
      summarise(count = n(), .groups = "drop") %>%
      group_by(bezirk) %>%
      mutate(percentage = count / sum(count) * 100) %>%
      ungroup()
    
    df_agg$gattung_grouped <- factor(df_agg$gattung_grouped,
                                     levels = c(top_genera, "Sonstige"))
    
    # "Sonstige" bekommt Grau; Rest aus globaler Palette
    fill_vals <- c(colorRampPalette(GDK_PALETTE_BASE)(n_gen), "#D3D3D3")
    names(fill_vals) <- c(top_genera, "Sonstige")
    
    ggplot(df_agg, aes(x = reorder(bezirk, count, sum), y = count,
                       fill = gattung_grouped)) +
      geom_bar(stat = "identity", position = "stack", color = "white", linewidth = 0.3) +
      scale_fill_manual(values = fill_vals, name = "Baumgattung") +
      labs(x = "Bezirk", y = "Anzahl Bäume") +
      theme_light() +
      theme(axis.text.x        = element_text(angle = 45, hjust = 1, size = 10),
            legend.position    = "right",
            panel.grid.major.x = element_blank())
  })
  
  # Info button
  observeEvent(input$info_btn_bvnb, {
    showModal(modalDialog(
      title = "Information: Baumverteilung nach Bezirken",
      HTML("
        <p>Diese Grafik zeigt die <strong>Gesamtanzahl und Zusammensetzung der Bäume</strong>
        in jedem Berliner Bezirk nach Gattung.</p>
        <ul>
          <li>Jeder Balken zeigt die Gesamtzahl der Bäume im Bezirk</li>
          <li>Nutzen Sie den Slider, um mehr oder weniger Gattungen anzuzeigen</li>
        </ul>
      "),
      easyClose = TRUE, footer = modalButton("Schließen")
    ))
  })
  
  # 2. Pie Chart - Gattungsverteilung
  output$tree_species_pie <- renderPlot({
    filtered_data <- df_merged
    if (input$pie_bezirk != "Alle Bezirke") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$pie_bezirk)
    }
    
    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%  
      count(gattung_deutsch, sort = TRUE) %>%
      mutate(
        gattung_grouped = ifelse(row_number() <= 10, gattung_deutsch, "Sonstige")
      ) %>%
      group_by(gattung_grouped) %>%
      summarise(count = sum(n), .groups = "drop") %>%
      arrange(desc(count)) %>%
      mutate(
        percentage = count / sum(count) * 100,
        label = paste0(gattung_grouped, "\n", round(percentage, 1), "%")
      )
    
    # new
    n_slices  <- nrow(df_agg)
    has_sonst <- "Sonstige" %in% df_agg$gattung_grouped
    n_named   <- if (has_sonst) n_slices - 1 else n_slices
    fill_vals <- c(colorRampPalette(GDK_PALETTE_BASE)(n_named),
                   if (has_sonst) "#D3D3D3" else NULL)
    names(fill_vals) <- df_agg$gattung_grouped
    
    ggplot(df_agg, aes(x = "", y = count, fill = gattung_grouped)) +
      geom_bar(stat = "identity", width = 1, color = "white", linewidth = 0.5) +
      coord_polar("y", start = 0) +
      scale_fill_manual(values = fill_vals, name = "Baumgattung") +
      labs(title = NULL) +
      theme_void() +
      theme(legend.position = "right",
            legend.text     = element_text(size = 9)) +
      geom_text(aes(label = ifelse(percentage > 3,
                                   paste0(round(percentage, 1), "%"), "")),
                position = position_stack(vjust = 0.5), color = "white",
                fontface = "bold", size = 3.5)
  })
  
  observeEvent(input$info_btn_vdb, {
    showModal(modalDialog(
      title = "Information: Verteilung der Baumgattungen",
      HTML("
      <p>Diese Grafik zeigt die <strong>prozentuale Verteilung der Baumgattungen</strong>.</p>
      <ul>
        <li>Zeigt die Top 10 häufigsten Baumgattungen (z.B. LINDE, AHORN, EICHE)</li>
        <li>Hilft zu verstehen, welche Gattungen in Berlin dominieren</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
  
  # 3. Baumdichte pro Bezirksfläche
  output$tree_density_area <- renderPlot({
    bezirk_flaeche <- data.frame(
      bezirk = c("Charlottenburg-Wilmersdorf", "Friedrichshain-Kreuzberg", "Lichtenberg",
                 "Marzahn-Hellersdorf", "Mitte", "Neukölln", "Pankow",
                 "Reinickendorf", "Spandau", "Steglitz-Zehlendorf",
                 "Tempelhof-Schöneberg", "Treptow-Köpenick"),
      flaeche_km2 = c(64.72, 20.16, 52.29, 61.74, 39.47, 44.93, 103.07,
                      89.46, 91.91, 102.50, 53.09, 168.42)
    )
    
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      group_by(bezirk) %>%
      summarise(total_trees = n_distinct(gml_id)) %>%
      ungroup() %>%
      left_join(bezirk_flaeche, by = "bezirk") %>%
      mutate(density = total_trees / flaeche_km2) %>%
      arrange(desc(density))
    
    ggplot(df_agg, aes(x = reorder(bezirk, -density), y = density, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      labs(
        title = NULL,
        x = "Bezirk",
        y = "Bäume pro km²"
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        panel.grid.major.x = element_blank()
      ) +
      scale_fill_discrete()
  })
  
  # Info button
  observeEvent(input$info_btn_bdpf, {
    showModal(modalDialog(
      title = "Information: Baumdichte pro km²",
      HTML("
      <p>Diese Grafik zeigt die <strong>Baumdichte</strong> in jedem Bezirk normalisiert auf die Fläche.</p>
      <ul>
        <li>Berechnung: Anzahl Bäume / Bezirksfläche in km²</li>
        <li>Ermöglicht fairen Vergleich zwischen großen und kleinen Bezirken</li>
        <li>Hohe Dichte = urbaner, mehr Straßenbäume</li>
        <li>Niedrige Dichte = ländlicher, mehr Wald/Parkflächen</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
  
  # 4. Top 10 gegossene Baumgattungen
  output$top_watered_species <- renderPlot({
    filtered_data <- df_merged %>%
      filter(!is.na(bewaesserungsmenge_in_liter)) 
    
    if (input$engagement_bezirk != "Alle Bezirke") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$engagement_bezirk)
    }
    
    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%   
      group_by(gattung_deutsch) %>%
      summarise(
        count = n(),
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)
      ) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      head(10)
    
    ggplot(df_agg, aes(x = reorder(gattung_deutsch, count), y = count, fill = gattung_deutsch)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      coord_flip() +
      labs(
        title = NULL,
        x = "Baumgattung",
        y = "Anzahl gegossener Bäume"
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        panel.grid.major.y = element_blank()
      ) +
      scale_fill_discrete()
  })
  
  observeEvent(input$info_btn_hgb, {
    showModal(modalDialog(
      title = "Information: Top 10 gegossene Baumgattungen",
      HTML("
      <p>Diese Grafik zeigt die <strong>am häufigsten gegossenen Baumgattungen</strong>.</p>
      <ul>
        <li>Nur Bäume, die tatsächlich bewässert wurden</li>
        <li>Zeigt, welche Gattungen am meisten Unterstützung erhalten</li>
        <li>Kann auf einzelne Bezirke gefiltert werden</li>
        <li>Hilft zu verstehen, welche Gattungen besondere Aufmerksamkeit bekommen</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
  
  # ------------ 5.6 ------------  
  
  output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      group_by(bezirk) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      ungroup() %>%
      arrange(desc(total_water))
    
    df_agg <- df_agg %>%
      mutate(
        converted = purrr::map(total_water, convert_units), 
        value = sapply(converted, `[[`, "value"),  
        unit = sapply(converted, `[[`, "unit")  
      )
    
    ggplot(df_agg, aes(x = reorder(bezirk, -value), y = value, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7, width = 0.8) +
      labs(
        title = NULL,
        x = "Bezirke in Berlin",
        y = paste0("Gesamte Bewässerungsmenge (", unique(df_agg$unit), ")")
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        axis.text.x = element_text(angle = 55, hjust = 1, size = 10),
        panel.grid.major.x = element_blank(),
        plot.margin = margin(10, 10, 10, 10)
      ) +
      scale_fill_discrete(name = "Bezirk")
  })
  
  observeEvent(input$info_btn_hbpb, {
    showModal(modalDialog(
      title = "Information: Bewässerung pro Bezirk",
      HTML("
      <p>Diese Grafik zeigt die <strong>gesamte Bewässerungsmenge</strong> für jeden Berliner Bezirk im Zeitraum 2020-2024.</p>
      <ul>
        <li>Die Daten werden automatisch in die passende Einheit (Liter, m³ oder Megaliter) umgerechnet</li>
        <li>Die Bezirke werden entlang der x-Achse dargestellt</li>
        <li>Die Höhe der Balken entspricht der gesamten Bewässerungsmenge</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
  
  # Plot: Durchschnittliche Bewässerung pro gegossenem Baum
  output$hist_bewaesserung_pro_baum <- renderPlot({
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%
      group_by(bezirk) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        trees_watered = n_distinct(gml_id)
      ) %>%
      ungroup() %>%
      mutate(water_per_tree = total_water / trees_watered) %>%
      arrange(desc(water_per_tree))
    
    df_agg <- df_agg %>%
      mutate(
        converted = purrr::map(water_per_tree, convert_units), 
        value = sapply(converted, `[[`, "value"),  
        unit = sapply(converted, `[[`, "unit")  
      )
    
    ggplot(df_agg, aes(x = reorder(bezirk, -value), y = value, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7, width = 0.8) +
      labs(
        title = NULL,
        x = "Bezirke in Berlin",
        y = paste0("Durchschnittliche Bewässerung pro Baum (", unique(df_agg$unit), ")")
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        axis.text.x = element_text(angle = 55, hjust = 1, size = 10),
        panel.grid.major.x = element_blank(),
        plot.margin = margin(10, 10, 10, 10)
      ) +
      scale_fill_discrete()
  })
  
  observeEvent(input$info_btn_hbpb2, {
    showModal(modalDialog(
      title = "Information: Bewässerung pro gegossenem Baum",
      HTML("
      <p>Diese Grafik zeigt die <strong>durchschnittliche Bewässerungsmenge pro gegossenem Baum</strong> in jedem Bezirk.</p>
      <ul>
        <li>Berechnung: Gesamtwasser geteilt durch Anzahl der tatsächlich gegossenen Bäume</li>
        <li>Zeigt die Intensität der Bewässerung und das Engagement der Bürger</li>
        <li>Höhere Werte bedeuten mehr Wasser pro Baum, der Pflege erhielt</li>
      </ul>
      <p><strong>Wichtige Hinweise:</strong></p>
      <ul>
        <li>Vergleiche zwischen Bezirken müssen mit Vorsicht interpretiert werden</li>
        <li>Baumalter, Arten und lokale Bedingungen variieren stark</li>
        <li>Zeigt nicht Bäume, die Wasser brauchten aber keins erhielten</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
}

# 5. Zusammenführung: Startet die Shiny-Anwendung
shinyApp(ui = ui, server = server)