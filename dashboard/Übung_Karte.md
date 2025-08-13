---
lang: de-DE
---

(map)=
# Einfügen Karte

In dieser Übung erstellen wir eine interaktive Karte, auf der alle Bäume (stand 2025) dargestellt sind. Dabei können verschiedene Filter gesetzt werden, z. B. nach Bezirk, Jahr, Jahreszeit oder Baumart. 

Ziel ist es, mit Hilfe der Leaflet-Bibliothek eine Karte zu generieren, die:

- Bewässerte Bäume als farbige Kreise darstellt
- Informationen zur Bewässerung beim Anklicken anzeigt
- Eine Legende zur Farbskala der Wassermenge enthält
- Funktionstüchtige Pumpen ab einem bestimmten Zoom-Level anzeigen

## Benutzeroberfläche (UI)
Die Benutzeroberfläche besteht aus zwei Teilen:

- einer Seitenleiste (``sidebarMenu``) mit der Navigation

- einem Inhaltsbereich (``tabItem``) mit:

    - Karte mit Baumbestands anzeige

    - Dropdowns zur Auswahl des Zeitraums, des Bezirks, des lor und der Baumgattung

**Navigation in der Seitenleiste**

```bash
dashboardSidebar(
  sidebarMenu(
    menuItem("Karte", tabName = "map", icon = icon("map"))
  )
)
```
- ``sidebarMenu(...)`` ist die Hauptnavigation des Dashboards.
- ``menuItem(...)`` erzeugt einen Menüpunkt:
- ``"Karte"`` ist der angezeigte Name.
- ``tabName = "map"`` verbindet den Menüpunkt mit dem Tab.
- ``icon("map")`` zeigt ein kleines Karten Symbol an.

```{admonition} Merke: 
:class: keypoint 

Mit ``menuItem(...)`` wird ein weiterer Navigationspunkt eingebunden. "map" als tabName verknüpft ihn mit dem Kartentab.
```

## UI: Karte mit Filter-Boxen

```bash
tabItem(tabName = "map",
  fluidRow(
    box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
      column(width = 6, selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE)),
      column(width = 6, selectInput("map_lor", "Lebensweltlich orientierte Räume auswählen:", choices = c("Alle", unique(df_merged_sum_distanz_umkreis_pump_ok_lor$bzr_name)), selected = "Alle", multiple = TRUE)),
      column(width = 6, selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024", unique(year(df_merged_clean$timestamp))), selected = "2020-2024", multiple = TRUE)),
      column(width = 6, selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE)),
      column(width = 6, selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df_merged_clean$gattung_deutsch)), selected = "Alle", multiple = TRUE))
    )
  ),
  leafletOutput("map", height = "800px")
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

## Zoom Javascript

```bash
 dashboardBody(
    tags$script(HTML("
      $(document).ready(function() {
        var map = $('#map').find('div.leaflet-container')[0];
        if (map) {
          var leafletMap = $(map).data('leaflet-map');
          leafletMap.on('zoomend', function() {
            Shiny.setInputValue('map_zoom', leafletMap.getZoom());
          });
        }
      });
    ")),
```
Diese Funktion überwacht die Zoomstufe der Karte. Wenn die Nutzer*innen herein- oder herauszoomen, wird die aktuelle Zoomstufe (``map_zoom``) an die Shiny-App zurückgemeldet, sodass darauf reagiert werden kann.

## Daten filtern im Server: filtered_data_map

```bash
filtered_data_map <- reactive({
  data <- df_merged_sum_distanz_umkreis_pump_ok_lor

  # 1. Nach Bezirk
  if (!is.null(input$map_bezirk) && !("Alle" %in% input$map_bezirk)) {
    data <- data %>% filter(bezirk %in% input$map_bezirk)
  }

  # 2. Nach LOR (Lebensweltlich orientierte Räume)
  if (!is.null(input$map_lor) && !("Alle" %in% input$map_lor)) {
    data <- data %>% filter(bzr_name %in% input$map_lor)
  }

  # 3. Nach Baumgattung
  if (!is.null(input$map_baumgattung) && !("Alle" %in% input$map_baumgattung)) {
    data <- data %>% filter(gattung_deutsch %in% input$map_baumgattung)
  }

  # 4. Nach Jahr
  if (!is.null(input$map_year) && !("2020-2024" %in% input$map_year)) {
    data$timestamp <- as.Date(data$timestamp)
    data <- data %>% filter(lubridate::year(timestamp) %in% as.numeric(input$map_year))
  }

  # 5. Nach Saison
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

  # 6. Nur mit Koordinaten
  data <- data %>% filter(!is.na(lat), !is.na(lng))
  data
  })
```
**Wichtige Begriffe erklärt:**
- ``reactive(...)``: erzeugt eine reaktive Funktion, die automatisch neu berechnet wird, wenn sich Eingaben ändern.
- NA-Werte (``NA``)
Steht für "Not Available" und bedeutet, dass ein Wert in den Daten fehlt oder unbekannt ist. Zum Beispiel, wenn für einen Baum die Koordinaten nicht bekannt sind.
  - ``is.na(x)`` prüft, ob x ein fehlender Wert ist.
  - ``!is.na(x)`` prüft, ob x nicht fehlt.
    ```bash
    filter(!is.na(lat), !is.na(lng))
    ```
    hier werden nur Datensätze berücksichtigt, bei denen sowohl lat (Breitengrad) als auch lng (Längengrad) vorhanden sind.
- ``filter(...)``: Filtert die Daten so, dass nur diejenigen Zeilen erhalten bleiben, die bestimmte Bedingungen erfüllen.
- ``%>%``  (Pipe-Operator)
Leitet das Ergebnis von links an die Funktion rechts weiter. Er sorgt für eine lesbare Verkettung von Operationen.

**Operatoren**
- ``%in%``: prüft, ob ein Wert in einer Liste enthalten ist.
  Zum Beispiel:
    ```bash
    bezirk %in% input$map_bezirk
    ```
- ``<-``: weist einer Variable einen Wert zu (z. B. ``x <- 3``).
- ``|`` = ODER, ``&`` = UND

```{admonition} Merke: 
:class: keypoint 

``reactive()`` ist wie ein **intelligenter Beobachter**: Er reagiert **automatisch** auf Eingaben und aktualisiert die Daten.
```
**if- und else-Anweisungen**
```bash
if (Bedingung) {
  # wird ausgeführt, wenn die Bedingung wahr ist
} else {
  # wird ausgeführt, wenn die Bedingung falsch ist
}
```

```{admonition} Merke: 
:class: keypoint 

Die Filter arbeiten unabhängig voneinander – so können beliebige Kombinationen gewählt werden.
```

```{admonition} Beispiel: 
:class: tip
Ein Filter „Bezirk: Friedrichshain-Kreuzberg“ + „Baumgattung: Ahorn“ ergibt nur Ahornbäume im gewählten Bezirk.
```

## Pumpen Icon hinzufügen

```bash
  icon_pumpe <- makeIcon(
    iconUrl = "icons/water-pump-icon-14.jpg",
    iconWidth = 15,
    iconHeight = 15
  )
```
**Wichtige Begriffe erklärt:**
- ``makeIcon``: Erstellt das Icon was man später nutzen kann
- ``iconUrl``: Gibt dem Pfad zum Pumpen Bild angibt
- ``iconWidth``: Gibt die Breite des Icons an
- ``iconHeight``: Gibt die Höhe des Icons an

## 6Karte zeichnen mit Leaflet

```bash
output$map <- renderLeaflet({
    data <- filtered_data_map()
    
    #  Farbpalette für Marker
    color_palette <- colorNumeric(
      palette = colorRampPalette(c("#FFA500", "#0000FF"))(100),
      domain = c(0, 2500),
      na.color = "#CCCCCC"
    )
    
    # Marker hinzufügen
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
      # Pumpenmaker
      addMarkers(
        data = pumpen_mit_bezirk,
        icon = icon_pumpe,
        group = "Pumpen"
      ) %>%
      addLayersControl(
        overlayGroups = c("Pumpen"),
        options = layersControlOptions(collapsed = FALSE)
      ) %>%
      #  Legende hinzufügen
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
```
- ``leaflet(...)``: Erstellt eine neue Leaflet-Karte mit den gefilterten Daten.
- ``filtered_data_map()`` enthält die gefilterten Baumdaten, die zuvor im reactive()-Block erstellt wurden.
- ``addTiles()``: Fügt die Hintergrundkarte hinzu (OpenStreetMap).
- ``addCircleMarkers(...)``: Zeichnet Punkte für jeden Baum:
- Zeichnet Kreise (Marker) für jeden Baum:
  - lng, lat: Die Koordinaten (Längengrad, Breitengrad)
  - radius = 4: Größe des Kreises
  - fillOpacity = 0.7: Durchsichtigkeit des Kreises
  - color = ...: Farbe hängt von der Bewässerungsmenge ab. Werte über 2500 werden abgeschnitten (pmin(...))
- popup = ...: Beim Anklicken erscheint ein Infofenster mit:
  - Baumart & Gattung
  - Standort (Straße + Hausnummer)
  - Gesamtbewässerung
  - Durchschnittliches Intervall in Tagen
- ``addMarkers``: Fügt Pumpen-Standorte als klassische Marker hinzu. Diese Marker gehören zur Gruppe "Pumpen", damit man sie ein- und ausblenden kann.
- Mit ``colorNumeric`` wird eine lineare Farblegende erzeugt. Je höher der Bewässerungswert, desto dunkler der Punkt.
- ``addLayersControl``: 
  - Fügt eine Kontrollleiste auf der Karte hinzu.
  - Nutzer*innen können die Gruppe "Pumpen" manuell ein- oder ausblenden.
  - collapsed = FALSE: Die Leiste ist standardmäßig ausgeklappt.
- Mit ``addLegend(...)`` wird eine Farblegende eingeblendet. Der Nutzer sieht, welche Farben welchen Bewässerungswerten entsprechen.
- ``hideGroup(...)``: 
  - Diese Zeile sorgt dafür, dass die Pumpen beim ersten Laden nicht sofort angezeigt werden.
  - Nutzer*innen können sie über die Ebenensteuerung bei Bedarf aktivieren.
- ``observe({...})``: Beobachtet laufend eine Eingabe – hier die Zoomstufe der Karte.
- ``input$map_zoom``: Die aktuelle Zoomstufe der Karte.
- ``req(...)``: Stellt sicher, dass ein gültiger Wert vorliegt.
- ``leafletProxy("map")``: Greift auf eine bestehende Karte zu, ohne sie neu zu laden.
- ``clearGroup("Pumpen")``: Löscht alle aktuellen Pumpen-Marker von der Karte.

Dann:

  - Wenn der Zoomwert ≥ 14 ist, werden die Pumpenmarker neu hinzugefügt.
  - Sonst bleibt die Karte ohne Pumpen.

**Warum ist das sinnvoll?**
Pumpenmarker sollen nur dann angezeigt werden, wenn man weit genug hineingezoomt hat. So bleibt die Karte bei niedriger Zoomstufe übersichtlich und schneller.

```{admonition} Merke: 
:class: keypoint 

Mit `leafletProxy()` kann man gezielt Inhalte einer bestehenden Karte ändern – z. B. Marker hinzufügen oder löschen – ohne dass die ganze Karte neu aufgebaut werden muss.
```

<details>
<summary><strong>Gesamter Code</strong></summary>

```r
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Karte", tabName = "map", icon = icon("map")),
    )
  ),
  dashboardBody(
    tags$script(HTML("
      $(document).ready(function() {
        var map = $('#map').find('div.leaflet-container')[0];
        if (map) {
          var leafletMap = $(map).data('leaflet-map');
          leafletMap.on('zoomend', function() {
            Shiny.setInputValue('map_zoom', leafletMap.getZoom());
          });
        }
      });
    ")),
    tabItems(
      tabItem(tabName = "map",
              fluidRow(
                box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    column(width = 6,
                           selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    ),
                    column(width = 6,
                           selectInput("map_lor", "Lebensweltlich orientierte Räume auswählen:", choices = c("Alle", unique(df_merged_sum_distanz_umkreis_pump_ok_lor$bzr_name)), selected = "Alle", multiple = TRUE)
                           ),
                    column(width = 6,
                           selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_merged_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
                    ),
                    column(width = 6,
                           selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE),
                    ),
                    column(width = 6,
                           selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df_merged_clean$gattung_deutsch)), selected = "Alle", multiple = TRUE)
                    ),
                )
              ),
              leafletOutput("map", height = "800px")
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


Server Code: 

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

}

```
</details>