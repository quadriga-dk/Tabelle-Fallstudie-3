# Verbesserung Baumstatistik

Verbessern: 
- Diagramm Baumverteilung_Nach_Bezirk mit verhältnis zu Bäumen in Berlin
    - Filter nach Jahren

Bis jetzt sollte das Diagramm zur Baumverteilung je nach Bezirk so aussehen: 

```{figure} _images/R_Baumverteilung_Nach_Bezirk.png
---
name: screenshot ein Diagramm zur Baumverteilung nach Bezirk zeigt
alt: Ein Screenshot, der ein Diagramm zur Baumverteilung nach Bezirk zeigt.
---
Diagramm zur Baumverteilung nach Bezirk
```

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

Mit Jahresfilter ohne Verhältnis

```bash

 fluidRow(
    box(status = "primary", solidHeader = TRUE, width = 12, title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
            div(actionButton("info_btn", label = "", icon = icon("info-circle")),  # Info-Button 
                    style = "position: absolute; right: 15px; top: 5px;")),
          selectInput("stats_baumvt_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
          plotlyOutput("tree_distribution")
    ),
 )

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
    
    # Plot
    plot <- df_filtered %>%
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


```bash
# Erstellen eines DataFrames mit Bezirksflächen
bezirksflaechen <- data.frame(
  bezirk = c("Mitte", "Friedrichshain-Kreuzberg", "Pankow", "Charlottenburg-Wilmersdorf",
             "Spandau", "Steglitz-Zehlendorf", "Tempelhof-Schöneberg", "Neukölln",
             "Treptow-Köpenick", "Marzahn-Hellersdorf", "Lichtenberg", "Reinickendorf"),
  flaeche_ha = c(3.940, 2.040, 10.322, 6.469, 9.188, 10.256, 5.305, 4.493, 16.773, 6.182, 5.212, 8.932)
)

# Zusammenführen mit deinem bestehenden DataFrame df_merged_sum
df_merged_sum <- df_merged_sum %>%
  left_join(bezirksflaechen, by = "bezirk")


# Anzahl gegossener Bäume je Bezirk
baumanzahl_pro_bezirk <- df_merged_sum %>%
  group_by(bezirk) %>%
  summarise(baumanzahl = n_distinct(pitid))

# Mit Fläche kombinieren und Bäume pro ha berechnen
baum_dichte <- baumanzahl_pro_bezirk %>%
  left_join(bezirksflaechen, by = "bezirk") %>%
  mutate(baeume_pro_ha = baumanzahl / flaeche_ha)
```

```bash
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
      summarise(tree_count = n_distinct(id))
    
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
```


```{figure} _images/Baumverteilung_Bezirksfläche.png
---
name: screenshot ein Diagramm zur Baumverteilung nach Bezirk im Verhältnis zur Fläche zeigt
alt: Ein Screenshot, der ein Diagramm zur Baumverteilung nach Bezirk im Verhältnis zur Fläche zeigt.
---
Diagramm zur Baumverteilung nach Bezirk im Verhältnis zur Fläche 
```




```bash
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
      marker = list(colors = RColorBrewer::brewer.pal(10, "Set3"))  # Farbpalette
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
```

```{figure} _images/R_Häufigste_gegossene_Baumart.png
---
name: screenshot Tortendiagramm welches die am häufigsten gegossenen Baumarten zeigt
alt: Ein Screenshot, der mit einem Tortendiagramm welches die am häufigsten gegossenen Baumarten zeigt.
---
Tortendiagramm welches die am häufigsten gegossenen Baumarten zeigt
```

```bash
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
```

```{figure} _images/R_Häufig_gegossene_Baumart_im_Verhältnis.png
---
name: screenshot Tortendiagramm welches die am häufigsten gegossenen Baumarten im Verhältnis zu ihrem Vorkommen zeigt
alt: Ein Screenshot, der mit einem Tortendiagramm welches die am häufigsten gegossenen Baumarten im Verhältnis zu ihrem Vorkommen zeigt.
---
Tortendiagramm welches die am häufigsten gegossenen Baumarten im Verhältnis zu ihrem Vorkommen zeigt
```

```bash
Warnung: Error in summarise: ℹ In argument: `tree_count = n_distinct(id)`.
ℹ In group 1: `bezirk = "Charlottenburg-Wilmersdorf"`.
Caused by error in `n_distinct()`:
! `..1` must be a vector, not a function.
  128: <Anonymous>
  127: signalCondition
  126: signal_abort
  125: abort
  124: handler
  123: <Anonymous>
  122: signalCondition
  121: signal_abort
  120: abort
  119: stop_vctrs
  118: stop_scalar_type
  117: df_list
  116: n_distinct
  115: eval
  114: mask$eval_all_summarise
  113: FUN
  112: lapply
  111: map
  109: summarise_cols
  108: summarise.grouped_df
  107: summarise
  106: %>%
  105: renderPlotly [C:\Users\cem67098\Documents\Rshiny\dashboard/server.R#127]
  104: func
  101: shinyRenderWidget
  100: func
   87: renderFunc
   86: output$tree_distribution
    1: runApp
Warnung in RColorBrewer::brewer.pal(10, "Set2")
  n too large, allowed maximum for palette Set2 is 8
Returning the palette you asked for with that many colors

Input to asJSON(keep_vec_names=TRUE) is a named vector. In a future version of jsonlite, this option will not be supported, and named vectors will be translated into arrays instead of objects. If you want JSON object output, please use a named list instead. See ?toJSON.
```
Lösung der Fehlermeldung: 

```bash
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
```