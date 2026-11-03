---
lang: de-DE
---

(watering)=
# Eine Bewässerungsanalyse einfügen
```{admonition} Story
:class: story

Nachdem Amir mithilfe der Bezirkskarte herausgefunden hat, in welchen Teilen Berlins besonders viele Bäume gegossen wurden, stellt er fest: Die Bürger:innen eines Bezirks können viele verschiedene Bäumen gegossen haben, aber jedem nur einen Schluck Wasser gegeben haben.
In einem anderen Bezirk haben die Bürger:innen vielleicht jeweils nur den Baum vor ihrem Haus gegossen, aber dafür eine ganze Gießkanne pro Baum herangeschleppt. Dann haben sie einen höheren Aufwand pro Baum betrieben. Zählt das nicht viel mehr?
```

```{admonition} Zweck dieser Übung
:class: lernziele

Während zuvor die Zahl der gegossenen Bäume im Mittelpunkt stand, visualisieren Sie nun die Bewässerungsmenge in Litern.
Ziel ist es, Bezirke hinsichtlich ihrer gesamten Bewässerungsleistung oder der durchschnittlichen Wassermenge pro Baum zu vergleichen. Sie lernen, wie Daten aggregiert, umgerechnet und visualisiert werden können.
Dadurch wird deutlich, dass die Auswahl der Messgröß (die Operationalisierung) zu verschiedenen analytischen Ergebnissen führen kann: Ein Bezirk, der bei der Anzahl gegossener Bäume gut abschneidet, liegt bei der Wassermenge möglicherweise nicht vorne (und umgekehrt).

```

Um die Unterschiede sichtbar zu machen, führen Sie eine umfassendere Analyse der Bewässerungsmenge durch:

- Wie viel Wasser wurde insgesamt pro Bezirk ausgebracht?
- Wie viel Wasser erhielt ein durchschnittlich gegossener Baum?
- Und verändert sich dadurch das Ranking der Bezirke?

So helfen Sie Amir zu verstehen, wie sich die Wahl der Operationalisierung, also „gezählte Bäume“ vs. „gegossene Liter“, auf die Ergebnisse auswirkt. Die Frage lautet:
Welche Geschichte erzählen die Daten, wenn man Liter statt Baumanzahl betrachtet?

````{margin}
```{admonition} Dashboard erkunden
:class: hinweis

Das fertige Dashboard können Sie hier direkt im Browser erkunden, während Sie die 
folgenden Abschnitte durcharbeiten:  
<a href="https://quadriga-dk.github.io/Visualisierung_in_der_Verwaltung/" target="_blank" class="external-link">Dashboard öffnen</a>
```
````

```{figure} ../assets/Dashboard_Bewässerungsanalyse_1.png
---
name: Bewässerung pro Bezirk
alt: Balkendiagramm Gesamte Bewässerungsmenge pro Bezirk
width: 600px
---
Balkendiagramm zur Bewässerung pro Bezirk (hier 2020 bis 03/2026). Die Abbildung zeigt die aggregierte Bewässerungsmenge in Millionen Litern für die einzelnen Berliner Bezirke. Auf der x-Achse sind die Bezirke dargestellt, während die y-Achse die gesamte Bewässerungsmenge angibt. Das Diagramm ermöglicht einen direkten Vergleich der Bewässerungsintensität zwischen den Bezirken. (Quelle: eigene Ausarbeitung)
```

```{figure} ../assets/Dashboard_Bewässerungsanalyse_2.png
---
name: Durchschnittliche Bewässerung pro gegossenem Baum
alt: Baumdiagramm entsprechend dem Titel nach Bezirk
width: 600px
---
Durchschnittliche Bewässerungsmenge pro gegossenem Baum nach Bezirk (hier 2020 bis 03/2026). Die Abbildung zeigt die durchschnittliche Bewässerungsmenge pro gegossenem Baum in Litern für die einzelnen Berliner Bezirke. Auf der x-Achse sind die Bezirke dargestellt, während die y-Achse die durchschnittliche Bewässerungsmenge pro Baum angibt. Das Balkendiagramm verdeutlicht Unterschiede in der Bewässerungsintensität zwischen den Bezirken. (Quelle: eigene Ausarbeitung)
``` 

## Benutzeroberfläche (UI)

Zunächst fügen Sie einen weiteren Menüpunkt zur Navigation hinzu, um den Bewässerungsanalyse-Tab zugänglich zu machen.

````{dropdown} Navigation in der Seitenleiste
```r
dashboardSidebar(
  sidebarMenu( id = "sidebarMenu",
    menuItem("Startseite", tabName = "start", icon = icon("home")),
    menuItem("Karte", tabName = "map", icon = icon("map")),
    # NEU: Menüpunkt für die Bewässerungsanalyse hinzufügen
    menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
  )
)
```
````

### Inhaltsbereich: Diagramme

Der Inhaltsbereich enthält die Diagramme. Da die Tabellen hier fest vorgegeben sind (für ganz Berlin vergleichend), benötigen Sie für diese Seite keine Filter-Dropdowns.

````{dropdown} Code
```r
tabItem(
  tabName = "analysis",
  fluidRow(
    box(
      title = tagList(
        "Bewässerung pro Bezirk",
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
```
````

````{admonition} Erklärung der Elemente
:class: hinweis, dropdown

- `tagList(...)`: Wird genutzt, um mehrere UI-Elemente im Titel der Box zu kombinieren – hier der Titeltext und der Informations-Button. So kann der Info-Button elegant im Titelbereich platziert werden.

- `actionButton`: Erstellt einen klickbaren Button. Dieser Button wird später dazu genutzt, **kontextbezogene Erklärungen oder Hilfetexte** zu öffnen (z. B. via `observeEvent()` + `showModal()`). Der Button hat die ID `"info_btn_hbpb"` und wird später verwendet, um eine Erklärung zur Grafik anzuzeigen. Gleiches gilt für `"info_btn_hbpb2"`.

- `plotOutput(...)`: Platzhalter für ein Diagramm, das im Server-Teil gerendert wird.
  - `hist_bewaesserung_pro_bezirk` zeigt die **Gesamtwassermenge pro Bezirk**.
  - `hist_bewaesserung_pro_baum` zeigt die **durchschnittliche Wassermenge pro gegossenem Baum**.

````

## Server


### Einheiten clever umrechnen

Bei der Darstellung von Wassermengen stehen Sie vor einer Herausforderung: Die Rohdaten enthalten Literangaben, die je nach Größenordnung unterschiedlich formatiert werden sollten. Eine Menge von 50 Litern ist überschaubar, aber 1.250.000 Liter sind schwer zu erfassen. 

Von Vorteil wäre es, wenn das Dashboard automatisch in sinnvolle Einheiten umrechnet, wie etwa Kubikmeter (m³) oder Megaliter (ML). Um dies zu erreichen, erstellen Sie zunächst Hilfsfunktionen für die Umrechnung und wenden diese anschließend direkt auf Ihren aggregierten Datensatz an.

````{dropdown} Code
```r
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
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**`convert_units(liters)`** nimmt eine Literzahl entgegen und wählt anhand ihrer Größe eine Einheit:  
  - `if (liters >= 1e6)` – 1.000.000 Liter oder mehr werden zu Megaliter (ML).
  - `else if (liters >= 1e3)` – 1.000 Liter oder mehr werden zu Kubikmeter (m³).
  - `else` – Kleinere Mengen bleiben Liter (L).

Die Funktion gibt eine Liste mit zwei Angaben zurück: dem gerundeten Zahlenwert (`value`) und der zugehörigen Einheit (`unit`).

- **`full_unit(unit)`**: 
  Wandelt Kurzformen (wie `"ML"`) mithilfe von `switch()` in ausgeschriebene Bezeichnungen (`"Mega Liter"`) um, falls dies für Tooltips oder Textanzeigen gebraucht wird.

**Warum ist das wichtig?**  
Große Zahlen wie „2.500.000 L“ sind im Dashboard auf einen Blick schwer erfassbar. Durch die Umrechnung wird daraus ein kompaktes und leicht lesbares „2,5 ML“.
````

### Berechnung der Bewässerung

Im ersten Diagramm wird die gesamte Bewässerungsmenge pro Bezirk berechnet. Dafür verwendet der Code den Datensatz `df_merged`, den Sie zu Beginn der Dashboard-Vorbereitung in [Kapitel 4.3](daten-laden) geladen haben. Anschließend fasst der Code die Wassermengen für jeden Bezirk zusammen.

````{dropdown} Code
```r
  # Plot: Bewässerung pro Bezirk
  output$hist_bewaesserung_pro_bezirk <- renderPlot({
    req(input$sidebarMenu == "analysis")
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
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

:class: hinweis, dropdown

**1. Daten nach Bezirk zusammenfassen**

- `req(input$sidebarMenu == "analysis")` – der Plot wird nur berechnet, wenn der Tab „Bewässerungsanalyse“ aktiv ist.
- `filter(!is.na(bezirk))` – entfernt Zeilen ohne Bezirksangabe.
- `group_by(bezirk)` – ordnet die Zeilen nach Bezirk zu Gruppen.
- `summarise(total_water = sum(...))` – addiert die Wassermengen jeder Gruppe und speichert die Summe in `total_water`.
- `ungroup()` – hebt die Gruppierung auf.
- `arrange(desc(total_water))` – sortiert die Bezirke nach Gesamtwassermenge, von groß nach klein.

Nach `summarise()` enthält `df_agg` eine Zeile pro Bezirk. Für dieses Diagramm hat die Tabelle zunächst zwei Spalten: `bezirk` und `total_water`.

**Vereinfachtes Beispiel** (die Zahlen dienen nur der Erklärung):

Auszug aus `df_merged`:

| `bezirk` | `bewaesserungsmenge_in_liter` |
|---|---:|
| Mitte | 10 |
| Mitte | 5 |
| Pankow | 20 |
| Mitte | 3 |

Nach dem Filtern und Zusammenfassen:

| `bezirk` | `total_water` |
|---|---:|
| Pankow | 20 |
| Mitte | 18 |

Die drei Zeilen für Mitte werden also zu einer Zeile mit der Summe 18. Die Zeile ohne Bezirksangabe wird vorher entfernt.

**2. Umrechnung mit `mutate()`**

Anschließend ergänzt `mutate()` weitere Spalten, ohne die Bezirke zu neuen Gruppen zusammenzufassen oder Zeilen zu entfernen:

- `purrr::map(total_water, convert_units)` wendet `convert_units()` auf jeden Wert in `total_water` an. Das Ergebnis wird in `converted` gespeichert. Diese Spalte enthält pro Zeile eine Liste mit `value` und `unit`.
- `sapply(converted, `[[`, "value")` liest den Zahlenwert aus jeder Liste aus und speichert ihn in `value`.
- `sapply(converted, `[[`, "unit")` liest die Einheit aus und speichert sie in `unit`.

Damit enthält `df_agg` nun zusätzlich die Spalten `converted`, `value` und `unit`. `value` wird später für die Balkenhöhe verwendet; `unit` wird für die Beschriftung der y-Achse benötigt.

| `bezirk` | `total_water` (Liter) | `converted` | `value` | `unit` |
|:---|---:|:---|---:|:---|
| Mitte | 2.500.000 | `list(value = 2.5, unit = "ML")` | 2,5 | ML |
| Pankow | 12.000 | `list(value = 12, unit = "m³")` | 12 | m³ |

*Die Bezirksnamen und Zahlen sind nur Beispiele zur Erklärung und keine tatsächlichen Ergebnisse aus dem Datensatz.*
````

### Balkendiagramm erstellen

Mit den aggregierten und umgerechneten Daten erstellt Amir nun das Balkendiagramm.

````{dropdown} Code
```r
    # Create plot
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

  # Info button observer
  observeEvent(input$info_btn_hbpb, {
    showModal(modalDialog(
      title = "Information: Bewässerung pro Bezirk",
      HTML("
      <p>Diese Grafik zeigt die <strong>gesamte Bewässerungsmenge</strong> für jeden Berliner Bezirk.</p>
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

```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Balkendiagramm aufbauen:**

- `reorder(bezirk, -value)` – sortiert Bezirke absteigend nach Wassermenge
- `y = value` – die umgerechnete Wassermenge auf der y-Achse
- `fill = bezirk` – jeder Bezirk erhält eine eigene Farbe
- `stat = "identity"` – die Balkenhöhe entspricht direkt dem Wert
- `color = "white", alpha = 0.7` – weiße Umrandung und leichte Transparenz für bessere Lesbarkeit
- `width = 0.8` – schmalere Balken für übersichtlichere Darstellung

**Achsenbeschriftung:**

- `title = NULL` – kein Titel, da dieser bereits in der Box steht
- `x = "Bezirke in Berlin"` – Beschriftung der x-Achse
- `y = paste0(...)` – dynamische y-Achsenbeschriftung mit der passenden Einheit (automatisch ML, m³ oder L)

**Design:**

- `theme_light()` – helles, sauberes Layout
- `legend.position = "none"` – keine Legende notwendig
- `axis.text.x = element_text(angle = 55, ...)` – Bezirksnamen schräg gestellt, um Überlappungen zu vermeiden
- `panel.grid.major.x = element_blank()` – vertikale Gitterlinien entfernt für klareres Bild
- `plot.margin = margin(10, 10, 10, 10)` – ausreichend Abstand, damit Beschriftungen nicht abgeschnitten werden
````


### Durchschnittliche Bewässerung pro Baum

Das zweite Diagramm zeigt eine andere Perspektive: Statt der Gesamtmenge wird hier berechnet, wie viel Wasser durchschnittlich auf jeden gegossenen Baum kam. Das hilft zu verstehen, ob in einem Bezirk besonders intensiv oder eher oberflächlich gegossen wurde.

````{dropdown} Code
```r
  # Plot: Durchschnittliche Bewässerung pro gegossenem Baum
  output$hist_bewaesserung_pro_baum <- renderPlot({
    req(input$sidebarMenu == "analysis")
    
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

  # Info button observer
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
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

Auch in diesem `renderPlot()`-Block wird `df_agg` neu aus `df_merged` erstellt. Es handelt sich also nicht um die Tabelle aus dem ersten Diagramm.

**Berechnung der Kennzahl:**

- `total_water = sum(...)` – addiert die Wassermengen pro Bezirk.
- `trees_watered = n_distinct(gml_id)` – zählt die unterschiedlichen Werte in der Spalte `gml_id` pro Bezirk.
- `mutate(water_per_tree = total_water / trees_watered)` – teilt die Gesamtwassermenge durch diese Anzahl und speichert das Ergebnis in `water_per_tree`.

**Vereinfachtes Beispiel** (die Zahlen dienen nur der Erklärung):

| `bezirk` | `total_water` (Liter) | `trees_watered` | `water_per_tree` (Liter) |
|:---|---:|---:|---:|
| Mitte | 12.000 | 4 | 3.000 |
| Pankow | 5.000 | 10 | 500 |

**Einheitenumrechnung:**

- Auch hier wird `convert_units()` angewendet, um die Werte in passende Einheiten umzurechnen
- Die y-Achse zeigt dynamisch "Durchschnittliche Bewässerung pro Baum" mit der automatisch gewählten Einheit

**Interpretation:**

Diese Kennzahl zeigt, wie intensiv die Bäume gegossen wurden. Ein Bezirk mit hoher Gesamtmenge kann eine niedrige Durchschnittsmenge pro Baum haben, wenn dort sehr viele Bäume nur leicht gegossen wurden. Umgekehrt kann ein Bezirk mit weniger Gesamtmenge eine hohe Durchschnittsmenge aufweisen, wenn dort wenige Bäume besonders intensiv versorgt wurden.
````

## Kritische Schlussfolgerung
Die Visualisierungen zeigen anschaulich, wie deutlich sich die Ergebnisse und folglich die Beantwortung der Leitfrage durch eine veränderte Operationalisierung verschieben können:

Bei der **Gesamtbewässerungsmenge** liegen nun **Mitte**, **Charlottenburg-Wilmersdorf** und **Tempelhof-Schöneberg** an der Spitze. Das deutet darauf hin, dass in diesen Bezirken besonders große Wassermengen eingesetzt wurden, sei es aufgrund vieler gegossener Bäume, hohem individuellem Einsatz oder besonderen lokalen Bedingungen.

Betrachtet man jedoch die **durchschnittliche Bewässerungsmenge pro Baum**, verschiebt sich das Bild: Hier tritt **Friedrichshain-Kreuzberg** am weitesten hervor.

**Das zeigt klar**:
Die Wahl der Messgröße, also „Wie viel Wasser insgesamt?“ vs. „Wie viel Wasser pro Baum?“, beeinflusst die Interpretation des Engagements wesentlich. Unterschiedliche Kennzahlen können *unterschiedliche Geschichten* erzählen, auch wenn sie auf denselben Rohdaten basieren.

Damit wird ein zentrales analytisches Prinzip deutlich:
**Daten sind nicht neutral. Die Art ihrer Aufbereitung formt das Narrativ.**

Ergänzend zu der Leitfrage soll nun eine vertiefte Betrachtung der zugrunde liegenden Dynamiken und Kontextfaktoren erfolgen. Welche **Kontextfaktoren** könnten zu den Unterschieden geführt haben?

- **Zeitlich** – etwa durch Veränderungen des Engagements im Jahresverlauf oder durch das Alter der Bäume (Kapitel 5.5)
- **Räumlich** – beispielsweise durch Unterschiede in der Baumdichte eines Gebiets (Kapitel 5.6)

````{admonition} Daraus ergeben sich neue Fragen:
:class: frage-feedback

- Welche zusätzlichen Datensätze lassen sich einbeziehen, um die Analyse zu vertiefen?

- Wie können interaktive Dashboards mögliche Kontextfaktoren verständlich und vergleichbar darstellen?
````






````{admonition} Gesamter Code für diesen Schritt
:class: solution, dropdown

```r
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  
  dashboardSidebar(
    sidebarMenu( id = "sidebarMenu",
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      menuItem("Karte", tabName = "map", icon = icon("map")),
      # NEU: Navigation für die Bewässerungsanalyse
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
    )
  ),
  
  dashboardBody(
    tabItems(
      # ... tabItem für "start" und "map" ...
      
      # NEU: Inhaltsbereich für die Bewässerungsanalyse
      tabItem(
        tabName = "analysis",
        fluidRow(
          box(
            title = tagList(
              "Bewässerung pro Bezirk",
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

# Server-Logik
server <- function(input, output, session) {
  
  # ... Code aus der Startseite und Karte
  
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
  
  # Plot: Bewässerung pro Bezirk
  output$hist_bewaesserung_pro_bezirk <- renderPlot({
    req(input$sidebarMenu == "analysis")
    
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
  
  # Info button observer
  observeEvent(input$info_btn_hbpb, {
    showModal(modalDialog(
      title = "Information: Bewässerung pro Bezirk",
      HTML("
      <p>Diese Grafik zeigt die <strong>gesamte Bewässerungsmenge</strong> für jeden Berliner Bezirk.</p>
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
    req(input$sidebarMenu == "analysis")
    
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
  
  # Info button observer
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
```
````
