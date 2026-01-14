---
lang: de-DE
---

(landing-page)=
# Einfügen Zeitverlauf
```{admonition} Story
:class: story

Nachdem Amir Weber die Bezirke und Bewässerungsmengen verglichen hat, interessiert ihn nun, **welche Rolle das Alter der Bäume** spielt.
Er fragt sich, ob bestimmte Jahrgänge besonders häufig gegossen werden — etwa jüngere Bäume, die nach wissenschaftlicher Empfehlung mehr Wasser benötigen, oder ältere Bäume, die empfindlicher auf Trockenstress reagieren.
Um dieser Frage nachzugehen, betrachtet er die gesamt gegossene Wassermenge pro Pflanzjahr und erhält so einen Überblick darüber, welche Baumkohorten am stärksten vom Engagement profitieren.

```

```{admonition} Zweck dieser Übung
:class: lernziele

Diese Übung zeigt:
- wie Bewässerungsdaten nach Pflanzjahren aggregiert werden können;
- welche Baumjahrgänge besonders viel oder wenig Wasser erhalten;
- und wie zeitliche oder altersbezogene Faktoren Hinweise auf Pflegebedarf und Gießverhalten liefern.

```

Nachdem die räumlichen Unterschiede der Bewässerung betrachtet wurden, richtet Amir Weber seinen Fokus nun auf **zeitliche und altersbezogene Faktoren des Engagements**. Denn Bürgerengagement beim Gießen wird nicht nur durch den Bezirk geprägt, sondern auch durch:

- zeitliche Muster (z. B. verändert sich die Bewässerungsaktivität über die Jahre?),

- Baumalter bzw. Pflanzjahr (wissenschaftlich ist belegt, dass besonders junge und teilweise auch sehr alte Bäume ein erhöhtes Wasservolumen benötigen),

- sowie infrastrukturelle Faktoren wie die Nähe zu Pumpen.

Um diese Aspekte besser zu verstehen, untersucht er zwei zentrale Fragen:

**1. Wie hat sich die Bewässerungsmenge über die Jahre entwickelt?**
→ Gibt es Trends, Spitzenjahre oder Rückgänge?

**2. Werden bestimmte Baumjahrgänge (Pflanzjahre) häufiger gegossen als andere?**
→ Deutet das auf besondere Pflegebedarfe oder engagiertes Handeln hin?

Die folgenden Visualisierungen zeigen deshalb sowohl **Trends im Jahresverlauf** als auch die **gesamt gegossene Wassermenge pro Pflanzjahr**, um das Zusammenspiel zwischen Baumalter, Bedarf und Engagement sichtbar zu machen. Eine chronologische Trenddarstellung ermöglicht es, zeitliche Entwicklungen und Muster im Gießverhalten zu erkennen. Nutzer:innen können nachvollziehen, wie sich die Bewässerungsaktivität über die Jahren hinweg verändert. Solche Erkenntnisse helfen nicht nur bei der Einschätzung des aktuellen Bedarfs, sondern auch bei der Planung zukünftiger Gießaktionen. Darüber hinaus macht die Visualisierung Schwankungen sichtbar. Für die Community kann die Trendlinie zudem motivierend wirken: Ein Aufwärtstrend zeigt wachsendes Engagement, während ein Abfall zum Handeln aufrufen kann. Langfristig liefert die chronologische Darstellung wertvolle Daten für die Evaluation von Maßnahmen und hilft zu verstehen, wann und warum Menschen aktiv werden – eine wichtige Grundlage für die Weiterentwicklung von Plattformen und gezielten Kommunikationsstrategien.

```{figure} Dashboard_Zeitverlauf.png
---
name: Dashboard Karte
alt: Ein Screenshot, der zeigt Dashboard Karte
width: 600px
---
Abbildung 4: Zeitverlauf der Baumbewässerung (Quelle: eigene Ausarbeitung)
``` 

## Benutzeroberfläche (UI)
```bash
dashboardHeader(title = "Gieß den Kiez Dashboard"),
dashboardSidebar(
  sidebarMenu(
    menuItem("Zeitverlauf", tabName = "stats", icon = icon("bar-chart")),
```

```bash
tabItem(
  tabName = "stats",
  fluidRow(
    box(
      title = tagList(
        "Trend der Bewässerung je Pflanzjahr",
        div(
          actionButton("info_btn_tdbjp", label = "", icon = icon("info-circle")),
          style = "position: absolute; right: 15px; top: 5px;"
        )
      ),
      status = "primary",
      solidHeader = TRUE,
      width = 12,
```

### Filterelemente (Inputs)
```bash
fluidRow(
  column(
    width = 6,
    sliderInput(
      "trend_year",
      "Pflanzjahre filtern:",
      min = 1900,
      max = max(df_merged$pflanzjahr, na.rm = TRUE),
      value = c(min(df_merged$pflanzjahr, na.rm = TRUE),
                max(df_merged$pflanzjahr, na.rm = TRUE)),
      step = 1,
      sep = ""
    )
  ),
```
- **sliderInput("trend_year")** erlaubt es, einen Bereich an Pflanzjahren auszuwählen.
- Der Bereich passt sich automatisch den Daten an (*dynamische min/max-Werte*).
- Sinn: gezielt nur junge Bäume, nur Altbestand oder ein bestimmtes Jahrzehnt untersuchen.

```bash
column(
  width = 6,
  selectInput(
    "trend_bezirk_pj",
    "Bezirk auswählen:",
    choices = c("Alle", sort(unique(df_merged$bezirk))),
    selected = "Alle",
    multiple = TRUE
  )
)
```

- **selectInput()** ermöglicht eine Auswahl von Bezirken – auch mehrfach.
- Standartwert ist "Alle". 
- Nutzer können so Trends für einzelne Bezirke, Gruppen oder ganz Berlin untersuchen.

### Visualisierung
```bash
plotlyOutput("trend_water", height = "500px")
```

- Zeigt den interaktiven Plot an, der später in ```server.R``` erzeugt wird.
- **Plotly** ermöglicht Zoomen, Tooltipps und interaktive Achsen.
- Visualisiert wird die **gesamt gegossene Wassermenge pro Pflanzjahr** (x = Pflanzjahr, y = Liter).

## Server
### Daten filtern
```bash
filtered_data <- df_merged %>%
  filter(!is.na(bewaesserungsmenge_in_liter)) %>%  
  filter(!is.na(pflanzjahr))
```

- Es werden **nur Bäume berücksichtigt, die tatsächlich gegossen wurden**.
- Zusätzlich werden nur Bäume mit **bekanntem Pflanzjahr** einbezogen.

### Bezirk-Filter anwenden
```bash
if (!"Alle" %in% input$trend_bezirk_pj && length(input$trend_bezirk_pj) > 0) {
  filtered_data <- filtered_data %>%
    filter(bezirk %in% input$trend_bezirk_pj)
}
```

- Wenn Nutzer **einen oder mehrere Bezirke** ausgewählt haben, werden ausschließlich diese einbezogen.
-Wenn „Alle“ ausgewählt ist → keine Einschränkung.

### Pflanzjahr-Regler anwenden
```bash
filtered_data <- filtered_data %>%
  filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2])
```

- Der Slider schränkt den Zeitraum ein (z. B. 1950–2020).
- Sehr praktisch: Nutzer*innen können so **nur junge Bäume, nur Altbestand** oder ein **bestimmtes Jahrzehnt** analysieren.

### Aggregation: Wasser pro Pflanzjahr
```bash
plot_data <- filtered_data %>%
  group_by(pflanzjahr) %>%
  summarize(
    total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
    count_trees = n_distinct(gml_id)
  ) %>%
  ungroup()
```

Für jedes Pflanzjahr wird berechnet:

- **total_water** → Wie viel Wasser wurde auf alle Bäume dieses Jahrgangs gegossen?
- **count_trees** → Wie viele individuelle Bäume aus diesem Jahrgang wurden gegossen?

→ liefert eine Zeitreihe nach Pflanzjahren – wichtig für die Frage:
„Werden junge oder alte Bäume stärker bewässert?“

### Erstellung des ggplot2-Liniendiagramms
```bash
plot <- ggplot(plot_data, aes(x = pflanzjahr, y = total_water)) +
  geom_line(color = "#2E86AB", size = 1) +
  geom_point(
    aes(text = paste0("Pflanzjahr: ", pflanzjahr,
                      "<br>Gesamtwasser: ", format(total_water, big.mark = ".", decimal.mark = ","), " L",
                      "<br>Anzahl Bäume: ", count_trees)),
    size = 2, color = "#2E86AB"
  ) +
  theme_minimal() +
  labs(
    x = "Pflanzjahr",
    y = "Gesamtbewässerung (Liter)"
  ) +
  theme(panel.grid.minor = element_blank())
```

- **Linie** zeigt den Trend über die Pflanzjahre.
- **Punkte** sind datenreich → im Hover erscheinen:
    - Pflanzjahr
    - gesamte Bewässerungsmenge
    - Anzahl der beteiligten Bäume
- **theme_minimal()** sorgt für ein aufgeräumtes Diagramm.

### Plotly-Interaktivität hinzufügen
```bash
ggplotly(plot, tooltip = "text") %>%
  layout(hovermode = "closest")
```

- Macht das Diagramm interaktiv.
- Tooltips zeigen die präzise Werte pro Produkt.
- Nutzer*innen können hineinzoomen, Achsen verschieben, etc. 

### Kritische Diskussion
Der dargestellte Trend der Bewässerungsmenge je Pflanzjahr zeigt zwar über den gesamten Zeitraum betrachtet einen **grundsätzlich steigenden Verlauf**, allerdings lässt sich **kein klar lineares oder systematisches Muster** erkennen. Stattdessen wirkt der Verlauf stark **heterogen**, mit ausgeprägten Spitzen und Einbrüchen in einzelnen Jahrgängen.

Diese Ausschläge sprechen eher dafür, dass **strukturelle Eigenschaften der Bäume** – wie Alter, Größe und Wasserbedarf – eine wesentlich größere Rolle spielen als der zeitliche Trend selbst. Insbesondere wird sichtbar, dass **jüngere Bäume**, also jene mit einem **neueren Pflanzjahr**, deutlich häufiger und intensiver gegossen werden. Das deckt sich mit den fachlichen Erwartungen:

- Jungbäume haben ein **unterentwickeltes Wurzelsystem**,
- sind schlechter in der Lage, **tiefere Bodenfeuchte zu erschließen**,
- und benötigen daher laut gärtnerischer Empfehlungen (vgl. z. B. Giess-den-Kiez) **mehr Bewässerung**, besonders in den ersten Jahren nach der Pflanzung.

Die beobachteten starken Peaks deuten also weniger auf ein „mehr Engagement über die Jahre“ hin, sondern vielmehr darauf, dass sich das Engagement **selektiv** auf jene Bäume konzentriert, die **besonders pflegebedürftig** sind.

### Einordnung der Unsicherheiten

Mehrere Faktoren schränken die Interpretierbarkeit des Trends ein:

- Die **Anzahl der Bäume je Pflanzjahr** ist nicht konstant; einzelne Jahrgänge sind stark unter- oder überrepräsentiert.
- Das Bewässerungsverhalten hängt zusätzlich vom **lokalen Kontext** (Bezirk, Pumpendichte, Freiwilligenaktivität) ab, der im Aggregat verschleiert wird.
- Stark schwankende Jahrgangswerte könnten auch auf **Einzelbäume mit extrem vielen Gießungen** zurückzuführen sein.

### Überleitung zum nächsten Analyse-Schritt

Die bisherige Betrachtung nach Pflanzjahren legt nahe, dass das Engagement nicht nur zeitlich, sondern vor allem **strukturell** geprägt ist — insbesondere durch Unterschiede im Alter der Bäume und damit verbundenem Wasserbedarf. Um diese Muster besser zu verstehen, ist es sinnvoll, das Bewässerungsverhalten im Kontext der **räumlichen und biologischen Baumstruktur** zu betrachten.