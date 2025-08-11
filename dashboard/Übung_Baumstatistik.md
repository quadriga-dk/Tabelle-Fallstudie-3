# Übung Baumstatistik

In dieser Übung lernen Sie, wie man mit Hilfe der Bibliothek plotly zwei interaktive Diagramme erstellt:

- Eine Balkengrafik zeigt die Verteilung der gegossenen Bäume und Baumdichte nach Berliner Bezirken im Verhältnis zur Bezirksfläche.

- Ein Kreisdiagramm (Tortendiagramm) visualisiert die häufigsten Baumarten – mit der Möglichkeit, nach Bezirk zu filtern.

### 1. Benutzeroberfläche (UI)
Die Benutzeroberfläche besteht aus zwei Teilen:

- einer Seitenleiste (``sidebarMenu``) mit der Navigation

- einem Inhaltsbereich (``tabItem``) mit:

    - Balkengrafik anzeigen
    - Kreisdiagramm
    - Dropdowns zur Auswahl des Bezirks

**Navigation in der Seitenleiste**
```bash
dashboardSidebar(
  sidebarMenu(
      menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart")),
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

## 2. UI: Balkengrafik und Kreisdiagramm mit Filter-Boxen

```bash
tabItems(
      tabItem(tabName = "stats",
              fluidRow(
                box(status = "primary", solidHeader = TRUE, width = 12, title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
                                                                                        div(actionButton("info_btn", label = "", icon = icon("info-circle")),  # Info-Button 
                                                                                            style = "position: absolute; right: 15px; top: 5px;")),
                    selectInput("stats_baumvt_year", "Jahr auswählen:",
                                choices = c("2020-2024", "Baumbestand Stand 2025", sort(unique(na.omit(year(df_merged$timestamp))))),
                                selected = "Baumbestand Stand 2025",
                                multiple = TRUE),
                    
                    plotlyOutput("tree_distribution")
                ),
                box(title = tagList("Häufig gegossene Baumarten im Verhältnis zu ihrem Vorkommen", 
                                    div(actionButton("info_btn_hb", label = "", icon = icon("info-circle")),  # Info-Button 
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12, height = "auto", 
                    selectInput("pie_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    plotlyOutput("tree_pie_chart"),
                    fill = TRUE
                )
              )
      )
```
- ``box(...)`` ist ein Container mit:
    - ``title`` (Überschrift)
    - ``status = "primary"`` (Farbe)
    - ``solidHeader = TRUE`` (fester Rand)
    - ``width = 12`` (volle Breite – 12 ist die maximale Spaltenanzahl)
- ``fluidRow(...)`` sorgt für eine horizontale Anordnung (z. B. nebeneinander statt untereinander).
- ``multiple = TRUE`` bedeutet, dass man mehrere Optionen gleichzeitig auswählen kann.

```{admonition} Merke: 
:class: keypoint 

``fluidRow()`` ordnet Inhalte nebeneinander. ``box(...)`` gruppiert UI-Elemente visuell und funktional.
```


```bash
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "stats",
              fluidRow(
                box(status = "primary", solidHeader = TRUE, width = 12, title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
                                                                                        div(actionButton("info_btn", label = "", icon = icon("info-circle")),  # Info-Button 
                                                                                            style = "position: absolute; right: 15px; top: 5px;")),
                    selectInput("stats_baumvt_year", "Jahr auswählen:",
                                choices = c("2020-2024", "Baumbestand Stand 2025", sort(unique(na.omit(year(df_merged$timestamp))))),
                                selected = "Baumbestand Stand 2025",
                                multiple = TRUE),
                    
                    plotlyOutput("tree_distribution")
                ),
                box(title = tagList("Häufig gegossene Baumarten im Verhältnis zu ihrem Vorkommen", 
                                    div(actionButton("info_btn_hb", label = "", icon = icon("info-circle")),  # Info-Button 
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12, height = "auto", 
                    selectInput("pie_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    plotlyOutput("tree_pie_chart"),
                    fill = TRUE
                )
              )
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


## 3. Baumverteilung pro Bezirk im Server:

```bash
output$tree_distribution <- renderPlotly({
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

  baumanzahl_filtered <- df_filtered %>%
    group_by(bezirk) %>%
    summarise(tree_count = n_distinct(gisid), .groups = "drop")

  baum_dichte_filtered <- baum_dichte %>%
    filter(bezirk %in% baumanzahl_filtered$bezirk) %>%
    left_join(baumanzahl_filtered, by = "bezirk")

  plot <- ggplot(baum_dichte_filtered,
      aes(x = reorder(bezirk, tree_count), y = tree_count, fill = baeume_pro_ha)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Baumdichte (Bäume/ha)") +
    coord_flip() +
    labs(title = "Baumverteilung im Verhältnis zur Bezirkfläche", x = "Bezirk", y = "Anzahl der Bäume") +
    theme_minimal()

  ggplotly(plot, tooltip = c("x", "y", "fill"))
})
```
**Wichtige Begriffe erklärt:**
- ``as.Date``: Wandelt einen Datumswert (z. B. ``"2023-05-01"``) in ein Datum, mit dem man rechnen oder filtern kann.
- - ``filter(...)``: Filtert die Daten so, dass nur diejenigen Zeilen erhalten bleiben, die bestimmte Bedingungen erfüllen.
- ``df_merged``: Ist der vorbereitete Datensatz
- NA-Werte (``NA``)
Steht für "Not Available" und bedeutet, dass ein Wert in den Daten fehlt oder unbekannt ist. Zum Beispiel, wenn für einen Baum die Koordinaten nicht bekannt sind.
  - ``is.na(x)`` prüft, ob x ein fehlender Wert ist.
  - ``!is.na(x)`` prüft, ob x nicht fehlt.
- ``c(...)``: Erstellt einen Vektor (also eine Liste von Werten). 
  Beispiel:
  ```bash
  c("rot", "blau", "gelb")
  ```
  Ergebnis: eine Liste mit den drei Farben.
- ``%>%``  (Pipe-Operator)
Leitet das Ergebnis von links an die Funktion rechts weiter. Er sorgt für eine lesbare Verkettung von Operationen.
- ``as.numeric``: Wandelt einen Wert (z. B. eine Jahreszahl als Text ``"2023"``) in eine Zahl ``2023`` um – damit man mathematisch damit arbeiten kann.
- ``lubridate``: Gehört zur Bibliothek lubridate, die speziell für Datumswerte gedacht ist. Die Funktion year(...) extrahiert das Jahr aus einem Datum.
  Beispiel:
  ```bash
  year(as.Date("2023-05-01"))  # Ergebnis: 2023
  ```
- ``group_by``: Gruppiert die Daten nach einer bestimmten Spalte – zum Beispiel nach Bezirken oder Baumarten. Damit kann man pro Gruppe Berechnungen durchführen.
- ``left_join``: Verbindet zwei Tabellen nach einem gemeinsamen Merkmal – z. B. nach dem Bezirk. Dabei bleiben alle Daten aus der linken Tabelle erhalten, auch wenn es rechts keine Entsprechung gibt.
- ``plot``
- ``aes``: Bedeutet **„Ästhetik“** – also welche Werte auf der X-Achse, Y-Achse und für Farben oder Größen verwendet werden sollen.
- ``geom_bar(stat = "identity")``: Zeichnet einen Balken für jede Gruppe – die Höhe entspricht genau dem übergebenen Wert (z. B. Anzahl der Bäume).
- ``scale_fill_gradient(...)``: Farbverlauf für die Balken – je mehr Bäume pro Hektar, desto dunkler die Farbe. Dies macht die Baumdichte visuell erkennbar.
- ``coord_flip()``: Dreht die Achsen – so wird aus einem vertikalen Balkendiagramm ein horizontales. Das ist oft besser lesbar, wenn die Namen lang sind.
- ``labs``
- ``theme_minimal()``: Ein schlankes, übersichtliches Design für das Diagramm ohne viele Linien oder Farben.
- ``tooltip``

```{admonition} Merke: 
:class: keypoint 

Die Filter arbeiten unabhängig voneinander – so können beliebige Kombinationen gewählt werden.
```

**Operatoren**
- ``%in%``: prüft, ob ein Wert in einer Liste enthalten ist.
  Zum Beispiel:
    ```bash
    bezirk %in% input$map_bezirk
    ```
- ``<-``: weist einer Variable einen Wert zu (z. B. ``x <- 3``).

## 4. Anteil gegossener Bäume nach Baumart im Server: 

```bash
output$tree_pie_chart <- renderPlotly({
  df_filtered <- df_merged

  if (!is.null(input$pie_bezirk) && !"Alle" %in% input$pie_bezirk) {
    df_filtered <- df_filtered %>% filter(bezirk %in% input$pie_bezirk)
  }

  baeume_einzigartig <- df_filtered %>%
    filter(!is.na(art_dtsch)) %>%
    distinct(gisid, art_dtsch)

  baeume_gegossen <- df_filtered %>%
    filter(!is.na(art_dtsch) & !is.na(bewaesserungsmenge_in_liter)) %>%
    distinct(gisid, art_dtsch)

  art_ratio_df <- baeume_einzigartig %>%
    group_by(art_dtsch) %>%
    summarise(gesamt = n()) %>%
    left_join(
      baeume_gegossen %>% group_by(art_dtsch) %>% summarise(gegossen = n()),
      by = "art_dtsch"
    ) %>%
    mutate(
      gegossen = replace_na(gegossen, 0),
      anteil_gegossen = gegossen / gesamt
    ) %>%
    arrange(desc(gesamt)) %>%
    slice_max(order_by = gesamt, n = 10)

  plot_ly(
    art_ratio_df,
    labels = ~art_dtsch,
    values = ~anteil_gegossen,
    type = "pie",
    textinfo = "label+percent",
    hoverinfo = "label+percent+value",
    marker = list(colors = RColorBrewer::brewer.pal(10, "Set2"))
  ) %>%
    layout(title = "Anteil gegossener Bäume pro Baumart (Top 10)")
})
```
**Wichtige Begriffe erklärt:**
- ``distinct``: Entfernt Dubletten (mehrfache Vorkommen derselben Kombination). Hier verwendet, um sicherzustellen, dass jeder Baum nur einmal gezählt wird.
- ``group_by``: Gruppiert die Daten nach einer bestimmten Spalte – zum Beispiel nach Bezirken oder Baumarten. Damit kann man pro Gruppe Berechnungen durchführen.
- ``mutate``: Fügt neue Spalten zu einem Datensatz hinzu oder verändert vorhandene. Beispiel: Berechnung des Anteils gegossener Bäume.
- ``arrange``: Sortiert die Tabelle. Mit ``desc(...)`` wird absteigend sortiert, z. B. von häufig zu selten.
- ``desc``
- ``plot_ly``: Erstellt eine interaktive Grafik mit ``plotly``. Man kann damit z. B. über die Tortenstücke fahren und zusätzliche Infos sehen.
- ``labels``: Welche Bezeichnungen sollen angezeigt werden? (z. B. Baumart)
- ``values``: Welche Werte bestimmen die Größe der Tortenstücke?
- ``textinfo``: Was wird auf dem Diagramm angezeigt?
- ``hoverinfo``: Was erscheint, wenn man mit der Maus darüber fährt?

**if- und else-Anweisungen**
```bash
if (Bedingung) {
  # wird ausgeführt, wenn die Bedingung wahr ist
} else {
  # wird ausgeführt, wenn die Bedingung falsch ist
}
```

<details>
<summary><strong>Gesamter Code</strong></summary>
```bash
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "stats",
              fluidRow(
                box(status = "primary", solidHeader = TRUE, width = 12, title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
                                                                                        div(actionButton("info_btn", label = "", icon = icon("info-circle")),  # Info-Button 
                                                                                            style = "position: absolute; right: 15px; top: 5px;")),
                    selectInput("stats_baumvt_year", "Jahr auswählen:",
                                choices = c("2020-2024", "Baumbestand Stand 2025", sort(unique(na.omit(year(df_merged$timestamp))))),
                                selected = "Baumbestand Stand 2025",
                                multiple = TRUE),
                    
                    plotlyOutput("tree_distribution")
                ),
                box(title = tagList("Häufig gegossene Baumarten im Verhältnis zu ihrem Vorkommen", 
                                    div(actionButton("info_btn_hb", label = "", icon = icon("info-circle")),  # Info-Button 
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12, height = "auto", 
                    selectInput("pie_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    plotlyOutput("tree_pie_chart"),
                    fill = TRUE
                )
              )
      )
    )
)


# Server-Logik
server <- function(input, output, session) {

output$tree_distribution <- renderPlotly({
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

  baumanzahl_filtered <- df_filtered %>%
    group_by(bezirk) %>%
    summarise(tree_count = n_distinct(gisid), .groups = "drop")

  baum_dichte_filtered <- baum_dichte %>%
    filter(bezirk %in% baumanzahl_filtered$bezirk) %>%
    left_join(baumanzahl_filtered, by = "bezirk")

  plot <- ggplot(baum_dichte_filtered,
      aes(x = reorder(bezirk, tree_count), y = tree_count, fill = baeume_pro_ha)) +
    geom_bar(stat = "identity") +
    scale_fill_gradient(low = "lightblue", high = "darkblue", name = "Baumdichte (Bäume/ha)") +
    coord_flip() +
    labs(title = "Baumverteilung im Verhältnis zur Bezirkfläche", x = "Bezirk", y = "Anzahl der Bäume") +
    theme_minimal()

  ggplotly(plot, tooltip = c("x", "y", "fill"))
})

output$tree_pie_chart <- renderPlotly({
  df_filtered <- df_merged

  if (!is.null(input$pie_bezirk) && !"Alle" %in% input$pie_bezirk) {
    df_filtered <- df_filtered %>% filter(bezirk %in% input$pie_bezirk)
  }

  baeume_einzigartig <- df_filtered %>%
    filter(!is.na(art_dtsch)) %>%
    distinct(gisid, art_dtsch)

  baeume_gegossen <- df_filtered %>%
    filter(!is.na(art_dtsch) & !is.na(bewaesserungsmenge_in_liter)) %>%
    distinct(gisid, art_dtsch)

  art_ratio_df <- baeume_einzigartig %>%
    group_by(art_dtsch) %>%
    summarise(gesamt = n()) %>%
    left_join(
      baeume_gegossen %>% group_by(art_dtsch) %>% summarise(gegossen = n()),
      by = "art_dtsch"
    ) %>%
    mutate(
      gegossen = replace_na(gegossen, 0),
      anteil_gegossen = gegossen / gesamt
    ) %>%
    arrange(desc(gesamt)) %>%
    slice_max(order_by = gesamt, n = 10)

  plot_ly(
    art_ratio_df,
    labels = ~art_dtsch,
    values = ~anteil_gegossen,
    type = "pie",
    textinfo = "label+percent",
    hoverinfo = "label+percent+value",
    marker = list(colors = RColorBrewer::brewer.pal(10, "Set2"))
  ) %>%
    layout(title = "Anteil gegossener Bäume pro Baumart (Top 10)")
})
}
```
</details>