---
lang: de-DE
---

(watering)=
# Einfügen Bewässerungsanalyse
```{admonition} Story
:class: story

Nachdem Amir mithilfe der Bezirkskarte herausgefunden hat, in welchen Teilen Berlins besonders viele Bäume gegossen wurden, stellt er sich eine neue Frage:
Reicht es wirklich aus, nur zu zählen, wie viele Bäume gegossen wurden?

Er merkt schnell: Diese Darstellung zeigt zwar den Umfang des Engagements, aber nicht die Intensität der Bewässerung. Ein Bezirk könnte viele Bäume gegossen haben – aber jeweils nur sehr wenig. Ein anderer Bezirk könnte weniger Bäume bewässert haben, dafür aber mit viel mehr Wasser pro Baum.
```

```{admonition} Zweck dieser Übung
:class: lernziele

Diese Übung zeigt, wie sich durch unterschiedliche Kennzahlen neue Perspektiven auf dieselben Verwaltungsdaten ergeben. Während zuvor die Zahl der gegossenen Bäume im Mittelpunkt stand, wird nun die Bewässerungsmenge in Litern analysiert.

Wir lernen dabei, wie Daten aggregiert, umgerechnet und visualisiert werden können, um Bezirke hinsichtlich ihrer gesamten Bewässerungsleistung oder der durchschnittlichen Wassermenge pro Baum zu vergleichen. Dadurch wird deutlich, dass die Auswahl der Messgröße – die Operationalisierung – zu verschiedenen analytischen Ergebnissen führen kann: Ein Bezirk, der bei der Anzahl gegossener Bäume gut abschneidet, liegt bei der Wassermenge möglicherweise nicht vorne (und umgekehrt).

```

Um die Unterschiede sichtbar zu machen, entscheidet sich Amir, eine umfassendere Analyse der Bewässerungsmenge durchzuführen:

- Wie viel Wasser wurde insgesamt pro Bezirk ausgebracht?
- Wie viel Wasser erhielt ein durchschnittlich gegossener Baum?
- Und verändert sich dadurch das Ranking der Bezirke?

So möchte Amir untersuchen, wie sich die Wahl der Operationalisierung – also „gezählte Bäume“ vs. „gegossene Liter“ – auf die Ergebnisse auswirkt. Die Frage lautet:
Welche Geschichte erzählen die Daten, wenn man Liter statt Baumanzahl betrachtet?

## Die Benutzeroberfläche (UI)
In der UI definieren wir eine neue Tab-Seite namens "stats" mit zwei Diagrammfeldern. In jedem Diagrammfeld findet man je eines des beiden erstellten Diagramme.

```{figure} Dashboard_Bewässerungsanalyse_1.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
---
Balkendiagramm zur Bewässerung pro Bezirk (2020–2024). Die Abbildung zeigt die aggregierte Bewässerungsmenge in Millionen Litern für die einzelnen Berliner Bezirke im Zeitraum von 2020 bis 2024. Auf der x-Achse sind die Bezirke dargestellt, während die y-Achse die gesamte Bewässerungsmenge angibt. Das Diagramm ermöglicht einen direkten Vergleich der Bewässerungsintensität zwischen den Bezirken. (Quelle: eigene Ausarbeitung)
```


````{dropdown} Code
```r
     tabItem(
        tabName = "analysis",
        fluidRow(
          box(
            title = tagList(
              "Bewässerung pro Bezirk (2020-2024)",
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
```
````
```{figure} Dashboard_Bewässerungsanalyse_2.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
width: 700px
---
Durchschnittliche Bewässerungsmenge pro gegossenem Baum nach Bezirk. Die Abbildung zeigt die durchschnittliche Bewässerungsmenge pro gegossenem Baum in Litern für die einzelnen Berliner Bezirke. Auf der x-Achse sind die Bezirke dargestellt, während die y-Achse die durchschnittliche Bewässerungsmenge pro Baum angibt. Das Balkendiagramm verdeutlicht Unterschiede in der Bewässerungsintensität zwischen den Bezirken. (Quelle: eigene Ausarbeitung)
``` 
````{dropdown} Code
```r
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

- ``tagList(...)``: Wird genutzt, um mehrere UI-Elemente im Titel der Box zu kombinieren – hier der Titeltext und der Informations-Button. So kann der Info-Button elegant im Titelbereich platziert werden.

- ``actionButton``: Erstellt einen klickbaren Button. Dieser Button wird später dazu genutzt, **kontextbezogene Erklärungen oder Hilfetexte** zu öffnen (z. B. via ``observeEvent()`` + ``showModal()``). Der Button hat die ID ``"info_btn_hbpb"`` und wird später verwendet, um eine Erklärung zur Grafik anzuzeigen. Gleiches gilt für ``"info_btn_hbpb2"``

- ``plotOutput(...)``
Platzhalter für ein Diagramm, das im Server-Teil gerendert wird.
 - ``hist_bewaesserung_pro_bezirk`` zeigt die **Gesamtwassermenge pro Bezirk**
 - ``hist_bewaesserung_pro_baum`` zeigt die **durchschnittliche Wassermenge pro gegossenem Baum**

````

## Server
### Berechnung der Bewässerung

Der erste Teil des Codes, der die **durchschnittliche Bewässerung pro Bezirk** darstellt, berechnet, wie viel Wasser insgesamt in jedem Bezirk verbraucht wurde.

````{dropdown} Code
```r
  output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      group_by(bezirk) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      ungroup() %>%
      arrange(desc(total_water))
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Daten aggregieren:**

- `filter(!is.na(bezirk))` – entfernt Einträge ohne Bezirksangabe
- `group_by(bezirk)` – gruppiert alle Bäume nach Bezirk
- `summarise(total_water = sum(...))` – berechnet die Gesamtwassermenge pro Bezirk
- `ungroup()` – löst die Gruppierung auf
- `arrange(desc(total_water))` – sortiert Bezirke absteigend nach Wassermenge

Durch diese Aggregation wird sichtbar, welche Bezirke absolut gesehen die meisten Liter Wasser auf ihre Bäume gegossen haben.
````

### Einheiten automatisch umrechnen

Da die Wassermenge sehr groß sein kann (Millionen Liter), rechnet Amir die Werte in passende Einheiten um: Liter, Kubikmeter oder Megaliter – je nach Größenordnung.

````{dropdown} Code
```r
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

**Einheiten umrechnen:**

- `purrr::map(total_water, convert_units)` – wendet die Funktion `convert_units()` auf jede Wassermenge an
  - Diese Funktion entscheidet automatisch, welche Einheit sinnvoll ist (L, m³ oder ML)
  - Das Ergebnis ist eine Liste mit `value` (Zahl) und `unit` (Einheit)
- `sapply(converted, `[[`, "value")` – extrahiert den numerischen Wert
- `sapply(converted, `[[`, "unit")` – extrahiert die Einheit

**Warum ist das wichtig?**  
Ohne Umrechnung würden große Zahlen wie "2.500.000 L" schwer lesbar sein. Mit der automatischen Umrechnung wird daraus "2,5 ML" – viel übersichtlicher.
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

### Info button observer

````{dropdown} Code
```r
  observeEvent(input$info_btn_hbpb, {
    showModal(modalDialog(
      title = "Information: Bewässerung pro Bezirk",
      HTML("
      <p>Diese Grafik zeigt die <strong>gesamte Bewässerungsmenge</strong> für jeden Berliner Bezirk im Zeitraum 2020-2024.</p>
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

````{admonition} Erklärung der Elemente
:class: hinweis, dropdown

- ``observeEvent()`` - Reagiert auf ein Ereignis – in diesem Fall das Klicken des Info-Buttons.
- ``input$info_btn_hbpb`` - ID des Buttons aus der Benutzeroberfläche. Sobald dieser geklickt wird, öffnet sich das Modal.
- ``showModal()`` - Zeigt ein Pop-up-Fenster über der Anwendung. Nützlich für Hinweise, Hilfetexte und Zusatzinfos.
- ``modalDialog()`` - Erzeugt das Dialogfenster selbst. Es enthält:
  - einen **Titel**,
  - **HTML-formatierten Text**, z. B. fett `<strong>` oder Listen,
  - eine **Schließen-Schaltfläche**.
- ``HTML("…")`` - Ermöglicht echte HTML-Struktur (Absätze, Listen, Hervorhebungen), statt einfachem Text.
- ``easyClose = TRUE`` - Das Fenster kann auch durch Klick außerhalb des Modals geschlossen werden.
- ``modalButton("Schließen")`` - Fügt unten rechts den Schließen-Button hinzu.
````


### Durchschnittliche Bewässerung pro Baum

Das zweite Diagramm zeigt eine andere Perspektive: Statt der Gesamtmenge wird hier berechnet, wie viel Wasser durchschnittlich auf jeden gegossenen Baum kam. Das hilft zu verstehen, ob in einem Bezirk besonders intensiv oder eher oberflächlich gegossen wurde.

````{dropdown} Code
```r
  # Plot: Durchschnittliche Bewässerung pro gegossenem Baum
  output$hist_bewaesserung_pro_baum <- renderPlot({
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
    
    # Convert units for water per tree
    df_agg <- df_agg %>%
      mutate(
        converted = purrr::map(water_per_tree, convert_units), 
        value = sapply(converted, `[[`, "value"),  
        unit = sapply(converted, `[[`, "unit")  
      )
    
    # Create plot
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

  # Info button observer for second graph
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

Die Struktur ist ähnlich wie beim ersten Diagramm, mit einigen wichtigen Unterschieden:

**Zusätzliche Kennzahlen:**

- `total_water = sum(...)` – Gesamtwassermenge pro Bezirk
- `trees_watered = n_distinct(gml_id)` – zählt, wie viele unterschiedliche Bäume gegossen wurden
- `mutate(water_per_tree = total_water / trees_watered)` – berechnet den Durchschnitt: Gesamtwasser geteilt durch Anzahl gegossener Bäume

**Einheitenumrechnung:**

- Auch hier wird `convert_units()` angewendet, um die Werte in passende Einheiten umzurechnen
- Die y-Achse zeigt dynamisch "Durchschnittliche Bewässerung pro Baum" mit der automatisch gewählten Einheit

**Interpretation:**

Diese Kennzahl zeigt, wie intensiv die Bäume gegossen wurden. Ein Bezirk mit hoher Gesamtmenge kann eine niedrige Durchschnittsmenge pro Baum haben, wenn dort sehr viele Bäume nur leicht gegossen wurden. Umgekehrt kann ein Bezirk mit weniger Gesamtmenge eine hohe Durchschnittsmenge aufweisen, wenn dort wenige Bäume besonders intensiv versorgt wurden.
````

## Kritische Schlussfolgerung
Die beiden Visualisierungen machen eindrucksvoll sichtbar, wie stark sich die Ergebnisse verändern, sobald man eine andere Operationalisierung wählt.

Bei der **Gesamtbewässerungsmenge** liegen *Marzahn-Hellersdorf* und *Spandau* klar an der Spitze – Spandau sogar mit deutlichem Abstand. Das deutet darauf hin, dass in diesen Bezirken besonders große Wassermengen eingesetzt wurden, sei es aufgrund vieler gegossener Bäume, hohem individuellem Einsatz oder besonderen lokalen Bedingungen.

Betrachtet man jedoch die **durchschnittliche Bewässerungsmenge pro Baum**, verschiebt sich das Bild vollständig: Hier treten Mitte und Friedrichshain-Kreuzberg wieder hervor. Die Bezirke, die bei der Gesamtmenge führend waren, liegen in dieser Metrik nicht mehr vorn.

**Das zeigt klar**:
Die Wahl der Messgröße – „Wie viel Wasser insgesamt?“ vs. „Wie viel Wasser pro Baum?“ – beeinflusst die Interpretation der Engagementmuster wesentlich. Unterschiedliche Kennzahlen erzählen *unterschiedliche Geschichten*, obwohl sie auf denselben Rohdaten basieren.

Damit wird ein zentrales analytisches Prinzip deutlich:
**Daten sind nicht neutral – die Art ihrer Aufbereitung formt das Narrativ.**

Die Erkenntnis, dass unterschiedliche Kennzahlen zu unterschiedlichen Ergebnissen führen, macht deutlich, dass Engagement und Bewässerungsmuster nicht allein durch Bezirksvergleiche erklärbar sind. Um ein umfassenderes Bild zu erhalten, müssen wir zusätzlich berücksichtigen, **wie sich Bewässerung über die Zeit entwickelt** und wie **die Baumstruktur in den Bezirken aussieht**.

In den nächsten beiden Reitern werden diese Perspektiven vertieft:

- Im **Zeitverlauf** betrachten wir, wie sich Bewässerungsaktivität über Monate und Jahre verändert – und ob sich saisonale Muster, Hitzewellen oder langfristige Trends erkennen lassen.

- In der **Baumstatistik** analysieren wir die Zusammensetzung des Baumbestands: Alter, Gattung, Verteilung im Stadtraum und deren potenzieller Einfluss auf Bewässerungsbedarfe.

Damit erweitern wir die Analyse von einer rein mengenbasierten Betrachtung hin zu einem Verständnis, das **räumliche**, **zeitliche** und **ökologische Faktoren** integriert.