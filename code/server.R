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
  
  filteredData <- function(filter_bezirk = TRUE) {
    selected_years <- unlist(lapply(input$start_year, function(x) {
      if (x == "2020-2024") {
        2020:2024
      } else {
        as.numeric(x)
      }
    }))
    
    df_clean %>%
      mutate(year = year(timestamp)) %>%
      filter(
        year %in% selected_years,
        if (filter_bezirk) (input$bezirk == "Alle" | bezirk %in% input$bezirk) else TRUE
      )
  }
  
  
  # mapFilteredData <- reactive({
  #   
  #   # Standardmäßig Jahre 2020-2024 setzen
  #   selected_years <- if (is.null(input$map_year) || input$map_year == "2020-2024") {
  #     2020:2024  
  #   } else {
  #     input$map_year
  #   }
  #   
  #   # Jahreszeiten basierend auf Monaten bestimmen
  #   df_merged %>%
  #     mutate(timestamp = ymd_hms(timestamp),
  #            year = year(timestamp),
  #            month = month(timestamp),
  #            saison = case_when(
  #              month %in% c(12, 1, 2) ~ "Winter",
  #              month %in% c(3, 4, 5)  ~ "Frühling",
  #              month %in% c(6, 7, 8)  ~ "Sommer",
  #              month %in% c(9, 10, 11) ~ "Herbst"
  #            )) %>%
  #     filter(
  #       (input$map_bezirk == "Alle" | bezirk %in% input$map_bezirk) &
  #         (year %in% selected_years) &
  #         (input$map_saison == "Alle" | saison %in% input$map_saison) &
  #         (input$map_baumgattung == "Alle" | gattung_deutsch %in% input$map_baumgattung)
  #     ) %>%
  #     group_by(pitid, lat, lng, gattung_deutsch, pflanzjahr) %>% 
  #     summarise(
  #       bewaesserungsmenge_in_liter = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
  #       print(bewaesserungsmenge_in_liter),
  #       durchschnitts_intervall = mean(durchschnitts_intervall, na.rm = TRUE)
  #     ) %>%
  #     ungroup()
  # })
  
  barFilteredData <- reactive({
    filteredData() %>%
      filter(input$bar_bezirk == "Alle" | bezirk %in% input$bar_bezirk)
  })
  
  filteredBaumgattung <- reactive({
    df_clean %>%
      filter(
        (input$gattung_deutsch == "Alle" | gattung_deutsch %in% input$gattung_deutsch)
      )
  })
  
  output$total_trees <- renderValueBox({
    valueBox(
      formatC(nrow(filteredData())),
      "Gesamtzahl der gegossenen Bäume",
      icon = icon("tree"),
      color = "green"
    )
  })
  
  
  output$tree_distribution <- renderPlotly({
    
    # Jahresauswahl übernehmen
    selected_years <- if (is.null(input$stats_baumvt_year) || "2020-2024" %in% input$stats_baumvt_year) {
      2020:2024
    } else {
      as.numeric(input$stats_baumvt_year)
    }
    
    # Timestamp vorbereiten
    df_clean$timestamp <- as.Date(df_clean$timestamp)
    
    # Nach Jahr filtern
    df_filtered <- df_clean %>%
      filter(lubridate::year(timestamp) %in% selected_years)
    
    # Baumanzahl je Bezirk berechnen
    baumanzahl_filtered <- df_filtered %>%
      group_by(bezirk) %>%
      summarise(tree_count = n_distinct(pitid))
    
    # Baumdichte mit den gefilterten Daten kombinieren
    baum_dichte_filtered <- baum_dichte %>%
      filter(bezirk %in% baumanzahl_filtered$bezirk) %>%
      left_join(baumanzahl_filtered, by = "bezirk")
    
    # Plot erstellen
    plot <- ggplot(baum_dichte_filtered, aes(x = reorder(bezirk, tree_count), y = tree_count, fill = baeume_pro_ha)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Baumdichte (Bäume/ha)") +  # Baumdichte als Farbskala
      coord_flip() +
      labs(title = "Baumverteilung im Verhältnis zur Bezirkfläche", x = "Bezirk", y = "Anzahl gegossener Bäume") +
      theme_minimal() +
      theme(legend.position = "right")
    
    ggplotly(plot, tooltip = c("x", "y", "fill"))
  })
  
  
  
  output$total_water <- renderValueBox({
    # Umrechnung des Werts und Ermittlung der Einheit
    conversion_result <- convert_units(sum(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE))
    
    # Der umgerechnete Wert und die Einheit
    converted_value <- conversion_result$value
    unit <- conversion_result$unit
    
    valueBox(
      paste(format(converted_value), unit),
      paste("Gesamtbewässerung (", full_unit(unit), ")", sep=""),  # Fix here by calling full_unit
      icon = icon("tint"),
      color = "blue"
    )
  })
  
  output$avg_water <- renderValueBox({
    valueBox(
      formatC(mean(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE), digits = 2),
      "Durchschnittliche Bewässerung pro gegossenen Baum (Liter)",
      icon = icon("chart-line"),
      color = "aqua"
    )
  })
  
  # # Interaktive Karte (openStreetMap) mit Leaflet rendern
  # output$map <- renderLeaflet({
  #   leaflet(mapFilteredData()) %>%
  #     addTiles() %>% # OpenStreetMap-Hintergrundkarte hinzufügen
  #     addCircleMarkers(
  #       ~lng, ~lat, 
  #       color = ~color_palette(pmin(ifelse(is.na(bewaesserungsmenge_in_liter), 0, bewaesserungsmenge_in_liter), 1200)),
  #       popup = ~paste("Baumart:", gattung_deutsch, 
  #                      "<br>Pflanzjahr:", pflanzjahr, 
  #                      "<br>Bewässerung:", bewaesserungsmenge_in_liter, "Liter",
  #                      "<br>Ø Bewässerungsintervall:", 
  #                      ifelse(is.infinite(durchschnitts_intervall), "Keine Daten", 
  #                             paste(round(durchschnitts_intervall, 1), "Tage"))
  #       )
  #     ) %>%
  #     addLegend(
  #       position = "bottomright",
  #       pal = color_palette,
  #       values = c(0, 1200),
  #       title = "Bewässerungsmenge (Liter)",
  #       opacity = 1
  #     )
  # })
  
  output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_clean %>%
      group_by(bezirk) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      ungroup()  # Ensure it's ungrouped for further operations
    
    # Apply the unit conversion on each row (ensure we return a consistent structure)
    df_agg <- df_agg %>%
      mutate(
        converted = purrr::map(total_water, convert_units),  # Apply conversion
        value = sapply(converted, `[[`, "value"),  # Extract the numeric value
        unit = sapply(converted, `[[`, "unit")  # Extract the unit
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
  
  
  # output$avg_water_district <- renderPlot({
  #   filteredData() %>%
  #     group_by(bezirk) %>%
  #     summarize(avg_water = mean(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
  #     ggplot(aes(x = reorder(bezirk, avg_water), y = avg_water)) +
  #     geom_bar(stat = "identity", fill = "darkblue") +
  #     coord_flip() +
  #     theme_minimal() +
  #     labs(title = "Durchschnittliche Bewässerung nach Bezirk", x = "Bezirk", y = "Durchschnittliche Bewässerungsmenge")
  # })
  
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
  
  output$tree_pie_chart <- renderPlotly({
    
    # Optional: nach Bezirk filtern
    df_filtered <- df_merged
    if (!is.null(input$pie_bezirk) && !"Alle" %in% input$pie_bezirk) {
      df_filtered <- df_filtered %>%
        filter(bezirk %in% input$pie_bezirk)
    }
    
    # Einzigartige Bäume mit Art extrahieren
    baeume_einzigartig <- df_filtered %>%
      filter(!is.na(art_dtsch)) %>%
      distinct(pitid, art_dtsch)
    
    
    #  Gegossene Bäume (mind. einmal gegossen) extrahieren
    baeume_gegossen <- df_filtered %>%
      filter(!is.na(art_dtsch) & !is.na(bewaesserungsmenge_in_liter)) %>%
      distinct(pitid, art_dtsch)
    
    #  Anzahl pro Art (gesamt & gegossen)
    art_ratio_df <- baeume_einzigartig %>%
      group_by(art_dtsch) %>%
      summarise(gesamt = n()) %>%
      left_join(
        baeume_gegossen %>%
          group_by(art_dtsch) %>%
          summarise(gegossen = n()),
        by = "art_dtsch"
      ) %>%
      mutate(
        gegossen = replace_na(gegossen, 0),
        anteil_gegossen = gegossen / gesamt
      ) %>%
      arrange(desc(gesamt)) %>%
      slice_max(order_by = gesamt, n = 10)  # Top 10 häufigste Arten
    
    # Pie Chart
    fig <- plot_ly(
      art_ratio_df,
      labels = ~art_dtsch,
      values = ~anteil_gegossen,
      type = 'pie',
      textinfo = 'label+percent',
      hoverinfo = 'label+percent+value',
      marker = list(colors = RColorBrewer::brewer.pal(10, "Set2"))
    ) %>%
      layout(
        title = list(
          text = "Anteil gegossener Bäume pro Baumart (Top 10)",
          font = list(size = 16)
        )
      )
    
    fig
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
             month = lubridate::month(timestamp, label = TRUE)) %>%
      filter(
        (input$trend_mode == "month" & year == input$trend_year_ts) | 
          (input$trend_mode == "year" & year >= 2020 & year <= 2024),
        (input$trend_bezirk == "Alle" | bezirk %in% input$trend_bezirk),
        (input$trend_baumgattung == "Alle" | gattung_deutsch %in% input$trend_baumgattung)
      ) %>%
      group_by(!!sym(input$trend_mode)) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      mutate(total_water = as.numeric(total_water)) %>%  # 🛠️ Hier sicherstellen!
      arrange(!!sym(input$trend_mode))
    
    # Einheit berechnen (mit Absicherung)
    max_value <- ifelse(all(is.na(df_agg$total_water)), 0, max(df_agg$total_water, na.rm = TRUE))
    conversion_result <- convert_units(max_value)
    
    df_agg <- df_agg %>%
      mutate(
        converted_value = total_water / ifelse(conversion_result$unit == "ML", 1e6,
                                               ifelse(conversion_result$unit == "m³", 1e3, 1)),
        unit = conversion_result$unit
      )
    
    return(df_agg)
  })
  
  
  output$trend_water_ts <- renderPlotly({
    df_plot <- filtered_trend_data()  %>% 
      mutate(tooltip = paste("Summe:", round(converted_value, 2), unit)) # tooltip wird hier vordefiniert 
    
    
    plot <- ggplot(df_plot, 
                   aes(x = get(names(df_plot)[1]), y = converted_value, group = 1)) +
      geom_line(color = "blue") + 
      geom_point(aes(text = tooltip), size = 0.2, color = "blue") + # änderung dieser Zeile so dass das vordefinierte aufgerufen wird
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
  
  # # Gruppiertes Balkendiagramm erstellen
  # output$bar_water_vh <- renderPlot({
  #   ggplot(baum_bewaesserung_long, aes(x = reorder(bezirk, -Wert), y = Wert, fill = Kategorie)) +
  #     geom_bar(stat = "identity", position = "dodge") +
  #     coord_flip() +
  #     theme_minimal() +
  #     labs(
  #       x = "Bezirk",
  #       y = "Verhältnis (Durchschnittliche Bewässerung / Bäume)",
  #       fill = "Kategorie"
  #     ) +
  #     scale_fill_manual(values = c("baum_anzahl_pro_durchschnitt" = "orange")) +
  #     theme(text = element_text(size = 12))
  # })
  
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
  
  icon_pumpe <- makeIcon(
    iconUrl = "icons/water-pump-icon-14.jpg",
    iconWidth = 15,
    iconHeight = 15
  )

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
          "<strong>Gesamtbewässerung: </strong>", round(as.numeric(gesamt_bewaesserung), 1), " Liter", "<br>",
          "Ø <strong>Bewässerungsintervall: </strong>",
          ifelse(is.infinite(durchschnitts_intervall), "Keine Daten",
                 paste(round(durchschnitts_intervall, 1), " Tage")), "<br><br>"
        )
      ) %>%
      addMarkers(
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
  
  # Observer für Zoomlevel-Änderungen
  observe({
    req(input$map_zoom) # Sicherstellen, dass Zoomlevel verfügbar ist
    
    zoom_level <- input$map_zoom
    
    if (!is.null(zoom_level)) {
      leafletProxy("map") %>% 
        clearGroup("Pumpen") %>% 
        {
          if (zoom_level >= 14) { # Nur anzeigen ab Zoomlevel 14
            addMarkers(., data = pumpen_mit_bezirk, icon = icon_pumpe, group = "Pumpen")
          } else {
            .
          }
        }
    }
  })
  
  
  
  
}