---
lang: de-DE
---

(trees)=
# Einfügen Baumstatistik
```{admonition} Story
:class: story

Amir Weber möchte nachvollziehen, inwieweit die Art der Bäume und ihrer Umgebung das freiwillige Engagement beim Gießen beeinflussen. Nachdem er bereits zeitliche Muster analysiert hat, richtet er seinen Blick nun auf räumliche Faktoren (Baumdichte) sowie baumartspezifische Merkmale.

```

```{admonition} Zweck dieser Übung
:class: lernziele

In dieser Übung wollen wir herausfinden, ob die Baumart und räumliche Faktoren (Baumdichte) einen Einfluss auf das Engagement beim Gießen haben. Wir üben:

- Baumarten und deren Verteilung in Bezirken statistisch zu beschreiben,
- relative Häufigkeiten und Top-Listen (z. B. meistgegossene Arten) zu interpretieren,
- Baumdichte im Verhältnis zur Bezirksfläche quantitativ zu berechnen,

und einfache Hypothesen über das Engagement – etwa bevorzugte Gattungen oder Nachbarschaftseffekte – mit Daten zu prüfen.

```

Nachdem zuvor untersucht wurde, wie Pflanzjahr und Zeitverlauf das Gießverhalten beeinflussen, richtet sich der Blick nun auf räumliche und baumartspezifische Unterschiede innerhalb Berlins. Verschiedene Bezirke weisen sehr unterschiedliche Baumstrukturen auf: Manche besitzen eine hohe Dichte, andere sind von wenigen dominanten Gattungen geprägt (Nachweis dazu fehlt - woraus wird das zu diesem Zeitpunkt abgeleitet?).

Amir Weber will also überprüfen:

- Ob bestimmte Baumgattungen häufiger gegossen werden als andere.
- Ob die Baumdichte das Gießverhalten beeinflusst.
Er vermutet, dass dicht bepflanzte Straßen oder Kieze mehr Interaktionen begünstigen – etwa nach dem Motto: „Wenn ich schon meinen Baum gieße, mache ich den daneben auch gleich mit.“

Die Funktion dieses Reiters besteht also darin, die Baumverteilung nach Bezirken sichtbar zu machen, die am häufigsten gegossenen Baumarten zu identifizieren und die Baumdichte im Verhältnis zur Bezirksfläche zu analysieren, um mögliche Muster im Engagement zu erkennen.

Damit dient der Reiter als Grundlage, um zu verstehen, welche strukturellen Faktoren im Stadtraum das Engagement der Gießenden möglicherweise begünstigen.

## Benutzeroberfläche (UI)

```bash
dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Baumstatistik", tabName = "engagement", icon = icon("hands-helping"))
```

![alt text](Dashboard_Baumstatistik_1.png)
*Abbildung 5: Baumverteilung nach Bezirken und Baumgattungen.
Die Abbildung zeigt die Verteilung der Bäume in den Berliner Bezirken, aufgeschlüsselt nach Baumgattungen. Die Anzahl der Bäume ist für jeden Bezirk als gestapeltes Balkendiagramm dargestellt, wobei die einzelnen Farbsegmente unterschiedliche Baumgattungen repräsentieren. Über einen Schieberegler kann die Anzahl der angezeigten, häufigsten Baumgattungen (Top-N) interaktiv angepasst werden, während weniger häufige Gattungen unter „Sonstige“ zusammengefasst sind. (Quelle: eigene Ausarbeitung)*

Das obenstehende Diagramm ist ein Balkendiagramm, genauer gesagt ein gestapeltes Balkendiagramm, das mehrere Informationsebenen gleichzeitig vermittelt. Der zentrale Mehrwert dieser Darstellungsform liegt darin, sowohl die Gesamtanzahl der Bäume pro Bezirk als auch deren Zusammensetzung nach Gattungen in einer einzigen Visualisierung zu vereinen. Die Balkenlänge zeigt auf einen Blick, welche Bezirke den größten Baumbestand haben, während die farbigen Segmente innerhalb jedes Balkens die Artenvielfalt und deren relative Anteile offenlegen. Dies ermöglicht direkte Vergleiche zwischen Bezirken: Nutzer:innen können nicht nur erkennen, dass Bezirk A mehr Bäume hat als Bezirk B, sondern auch, ob beide eine ähnliche Gattungsverteilung aufweisen oder ob bestimmte Arten in einzelnen Bezirken dominieren. Die Anpassung über den Top-N-Schieberegler reduziert visuelle Komplexität und ermöglicht es, den Fokus je nach Fragestellung auf die häufigsten Gattungen zu legen oder eine detailliertere Aufschlüsselung zu betrachten. Somit verbindet das gestapelte Balkendiagramm quantitative Präzision mit visueller Übersichtlichkeit und macht komplexe, mehrdimensionale Daten intuitiv erfassbar. Balkendiagramme zählen zu den etabliertesten Darstellungswerkzeugen der Datenvisualisierung – ihre breite Anwendung in dieser Fallstudie spiegelt ihre Vielseitigkeit und Lesbarkeit wider.

```bash
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
```

![alt text](Dashboard_Baumstatistik_2.png)
*Abbildung 6: Verteilung der Baumgattungen.
Die Abbildung zeigt die prozentuale Verteilung der Baumgattungen im Berliner Baumbestand in Form eines Kreisdiagramms. Über ein Auswahlfeld kann der betrachtete Bezirk festgelegt werden, wodurch sich die dargestellte Verteilung entsprechend anpasst. Die einzelnen Kreissegmente repräsentieren die Anteile der jeweiligen Baumgattungen am Gesamtbestand des ausgewählten Bezirks. (Quelle: eigene Ausarbeitung)*

Das obenstehende Diagramm ist ein Kreisdiagramm (auch Tortendiagramm genannt), das die prozentuale Zusammensetzung der Baumgattungen innerhalb eines Bezirks visualisiert. Der zentrale Mehrwert dieser Darstellungsform liegt in ihrer Fähigkeit, Anteile und Proportionen intuitiv erfassbar zu machen: Nutzer:innen erkennen auf einen Blick, welche Gattungen den Baumbestand dominieren und welche nur eine untergeordnete Rolle spielen. Die Kreisform vermittelt das Konzept des "Ganzen" unmittelbar – alle Segmente zusammen ergeben 100% des Baumbestands im gewählten Bezirk. Dies erleichtert das Verständnis relativer Größenverhältnisse, etwa wenn eine Gattung ein Viertel oder die Hälfte aller Bäume ausmacht. Die interaktive Bezirksauswahl ermöglicht zudem gezielte Vergleiche: Nutzer:innen können erkunden, ob bestimmte Gattungen in verschiedenen Stadtteilen unterschiedlich stark vertreten sind. Im Gegensatz zum Balkendiagramm, das absolute Zahlen und Mengenvergleiche betont, fokussiert das Kreisdiagramm auf die innere Struktur und Diversität des Baumbestands eines einzelnen Bezirks.

```bash
       
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
             choices = c("Alle", sort(unique(df_merged$bezirk))),
             selected = "Alle"
           ),
           plotOutput("tree_species_pie", height = "500px")
         ),         
```

![alt text](Dashboard_Baumstatistik_3.png)
*Abbildung 7: Top 10 gegossene Baumgattungen.
Die Abbildung zeigt die Top 10 gegossenen Baumgattungen in Berlin in Form eines horizontalen Balkendiagramms. Über ein Auswahlfeld kann der betrachtete Bezirk festgelegt werden, wodurch sich die dargestellten Werte entsprechend anpassen. Die Balken repräsentieren die absolute Anzahl gegossener Bäume je Gattung, wobei die Linde mit deutlichem Abstand an erster Stelle steht, gefolgt von Ahorn (ca. 250.000) und weiteren Gattungen mit jeweils deutlich geringeren Werten. Die x-Achse zeigt die Anzahl gegossener Bäume, die y-Achse die Baumgattungen. (Quelle: eigene Ausarbeitung)*

```bash         
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
           width = 6,
           plotOutput("tree_density_area", height = "500px")
         )
       ),       
```

![alt text](Dashboard_Baumstatistik_4.png)
*Abbildung 8: Baumdichte pro km²
Die Abbildung zeigt die Baumdichte pro km² in den verschiedenen Berliner Bezirken in Form eines vertikalen Balkendiagramms. Die Balken repräsentieren die jeweilige Baumdichte, wobei Friedrichshain-Kreuzberg die höchste Dichte aufweist. Die x-Achse zeigt die Bezirke, die y-Achse die Anzahl der Bäume pro km². Die Darstellung ermöglicht einen direkten Vergleich der Baumdichte zwischen den zwölf Berliner Bezirken. (Quelle: eigene Ausarbeitung)*

```bash
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
             choices = c("Alle", sort(unique(df_merged$bezirk))),
             selected = "Alle"
           ),
           plotOutput("top_watered_species", height = "500px")
         )
       )
     ),
```

## Server
```bash  
# 1. Stacked Bar Chart - Baumverteilung mit Gattungen
  output$tree_distribution_stacked <- renderPlot({
    top_genera <- df_merged %>%
      filter(!is.na(gattung_deutsch)) %>%   
      count(gattung_deutsch, sort = TRUE) %>%
      head(input$top_n_species) %>%
      pull(gattung_deutsch)
```

- Zählt alle Baumarten.
- Wählt die **Top-N meistverbreiteten Baumgattungen** (über UI steuerbar).
- Speichert sie in ```top_genera```.

```bash
    df_agg <- df_merged %>%
      filter(!is.na(bezirk)) %>%  
      mutate(gattung_grouped = ifelse(gattung_deutsch %in% top_genera, gattung_deutsch, "Sonstige")) %>%
      group_by(bezirk, gattung_grouped) %>%
      summarise(count = n(), .groups = "drop") %>%
      group_by(bezirk) %>%
      mutate(percentage = count / sum(count) * 100) %>%
      ungroup()
```

- Bäume ohne Bezirk werden entfernt.
- Alle Gattungen **außer den Top-N** werden zu **„Sonstige“** zusammengefasst.
- Für jeden Bezirk + Artengruppe wird **gezählt**, wie viele Bäume es gibt.
- Zusätzlich wird der **prozentuale Anteil** innerhalb des Bezirks berechnet.
- Die Ergebnisstruktur ist ein typisches **Bezirks-Gattungs-Aggregat**.

```bash
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
```

Der Plot zeigt somit:
- **Welche Gattungen in welchem Bezirk dominieren**,
- wie groß der Anteil der **Sonstigen** ist,
- und wie sich Bezirke in ihrer Baumstruktur unterscheiden.
 
```bash
  # 2. Pie Chart - Gattungsverteilung
  output$tree_species_pie <- renderPlot({
    filtered_data <- df_merged
    if (input$pie_bezirk != "Alle") {
      filtered_data <- filtered_data %>%
        filter(bezirk == input$pie_bezirk)
    }
    

    df_agg <- filtered_data %>%
      filter(!is.na(gattung_deutsch)) %>%  
      count(gattung_deutsch, sort = TRUE) %>%
      mutate(
        gattung_grouped = ifelse(row_number() <= 10, gattung_deutsch, "Sonstige")
      ) %>% # row_number vergibt laufende Reihenfolgenummern innerhalb einer sortierten Tabelle
      group_by(gattung_grouped) %>%
      summarise(count = sum(n), .groups = "drop") %>%
      arrange(desc(count)) %>%
      mutate(
        percentage = count / sum(count) * 100,
        label = paste0(gattung_grouped, "\n", round(percentage, 1), "%")
      )
    
    ggplot(df_agg, aes(x = "", y = count, fill = gattung_grouped)) +
      geom_bar(stat = "identity", width = 1, color = "white", size = 0.5) +
      coord_polar("y", start = 0) + # ein Balkendiagramm wird durch coord_polar("y") zu einem Pie-Chart umgewandelt
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
  
```bash
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

Neu ist hier lediglich eine kleine Lookup-Tabelle mit Bezirksflächen, die über ```left_join()``` ergänzt wird, um die Baumdichte (Bäume pro km²) berechnen zu können. Alles andere entspricht bekannten Mustern der vorherigen Plots.

```bash
  # 4. Top 10 gegossene Baumgattungen
  output$top_watered_species <- renderPlot({
    filtered_data <- df_merged %>%
      filter(!is.na(bewaesserungsmenge_in_liter)) 
    
    if (input$engagement_bezirk != "Alle") {
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

Neu sind die gleichzeitige Berechnung zweier Kennzahlen (```count``` und ```total_water```) sowie die Sortierung nach Häufigkeit mit anschließender Auswahl der Top 10. Der Rest des Codes folgt bereits bekannten Mustern aus früheren Aggregationen und Visualisierungen.

## Schlussfolgerung
Die Analyse zeigt deutlich, dass der Berliner Baumbestand stark von wenigen Gattungen dominiert wird. **Linden machen berlinweit rund 55,6 % aller Straßenbäume aus**, was bedeutet, dass viele Muster der Verteilung zwangsläufig von dieser einen Gattung geprägt werden. Die Betrachtung der Gattungen ist daher zwar interessant, besitzt jedoch **nur begrenzte Aussagekraft**, da sie strukturelle Eigenheiten der Berliner Bepflanzung widerspiegelt und weniger das Verhalten der Bürgerinnen und Bürger.

Beim Vergleich der Bezirke treten klare Unterschiede in der räumlichen Verteilung zutage. **Friedrichshain-Kreuzberg und Mitte weisen die höchsten Baumdichten pro km² auf**, was typisch für kompakte, urbane Bezirke mit vielen Straßenbäumen ist. Gleichzeitig besitzen **Mitte, Pankow und Charlottenburg-Wilmersdorf die größten absoluten Baumzahlen**, was vor allem auf großflächige Areale mit Mischbeständen und Gehölzflächen zurückzuführen ist.

Setzt man diese Befunde in Bezug zu den Engagement-Daten, deutet sich ein Muster an:
**Bezirke mit hoher Baumdichte zeigen tendenziell auch mehr Bürgerengagement**.
Dies ist plausibel, da in dichter bebauten Gebieten mehr Menschen auf engem Raum auf Bäume treffen und häufiger die Möglichkeit haben, einzelne Straßenbäume zu gießen.

Die Baumgattungen selbst liefern hingegen **keinen starken Erklärungswert für das Engagement**. Es zeigt sich zwar, welche Gattungen besonders häufig gegossen werden, doch dies korreliert in erster Linie damit, wie verbreitet die jeweilige Gattung im Stadtbild ist. Dass Linden oft gegossen werden, liegt also vor allem daran, dass sie fast überall stehen – nicht daran, dass sie besonders pflegebedürftig oder beliebter wären.

**Kernbotschaft**
*Die Verteilung des Engagements folgt eher der Dichte und Sichtbarkeit von Bäumen in den Bezirken als der Art der Bäume. Baumgattungen erklären wenig – räumliche Faktoren jedoch sehr viel.*
