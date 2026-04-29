---
lang: de-DE
---

(map)=
# Eine Karte erstellen
```{admonition} Story
:class: story
Nachdem Amir sein Dashboard mit Ihrer Unterstützung einrichten lassen und die wichtigsten Kennzahlen sichtbar machen lassen hat, möchte er nun genauer verstehen, wo in Berlin besonders viel gegossen wird.
Die Plattform [Gieß den Kiez](https://www.giessdenkiez.de/map?treeAgeMax=200&lang=de&lat=52.494590307846366&lng=13.388836926491992) zeigt ihm eindrucksvolle Karten, die Bezirke farblich nach bestimmten Kriterien hervorheben – das möchte Amir für seine Anwendung nachbauen lassen.

Sein Ziel: Eine intuitive Karte von Berlin, die sofort erkennen lässt, in welchen Bezirken viele Bäume gegossen wurden und wo eher weniger.
```

```{admonition} Zweck dieser Übung
:class: lernziele
Das Erstellen einer [Leaflet-Karte](https://de.wikipedia.org/wiki/Leaflet) dient dazu, räumliche Informationen nutzbar zu machen, um Verwaltungsdaten visuell zugänglich und vergleichbar darzustellen. In dieser Übung lernen Sie, wie Bezirksdaten mit statistischen Kennzahlen verknüpft und anschließend mithilfe einer Farbskala intuitiv interpretiert werden können. Die farbliche Hervorhebung des Anteils bewässerter Bäume ermöglicht es, Muster und regionale Unterschiede auf einen Blick zu erkennen und zusätzliche Antworten auf die Leitfrage zu gewinnen: In welchen Bezirken wird besonders viel gegossen?
```

Das Dashboard soll um eine **Bezirkskarte** erweitert werden. Nachdem die Startseite bereits erste Kennzahlen sichtbar macht, werden Sie nun räumlich darstellen, **wo** in Berlin besonders viel gegossen wurde. Eine kartenbasierte Visualisierung eignet sich ideal, um regionale Muster zu erkennen, Hotspots sichtbar zu machen und Unterschiede zwischen den Bezirken intuitiv zu erfassen.

Für diese Aufgabe nutzen Sie das Paket **Leaflet**, das interaktive Karten direkt in R-Shiny erzeugt. Ergänzt wird Leaflet durch **sf** zur Verarbeitung der Bezirks-Geodaten sowie durch Funktionen wie ```colorNumeric()```, mit denen eine aussagekräftige Farbskala erzeugt wird. Die Karte verknüpft also zwei Datenquellen:
die **räumliche Geometrie** der Berliner Bezirke und die **berechneten Kennzahlen** aus seinem Datensatz – insbesondere die Anzahl der Bäume sowie den Anteil der bewässerten Bäume pro Bezirk.

```{figure} ../assets/Dashboard_Karte.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
width: 450px
---
zweiter Reiter des Dashboards - Karte; Die Abbildung zeigt eine Karte aller Berliner Bezirke. Die Farbsättigung eines Bezirks entspricht dem prozentualen Anteil der gegossenen Bäume an der Gesamtzahl der Bäume im jeweiligen Bezirk. Die genaue Zuordnung der Farbskala ist in der Legende erläutert.  (Quelle: eigene Ausarbeitung)
``` 

```{admonition} Die Karte erfüllt mehrere Ziele gleichzeitig:
:class: lernziele

- Sie zeigt für **jeden Bezirk**, wie viele Bäume dort stehen und wie viele davon gegossen wurden.

- Durch die farbliche Schattierung lässt sich der **Anteil bewässerter Bäume** sofort erkennen – hohe Werte erscheinen dunkler.

- Ein **Tooltip** zeigt beim Überfahren eines Bezirks die genauen Zahlen und den exakten Prozentsatz, sodass die Nutzer:innen nicht nur visuell, sondern auch quantitativ informiert werden.
```

Durch die Visualisierung können Sie ebenso die zentrale Leitfrage beantworten:
**Wie stark engagieren sich die Berliner:innen für die Bäume in ihrer Stadt – und in welchen Bezirken ist dieses Engagement am höchsten?**  <span style="color: red;">Können wir diese Fragen wirklich beantworten? Wir haben zwar gute Baumkatasterdaten, aber das Engagement nur über die Messungen von Gieß den Kiez gegeben, was eine geringer Userbase hat. Dazu gibt es bestimmt auch Menschen, die gießen ohne das einzutragen (durch Unwissenheit, mangelndem Interesse oder bewusster Ablehnung). Für die FS ist das Beispiel sicherlich dennoch geeignet, allerdings sollten wir diese Gedanken eventuell erwähnen.</span>

Eine **Choroplethenkarte** ist eine thematische Karte, bei der Flächen entsprechend statistischer Werte eingefärbt werden – in diesem Fall nach dem prozentualen Anteil gegossener Bäume pro Bezirk. Der entscheidende Mehrwert dieser Darstellungsform liegt in der simultanen räumlichen Vergleichbarkeit: man erfasst auf einen Blick, welche Bezirke gut versorgt sind und wo Handlungsbedarf besteht, ohne zwischen verschiedenen Ansichten wechseln zu müssen. Die geografische Anordnung ermöglicht es zudem, räumliche Muster zu erkennen – etwa ob zentrale Bezirke anders versorgt werden als Randbezirke, oder ob benachbarte Gebiete ähnliche Bewässerungsquoten aufweisen. Dunkle Schattierungen signalisieren hohe Bewässerungsraten, helle Bereiche weisen auf niedrigere Werte hin. Die Karte vereint explorative Analyse mit detaillierter Datenabfrage und macht räumliche Zusammenhänge zugänglich.

Technisch nutzen Sie dafür ein Zusammenspiel aus:

- ```leaflet()``` – erstellt die interaktive Karte
- ```addPolygons()``` – zeichnet die Bezirksflächen
- ```colorNumeric()``` – berechnet die Farbskala
- ```left_join()``` – verbindet Geodaten mit Bezirkstatistiken
- **Tooltips (HTML)** – zeigen detaillierte Kennzahlen beim Hover
- **Legende** (```addLegend()```) – erklärt die Farbcodierung

Durch diese Kombination entsteht eine sowohl leicht verständliche als auch analytisch wertvolle Darstellung. Nutzer:innen können sofort erkennen, wie die Bewässerungsaktivität räumlich verteilt ist und welche Bezirke auffallen – im positiven oder negativen Sinne.

## Benutzeroberfläche (UI)

Da Sie die Grundstruktur der Benutzeroberfläche bereits in der vorherigen Übung aufgebaut haben, erweitert Sie diese nun lediglich um die Elemente für die Karte. Sie ergänzen:  
- die **Seitenleiste** (`sidebarMenu`) um einen neuen Navigationspunkt für die Karte.
- den **Inhaltsbereich** (`tabItems`) um ein neues `tabItem`, in dem die Karte dargestellt wird.

````{dropdown} Navigation in der Seitenleiste
```r
dashboardSidebar(
  sidebarMenu(
    menuItem("Startseite", tabName = "start", icon = icon("home")),
    # NEU: Menüpunkt für die Karte hinzufügen
    menuItem("Karte", tabName = "map", icon = icon("map"))
  )
)
```
Wie bereits von der Startseite bekannt, erzeugt `menuItem(...)` einen neuen Eintrag in der Seitenleiste. Durch `tabName = "map"` verknüpfen Sie diesen mit dem noch zu erstellenden Inhaltsbereich.
````

### Inhaltsbereich: Karte mit Filter-Boxen

Idealerweise stellen Sie die Leaflet-Karte zentral dar, sodass diese sofort ins Auge fällt. Die Karte soll nicht nur schön aussehen, sondern auf einen Blick zeigen, wo in Berlin besonders viel gegossen wird. Darunter sollen Filter es ermöglichen, die Ansicht auf bestimmte Bezirke oder Zeiträume einzugrenzen.

````{dropdown} Code
```r
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
      )
```
````
````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- ``box(...)`` ist ein Container mit:
    - ``title`` - Überschrift („Anteil bewässerter Bäume nach Bezirk“)
    - ``status = "primary"`` – Farbe des Box-Headers
    - ``solidHeader = TRUE`` – durchgezogene Kopfzeile
    - ``width = 12`` – Box nimmt die volle Seitenbreite ein (12 = max. Spaltenzahl)
- ``fluidRow(...)`` sorgt für eine horizontale Anordnung (z. B. nebeneinander statt untereinander).
- ``multiple = TRUE`` bedeutet, dass man mehrere Optionen gleichzeitig auswählen kann.
 
``fluidRow()`` ordnet Inhalte nebeneinander. ``box(...)`` gruppiert UI-Elemente visuell und funktional.

````


## Server

### Bewässerungsstatistik pro Bezirk berechnen

Bevor die Karte gezeichnet werden kann, müssen Sie für jeden Berliner Bezirk die relevanten Kennzahlen berechnen: Wie viele Bäume stehen dort insgesamt? Wie viele davon wurden gegossen? Und welcher Anteil wurde bewässert?

````{dropdown} Code
```r
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
```
````
````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- `reactive({...})` – erzeugt eine reaktive Funktion, die automatisch neu berechnet wird, wenn sich die Eingaben ändern
- `group_by(bezirk)` – gruppiert alle Bäume nach Bezirk
- `n_distinct(gisid)` – zählt die eindeutigen Baum-IDs (jeder Baum wird nur einmal gezählt)
- `n_distinct(gisid[!is.na(timestamp)])` – zählt nur Bäume, die mindestens einmal gegossen wurden (erkennbar am Zeitstempel)
- `pct_watered` – berechnet den prozentualen Anteil bewässerter Bäume pro Bezirk
- `ungroup()` – löst die Gruppierung auf

Diese reaktive Funktion wird später im `renderLeaflet`-Block aufgerufen, um die Karte mit aktuellen Daten zu befüllen.
````

### Karte zeichnen mit Leaflet
Jetzt entsteht die eigentliche Karte. Jeder Berliner Bezirk gestalten Sie farblich: Dunklere Farben zeigen hohes Engagement, hellere Bereiche niedrigere Bewässerungsraten. Beim Überfahren mit der Maus erscheinen die genauen Zahlen – wie viele Bäume es gibt, wie viele gegossen wurden und der prozentuale Anteil.

<span style="color: red;">Ich würde den folgenden Codeblock wegen seiner Größe aufteilen oder inline kommentieren</span>

````{dropdown} Code
```r
  output$map <- renderLeaflet({
    data_stats <- data_by_bezirk()
    
    map_data <- berlin_bezirke_sf %>%
      left_join(data_stats, by = "bezirk") %>%
      mutate(
        n_total = replace_na(n_total, 0),
        n_watered = replace_na(n_watered, 0),
        pct_watered = replace_na(pct_watered, 0)
      )
    
    pal <- colorNumeric(
      palette = "Blues",
      domain = map_data$pct_watered,
      na.color = "transparent"
    )
    
    leaflet(map_data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(pct_watered),
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
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~pct_watered,
        title = "Anteil bewässerter Bäume (%)",
        opacity = 1
      )
  })
```
````
````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- ``renderLeaflet({...})``: Erzeugt eine Leaflet-Karte, die dynamisch auf Eingaben reagieren kann.
- ``data_stats <- data_by_bezirk()``: Holt aggregierte Statistiken pro Bezirk (z. B. Anzahl Bäume, Anteil bewässert).
- ``left_join(...)``: Verknüpft die Berliner Bezirks-Polygone (``berlin_bezirke_sf``) mit deinen Statistikdaten.
- ``mutate(...)`` + ``replace_na(...)``: Stellt sicher, dass fehlende Werte (``NA``) durch 0 ersetzt werden, damit später keine Fehlfarben entstehen.
- ``colorNumeric(...)``: Erstellt eine Farbskala („Blues“), die zur Einfärbung der Bezirke verwendet wird. Höherer Anteil bewässerter Bäume = dunklere Farbe.
- ``leaflet(map_data)``: Startet eine Leaflet-Karte mit den verknüpften Bezirksdaten.
- ``addProviderTiles(providers$CartoDB.Positron)``: Fügt eine helle, übersichtliche Hintergrundkarte hinzu.
- ``addPolygons(...)``: Zeichnet die Bezirksgrenzen.
- Wichtige Parameter:
  - ``fillColor = ~pal(pct_watered)`` → Färbt Bezirke je nach Anteil bewässerter Bäume
  - ``weight``/``color`` → Rahmelinien
  - ``highlightoptions`` → Bezirk hebt sich beim Überfahren mit der Maus hervor
  - ``label`` → Tooltip mit HTML-Formatierung
    Enthält:
    - Bezirksname
    - Gesamtzahl der Bäume
    - Anzahl bewässerter Bäume
    - Anteil in Prozent
  - ``addLegend(...)``  →  Fügt unten rechts eine Farblegende ein, die zeigt, welcher Blauton welchem Prozentwert entspricht.
 
Leaflet kombiniert Geodaten (hier: Bezirks-Polygone) mit dynamischen Werten.
Mit Farbskalen wie colorNumeric() können Bezirke automatisch nach Kennzahlen eingefärbt werden.

````

Durch die Bezirkskarte erhalten Sie erstmals einen **räumlichen Überblick** darüber, in welchen Berliner Bezirken besonders viele Bäume gegossen wurden. Die Visualisierung zeigt deutlich, dass **Friedrichshain-Kreuzberg** den höchsten Anteil bewässerter Bäume aufweist, dicht gefolgt von **Mitte**. Damit beantwortet die Karte bereits einen wichtigen Teil der Leitfrage:
**Wo engagieren sich Bürger:innen besonders häufig beim Gießen der Straßenbäume?**

Seien Sie sich jedoch bewusst, dass diese Darstellung nur einen Teil der Realität zeigt. Die Karte unterscheidet zwar zwischen *bewässert* und *nicht bewässert*, doch sie berücksichtigt nicht, **wie viel Wasser** tatsächlich in den Bezirken geflossen ist. Ein Baum, der einmal mit 5 Litern begossen wurde, gilt genauso als „bewässert“ wie ein Baum, der über Wochen hinweg hunderte Liter erhalten hat – und genau dieser Unterschied ist für eine belastbare Bewertung des Gießverhaltens entscheidend.

Daher führen Sie die Analyse im nächsten Schritt weiter und widmen sich einer differenzierteren Betrachtung:
**Wie viele Liter wurden tatsächlich pro Bezirk gegossen – absolut und im Verhältnis zur Gesamtzahl der Bäume?**

Diese „Bewässerungsanalyse“ bildet die Grundlage der dritten Übung. Sie ermöglicht es, nicht nur die Häufigkeit, sondern auch die **Intensität des Gießens** zu messen und damit ein vollständigeres Bild des Engagements der Bürger:innen zu erhalten.


````{admonition} Gesamter Code für diesen Schritt
:class: solution, dropdown

```r
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      # NEU: Navigation für die Karte
      menuItem("Karte", tabName = "map", icon = icon("map"))
    )
  ),
  dashboardBody(
    tabItems(
      # ... Code aus der Startseite (tabItem für "start") ...
      
      # NEU: Inhaltsbereich für die Karte
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
      )
    )
  )
)

# Server-Logik
server <- function(input, output, session) {
  
  # ... Code aus der Startseite (Hilfsfunktionen, filteredData, ValueBoxes) ...
  
  # NEU: Reaktive Datenberechnung: Bewässerungsstatistik pro Bezirk
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

  # NEU: Rendering der Leaflet-Karte
  output$map <- renderLeaflet({
    data_stats <- data_by_bezirk()
    
    map_data <- berlin_bezirke_sf %>%
      left_join(data_stats, by = "bezirk") %>%
      mutate(
        n_total = replace_na(n_total, 0),
        n_watered = replace_na(n_watered, 0),
        pct_watered = replace_na(pct_watered, 0)
      )
    
    pal <- colorNumeric(
      palette = "Blues",
      domain = map_data$pct_watered,
      na.color = "transparent"
    )
    
    leaflet(map_data) %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        fillColor = ~pal(pct_watered),
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
      addLegend(
        position = "bottomright",
        pal = pal,
        values = ~pct_watered,
        title = "Anteil bewässerter Bäume (%)",
        opacity = 1
      )
  })
}

shinyApp(ui = ui, server = server)
```
````

