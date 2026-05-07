---
lang: de-DE
---

(trees)=
# Eine Baumstatistik einfügen
```{admonition} Story
:class: story

Amir Weber möchte nachvollziehen, inwieweit die Art der Bäume und ihrer Umgebung das freiwillige Engagement beim Gießen beeinflussen. Nachdem Sie bereits zeitliche Muster analysiert haben, sollten Sie Ihren Blick nun auf räumliche Faktoren (Baumdichte) sowie baumartspezifische Merkmale richten.

```

```{admonition} Zweck dieser Übung
:class: lernziele

In dieser Übung sollen Sie herausfinden, ob die Baumart und räumliche Faktoren (Baumdichte) einen Einfluss auf das Engagement beim Gießen haben. Sie üben:

- Baumarten und deren Verteilung in Bezirken statistisch zu beschreiben,
- relative Häufigkeiten und Top-Listen (z. B. meistgegossene Arten) zu interpretieren,
- Baumdichte im Verhältnis zur Bezirksfläche quantitativ zu berechnen,

und einfache Hypothesen über das Engagement – etwa bevorzugte Gattungen oder Nachbarschaftseffekte – mit Daten zu prüfen.

```

Nachdem Sie zuvor untersucht haben, wie Pflanzjahr und Zeitverlauf das Gießverhalten beeinflussen, richten Sie ihren Blick nun auf räumliche und baumartspezifische Unterschiede innerhalb Berlins. Verschiedene Bezirke weisen sehr unterschiedliche Baumstrukturen auf: Manche besitzen eine hohe Dichte, andere sind von wenigen dominanten Gattungen geprägt (Nachweis dazu fehlt - woraus wird das zu diesem Zeitpunkt abgeleitet?).

Sie überprüfen also:

- Ob bestimmte Baumgattungen häufiger gegossen werden als andere.
- Ob die Baumdichte das Gießverhalten beeinflusst.
Er vermutet, dass dicht bepflanzte Straßen oder Kieze mehr Interaktionen begünstigen – etwa nach dem Motto: „Wenn ich schon meinen Baum gieße, mache ich den daneben auch gleich mit.“

Die Funktion dieses Reiters besteht also darin, die Baumverteilung nach Bezirken sichtbar zu machen, die am häufigsten gegossenen Baumarten zu identifizieren und die Baumdichte im Verhältnis zur Bezirksfläche zu analysieren, um mögliche Muster im Engagement zu erkennen.

Damit dient der Reiter als Grundlage, um zu verstehen, welche strukturellen Faktoren im Stadtraum das Engagement der Gießenden möglicherweise begünstigen.
<span style="color: red;">Die Farben für die Bezirke und Baumarten unterscheiden sich von Plot zu Plot. Es wäre vielleicht besser, wenn diese über das ganze Dashboard hinweg einheitlich wären</span>




```{figure} ../assets/Dashboard_Baumstatistik_1.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
---
Baumverteilung nach Bezirken und Baumgattungen. Die Abbildung zeigt die Verteilung der Bäume in den Berliner Bezirken, aufgeschlüsselt nach Baumgattungen. Die Anzahl der Bäume ist für jeden Bezirk als gestapeltes Balkendiagramm dargestellt, wobei die einzelnen Farbsegmente unterschiedliche Baumgattungen repräsentieren. Über einen Schieberegler kann die Anzahl der angezeigten, häufigsten Baumgattungen (Top-N) interaktiv angepasst werden, während weniger häufige Gattungen unter „Sonstige“ zusammengefasst sind. (Quelle: eigene Ausarbeitung)
``` 

Das obenstehende Diagramm ist ein Balkendiagramm, genauer gesagt ein gestapeltes Balkendiagramm, das mehrere Informationsebenen gleichzeitig vermittelt. Der zentrale Mehrwert dieser Darstellungsform liegt darin, sowohl die Gesamtanzahl der Bäume pro Bezirk als auch deren Zusammensetzung nach Gattungen in einer einzigen Visualisierung zu vereinen. Die Balkenlänge zeigt auf einen Blick, welche Bezirke den größten Baumbestand haben, während die farbigen Segmente innerhalb jedes Balkens die Artenvielfalt und deren relative Anteile offenlegen. Dies ermöglicht direkte Vergleiche zwischen Bezirken: Nutzer:innen können nicht nur erkennen, dass Bezirk A mehr Bäume hat als Bezirk B, sondern auch, ob beide eine ähnliche Gattungsverteilung aufweisen oder ob bestimmte Arten in einzelnen Bezirken dominieren. Die Anpassung über den Top-N-Schieberegler reduziert visuelle Komplexität und ermöglicht es, den Fokus je nach Fragestellung auf die häufigsten Gattungen zu legen oder eine detailliertere Aufschlüsselung zu betrachten. Somit verbindet das gestapelte Balkendiagramm quantitative Präzision mit visueller Übersichtlichkeit und macht komplexe, mehrdimensionale Daten intuitiv erfassbar. Balkendiagramme zählen zu den etabliertesten Darstellungswerkzeugen der Datenvisualisierung – ihre breite Anwendung in dieser Fallstudie spiegelt ihre Vielseitigkeit und Lesbarkeit wider.

```{figure} ../assets/Dashboard_Baumstatistik_2.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
width: 600px
---
Verteilung der Baumgattungen. Die Abbildung zeigt die prozentuale Verteilung der Baumgattungen im Berliner Baumbestand in Form eines Kreisdiagramms. Über ein Auswahlfeld kann der betrachtete Bezirk festgelegt werden, wodurch sich die dargestellte Verteilung entsprechend anpasst. Die einzelnen Kreissegmente repräsentieren die Anteile der jeweiligen Baumgattungen am Gesamtbestand des ausgewählten Bezirks. (Quelle: eigene Ausarbeitung)
``` 

Das obenstehende Diagramm ist ein Kreisdiagramm (auch Tortendiagramm genannt), das die prozentuale Zusammensetzung der Baumgattungen innerhalb eines Bezirks visualisiert. Der zentrale Mehrwert dieser Darstellungsform liegt in ihrer Fähigkeit, Anteile und Proportionen intuitiv erfassbar zu machen: Nutzer:innen erkennen auf einen Blick, welche Gattungen den Baumbestand dominieren und welche nur eine untergeordnete Rolle spielen. Die Kreisform vermittelt das Konzept des "Ganzen" unmittelbar – alle Segmente zusammen ergeben 100% des Baumbestands im gewählten Bezirk. Dies erleichtert das Verständnis relativer Größenverhältnisse, etwa wenn eine Gattung ein Viertel oder die Hälfte aller Bäume ausmacht. Die interaktive Bezirksauswahl ermöglicht zudem gezielte Vergleiche: Nutzer:innen können erkunden, ob bestimmte Gattungen in verschiedenen Stadtteilen unterschiedlich stark vertreten sind. Im Gegensatz zum Balkendiagramm, das absolute Zahlen und Mengenvergleiche betont, fokussiert das Kreisdiagramm auf die innere Struktur und Diversität des Baumbestands eines einzelnen Bezirks.

```{figure} ../assets/Dashboard_Baumstatistik_3.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
width: 650px
---
Top 10 gegossene Baumgattungen. Die Abbildung zeigt die Top 10 gegossenen Baumgattungen in Berlin in Form eines horizontalen Balkendiagramms. Über ein Auswahlfeld kann der betrachtete Bezirk festgelegt werden, wodurch sich die dargestellten Werte entsprechend anpassen. Die Balken repräsentieren die absolute Anzahl gegossener Bäume je Gattung, wobei die Linde mit deutlichem Abstand an erster Stelle steht, gefolgt von Ahorn (ca. 250.000) und weiteren Gattungen mit jeweils deutlich geringeren Werten. Die x-Achse zeigt die Anzahl gegossener Bäume, die y-Achse die Baumgattungen. (Quelle: eigene Ausarbeitung)
``` 

```{figure} ../assets/Dashboard_Baumstatistik_4.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
width: 600px
---
Baumdichte pro km². Die Abbildung zeigt die Baumdichte pro km² in den verschiedenen Berliner Bezirken in Form eines vertikalen Balkendiagramms. Die Balken repräsentieren die jeweilige Baumdichte, wobei Friedrichshain-Kreuzberg die höchste Dichte aufweist. Die x-Achse zeigt die Bezirke, die y-Achse die Anzahl der Bäume pro km². Die Darstellung ermöglicht einen direkten Vergleich der Baumdichte zwischen den zwölf Berliner Bezirken. (Quelle: eigene Ausarbeitung)
``` 

```{admonition} Was Sie beachten sollten
:class: keypoint

Nur weil Indikatoren nicht auftauchen, heißt es nicht, dass sie nicht wichtig sein können. Für das Verständnis der obigen Abbildung 4.8 'Top 10 gegossene Baumgattungen' ist beispielsweise eine Information zur Häufigkeit von Baumarten (wie in Abb. 4.7 dargestellt) unabdingbar. Und für eine korrekte Analyse der Abbildung 4.9 'Baumdichte pro km²' braucht es mindestens Hinweise zur Größe der Bezirke. Möglichicherweise wären auch Indikatoren wie Bevölkerungsdichte sinnvoll, um die angegebenen Werte zu kontextualisieren. 

Vor allem hinsichtlich der Interpretation von Datenvisualisierungen sollten Sie also darauf achten, sich nicht von den Indikatoren, die visuell hervorgehoben oder überhaupt dargestellt werden, in die Irre führen zu lassen. Es kann weitere Merkmale geben, die zum Verständnis oder der Analyse der Daten notwendig sind.

```

## Benutzeroberfläche (UI)

Zunächst fügen Sie einen weiteren Menüpunkt zur Navigation hinzu, um den Baumstatistik-Tab zugänglich zu machen.

````{dropdown} Navigation in der Seitenleiste
```r
dashboardSidebar(
  sidebarMenu(
    menuItem("Startseite", tabName = "start", icon = icon("home")),
    menuItem("Karte", tabName = "map", icon = icon("map")),
    menuItem("Zeitverlauf", tabName = "stats", icon = icon("bar-chart")),
    # NEU: Menüpunkt für die Baumstatistik hinzufügen
    menuItem("Baumstatistik", tabName = "engagement", icon = icon("hands-helping"))
  )
)
```
````

### Inhaltsbereich: Diagramme und Filter

Der Inhaltsbereich enthält die Diagramme sowie Filteroptionen, mit denen Nutzer:innen die Darstellung anpassen können.

````{dropdown} Code
```r
tabItem(
  tabName = "engagement",
  fluidRow(
    box(
      title = tagList(
        "Baumverteilung nach Bezirken (mit Baumgattungen)",
        div(
          actionButton("info_btn_bvnb", label = "", icon = icon("info-circle")),
          style = "position: absolute; right: 15px; top: 5px;"
        )
      ),
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      sliderInput(
        "top_n_species",
        "Top N Baumgattungen anzeigen:",
        min = 3,
        max = 15,
        value = 8,
        step = 1
      ),
      plotOutput("tree_distribution_stacked", height = "500px")
    )
  ),
  fluidRow(
    box(
      title = tagList(
        "Verteilung der Baumgattungen",
        div(
          actionButton("info_btn_vdb", label = "", icon = icon("info-circle")),
          style = "position: absolute; right: 15px; top: 5px;"
        )
      ),
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      selectInput(
        "pie_bezirk",
        "Bezirk auswählen:",
        choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
        selected = "Alle Bezirke"
      ),
      plotOutput("tree_species_pie", height = "500px")
    ),         
    box(
      title = tagList(
        "Baumdichte pro km²",
        div(
          actionButton("info_btn_bdpf", label = "", icon = icon("info-circle")),
          style = "position: absolute; right: 15px; top: 5px;"
        )
      ),
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      plotOutput("tree_density_area", height = "500px")
    )
  ),       
  fluidRow(
    box(
      title = tagList(
        "Top 10 gegossene Baumgattungen",
        div(
          actionButton("info_btn_hgb", label = "", icon = icon("info-circle")),
          style = "position: absolute; right: 15px; top: 5px;"
        )
      ),
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      selectInput(
        "engagement_bezirk",
        "Bezirk auswählen:",
        choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
        selected = "Alle Bezirke"
      ),
      plotOutput("top_watered_species", height = "500px")
    )
  )
)
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Struktur des Inhaltsbereichs:**

- `box(...)` gruppiert alle Elemente visuell
  - `title` enthält die jeweilige Überschrift und einen Info-Button
  - `status = "primary"` bestimmt das farblich einheitliche Design mit `solidHeader = TRUE`
  - `width = 12` bedeutet volle Seitenbreite in der Rasterstruktur des Dashboards.

**Filterelemente:**

- `sliderInput("top_n_species", ...)` – Ein Schieberegler zur dynamischen Anpassung der Anzahl gezeigter Baumgattungen. So lassen sich die Balkendiagramme übersichtlich halten.
- `selectInput(...)` – Dropdown-Menüs (`pie_bezirk`, `engagement_bezirk`), mit denen Nutzer:innen gezielt nach spezifischen Bezirken filtern können.

**Visualisierung:**

- `plotOutput(...)` (z. B. `"tree_distribution_stacked"`, `"tree_species_pie"`) reserviert Platz für das grafische Element.
  - Die tatsächliche Grafik wird später im Server über die `renderPlot()`-Funktion erzeugt.
  - `height = "500px"` sorgt für ein einheitliches Anzeigefenster aller Diagramme.

Diese Struktur ermöglicht den Nutzer:innen interaktive Ansichten und ein klares Interface zur Datenerkundung.
````

## Server

### Gestapeltes Balkendiagramm: Baumverteilung nach Bezirken

Das erste Diagramm soll zeigen, wie viele Bäume in jedem Bezirk stehen und welche Gattungen dort dominieren. Um die Visualisierung übersichtlich zu halten, konzentrieren Sie sich auf **die häufigsten Baumgattungen** – alle anderen fassen Sie unter "Sonstige" zusammen.

````{dropdown} Code
```r  
# 1. Stacked Bar Chart - Baumverteilung mit Gattungen
  output$tree_distribution_stacked <- renderPlot({
    top_genera <- df_merged %>%
      filter(!is.na(gattung_deutsch)) %>%   
      count(gattung_deutsch, sort = TRUE) %>%
      head(input$top_n_species) %>%
      pull(gattung_deutsch)
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Top-Gattungen ermitteln:**

- `filter(!is.na(gattung_deutsch))` – entfernt Bäume ohne Gattungsangabe
- `count(gattung_deutsch, sort = TRUE)` – zählt jede Gattung und sortiert absteigend
- `head(input$top_n_species)` – wählt die Top-N häufigsten Gattungen (über UI-Slider steuerbar)
- `pull(gattung_deutsch)` – extrahiert die Gattungsnamen als Vektor

Diese Gattungsliste verwenden Sie später, um alle anderen Gattungen als "Sonstige" zu kennzeichnen.
````


### Daten aggregieren und gruppieren

Jetzt bereiten Sie die Daten so auf, dass für jeden Bezirk gezählt wird, wie viele Bäume jeder Gattungsgruppe dort stehen.

````{dropdown} Code
```r
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      mutate(gattung_grouped = ifelse(gattung_deutsch %in% top_genera, gattung_deutsch, "Sonstige")) %>%
      group_by(bezirk, gattung_grouped) %>%
      summarise(count = n(), .groups = "drop") %>%
      group_by(bezirk) %>%
      mutate(percentage = count / sum(count) * 100) %>%
      ungroup()
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Datenaufbereitung:**

- `filter(!is.na(bezirk))` – entfernt Bäume ohne Bezirkszuordnung
- `mutate(gattung_grouped = ...)` – gruppiert Gattungen:
  - Wenn die Gattung zu den Top-N gehört → behalte den Namen
  - Ansonsten → kennzeichne als "Sonstige"
- `group_by(bezirk, gattung_grouped)` – gruppiert nach Bezirk und Gattungsgruppe
- `summarise(count = n())` – zählt Bäume pro Gruppe
- `mutate(percentage = ...)` – berechnet den prozentualen Anteil jeder Gattung innerhalb des Bezirks

````


### Gestapeltes Balkendiagramm erstellen

Mit den aggregierten Daten erstellen Sie nun das gestapelte Balkendiagramm, das die Baumverteilung nach Bezirken visualisiert.

````{dropdown} Code
```r
    df_agg$gattung_grouped <- factor(df_agg$gattung_grouped, 
                                     levels = c(top_genera, "Sonstige"))
    
    ggplot(df_agg, aes(x = reorder(bezirk, count, sum), y = count, fill = gattung_grouped)) +
      geom_bar(stat = "identity", position = "stack", color = "white", size = 0.3) +
      labs(
        title = NULL,
        x = "Bezirk",
        y = "Anzahl Bäume",
        fill = "Baumgattung"
      ) +
      theme_light() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        legend.position = "right",
        panel.grid.major.x = element_blank()
      ) +
      scale_fill_brewer(palette = "Set3")
  })

  # Info button
  observeEvent(input$info_btn_bvnb, {
    showModal(modalDialog(
      title = "Information: Baumverteilung nach Bezirken",
      HTML("
      <p>Diese Grafik zeigt die <strong>Gesamtanzahl und Zusammensetzung der Bäume</strong> in jedem Berliner Bezirk nach Gattung.</p>
      <ul>
        <li>Jeder Balken zeigt die Gesamtzahl der Bäume im Bezirk</li>
        <li>Die Farben zeigen die verschiedenen Baumgattungen (z.B. LINDE, AHORN, EICHE)</li>
        <li>Seltene Gattungen werden als 'Sonstige' zusammengefasst</li>
        <li>Nutzen Sie den Slider, um mehr oder weniger Gattungen anzuzeigen</li>
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

**Gestapeltes Balkendiagramm:**

- `factor(df_agg$gattung_grouped, levels = ...)` – definiert die Reihenfolge der Gattungen (Top-Gattungen zuerst, dann "Sonstige")
- `reorder(bezirk, count, sum)` – sortiert Bezirke nach Gesamtanzahl der Bäume
- `geom_bar(stat = "identity", position = "stack")` – erstellt gestapelte Balken
- `fill = gattung_grouped` – färbt die Segmente nach Gattungsgruppe
- `scale_fill_brewer(palette = "Set3")` – verwendet eine farblich abgestimmte Palette

**Was zeigt der Plot?**
- Welche Gattungen in welchem Bezirk dominieren
- Wie groß der Anteil der "Sonstigen" ist
- Wie sich Bezirke in ihrer Baumstruktur unterscheiden
````

### Kreisdiagramm: Gattungsverteilung

Das Kreisdiagramm soll die prozentuale Zusammensetzung der Baumgattungen zeigen – entweder für ganz Berlin oder für einen ausgewählten Bezirk. Diese Darstellung macht auf einen Blick deutlich, welche Gattungen dominieren.

````{dropdown} Code
```r
  # 2. Pie Chart - Gattungsverteilung
  output$tree_species_pie <- renderPlot({
    filtered_data <- df_merged
    if (input$pie_bezirk != "Alle Bezirke") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$pie_bezirk)
    }
    
    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%  
      count(gattung_deutsch, sort = TRUE) %>%
      mutate(
        gattung_grouped = ifelse(row_number() <= 10, gattung_deutsch, "Sonstige")
      ) %>%
      group_by(gattung_grouped) %>%
      summarise(count = sum(n), .groups = "drop") %>%
      arrange(desc(count)) %>%
      mutate(
        percentage = count / sum(count) * 100,
        label = paste0(gattung_grouped, "\n", round(percentage, 1), "%")
      )
    
    ggplot(df_agg, aes(x = "", y = count, fill = gattung_grouped)) +
      geom_bar(stat = "identity", width = 1, color = "white", size = 0.5) +
      coord_polar("y", start = 0) +
      labs(
        title = NULL,
        fill = "Baumgattung"
      ) +
      theme_void() +
      theme(
        legend.position = "right",
        legend.text = element_text(size = 9)
      ) +
      scale_fill_brewer(palette = "Set3") +
      geom_text(aes(label = ifelse(percentage > 3, paste0(round(percentage, 1), "%"), "")),
                position = position_stack(vjust = 0.5),
                size = 3,
                color = "black")
  })

  # Info button
  observeEvent(input$info_btn_vdb, {
    showModal(modalDialog(
      title = "Information: Verteilung der Baumgattungen",
      HTML("
      <p>Diese Grafik zeigt die <strong>prozentuale Verteilung der Baumgattungen</strong>.</p>
      <ul>
        <li>Zeigt die Top 10 häufigsten Baumgattungen (z.B. LINDE, AHORN, EICHE)</li>
        <li>Alle anderen Gattungen werden als 'Sonstige' zusammengefasst</li>
        <li>Kann auf einzelne Bezirke gefiltert werden</li>
        <li>Hilft zu verstehen, welche Gattungen in Berlin dominieren</li>
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

**Bezirksfilter:**

- Wenn ein bestimmter Bezirk ausgewählt wurde, werden nur dessen Bäume betrachtet
- Ansonsten zeigt das Diagramm die Verteilung für ganz Berlin

**Datenaufbereitung:**

- `count(gattung_deutsch, sort = TRUE)` – zählt jede Gattung
- `row_number() <= 10` – markiert die Top-10-Gattungen, alle anderen werden zu "Sonstige"
- `group_by(gattung_grouped)` – fasst gleiche Gruppen zusammen
- `mutate(percentage = ...)` – berechnet prozentuale Anteile

**Kreisdiagramm erstellen:**

- `coord_polar("y", start = 0)` – wandelt ein Balkendiagramm in ein Kreisdiagramm um
- `geom_text(...)` – fügt Prozentangaben hinzu (nur bei Segmenten > 3%)
- `theme_void()` – entfernt Achsen und Gitter für eine klare Darstellung

Das Kreisdiagramm zeigt intuitiv, welche Gattungen den Baumbestand dominieren – ideal für schnelle Vergleiche zwischen Bezirken.
````

### Baumdichte pro Fläche berechnen

Um Bezirke fair vergleichen zu können, berechnen Sie die Baumdichte – also wie viele Bäume pro Quadratkilometer stehen. Ein großer Bezirk kann viele Bäume haben, aber trotzdem eine niedrige Dichte aufweisen.

````{dropdown} Code
```r
  # 3. Baumdichte pro Bezirksfläche
  output$tree_density_area <- renderPlot({
    bezirk_flaeche <- data.frame(
      bezirk = c("Charlottenburg-Wilmersdorf", "Friedrichshain-Kreuzberg", "Lichtenberg",
                 "Marzahn-Hellersdorf", "Mitte", "Neukölln", "Pankow",
                 "Reinickendorf", "Spandau", "Steglitz-Zehlendorf",
                 "Tempelhof-Schöneberg", "Treptow-Köpenick"),
      flaeche_km2 = c(64.72, 20.16, 52.29, 61.74, 39.47, 44.93, 103.07,
                      89.46, 91.91, 102.50, 53.09, 168.42)
    )
    
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      group_by(bezirk) %>%
      summarise(total_trees = n_distinct(gml_id)) %>%
      ungroup() %>%
      left_join(bezirk_flaeche, by = "bezirk") %>%
      mutate(density = total_trees / flaeche_km2) %>%
      arrange(desc(density))
    
    ggplot(df_agg, aes(x = reorder(bezirk, -density), y = density, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      labs(
        title = NULL,
        x = "Bezirk",
        y = "Bäume pro km²"
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        panel.grid.major.x = element_blank()
      ) +
      scale_fill_discrete()
  })

  # Info button
  observeEvent(input$info_btn_bdpf, {
    showModal(modalDialog(
      title = "Information: Baumdichte pro km²",
      HTML("
      <p>Diese Grafik zeigt die <strong>Baumdichte</strong> in jedem Bezirk normalisiert auf die Fläche.</p>
      <ul>
        <li>Berechnung: Anzahl Bäume / Bezirksfläche in km²</li>
        <li>Ermöglicht fairen Vergleich zwischen großen und kleinen Bezirken</li>
        <li>Hohe Dichte = urbaner, mehr Straßenbäume</li>
        <li>Niedrige Dichte = ländlicher, mehr Wald/Parkflächen</li>
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

**Flächendaten hinzufügen:**

- Eine kleine Lookup-Tabelle (`bezirk_flaeche`) enthält die Fläche jedes Bezirks in km²
- `left_join(bezirk_flaeche, by = "bezirk")` – verknüpft diese Flächenangaben mit den Baumdaten

**Dichte berechnen:**

- `group_by(bezirk)` – gruppiert nach Bezirk
- `summarise(total_trees = n_distinct(gml_id))` – zählt eindeutige Bäume pro Bezirk
- `mutate(density = total_trees / flaeche_km2)` – berechnet Bäume pro km²
- `arrange(desc(density))` – sortiert absteigend nach Dichte

**Balkendiagramm:**

- `reorder(bezirk, -density)` – sortiert Bezirke nach Dichte
- Das Diagramm zeigt, welche Bezirke besonders dicht bepflanzt sind (z. B. urbane Zentren) und welche eher locker (z. B. Randbezirke mit viel Grünfläche)

Diese Normalisierung ermöglicht faire Vergleiche: Ein kleiner, urbaner Bezirk kann trotz weniger Bäume eine höhere Dichte haben als ein großer, ländlicher Bezirk.
````

### Top 10 gegossene Baumgattungen

Diese Visualisierung zeigt, welche Baumgattungen am häufigsten gegossen wurden. Das hilft zu verstehen, ob bestimmte Gattungen mehr Aufmerksamkeit erhalten – möglicherweise weil sie häufiger vorkommen oder als besonders pflegebedürftig wahrgenommen werden.

````{dropdown} Code
```r
  # 4. Top 10 gegossene Baumgattungen
  output$top_watered_species <- renderPlot({
    filtered_data <- df_merged %>%
      filter(!is.na(bewaesserungsmenge_in_liter)) 
    
    if (input$engagement_bezirk != "Alle Bezirke") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$engagement_bezirk)
    }
    
    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%   
      group_by(gattung_deutsch) %>%
      summarise(
        count = n(),
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)
      ) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      head(10)
    
    ggplot(df_agg, aes(x = reorder(gattung_deutsch, count), y = count, fill = gattung_deutsch)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      coord_flip() +
      labs(
        title = NULL,
        x = "Baumgattung",
        y = "Anzahl gegossener Bäume"
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        panel.grid.major.y = element_blank()
      ) +
      scale_fill_discrete()
  })

  # Info button
  observeEvent(input$info_btn_hgb, {
    showModal(modalDialog(
      title = "Information: Top 10 gegossene Baumgattungen",
      HTML("
      <p>Diese Grafik zeigt die <strong>am häufigsten gegossenen Baumgattungen</strong>.</p>
      <ul>
        <li>Nur Bäume, die tatsächlich bewässert wurden</li>
        <li>Zeigt, welche Gattungen am meisten Unterstützung erhalten</li>
        <li>Kann auf einzelne Bezirke gefiltert werden</li>
        <li>Hilft zu verstehen, welche Gattungen besondere Aufmerksamkeit bekommen</li>
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

**Nur gegossene Bäume berücksichtigen:**

- `filter(!is.na(bewaesserungsmenge_in_liter))` – behalte nur Bäume, die tatsächlich bewässert wurden
- Optional: Filterung nach Bezirk, falls ausgewählt

**Top-10-Gattungen ermitteln:**

- `group_by(gattung_deutsch)` – gruppiert nach Gattung
- `summarise(count = n(), total_water = sum(...))` – berechnet zwei Kennzahlen:
  - `count` – wie viele Bäume dieser Gattung gegossen wurden
  - `total_water` – wie viel Wasser insgesamt auf diese Gattung gegossen wurde
- `arrange(desc(count))` – sortiert absteigend nach Häufigkeit
- `head(10)` – wählt die Top 10 aus

**Horizontales Balkendiagramm:**

- `coord_flip()` – dreht das Diagramm um 90°, sodass Gattungsnamen gut lesbar sind
- `reorder(gattung_deutsch, count)` – sortiert Gattungen nach Anzahl gegossener Bäume

Diese Visualisierung macht sichtbar, welche Gattungen die meiste Aufmerksamkeit erhalten – allerdings korreliert dies stark mit der Verbreitung der jeweiligen Gattung im Stadtbild.
````

### Kritische Diskussion

Die Analyse zeigt deutlich, dass bestimmte Baumgattungen besonders oft im Berliner Baumbestand vorkommen. **Ahorn, Linde und Eiche machen berlinweit gemeinsam rund 57,4 % aller Straßenbäume aus**, wohingegen sich alle anderen Baumgattungen 42,6% teilen. Das bedeutet, dass viele Muster der Verteilung zwangsläufig von dieser einen Gattung geprägt werden. Die Betrachtung der Gattungen ist daher zwar interessant, besitzt jedoch **nur begrenzte Aussagekraft**, da sie strukturelle Eigenheiten der Berliner Bepflanzung widerspiegelt und weniger das Verhalten der Bürgerinnen und Bürger.

Beim Vergleich der Bezirke treten klare Unterschiede in der räumlichen Verteilung zutage. **Friedrichshain-Kreuzberg und Mitte weisen die höchsten Baumdichten pro km² auf**, was typisch für kompakte, urbane Bezirke mit vielen Straßenbäumen ist. Gleichzeitig besitzen **Steglitz-Zehlendorf, Pankow und Marzahn-Hellersdorf die größten absoluten Baumzahlen**, was vor allem auf großflächige Areale mit Mischbeständen und Gehölzflächen zurückzuführen ist.

Setzt man diese Befunde in Bezug zu den Engagement-Daten, deutet sich ein Muster an:
**Bezirke mit hoher Baumdichte zeigen tendenziell auch mehr Bürgerengagement**.
Dies ist plausibel, da in dichter bebauten Gebieten mehr Menschen auf engem Raum auf Bäume treffen und häufiger die Möglichkeit haben, einzelne Straßenbäume zu gießen.

Die Baumgattungen selbst liefern hingegen **keinen starken Erklärungswert für das Engagement**. Es zeigt sich zwar, welche Gattungen besonders häufig gegossen werden, doch dies korreliert in erster Linie damit, wie verbreitet die jeweilige Gattung im Stadtbild ist. Dass Linden oft gegossen werden, liegt also vor allem daran, dass sie fast überall stehen – nicht daran, dass sie besonders pflegebedürftig oder beliebter wären.

**Kernbotschaft**
*Die Verteilung des Engagements folgt eher der Dichte und Sichtbarkeit von Bäumen in den Bezirken als der Art der Bäume. Baumgattungen erklären wenig – räumliche Faktoren jedoch deuten auf einiges hin.*


````{admonition} Gesamter Code für diesen Schritt
:class: solution, dropdown

```r
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      menuItem("Karte", tabName = "map", icon = icon("map")),
      menuItem("Zeitverlauf", tabName = "stats", icon = icon("bar-chart")),
      # NEU: Navigation für die Baumstatistik
      menuItem("Baumstatistik", tabName = "engagement", icon = icon("hands-helping"))
    )
  ),
  dashboardBody(
    tabItems(
      # ... tabItem für "start", "map" & "stats" ...
      
      # NEU: Inhaltsbereich für die Baumstatistik
      tabItem(
        tabName = "engagement",
        fluidRow(
          box(
            title = tagList(
              "Baumverteilung nach Bezirken (mit Baumgattungen)",
              div(
                actionButton("info_btn_bvnb", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            sliderInput(
              "top_n_species",
              "Top N Baumgattungen anzeigen:",
              min = 3,
              max = 15,
              value = 8,
              step = 1
            ),
            plotOutput("tree_distribution_stacked", height = "500px")
          )
        ),
        fluidRow(
          box(
            title = tagList(
              "Verteilung der Baumgattungen",
              div(
                actionButton("info_btn_vdb", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            selectInput(
              "pie_bezirk",
              "Bezirk auswählen:",
              choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
              selected = "Alle Bezirke"
            ),
            plotOutput("tree_species_pie", height = "500px")
          ),         
          box(
            title = tagList(
              "Baumdichte pro km²",
              div(
                actionButton("info_btn_bdpf", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotOutput("tree_density_area", height = "500px")
          )
        ),       
        fluidRow(
          box(
            title = tagList(
              "Top 10 gegossene Baumgattungen",
              div(
                actionButton("info_btn_hgb", label = "", icon = icon("info-circle")),
                style = "position: absolute; right: 15px; top: 5px;"
              )
            ),
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            selectInput(
              "engagement_bezirk",
              "Bezirk auswählen:",
              choices = c("Alle Bezirke", sort(unique(df_merged$bezirk))),
              selected = "Alle Bezirke"
            ),
            plotOutput("top_watered_species", height = "500px")
          )
        )
      )
    )
  )
)

# Server-Logik
server <- function(input, output, session) {
  
  # ... Code aus der Startseite, Karte und Zeitverlauf ...
  
  # 1. Stacked Bar Chart - Baumverteilung mit Gattungen
  output$tree_distribution_stacked <- renderPlot({
    top_genera <- df_merged %>%
      filter(!is.na(gattung_deutsch)) %>%   
      count(gattung_deutsch, sort = TRUE) %>%
      head(input$top_n_species) %>%
      pull(gattung_deutsch)
      
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      mutate(gattung_grouped = ifelse(gattung_deutsch %in% top_genera, gattung_deutsch, "Sonstige")) %>%
      group_by(bezirk, gattung_grouped) %>%
      summarise(count = n(), .groups = "drop") %>%
      group_by(bezirk) %>%
      mutate(percentage = count / sum(count) * 100) %>%
      ungroup()
      
    df_agg$gattung_grouped <- factor(df_agg$gattung_grouped, 
                                     levels = c(top_genera, "Sonstige"))
    
    ggplot(df_agg, aes(x = reorder(bezirk, count, sum), y = count, fill = gattung_grouped)) +
      geom_bar(stat = "identity", position = "stack", color = "white", size = 0.3) +
      labs(
        title = NULL,
        x = "Bezirk",
        y = "Anzahl Bäume",
        fill = "Baumgattung"
      ) +
      theme_light() +
      theme(
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        legend.position = "right",
        panel.grid.major.x = element_blank()
      ) +
      scale_fill_brewer(palette = "Set3")
  })

  observeEvent(input$info_btn_bvnb, {
    showModal(modalDialog(
      title = "Information: Baumverteilung nach Bezirken",
      HTML("
      <p>Diese Grafik zeigt die <strong>Gesamtanzahl und Zusammensetzung der Bäume</strong> in jedem Berliner Bezirk nach Gattung.</p>
      <ul>
        <li>Jeder Balken zeigt die Gesamtzahl der Bäume im Bezirk</li>
        <li>Nutzen Sie den Slider, um mehr oder weniger Gattungen anzuzeigen</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })

  # 2. Pie Chart - Gattungsverteilung
  output$tree_species_pie <- renderPlot({
    filtered_data <- df_merged
    if (input$pie_bezirk != "Alle Bezirke") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$pie_bezirk)
    }
    
    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%  
      count(gattung_deutsch, sort = TRUE) %>%
      mutate(
        gattung_grouped = ifelse(row_number() <= 10, gattung_deutsch, "Sonstige")
      ) %>%
      group_by(gattung_grouped) %>%
      summarise(count = sum(n), .groups = "drop") %>%
      arrange(desc(count)) %>%
      mutate(
        percentage = count / sum(count) * 100,
        label = paste0(gattung_grouped, "\n", round(percentage, 1), "%")
      )
    
    ggplot(df_agg, aes(x = "", y = count, fill = gattung_grouped)) +
      geom_bar(stat = "identity", width = 1, color = "white", size = 0.5) +
      coord_polar("y", start = 0) +
      labs(
        title = NULL,
        fill = "Baumgattung"
      ) +
      theme_void() +
      theme(
        legend.position = "right",
        legend.text = element_text(size = 9)
      ) +
      scale_fill_brewer(palette = "Set3") +
      geom_text(aes(label = ifelse(percentage > 3, paste0(round(percentage, 1), "%"), "")),
                position = position_stack(vjust = 0.5),
                color = "black")
  })

  observeEvent(input$info_btn_vdb, {
    showModal(modalDialog(
      title = "Information: Verteilung der Baumgattungen",
      HTML("
      <p>Diese Grafik zeigt die <strong>prozentuale Verteilung der Baumgattungen</strong>.</p>
      <ul>
        <li>Zeigt die Top 10 häufigsten Baumgattungen (z.B. LINDE, AHORN, EICHE)</li>
        <li>Hilft zu verstehen, welche Gattungen in Berlin dominieren</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })

  # 3. Baumdichte pro Bezirksfläche
  output$tree_density_area <- renderPlot({
    bezirk_flaeche <- data.frame(
      bezirk = c("Charlottenburg-Wilmersdorf", "Friedrichshain-Kreuzberg", "Lichtenberg",
                 "Marzahn-Hellersdorf", "Mitte", "Neukölln", "Pankow",
                 "Reinickendorf", "Spandau", "Steglitz-Zehlendorf",
                 "Tempelhof-Schöneberg", "Treptow-Köpenick"),
      flaeche_km2 = c(64.72, 20.16, 52.29, 61.74, 39.47, 44.93, 103.07,
                      89.46, 91.91, 102.50, 53.09, 168.42)
    )
    
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      group_by(bezirk) %>%
      summarise(total_trees = n_distinct(gml_id)) %>%
      ungroup() %>%
      left_join(bezirk_flaeche, by = "bezirk") %>%
      mutate(density = total_trees / flaeche_km2) %>%
      arrange(desc(density))
    
    ggplot(df_agg, aes(x = reorder(bezirk, -density), y = density, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      labs(
        title = NULL,
        x = "Bezirk",
        y = "Bäume pro km²"
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
        panel.grid.major.x = element_blank()
      ) +
      scale_fill_discrete()
  })
  
  # Info button
  observeEvent(input$info_btn_bdpf, {
    showModal(modalDialog(
      title = "Information: Baumdichte pro km²",
      HTML("
      <p>Diese Grafik zeigt die <strong>Baumdichte</strong> in jedem Bezirk normalisiert auf die Fläche.</p>
      <ul>
        <li>Berechnung: Anzahl Bäume / Bezirksfläche in km²</li>
        <li>Ermöglicht fairen Vergleich zwischen großen und kleinen Bezirken</li>
        <li>Hohe Dichte = urbaner, mehr Straßenbäume</li>
        <li>Niedrige Dichte = ländlicher, mehr Wald/Parkflächen</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })

  # 4. Top 10 gegossene Baumgattungen
  output$top_watered_species <- renderPlot({
    filtered_data <- df_merged %>%
      filter(!is.na(bewaesserungsmenge_in_liter)) 
    
    if (input$engagement_bezirk != "Alle Bezirke") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$engagement_bezirk)
    }
    
    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%   
      group_by(gattung_deutsch) %>%
      summarise(
        count = n(),
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)
      ) %>%
      ungroup() %>%
      arrange(desc(count)) %>%
      head(10)
    
    ggplot(df_agg, aes(x = reorder(gattung_deutsch, count), y = count, fill = gattung_deutsch)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7) +
      coord_flip() +
      labs(
        title = NULL,
        x = "Baumgattung",
        y = "Anzahl gegossener Bäume"
      ) +
      theme_light() +
      theme(
        legend.position = "none",
        panel.grid.major.y = element_blank()
      ) +
      scale_fill_discrete()
  })

  observeEvent(input$info_btn_hgb, {
    showModal(modalDialog(
      title = "Information: Top 10 gegossene Baumgattungen",
      HTML("
      <p>Diese Grafik zeigt die <strong>am häufigsten gegossenen Baumgattungen</strong>.</p>
      <ul>
        <li>Nur Bäume, die tatsächlich bewässert wurden</li>
        <li>Zeigt, welche Gattungen am meisten Unterstützung erhalten</li>
        <li>Kann auf einzelne Bezirke gefiltert werden</li>
        <li>Hilft zu verstehen, welche Gattungen besondere Aufmerksamkeit bekommen</li>
      </ul>
    "),
      easyClose = TRUE,
      footer = modalButton("Schließen")
    ))
  })
}

shinyApp(ui = ui, server = server)
```
````

### Überleitung zum nächsten Analyse-Schritt

Da Sie nun gesehen haben, dass die Baumdichte und räumliche Gegebenheiten relevanter für das Engagement sein könnten als rein baumbiologische Aspekte (wie die Gattung), sollten Sie sich im nächsten Schritt noch konkreter ansehen, welche Rolle urbane Infrastruktur spielt. Eine naheliegende Hypothese: Bäume, die näher an Wasserpumpen stehen, werden häufiger gegossen. Darum dreht sich das nächste Kapitel.
