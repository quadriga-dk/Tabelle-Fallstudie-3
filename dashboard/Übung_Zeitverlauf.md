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
Zeitverlauf der Baumbewässerung (Quelle: eigene Ausarbeitung)
``` 

## Benutzeroberfläche (UI)

### Seitenleiste mit Navigation

Zunächst fügt Amir einen weiteren Menüpunkt zur Navigation hinzu, um den Zeitverlauf-Tab zugänglich zu machen.

````{dropdown} Code
```r
dashboardSidebar(
  sidebarMenu(
    menuItem("Zeitverlauf", tabName = "stats", icon = icon("bar-chart"))
  )
)
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- `menuItem(...)` erzeugt einen neuen Navigationspunkt:
  - `"Zeitverlauf"` ist der sichtbare Name
  - `tabName = "stats"` verknüpft diesen Menüpunkt mit dem Inhaltsbereich
  - `icon("bar-chart")` fügt ein Diagramm-Symbol zur visuellen Orientierung hinzu

Dieser Menüpunkt reiht sich in die bestehende Navigation ein – neben Startseite und Karte.
````

### Inhaltsbereich mit Diagramm und Filtern

Der Inhaltsbereich enthält das Liniendiagramm sowie Filteroptionen, mit denen Nutzer:innen die Darstellung anpassen können.

````{dropdown} Code

```r
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
      ),
      
      plotlyOutput("trend_water", height = "500px")
    )
  )
)
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Struktur des Inhaltsbereichs:**

- `box(...)` gruppiert alle Elemente visuell
  - `title` enthält die Überschrift und einen Info-Button
  - `status = "primary"` bestimmt die Farbe
  - `width = 12` bedeutet volle Seitenbreite

**Filterelemente:**

- `sliderInput("trend_year", ...)` – ein Schieberegler zur Auswahl eines Pflanzjahr-Bereichs
  - Die Min/Max-Werte passen sich automatisch an die vorhandenen Daten an
  - Nutzer:innen können gezielt nur junge Bäume, nur Altbestand oder ein bestimmtes Jahrzehnt untersuchen
  
- `selectInput("trend_bezirk_pj", ...)` – ein Dropdown zur Bezirksauswahl
  - `multiple = TRUE` ermöglicht die Auswahl mehrerer Bezirke gleichzeitig
  - Standardwert ist "Alle"

**Visualisierung:**

- `plotlyOutput("trend_water", ...)` – reserviert Platz für das interaktive Diagramm
  - Die tatsächliche Grafik wird im Server erzeugt
  - Plotly ermöglicht Zoomen, Tooltips und interaktive Achsen

Diese Struktur gibt Nutzer:innen volle Kontrolle: Sie können sowohl den Zeitraum als auch die betrachteten Bezirke frei anpassen und so gezielt nach Mustern suchen.
````

## Server

### Daten vorbereiten und filtern

Zunächst müssen die Rohdaten so vorbereitet werden, dass nur relevante Einträge berücksichtigt werden – also Bäume, die tatsächlich gegossen wurden und für die ein Pflanzjahr bekannt ist.

````{dropdown} Code
```r
filtered_data <- df_merged %>%
  filter(!is.na(bewaesserungsmenge_in_liter)) %>%  
  filter(!is.na(pflanzjahr))

if (!"Alle" %in% input$trend_bezirk_pj && length(input$trend_bezirk_pj) > 0) {
  filtered_data <- filtered_data %>%
    filter(bezirk %in% input$trend_bezirk_pj)
}

filtered_data <- filtered_data %>%
  filter(pflanzjahr >= input$trend_year[1] & pflanzjahr <= input$trend_year[2])

```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**Grundfilterung:**  
- `filter(!is.na(bewaesserungsmenge_in_liter))` – nur Bäume, die tatsächlich gegossen wurden
- `filter(!is.na(pflanzjahr))` – nur Bäume mit bekanntem Pflanzjahr

**Bezirksfilter:**  
- Wenn "Alle" ausgewählt ist → keine Einschränkung
- Wenn bestimmte Bezirke ausgewählt wurden → behalte nur diese

**Pflanzjahr-Filter:**  
- `input$trend_year[1]` ist der untere Wert des Schiebereglers
- `input$trend_year[2]` ist der obere Wert
- So können Nutzer:innen gezielt z. B. nur Bäume aus den Jahren 1950–2020 betrachten

Durch diese mehrstufige Filterung erhält Amir einen sauberen Datensatz, der genau die Bäume enthält, die für die aktuelle Analyse relevant sind.
````

### Bewässerungsmenge pro Pflanzjahr berechnen

Jetzt aggregiert Amir die Daten: Für jedes Pflanzjahr wird die gesamte gegossene Wassermenge sowie die Anzahl der bewässerten Bäume berechnet.

````{dropdown} Code
```r
plot_data <- filtered_data %>%
  group_by(pflanzjahr) %>%
  summarize(
    total_water = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
    count_trees = n_distinct(gml_id)
  ) %>%
  ungroup()
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- `group_by(pflanzjahr)` gruppiert die Daten nach Pflanzjahr
- `summarize(...)` berechnet für jede Gruppe:
  - `total_water` – die Summe aller gegossenen Liter
  - `count_trees` – die Anzahl unterschiedlicher Bäume (`n_distinct` zählt jeden Baum nur einmal)
- `ungroup()` löst die Gruppierung wieder auf

 
Eine Tabelle mit drei Spalten: Pflanzjahr, Gesamtwassermenge, Anzahl Bäume  

Diese Aggregation beantwortet die zentrale Frage: „Welche Baumjahrgänge wurden besonders intensiv bewässert?"
````

### Liniendiagramm erstellen

Mit den aggregierten Daten erstellt Amir nun ein Liniendiagramm, das den Trend über die Pflanzjahre zeigt.

````{dropdown} Code
```r
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

ggplotly(plot, tooltip = "text") %>%
  layout(hovermode = "closest")
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**ggplot2-Grundstruktur:**

- `aes(x = pflanzjahr, y = total_water)` definiert, was auf den Achsen dargestellt wird
- `geom_line(...)` zeichnet die Verbindungslinie zwischen den Datenpunkten
- `geom_point(...)` setzt Punkte auf jeden Datenpunkt
  - `aes(text = ...)` definiert, was beim Überfahren mit der Maus angezeigt wird:
    - Pflanzjahr
    - Gesamtwassermenge (formatiert mit Tausenderpunkten)
    - Anzahl der bewässerten Bäume
- `theme_minimal()` sorgt für ein aufgeräumtes Design
- `labs(...)` beschriftet die Achsen

**Interaktivität durch Plotly:**

- `ggplotly(...)` wandelt das statische ggplot in ein interaktives Plotly-Diagramm um
- `tooltip = "text"` zeigt die zuvor definierten Tooltips beim Hover an
- `layout(hovermode = "closest")` sorgt dafür, dass immer der nächstgelegene Datenpunkt angezeigt wird

Durch diese Kombination aus ggplot2 und Plotly entsteht ein Diagramm, in dem Nutzer:innen hineinzoomen, Achsen verschieben und präzise Werte ablesen können.
```` 

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