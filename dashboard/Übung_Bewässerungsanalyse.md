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
:class: story

Diese Übung zeigt, wie sich durch unterschiedliche Kennzahlen neue Perspektiven auf dieselben Verwaltungsdaten ergeben. Während zuvor die Zahl der gegossenen Bäume im Mittelpunkt stand, wird nun die Bewässerungsmenge in Litern analysiert.

Wir lernen dabei, wie Daten aggregiert, umgerechnet und visualisiert werden können, um Bezirke hinsichtlich ihrer gesamten Bewässerungsleistung oder der durchschnittlichen Wassermenge pro Baum zu vergleichen. Dadurch wird deutlich, dass die Auswahl der Messgröße – die Operationalisierung – zu verschiedenen analytischen Ergebnissen führen kann: Ein Bezirk, der bei der Anzahl gegossener Bäume gut abschneidet, liegt bei der Wassermenge möglicherweise nicht vorne (und umgekehrt).

```

Um die Unterschiede sichtbar zu machen, entscheidet sich Amir, eine umfassendere Analyse der Bewässerungsmenge durchzuführen:

- Wie viel Wasser wurde insgesamt pro Bezirk ausgebracht?
- Wie viel Wasser erhielt ein durchschnittlich gegossener Baum?
- Und verändert sich dadurch das Ranking der Bezirke?

So möchte Amir untersuchen, wie sich die Wahl der Operationalisierung – also „gezählte Bäume“ vs. „gegossene Liter“ – auf die Ergebnisse auswirkt. Die Frage lautet:
Welche Geschichte erzählen die Daten, wenn man Liter statt Baumanzahl betrachtet?

![alt text](Dashboard_Bewässerungsanalyse.png)
*Abbildung 3: dritter Reiter des Dashboards - Bewässerungsanalyse (Quelle: eigene Ausarbeitung)*

## Die Benutzeroberfläche (UI)
In der ui definieren wir eine neue Tab-Seite namens "stats" mit zwei Diagrammfeldern:

```bash
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

**Erklärung der Elemente:**

- ``tagList(...)``: Wird genutzt, um mehrere UI-Elemente im Titel der Box zu kombinieren – hier der Titeltext und der Informations-Button. So kann der Info-Button elegant im Titelbereich platziert werden.

- ``actionButton``: Erstellt einen klickbaren Button. Dieser Button wird später dazu genutzt, **kontextbezogene Erklärungen oder Hilfetexte** zu öffnen (z. B. via ``observeEvent()`` + ``showModal()``). Der Button hat die ID ``"info_btn_hbpb"`` und wird später verwendet, um eine Erklärung zur Grafik anzuzeigen. Gleiches gilt für ``"info_btn_hbpb2"``

- ``plotOutput(...)``
Platzhalter für ein Diagramm, das im Server-Teil gerendert wird.
 - ``hist_bewaesserung_pro_bezirk`` zeigt die **Gesamtwassermenge pro Bezirk**
 - ``hist_bewaesserung_pro_baum`` zeigt die **durchschnittliche Wassermenge pro gegossenem Baum**

# Server
## Berechnung der Bewässerung

Der erste Teil des Codes, der die **durchschnittliche Bewässerung pro Bezirk** darstellt, berechnet, wie viel Wasser insgesamt in jedem Bezirk verbraucht wurde.

```bash
  output$hist_bewaesserung_pro_bezirk <- renderPlot({
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      group_by(bezirk) %>%
      summarise(total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
      ungroup() %>%
      arrange(desc(total_water))
```

**Erklärung der Elemente:** 

- ``filter(!is.na(bezirk))`` - Entfernt Einträge ohne Bezirksangabe, damit nur gültige Bezirke im Diagramm erscheinen.
- ``group_by(bezirk)`` - Gruppiert die Daten nach Bezirk, damit alle Bäume eines Bezirks gemeinsam ausgewertet werden.
- ``summarise(total_water = sum(...))`` - Berechnet für jeden Bezirk die gesamte Bewässerungsmenge (Summe aller Liter im Zeitraum).
- ``ungroup()`` - Entfernt die Gruppierungsstruktur, um spätere Verarbeitungsschritte nicht zu blockieren.
- ``arrange(desc(total_water))`` - Sortiert die Bezirke nach der Gesamtbewässerungsmenge – größte Werte stehen oben bzw. links im Plot.

```bash
    df_agg <- df_agg %>%
      mutate(
        converted = purrr::map(total_water, convert_units), 
        value = sapply(converted, `[[`, "value"),  
        unit = sapply(converted, `[[`, "unit")  
      )
```

**Erklärung der Elemente:** 
- ``converted = purrr::map(total_water, convert_units)`` - Für jeden Bezirk wird die Gesamtbewässerung (``total_water``) an die Funktion ``convert_units()`` übergeben.
  Diese Funktion entscheidet automatisch:
  - Liter (*L*)
  - Kubikmeter (*m³*)
  - Megaliter (*ML*)
  Das Ergebnis ist eine Liste pro Zeile – bestehend aus **Wert** + **Einheit**.
- ``value = sapply(converted, `[[`, "value"),`` - Extrahiert aus jedem Listenelement den umgerechneten **numerischen Wert**, z. B.:
  - **2.3**
  - **150**
  - **0.85**
  Das macht die Werte direkt für die Achse im Diagramm nutzbar.
- ``unit = sapply(converted, `[[`, "unit")`` - Extrahiert die zugehörige **Einheit** (z. B. "ML", "m³", "L"`), damit später die y-Achse korrekt beschriftet werden kann.



    # Create plot
    ```bash
    ggplot(df_agg, aes(x = reorder(bezirk, -value), y = value, fill = bezirk)) +
      geom_bar(stat = "identity", color = "white", alpha = 0.7, width = 0.8) +
      labs(
        title = NULL,  # Title is already in the box header
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
  
**Erklärung der Elemete**:
- Initialisiert die Grafik mit dem Datensatz ``df_agg``.
- ``reorder(bezirk, -value)`` sortiert die Bezirke absteigend nach Bewässerungsmenge.
- ``y = value`` stellt die berechnete / umgerechnete Wassermenge dar.
- ``fill = bezirk`` weist jedem Bezirk eine eigene Farbe zu.
- ``stat = "identity"`` bedeutet: die Balkenhöhe entspricht direkt dem numerischen Wert (keine Häufigkeit).
- **Weiße Umrandung** trennt die Balken klar voneinander.
- **Transparenz** (``alpha = 0.7``) sorgt für einen angenehmen, nicht zu harten Look.
- ``width = 0.8`` macht die Balken etwas schmaler für bessere Lesbarkeit.
- **Kein Titel** – dieser kommt bereits von der Box im UI.
- **X-Achse**: Bezirke in Berlin.
- **Y-Achse**: Dynamisch generiert je nach Einheit (Liter, m³ oder ML), die vorher berechnet wurde.
- ``theme_light()``: helles, sauberes Standard-Layout.
- **Legende ausgeblendet**, da Farben für die Interpretation nicht relevant sind.
- **X-Achsentexte gedreht** (55°), um Überlappung zu vermeiden.
- **Vertikale Gitterlinien entfernt** – der Plot wirkt klarer und ruhiger.
- **Plot-Margin erhöht**, damit Achsenbeschriftungen nicht abgeschnitten werden.
- Verwendet die **ggplot-Standardfarbpalette**.
- **Keine manuelle Farbzuordnung** nötig.

  # Info button observer
  ```bash
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

**Erklärung der Elemente**
- ``observeEvent()`` - Reagiert auf ein Ereignis – in diesem Fall das Klicken des Info-Buttons.
- ``input$info_btn_hbpb`` - ID des Buttons aus der Benutzeroberfläche. Sobald dieser geklickt wird, öffnet sich das Modal.
- ``showModal()`` - Zeigt ein Pop-up-Fenster über der Anwendung. Nützlich für Hinweise, Hilfetexte und Zusatzinfos.
- ``modalDialog()`` - Erzeugt das Dialogfenster selbst. Es enthält:
  - einen **Titel**,
  - **HTML-formatierten Text**, z. B. fett <strong> oder Listen,
  - eine **Schließen-Schaltfläche**.
- ``HTML("…")`` - Ermöglicht echte HTML-Struktur (Absätze, Listen, Hervorhebungen), statt einfachem Text.
- ``easyClose = TRUE`` - Das Fenster kann auch durch Klick außerhalb des Modals geschlossen werden.
- ``modalButton("Schließen")`` - Fügt unten rechts den Schließen-Button hinzu.


```bash

  # Plot: Durchschnittliche Bewässerung pro gegossenem Baum
  output$hist_bewaesserung_pro_baum <- renderPlot({
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%   # <--- exclude NA only for the plot
      group_by(bezirk) %>%
      summarise(
        total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
        trees_watered = n_distinct(gml_id)  # Count unique trees that were watered
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

Der zweite Plot ist strkuturell ähnlich zum ersten, jedoch mit kleinen Unterschieden, weil:
- eine zusätzliche Kennzahl berechnet wird (```trees_watered```)
- eine neue Metrik entsteht (```water_per_tree```)

Die übrige Struktur (Plotaufbau, Theme, Farben, Layout) bleibt gleich.

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