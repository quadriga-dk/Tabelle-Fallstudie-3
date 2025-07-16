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
      drop_na(strname) %>%
      filter(input$bar_bezirk == "Alle" | bezirk %in% input$bar_bezirk)
  })
  
  filteredBaumgattung <- reactive({
    df_merged %>%
      filter(
        (input$gattung_deutsch == "Alle" | gattung_deutsch %in% input$gattung_deutsch)
      )
  })
  
  output$total_trees <- renderValueBox({
    valueBox(
      formatC(n_distinct(df_merged$gisid), format = "d", big.mark = "."),
      "Gesamtzahl der Bäume",
      icon = icon("tree"),
      color = "green"
    )
  })
  
  output$total_tree_watered <- renderValueBox({
    valueBox(
      formatC(n_distinct(filteredData()$gisid), format = "d", big.mark = "."),
      "Gesamtzahl der gegossenen Bäume",
      icon = icon("tree"),
      color = "green"
    )
  })
  
  # Dynamische Auswahl: welche Box zeigen?
  output$dynamic_tree_box <- renderUI({
    if ("Baumbestand Stand 2025" %in% input$start_year) {
      valueBoxOutput("total_trees")
    } else {
      valueBoxOutput("total_tree_watered")
    }
  })
  
  
  
  output$tree_distribution <- renderPlotly({
    
    # sicher stellen, dass timestamp ein Date ist
    df_merged$timestamp <- as.Date(df_merged$timestamp)
    
    df_filtered <- df_merged %>%
      filter(
        ("Baumbestand Stand 2025" %in% input$stats_baumvt_year & 
           (is.na(timestamp) | lubridate::year(timestamp) %in% 2020:2024)) |
          ("2020-2024" %in% input$stats_baumvt_year & 
             !is.na(timestamp) & lubridate::year(timestamp) %in% 2020:2024) |
          (any(!input$stats_baumvt_year %in% c("2020-2024", "Baumbestand Stand 2025")) &
             lubridate::year(timestamp) %in% as.numeric(input$stats_baumvt_year))
      )
    
    x_axis_title <- if ("Baumbestand Stand 2025" %in% input$stats_baumvt_year) {
      "Anzahl der Bäume"
    } else {
      "Anzahl gegossener Bäume"
    }
    
    
    baumanzahl_filtered <- df_filtered %>%
      group_by(bezirk) %>%
      summarise(tree_count = n_distinct(gisid), .groups = "drop")
    
    baum_dichte_filtered <- baum_dichte %>%
      filter(bezirk %in% baumanzahl_filtered$bezirk) %>%
      left_join(baumanzahl_filtered, by = "bezirk")
    
    plot <- ggplot(baum_dichte_filtered, aes(x = reorder(bezirk, tree_count), y = tree_count, fill = baeume_pro_ha)) +
      geom_bar(stat = "identity", position = "dodge") +
      scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Baumdichte (Bäume/ha)") +
      coord_flip() +
      labs(title = "Baumverteilung im Verhältnis zur Bezirkfläche", x = "Bezirk", y = x_axis_title)+
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
      paste(format(converted_value, decimal.mark = ",", big.mark = "."), unit),
      paste("Gesamtbewässerung (", full_unit(unit), ")", sep=""),  
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
    plot <- df_merged %>%
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
    
    #  nach Bezirk filtern
    df_filtered <- df_merged
    if (!is.null(input$pie_bezirk) && !"Alle" %in% input$pie_bezirk) {
      df_filtered <- df_filtered %>%
        filter(bezirk %in% input$pie_bezirk)
    }
    
    # Einzigartige Bäume mit Art extrahieren
    baeume_einzigartig <- df_filtered %>%
      filter(!is.na(art_dtsch)) %>%
      distinct(gisid, art_dtsch)
    
    
    #  Gegossene Bäume (mind. einmal gegossen) extrahieren
    baeume_gegossen <- df_filtered %>%
      filter(!is.na(art_dtsch) & !is.na(bewaesserungsmenge_in_liter)) %>%
      distinct(gisid, art_dtsch)
    
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
  
  filtered_trend_data <- reactive({
    df_agg <- df_merged_sum_distanz_umkreis_pump_ok_lor_clean %>%
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
      summarise(total_water = sum(gesamt_bewaesserung)) %>%
      mutate(total_water = as.numeric(total_water)) %>%  
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
  baum_bewaesserung_daten <- df_merged %>%
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
    # data <- df_merged_sum_pump_ok
    data <- df_merged_sum_distanz_umkreis_pump_ok_lor
    
    # Bezirk
    if (!is.null(input$map_bezirk) && !("Alle" %in% input$map_bezirk)) {
      data <- data %>% filter(bezirk %in% input$map_bezirk)
    }
    
    if (!is.null(input$map_lor) && !("Alle" %in% input$map_lor)) {
      data <- data %>% filter(bzr_name %in% input$map_lor)
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
  
  df_merged_sum_distanz_umkreis_pump_ok_lor <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
    mutate(
      lat = as.numeric(str_replace(lat, ",", ".")),
      lng = as.numeric(str_replace(lng, ",", "."))
    )
  
  df_merged_sum_distanz_umkreis_pump_ok_lor <- df_merged_sum_distanz_umkreis_pump_ok_lor %>% drop_na(lat, lng)
  
  # Nur funktionierende Pumpen berücksichtigen
  pumpen_mit_bezirk_ok <- pumpen_mit_bezirk %>%
    filter(pump.status == "ok")
  
  # Pumpenanzahl je Bezirk zählen
  pumpen_pro_bezirk <- pumpen_mit_bezirk_ok %>%
    st_drop_geometry() %>%
    group_by(bezirk) %>%
    summarise(pumpenanzahl = n())
  
  # Mit Fläche verknüpfen
  pumpendichte <- pumpen_pro_bezirk %>%
    left_join(bezirksflaechen, by = "bezirk") %>%
    mutate(pumpen_pro_ha = pumpenanzahl / flaeche_ha)
  
  
  giess_pumpen_dichte_df <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
    group_by(bezirk) %>%
    summarise(
      gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
      durchschnittl_intervall = mean(durchschnitts_intervall[is.finite(durchschnitts_intervall)], na.rm = TRUE),
      .groups = "drop"
    ) %>%
    left_join(pumpendichte, by = "bezirk")
  
  
  anzahl_pumpen_pro_bezirk <- pumpen_mit_bezirk_ok %>%
    st_drop_geometry() %>%
    group_by(bezirk) %>%
    summarise(anzahl_pumpen = n(), .groups = "drop")

  
  giess_pumpen_dichte_df <- giess_pumpen_dichte_df %>%
    left_join(anzahl_pumpen_pro_bezirk, by = "bezirk")
  
  # 'bezirksgrenzen' und 'giess_pumpen_dichte_df' verbinden
  bezirke_karte <- bezirksgrenzen %>%
    left_join(giess_pumpen_dichte_df, by = c("Gemeinde_name" = "bezirk"))
  
  # Bezirkszentren berechnen
  bezirkszentren <- st_centroid(bezirksgrenzen) %>%
    rename(bezirk = Gemeinde_name)
  
  # Merge mit Pumpenanzahl
  bezirkszentren <- bezirkszentren %>%
    left_join(anzahl_pumpen_pro_bezirk, by = "bezirk")
  
  # output$karte_giessverhalten <- renderLeaflet({
  #   
  #   # Farbpalette: Blauverlauf
  #   pal <- colorNumeric(palette = "Blues", domain = bezirke_karte$gesamt_bewaesserung)
  #   
  #   leaflet() %>%
  #     addProviderTiles(providers$CartoDB.Positron) %>%
  #     
  #     # Bezirke einfärben
  #     addPolygons(
  #       data = bezirke_karte,
  #       fillColor = ~pal(gesamt_bewaesserung),
  #       fillOpacity = 0.7,
  #       weight = 1,
  #       color = "white",
  #       highlightOptions = highlightOptions(
  #         weight = 2,
  #         color = "#666",
  #         fillOpacity = 0.9,
  #         bringToFront = FALSE
  #       ),
  #       label = ~paste0(Gemeinde_name, ": ", round(gesamt_bewaesserung), " Liter"),
  #       labelOptions = labelOptions(
  #         style = list("font-weight" = "normal", padding = "3px 8px"),
  #         direction = "auto"
  #       )
  #     ) %>%
  #     
  #     # Pumpen-Punkte (an Bezirkszentren) mit Größen nach Anzahl
  #     addCircleMarkers(
  #       data = bezirkszentren,
  #       radius = ~sqrt(anzahl_pumpen) * 2,  
  #       color = "blue",
  #       fillColor = "white",
  #       fillOpacity = 0.9,
  #       stroke = TRUE,
  #       weight = 1,
  #       label = ~paste0(bezirk, ": ", anzahl_pumpen, " Pumpen"),
  #       labelOptions = labelOptions(
  #         style = list("font-weight" = "bold", padding = "3px 8px"),
  #         direction = "auto"
  #       )
  #     ) %>%
  #     addLegend(
  #       "bottomright", pal = pal, values = bezirke_karte$gesamt_bewaesserung,
  #       title = "Gesamtbewässerung (Liter)",
  #       opacity = 1
  #     )
  # })

  
  # Pumpen pro LOR zählen
  pumpen_pro_lor <- pumpen_mit_lor %>%
    st_drop_geometry() %>%
    group_by(bzr_id) %>%
    summarise(pumpen_anzahl_lor = n()) %>%
    ungroup()
  
  # Mit LOR-Geometrien verbinden
  lor_mit_pumpen <- lor %>%
    left_join(pumpen_pro_lor, by = "bzr_id") %>%
    mutate(pumpen_anzahl_lor = ifelse(is.na(pumpen_anzahl_lor), 0, pumpen_anzahl_lor))
  
  # LOR-Zentren für Marker berechnen
  lor_zentren <- st_centroid(lor) %>%
    left_join(pumpen_pro_lor, by = "bzr_id")
  
  output$karte_giessverhalten <- renderLeaflet({
    # Farbpaletten erstellen (beide blau für Konsistenz)
    pal_bezirk <- colorNumeric(palette = "Blues", domain = bezirke_karte$gesamt_bewaesserung)
    pal_lor <- colorNumeric(palette = "Blues", domain = df_merged_mit_lor_sum$gesamt_bewaesserung_lor)
    
    # Gruppennamen für die Layer-Control
    group_bezirke <- "Bezirke"
    group_lor <- "LOR-Bereiche"
    group_pumpen_bezirk <- "Pumpen (Bezirk)"
    group_pumpen_lor <- "Pumpen (LOR)"
    group_bezirksgrenzen <- "Bezirksgrenzen (LOR-Ebene)"
    
    # Pumpen pro LOR zählen und Zentren berechnen
    lor_zentren <- st_centroid(lor) %>%
      left_join(
        pumpen_mit_lor %>% 
          st_drop_geometry() %>%
          group_by(bzr_id) %>%
          summarise(pumpen_anzahl = n()),
        by = "bzr_id"
      ) %>%
      mutate(pumpen_anzahl = ifelse(is.na(pumpen_anzahl), 0, pumpen_anzahl))
    
    # LOR-Daten mit Bewässerung verknüpfen
    lor_mit_bewaesserung <- lor %>%
      left_join(
        df_merged_mit_lor_sum %>% 
          st_drop_geometry() %>%
          select(bzr_id, gesamt_bewaesserung_lor),
        by = "bzr_id"
      )
    
    # Karte erstellen
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      
      # BEZIRKS-EBENE (bei niedrigem Zoom) -------------------------------
    # Bezirksflächen einfärben
    addPolygons(
      data = bezirke_karte,
      group = group_bezirke,
      fillColor = ~pal_bezirk(gesamt_bewaesserung),
      fillOpacity = 0.7,
      weight = 2,
      color = "white",
      highlightOptions = highlightOptions(
        weight = 3,
        color = "#666",
        fillOpacity = 0.9
      ),
      label = ~paste0(Gemeinde_name, ": ", round(gesamt_bewaesserung), " Liter")
    ) %>%
      
      # Pumpen-Punkte auf Bezirksebene
      addCircleMarkers(
        data = bezirkszentren,
        group = group_pumpen_bezirk,
        radius = ~sqrt(anzahl_pumpen) * 2,
        color = "blue",
        fillColor = "white",
        fillOpacity = 0.9,
        stroke = TRUE,
        weight = 1,
        label = ~paste0(bezirk, ": ", anzahl_pumpen, " Pumpen")
      ) %>%
      
      # BEZIRKSGRENZEN (für LOR-Ebene) - dickere Linien
      addPolylines(
        data = bezirksgrenzen,
        group = group_bezirksgrenzen,
        color = "#333",
        weight = 3,
        opacity = 0.8,
        options = pathOptions(clickable = FALSE)
      ) %>%
      
      # LOR-EBENE (bei hohem Zoom) ---------------------------------------
    # LOR-Bereiche blau einfärben
    addPolygons(
      data = lor_mit_bewaesserung,
      group = group_lor,
      fillColor = ~pal_lor(gesamt_bewaesserung_lor),
      fillOpacity = 0.7,
      weight = 1,
      color = "#666",
      opacity = 0.7,
      highlightOptions = highlightOptions(
        weight = 2,
        color = "#000",
        bringToFront = FALSE
      ),
      label = ~paste0(bzr_name, ": ", round(gesamt_bewaesserung_lor), " Liter"),
      options = pathOptions(clickable = TRUE)
    ) %>%
      
      # Pumpen-Punkte auf LOR-Ebene
      addCircleMarkers(
        data = lor_zentren,
        group = group_pumpen_lor,
        radius = ~sqrt(pumpen_anzahl) * 2,
        color = "red",
        fillColor = "white",
        fillOpacity = 0.9,
        stroke = TRUE,
        weight = 1,
        label = ~paste0(bzr_name, ": ", pumpen_anzahl, " Pumpen")
      ) %>%
      
      # Legenden
      addLegend(
        "bottomright",
        pal = pal_bezirk,
        values = bezirke_karte$gesamt_bewaesserung,
        title = "Bewässerung (Liter)",
        opacity = 1,
        group = group_bezirke
      ) %>%
      
      # Layer-Control
      addLayersControl(
        overlayGroups = c(group_bezirke, group_pumpen_bezirk),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      
      # ZOOM-LOGIK -------------------------------------------------------
    htmlwidgets::onRender("
      function(el, x) {
        var map = this;
        
        function updateLayers() {
          var zoom = map.getZoom();
          
          if (zoom >= 12) {
            // LOR-EBENE ANZEIGEN
            map.layerManager.getLayerGroup('Bezirke').remove();
            map.layerManager.getLayerGroup('Pumpen (Bezirk)').remove();
            map.layerManager.getLayerGroup('Bezirksgrenzen (LOR-Ebene)').addTo(map);
            map.layerManager.getLayerGroup('LOR-Bereiche').addTo(map);
            map.layerManager.getLayerGroup('Pumpen (LOR)').addTo(map);
          } else {
            // BEZIRKS-EBENE ANZEIGEN
            if (!map.hasLayer(map.layerManager.getLayerGroup('Bezirke'))) {
              map.layerManager.getLayerGroup('Bezirke').addTo(map);
              map.layerManager.getLayerGroup('Pumpen (Bezirk)').addTo(map);
            }
            map.layerManager.getLayerGroup('Bezirksgrenzen (LOR-Ebene)').remove();
            map.layerManager.getLayerGroup('LOR-Bereiche').remove();
            map.layerManager.getLayerGroup('Pumpen (LOR)').remove();
          }
        }
        
        // Initialen Zustand setzen
        updateLayers();
        
        // Bei Zoom-Änderungen aktualisieren
        map.on('zoomend', updateLayers);
      }
    ")
  })
  
  
  
  
 
  
  # Daten in long-format bringen:
  giess_long <- giess_pumpen_dichte_df %>%
    select(bezirk, anzahl_pumpen, gesamt_bewaesserung) %>%
    pivot_longer(cols = c(anzahl_pumpen, gesamt_bewaesserung),
                 names_to = "variable",
                 values_to = "wert")
  

  
  output$balken_plot <- renderPlotly({ 
    
    # Skalierungsfaktor berechnen
    max_bewaesserung <- max(giess_pumpen_dichte_df$gesamt_bewaesserung, na.rm = TRUE)
    max_pumpen <- max(giess_pumpen_dichte_df$anzahl_pumpen, na.rm = TRUE)
    scaling_factor <- max_bewaesserung / max_pumpen
    
    # ggplot erstellen
    p <- ggplot(giess_pumpen_dichte_df, aes(x = bezirk)) +
      geom_bar(
        aes(y = gesamt_bewaesserung, fill = "Bewässerung", 
            text = paste("Bezirk:", bezirk, "<br>Bewässerung:", gesamt_bewaesserung, "L")), 
        stat = "identity", position = position_nudge(x = -0.2), width = 0.4
      ) +
      geom_bar(
        aes(y = anzahl_pumpen * scaling_factor, fill = "Pumpenanzahl", 
            text = paste("Bezirk:", bezirk, "<br>Anzahl Pumpen:", anzahl_pumpen)), 
        stat = "identity", position = position_nudge(x = 0.2), width = 0.4
      ) +
      scale_fill_manual(
        name = "Kategorie", 
        values = c("Bewässerung" = "steelblue", "Pumpenanzahl" = "seagreen")
      ) +
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
    
    ggplotly(p, tooltip = "text")
  })
  
  output$balken_plot <- renderPlotly({
    
    # Skalierungsfaktor berechnen
    max_bewaesserung <- max(giess_pumpen_dichte_df$gesamt_bewaesserung, na.rm = TRUE)
    max_pumpen <- max(giess_pumpen_dichte_df$anzahl_pumpen, na.rm = TRUE)
    scaling_factor <- max_bewaesserung / max_pumpen
    
    plot_ly() %>%
      add_bars(
        data = giess_pumpen_dichte_df,
        x = ~bezirk,
        y = ~gesamt_bewaesserung,
        name = "Bewässerung (L)",
        marker = list(color = 'steelblue'),
        hovertemplate = paste(
          "<b>Bezirk:</b> %{x}<br>",
          "<b>Bewässerung:</b> %{y} L"
        )
      ) %>%
      add_bars(
        data = giess_pumpen_dichte_df,
        x = ~bezirk,
        y = ~anzahl_pumpen * scaling_factor,
        name = "Pumpenanzahl",
        marker = list(color = 'seagreen'),
        customdata = giess_pumpen_dichte_df$anzahl_pumpen,
        hovertemplate = paste(
          "<b>Bezirk:</b> %{x}<br>",
          "<b>Anzahl Pumpen:</b> %{customdata}"
        )
      ) %>%
      add_trace(
        x = c(NA), y = c(NA),
        type = "bar",
        yaxis = "y2",
        showlegend = FALSE,
        hoverinfo = "none"
      ) %>%
      layout(
        title = "Pumpenanzahl und Bewässerung pro Bezirk",
        barmode = "group",
        xaxis = list(title = "Bezirk"),
        yaxis = list(
          title = "Gesamtbewässerung (Liter)",
          side = "left"
        ),
        yaxis2 = list(
          title = "Anzahl Pumpen",
          overlaying = "y",
          side = "right",
          tickvals = seq(0, max_bewaesserung, length.out = 6),
          ticktext = round(seq(0, max_pumpen, length.out = 6), 0),
          range = c(0, max_bewaesserung),
          showgrid = FALSE
        ),
        legend = list(orientation = "h", x = 0.3, y = 1.1)
      )
  })
  
  
  df_merged_sum_distanz_umkreis_pump_ok_lor <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
    mutate(pumpenkategorie = case_when(
      pumpen_im_umkreis_100m == 0 ~ "Keine Pumpe",
      pumpen_im_umkreis_100m == 1 ~ "Eine Pumpe",
      pumpen_im_umkreis_100m >= 2 ~ "Mehrere Pumpen"
    ))
  
  output$pumpenkategorien_plot_pump_ok <- renderPlot({
    
    df_kategorie_mittelwert <- df_merged_sum_distanz_umkreis_pump_ok_lor %>%
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
        title = "Durchschnittliche Gießmenge nach Pumpen-Kategorie im 100 m Umkreis mit Pumpen außerbetrieb",
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

}