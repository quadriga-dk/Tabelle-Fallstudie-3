# Übung Verbesserung Bewässerungsanalyse (Debugging)

#### Fehleranalyse

1. Fehlermeldung A – lubridate::month():

```bash
Error in mutate: In argument: month = month(timestamp, label = TRUE).
Caused by error in month(): ! unbenutztes Argument (label = TRUE)
```
**Ursache:**
Das month()-Funktion wurde maskiert (z. B. durch das data.table-Paket) und daher wurde nicht die lubridate::month()-Funktion verwendet.


2. Fehlermeldung B – Tooltip-Anzeige:

```bash
Warning in geom_point(aes(text = ...)): Ignoring unknown aesthetics: text
```
**Ursache:**
ggplot2::geom_point() kennt den Aesthetic text nicht – aber plotly::ggplotly() nutzt ihn zur Anzeige von Tooltips. Diese Warnung ist harmlos, aber notwendig für das gewünschte Verhalten.


#### Lösungen im Überblick

1. Fehlerhafte Maskierung von month() beheben
Änderung in filtered_trend_data
Vorher:

```bash
month = month(timestamp, label = TRUE)
```

Nachher (Fix):

```bash
month = lubridate::month(timestamp, label = TRUE)
```

Dies stellt sicher, dass lubridate::month() trotz eventueller Maskierung korrekt verwendet wird.

Korrekt korigierter Codeabschnitt zur Kontrolle:

```bash
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
```

2. Tooltip in ggplotly() **korrekt anzeigen**
Problem: Die direkte Verwendung von aes(text = ...) in geom_point() mit paste(...) erzeugt zwar Tooltips in plotly, aber ggplot2 wirft eine Warnung.

**Lösung:**
Den Tooltip vorher in einem mutate()-Schritt berechnen und dann referenzieren.

**Änderung** in renderPlotly()
**Vorher:**
```bash
geom_point(aes(text = paste("Summe:", converted_value, df_plot$unit)), ...)
```

**Nachher:**
```bash
df_plot <- filtered_trend_data() %>%
  mutate(tooltip = paste("Summe:", round(converted_value, 2), unit))

geom_point(aes(text = tooltip), ...)
```

Die Warnung Ignoring unknown aesthetics: text bleibt, ist aber gewollt und notwendig für Tooltips in plotly.

Korrekt korigierter Codeabschnitt zur Kontrolle:

```bash
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
```

#### Zusätzliche Änderung im Datenbereinigungsschritt (df_clean)

**Ziel**: Timestamp-Konvertierung direkt beim Aufbereiten der Daten.

**Vorher:**
```bash
mutate(strname = str_to_title(trimws(tolower(strname))))
```

**Nachher:**

```bash
mutate(
  strname = str_to_title(trimws(tolower(strname))),
  timestamp = ymd_hms(timestamp)
)
```

Korrekt korigierter Codeabschnitt zur Kontrolle:

```bash
df_clean <- df %>% drop_na(lng, lat, bewaesserungsmenge_in_liter)  %>% 
  mutate(strname = str_to_title(trimws(tolower(strname)),
          timestamp = ymd_hms(timestamp))) %>% 
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]")) 

```


#### Fehlermeldung lösen

```bash
Input to asJSON(keep_vec_names=TRUE) is a named vector. In a future version of jsonlite, this option will not be supported, and named vectors will be translated into arrays instead of objects. If you want JSON object output, please use a named list instead. See ?toJSON.
Warnung: There was 1 warning in `mutate()`.
ℹ In argument: `timestamp = ymd_hms(timestamp)`.
Caused by warning:
!  3074 failed to parse.
```
Hier die Lösung: 
```bash
df_clean <- df_merged %>%
  filter(str_detect(timestamp, "^\\d{4}-\\d{2}-\\d{2}")) %>%  # Nur gültige ISO-Formate
  mutate(timestamp = ymd_hms(timestamp)) %>%
  drop_na(lat, lng) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))

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
```