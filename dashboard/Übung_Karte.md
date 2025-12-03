---
lang: de-DE
---

(map)=
# Eine Karte für das Dashboard erstellen
```{admonition} Story
:class: story
Nachdem Amir sein Dashboard eingerichtet und die wichtigsten Kennzahlen sichtbar gemacht hat, möchte er nun genauer verstehen, wo in Berlin besonders viel gegossen wird.
Die Plattform Gieß den Kiez zeigt ihm eindrucksvolle Karten, die Bezirke farblich nach bestimmten Kriterien hervorheben – das möchte Amir für seine Anwendung nachbauen.

Sein Ziel: Eine intuitive Karte, die sofort erkennen lässt, in welchen Bezirken viele Bäume gegossen wurden und wo eher weniger.
```

```{admonition} Zweck dieser Übung
:class: lernziele
- Das Erstellen einer Leaflet-Karte dient dazu, räumliche Informationen nutzbar zu machen, um Verwaltungsdaten visuell zugänglich und vergleichbar darzustellen. In dieser Übung lernen wir, wie Bezirksdaten mit statistischen Kennzahlen verknüpft und anschließend mithilfe einer Farbskala intuitiv interpretiert werden können. Die farbliche Hervorhebung des Anteils bewässerter Bäume ermöglicht es, Muster und regionale Unterschiede auf einen Blick zu erkennen und erste Antworten auf die Leitfrage zu gewinnen: In welchen Bezirken wird besonders viel gegossen?
```

Die **Bezirkskarte** bildet den nächsten zentralen Baustein in Amirs Dashboard. Nachdem die Startseite bereits erste Kennzahlen sichtbar macht, möchte Amir nun räumlich darstellen, **wo** in Berlin besonders viel gegossen wurde. Eine kartenbasierte Visualisierung eignet sich ideal, um regionale Muster zu erkennen, Hotspots sichtbar zu machen und Unterschiede zwischen den Bezirken intuitiv zu erfassen.

Für diese Aufgabe nutzt Amir das Paket **Leaflet**, das interaktive Karten direkt in R-Shiny erzeugt. Ergänzt wird Leaflet durch **sf** zur Verarbeitung der Bezirks-Geodaten sowie durch Funktionen wie ```colorNumeric()```, mit denen eine aussagekräftige Farbskala erzeugt wird. Die Karte verknüpft also zwei Datenquellen:
die **räumliche Geometrie** der Berliner Bezirke und die **berechneten Kennzahlen** aus seinem Datensatz – insbesondere die Anzahl der Bäume sowie den Anteil der bewässerten Bäume pro Bezirk.

![alt text](Dashboard_Startseite_2.png)
*Abbildung 2: zweiter Reiter des Dashboards - Karte (Quelle: eigene Ausarbeitung)*

Die Karte erfüllt mehrere Ziele gleichzeitig:

- Sie zeigt für **jeden Bezirk**, wie viele Bäume dort stehen und wie viele davon gegossen wurden.

- Durch die farbliche Schattierung lässt sich der **Anteil bewässerter Bäume** sofort erkennen – hohe Werte erscheinen dunkler.

- Ein **Tooltip** zeigt beim Überfahren eines Bezirks die genauen Zahlen und den exakten Prozentsatz, sodass die Nutzer:innen nicht nur visuell, sondern auch quantitativ informiert werden.

Damit beantwortet die Karte eine zentrale Leitfrage:
**In welchen Bezirken engagieren sich Bürger:innen besonders stark beim Gießen der Bäume – und wo weniger?**

Technisch nutzt Amir dafür ein Zusammenspiel aus:

- ```leaflet()``` – erstellt die interaktive Karte
- ```addPolygons()``` – zeichnet die Bezirksflächen
- ```colorNumeric()``` – berechnet die Farbskala
- ```left_join()``` – verbindet Geodaten mit Bezirkstatistiken
- **Tooltips (HTML)** – zeigen detaillierte Kennzahlen beim Hover
- **Legende** (```addLegend()```) – erklärt die Farbcodierung

Durch diese Kombination entsteht eine sowohl leicht verständliche als auch analytisch wertvolle Darstellung. Nutzer:innen können sofort erkennen, wie die Bewässerungsaktivität räumlich verteilt ist und welche Bezirke auffallen – im positiven oder negativen Sinne.

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
- ``box(...)`` ist ein Container mit:
    - ``title`` - Überschrift („Anteil bewässerter Bäume nach Bezirk“)
    - ``status = "primary"`` – Farbe des Box-Headers
    - ``solidHeader = TRUE`` – durchgezogene Kopfzeile
    - ``width = 12`` – Box nimmt die volle Seitenbreite ein (12 = max. Spaltenzahl)
- ``fluidRow(...)`` sorgt für eine horizontale Anordnung (z. B. nebeneinander statt untereinander).
- ``multiple = TRUE`` bedeutet, dass man mehrere Optionen gleichzeitig auswählen kann.

```{admonition} Merke: 
:class: keypoint 

``fluidRow()`` ordnet Inhalte nebeneinander. ``box(...)`` gruppiert UI-Elemente visuell und funktional.
```

## Zoom Javascript

```bash
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


## 6Karte zeichnen mit Leaflet

```bash
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


```{admonition} Merke: 
:class: keypoint 

Leaflet kombiniert Geodaten (hier: Bezirks-Polygone) mit dynamischen Werten.
Mit Farbskalen wie colorNumeric() können Bezirke automatisch nach Kennzahlen eingefärbt werden.
```

Durch die Bezirkskarte erhält Amir erstmals einen **räumlichen Überblick** darüber, in welchen Berliner Bezirken besonders viele Bäume gegossen wurden. Die Visualisierung zeigt deutlich, dass **Friedrichshain-Kreuzberg** den höchsten Anteil bewässerter Bäume aufweist, dicht gefolgt von **Mitte**. Damit beantwortet die Karte bereits einen wichtigen Teil der Leitfrage:
**Wo engagieren sich Bürger:innen besonders häufig beim Gießen der Straßenbäume?**

Allerdings wird Amir bewusst, dass diese Darstellung nur einen Teil der Realität zeigt. Die Karte unterscheidet zwar zwischen *bewässert* und *nicht bewässert*, doch sie berücksichtigt nicht, **wie viel Wasser** tatsächlich in den Bezirken geflossen ist. Ein Baum, der einmal mit 5 Litern begossen wurde, gilt genauso als „bewässert“ wie ein Baum, der über Wochen hinweg hunderte Liter erhalten hat – und genau dieser Unterschied ist für eine belastbare Bewertung des Gießverhaltens entscheidend.

Daher führt Amir die Analyse im nächsten Schritt weiter und widmet sich einer differenzierteren Betrachtung:
**Wie viele Liter wurden tatsächlich pro Bezirk gegossen – absolut und im Verhältnis zur Gesamtzahl der Bäume?**

Diese „Bewässerungsanalyse“ bildet die Grundlage der dritten Übung. Sie ermöglicht es, nicht nur die Häufigkeit, sondern auch die **Intensität des Gießens** zu messen und damit ein vollständigeres Bild des Engagements der Bürger:innen zu erhalten.