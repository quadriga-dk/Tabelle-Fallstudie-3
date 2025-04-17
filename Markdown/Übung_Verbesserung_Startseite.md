# Startseite verbessern 

```{figure} _images/R_Startseite.png
---
name: screenshot der Startseite
alt: Ein Screenshot, der die Startseite des Dashboards zeigt.
---
Dashboard Startseite.
```


verbesserungen: 
Was wir einbauen wollen um das Dashboard zu verbessern: 
- Filter nach Jahren einbauen 
- Layout ändern
- Einbindung des Baumbestands

Ui veränderung: 
```bash
    tabItems(
      tabItem(tabName = "start",
              fluidRow(
                valueBoxOutput("total_trees"),
                valueBoxOutput("total_water"),
                valueBoxOutput("avg_water")
              ),
              fluidRow(
                box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    # Einfügen des Jahresfilters 
                    selectInput("start_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
                    selectInput("bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE)
                )
              )
      ),
```

Server änderung: 

```bash
filteredData <- reactive({
    # Jahre extrahieren (inkl. "2020-2024"-Shortcut)
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
        (input$bezirk == "Alle" | bezirk %in% input$bezirk)
      )
  })
```

Der Rest bleibt gleich 


Dann sollten es bei Ihnen so aussehen: 

```{figure} _images/R_Startseite_Jahresfilter.png
---
name: screenshot der Startseite mit Jahresfilter
alt: Ein Screenshot, der die Startseite des Dashboards zeigt.
---
Dashboard Startseite mit Jahresfilter.
```


```{figure} _images/R_Startseite_Layout_änderung.png
---
name: screenshot der Startseite mit geändertem Layout
alt: Ein Screenshot, der die Startseite des Dashboards mit geändertem Layout zeigt.
---
Dashboard Startseite mit geändertem Layout.
```

Um das Layout so zu ändern wie im bild wird folgende änderung in der Ui vorgenommen

```bash
    tabItems(
      tabItem(tabName = "start",
              box(title = "Overview", status = "primary", solidHeader = TRUE, width = 12,
                fluidRow(
                  valueBoxOutput("total_trees"),
                  valueBoxOutput("total_water"),
                  valueBoxOutput("avg_water")
                ),
                fluidRow(
                  column(width = 6,
                         selectInput("start_year", "Jahr auswählen:", 
                                     choices = c("2020-2024", unique(year(df_clean$timestamp))), 
                                     selected = "2020-2024", multiple = TRUE)
                  ),
                  column(width = 6,
                         selectInput("bezirk", "Bezirk auswählen:", 
                                     choices = c("Alle", unique(df$bezirk)), 
                                     selected = "Alle", multiple = TRUE)
                  )
                )
              )
      ),
```

Der Link für den Baumbestand <a href="https://daten.berlin.de/datensaetze/baumbestand-berlin-wfs-48ad3a23" target="_blank">"Baumbestand Berlin"</a>
