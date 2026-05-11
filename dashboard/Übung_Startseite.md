---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

(landing-page)=
# Eine Startseite gestalten


```{admonition} Zweck dieser Übung 
:class: lernziele

- Der Aufbau eines Dashboards als Form der Visualisierung in der Verwaltungswissenschaft umfasst die Gestaltung einer übersichtlichen Startseite für ein R-Shiny-Dashboard. Diese soll zentrale Informationen klar strukturiert darstellen, den Nutzer:innen einen schnellen Überblick verschaffen und gleichzeitig als intuitiver Einstiegspunkt in die Anwendung dienen.

```

Die **Startseite** seines Dashboards soll als zentrale Übersicht und Einstiegspunkt dienen. Hier werden die wichtigsten Kennzahlen sofort sichtbar:

- **Gesamtanzahl der Bäume**  
- **Anzahl gegossener Bäume**

Damit liefert die Startseite einen kompakten, aber aussagekräftigen Überblick über das Engagement der Bürger:innen. Sie beantwortet bereits auf den ersten Blick zentrale Fragen der Analyse:  

**1. Wie groß ist der Gesamtbestand an Bäumen?**  
**2. Wie viele davon wurden aktiv bewässert?**

So ist die Startseite nicht nur auf erstem Blick intuitiv und verständlich, sondern auch funktional der ideale Ausgangspunkt für die weitere Erkundung der Daten.

Für den Einstieg arbeiten Sie mit dem Datensatz *„Gieß den Kiez – Bewässerungsdaten“* von **GovData**. Dieser Datensatz bietet detaillierte Informationen darüber, wann, wo und wie viel gegossen wurde. Er eignet sich ideal, um erste Analysen zum Gießverhalten zu erstellen, da er sowohl zeitliche als auch räumliche Bezüge enthält und öffentlich zugänglich ist.


```{figure} ../assets/Dashboard_Startseite.png
---
name: Dashboard Startseite
alt: Ein Screenshot, der zeigt Dashboard Startseite
---
Startseite des Dashboards; Die Startseite zeigt zwei Kacheln mit der Gesamtzahl der Bäume in Berlin sowie der Anzahl der bereits gegossenen Bäume, die eine Teilmenge des gesamten Baumbestands darstellen. Zusätzlich steht ein Filter zur Verfügung, mit dem der Baumbestand nach Bezirken ausgewählt und angezeigt werden kann. (Quelle: eigene Ausarbeitung)
``` 

Für die Startseite seiner Anwendung möchte Amir eine **kompakte Kennzahlenübersicht** erstellen. Diese soll den Nutzer:innen helfen, sofort die Größenordnung des Gießverhaltens einzuschätzen – etwa, wie viele Bäume gegossen wurden, wie oft und mit welchem Wasservolumen. Der Mehrwert einer Startseite mit Kennzahlenkacheln umfasst also die schnellere Orientierung - Nutzer:innen erfassen auf einen Blick den aktuellen Stand der Gießaktivitäten, ohne durch die Anwendung navigieren zu müssen. Dies spart Zeit und erleichtert den Einstieg. Die Kennzahlen dienen als Ausgangspunkt: man kann von dort aus zu detaillierteren Visualisierungen und Analysen navigieren.

Zusätzlich plant er **Filtermöglichkeiten** nach **Bezirk**, um die Kennzahlen gezielt einzugrenzen und regionale Unterschiede sichtbar zu machen. Damit lassen sich die Daten auch in einer feineren Granularität betrachten – von stadtweiter Übersicht bis hin zu einzelnen Bezirken. Die auf der Startseite dargestellten Kennzahlen werden dabei ausschließlich als **absolute Werte** angezeigt und **nicht ins Verhältnis** zueinander gesetzt, da sie zunächst eine verlässliche Datengrundlage vermitteln sollen, bevor weiterführende Analysen und Vergleiche auf den Folgeseiten möglich werden.

Als Nächstes bauen Sie die Startseite des Dashboards mit R. Nach jedem Codeabschnitt werden kurz die verwendeten Techniken und Befehle erklärt. Dabei widmen Sie sich sowohl der Benutzeroberfläche (UI), als auch der Serverseite des R-Shiny-Dashboards.

## Benutzeroberfläche (UI)

````{admonition} Platzierung des UI Codes
:class: hinweis

Alle in diesem Abschnitt folgenden Code-Bausteine für die Benutzeroberfläche gehören in die `ui`-Struktur, die Sie in den Vorbereitungen definiert haben:

```r
ui <- dashboardPage(
  dashboardHeader(...),
  dashboardSidebar(
    # ... Hier kommt der Code für die Seitenleiste hin ...
  ),
  dashboardBody(
    # ... Hier kommt der Code für den Inhaltsbereich hin ...
  )
)
```
````

Das System Ihrer Benutzeroberfläche wird aus zwei Teilen bestehen:

- einer Seitenleiste (``sidebarMenu``) mit der Navigation

- einem Inhaltsbereich (``tabItem``) mit:

    - sog. ValueBoxen für wichtige Kennzahlen

    - Dropdowns zur Auswahl des Zeitraums und des Bezirks

Somit können Sie eine übersichtliche Navigationsstruktur etablieren.

### Seitenleiste mit der Navigation (sidebarMenu)
Die Seitenleiste enthält Menüpunkte, die jeweils einen Namen und ein Symbol zur besseren Orientierung bekommen.
Hier können Sie zwischen verschiedenen Dashboard-Bereichen wechseln (etwa von der Startseite zur Kartenansicht oder zur Bewässerungsanalyse).

````{dropdown} Code
```r
dashboardSidebar(
  sidebarMenu(
    menuItem("Startseite", tabName = "start", icon = icon("home"))
  )
)
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

`sidebarMenu(...)` erzeugt die Navigationsleiste. Jedes
 `menuItem(...)` darin repräsentiert einen Menüpunkt:
- `"Startseite"` ist der sichtbare Text
- `tabName = "start"` verknüpft diesen Menüpunkt mit dem zugehörigen Inhaltsbereich, welcher Inhalt angezeigt werden soll
- `icon("home")` fügt ein kleines Haus-Symbol zur visuellen Orientierung hinzu

Später können Sie weitere Menüpunkte ergänzen – etwa für die Karte oder die Baumstatistik. Das Prinzip bleibt gleich: Jedes `menuItem` erhält einen Namen, ein Symbol und eine eindeutige `tabName`, die ihn mit dem entsprechenden Inhaltsbereich verbindet.
````

### Inhaltsbereich

Auf der Startseite des Dashboards visualisieren Sie die beiden zentralen Kennzahlen: die Gesamtzahl der Bäume sowie die Anzahl der bewässerten Bäume. Über einen integrierten Filter kann die Anzeige zudem auf spezifische Bezirke eingegrenzt werden.

````{dropdown} Code
```r
tabItems(
      tabItem(
        tabName = "start",
        fluidRow(
          box(width = 12,
              # Label: Einfacher Text, Zahl hervorgehoben
              div(style = "padding: 10px 15px 0 15px;",
                  p(style = "font-size: 15px; margin-bottom: 2px;",
                    "Gesamter Baumbestand in Berlin:"),
                  span(style = "font-size: 28px; font-weight: bold; color: #3C6E97; margin-top: 0;",
                    textOutput("total_trees_label"))
              ),
          
              # Dropdown-Filter in voller Breite darüber
              fluidRow(
                column(width = 12,
                       div(style = "padding: 10px 15px;", 
                           selectInput("bezirk", "Bezirk auswählen (Mehrfachauswahl möglich):", 
                                       choices = c("Alle Bezirke", sort(na.omit(unique(df_merged$bezirk)))), 
                                       selected = "Alle Bezirke", multiple = TRUE)
                       )
                )
              ),
            
              # Zwei dynamische Kacheln nebeneinander
              fluidRow(
                valueBoxOutput("total_trees_filtered", width = 6),
                valueBoxOutput("total_tree_watered", width = 6)
              )
          )
        )
      )
    )
```
````
````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**`box(...)`** gruppiert alle Elemente visuell mit:
- `width = 12` (volle Breite – 12 ist die maximale Spaltenanzahl im Raster)

**Der Layout-Aufbau (vertikal strukturiert):**
- **Das Text-Label (`textOutput("total_trees_label")`)**: Mithilfe von `span(...)` und `p(...)` wird die stadtweite Kennzahl als Text ergänzt durch eine formatierte Zahl hervorgehoben.
- **Der Filterbereich (`fluidRow` & `selectInput`)**: Das Dropdown-Menü nimmt die volle Breite ein (`column(width = 12)`) und steht direkt über den Kacheln.
- **Die Kacheln (`fluidRow` & `valueBoxOutput`)**: Die verbleibenden beiden Kacheln teilen sich nun horizontal den Platz. Durch `width = 6` passen genau zwei Stück nebeneinander.

**`selectInput(...)`** erstellt das Dropdown-Menü (Auswahlliste) mit:
- `"bezirk"` ist dy diesen Input später im Server erkennt → `input$bezirk`
- `"Bezirk auswählen ..."` ist der Text,er Name, unter dem Shin der über dem Menü steht.
- `choices = c("Alle Bezirke", sort(na.omit(unique(df_merged$bezirk))))` definiert die Auswahlmöglichkeiten:
  - `unique(df_merged$bezirk)` bedeutet: Jeden Bezirk nur einmal anzeigen.
  - `na.omit(...)` entfernt leere oder fehlerhafte Felder (NAs).
  - `sort(...)` sortiert die Bezirke alphabetisch (A-Z).
  - `c(...)` macht daraus eine Liste und setzt den Eintrag **“Alle Bezirke”** ganz nach oben.
- `selected = "Alle Bezirke"` legt fest, dass beim Start alle Bezirke angezeigt werden.
- `multiple = TRUE` heißt: Man darf mehrere Bezirke gleichzeitig auswählen.

Diese Filterauswahl wird im Server verarbeitet und bestimmt, welche Daten für die dynamischen Kacheln berechnet werden.
````


Mit diesem Aufbau haben Sie die **Struktur** seiner Startseite definiert:
- Eine klare Navigation über die Seitenleiste
- Zwei zentrale Kennzahlen in prominenter Position
- Ein Filter zur Eingrenzung nach Bezirken

Was noch fehlt, ist die Intelligenz: Die tatsächliche Berechnung der Kennzahlen und die Reaktion auf Nutzer:inneneingaben. Dafür ist der Server zuständig.

## Server – Die Logik hinter dem Dashboard

````{admonition} Platzierung des Server Codes
:class: hinweis

Alle in diesem Abschnitt folgenden Code-Bausteine für den Server gehören in die `server`-Funktion, die Sie in den Vorbereitungen definiert haben:

```r
server <- function(input, output) { 
  # Hier folgt der R-Code zur Datenverarbeitung...
}
```
````

In Shiny beobachtet der Server kontinuierlich die Eingabefelder (`input$...`) und **aktualisiert automatisch** alle Ausgaben (`output$...`), die von diesen Eingaben abhängen.

Für Ihr Dashboard bedeutet das konkret:
- Sobald Nutzer:innen einen anderen Bezirk auswählen, wird der Datensatz im Hintergrund neu gefiltert
- Die Kennzahlen werden neu berechnet und sofort in den ValueBoxen angezeigt
- Alles geschieht ohne Verzögerung, ohne manuelles Nachladen

### Daten filtern mit reaktiven Funktionen
Amir beginnt mit der zentralen Aufgabe: Die Daten müssen je nach Auswahl der Nutzer:innen gefiltert werden. Dafür erstellt er eine **reaktive Funktion**, die immer dann neu ausgeführt wird, wenn sich die Eingaben ändern.

````{dropdown} Code
```r
filteredData <- reactive({
  req(input$bezirk)
  
  df <- df_merged 
  df_filtered <- df
  
  # Filter nach Bezirk
  if (!("Alle Bezirke" %in% input$bezirk)) {
    df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
  }
  
  df_filtered
})
```
````

````{admonition} Erläuterung des Codes
:class: hinweis, dropdown

**`reactive({...})`**  
- erzeugt eine reaktive Funktion, die automatisch neu berechnet wird, wenn sich Eingaben ändern.
- ist wie ein **intelligenter Beobachter**: Sobald sich `input$bezirk` ändert, wird filteredData() neu berechnet.

**`req(input$bezirk)`**  
- sorgt dafür, dass die Funktion nur ausgeführt wird, wenn bestimmte Eingaben vorhanden sind.

**Dynamische Anzeige**
Damit das Dashboard Entscheidungen treffen kann (z. B. beim Filtern oder Anpassen von Ansichten), nutzt  es `if`-Anweisungen und Operatoren:

```r
if (Bedingung) {
  # wird ausgeführt, wenn die Bedingung wahr ist
} else {
  # wird ausgeführt, wenn die Bedingung falsch ist
}
```

**Die Filterlogik**  
```r
if (!("Alle Bezirke" %in% input$bezirk)) {
  df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
}
``` 
Diese Bedingung implementiert die eigentliche Filterung:
- Falls "Alle Bezirke" in der Auswahl enthalten ist → keine Einschränkung, alle Daten bleiben erhalten
- Falls nur bestimmte Bezirke ausgewählt wurden → behalte nur die Zeilen, deren `bezirk` in der Auswahl (`input$bezirk`) vorkommt

**Warum ist diese Struktur wichtig?**  
Sie müssen den Filtercode nur einmal schreiben. Alle Visualisierungen und Kennzahlen, die `filteredData()` verwenden, greifen automatisch auf die aktuell gefilterte Version der Daten zu. Das vermeidet Redundanz und macht den Code wartbar.

````

### Praktisches Beispiel für das Dashboard

````{dropdown} Code
```r
output$dynamic_tree_box <- renderUI({
  if ("Baumbestand Stand 2025" %in% input$start_year) {
    valueBoxOutput("total_trees")
  } else {
    valueBoxOutput("total_tree_watered")
  }
})
```
````
````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- ``renderUI(...)``: erzeugt dynamische Elemente und erlaubt es, UI-Elemente zur Laufzeit zu verändern – je nach Nutzereingabe.
- Abhängig von der Auswahl (``input$start_year``) wird eine andere Kennzahl angezeigt.

**Beispiel:**  
Wird nur „2020–2024“ ausgewählt, zeigt dynamic_tree_box nur gegossene Bäume an.

````

### ValueBoxes: Kennzahlen anzeigen

Nun können Sie die Kennzahlen mit Inhalten füllen. In der UI wurden diese bereits als Label `textOutput("total_trees_label")` und zwei Kacheln `valueBoxOutput("total_trees_filtered")` und `valueBoxOutput("total_tree_watered")` angelegt – jetzt definieren Sie, was darin erscheinen soll.


````{dropdown} Alle Bäume
```r
output$total_trees_label <- renderText({
  formatC(n_distinct(df_merged$gisid), format = "d", big.mark = ".")
})

output$total_trees_filtered <- renderValueBox({
  valueBox(
    formatC(n_distinct(filteredData()$gisid), format = "d", big.mark = "."),
    "erfasste Bäume (Bezirksauswahl)",
    icon = icon("tree"),
    color = "olive" 
  )
})
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- ``output$total_trees_label`` ist das, was an das simple UI-Element ``textOutput("total_trees_label")`` gesendet wird.
- ``renderText({...})`` berechnet reinen Text, anstelle einer visuell aufwändigen Kachel.
- ``n_distinct(...)``: zählt eindeutige Bäume (verhindert doppelte Zählungen).
- ``formatC(...)`` formatiert die Nummer ansprechend mit Tausendertrennzeichen.
````

````{dropdown} Gegossene Bäume
```r
output$total_tree_watered <- renderValueBox({
  valueBox(
    formatC(n_distinct(filteredData()$gisid[!is.na(filteredData()$timestamp)]), 
            format = "d", big.mark = "."),
    "bewässerte Bäume (Bezirksauswahl)",
    icon = icon("tint"),
    color = "blue"
  )
})
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

Hier gibt es einen entscheidenden Unterschied zum Text-Label oben:
- Statt `df_merged` verwenden Sie nun `filteredData()` – die reaktive Datenquelle, die sich blitzschnell je nach gewählten Bezirken ändert.
- `!is.na(filteredData()$timestamp)` filtert zusätzlich: Es werden nur jene Bäume der Auswahl gezählt, die mindestens einmal gegossen wurden (erkennbar an einem gültigen Zeitstempel).
- `icon("tint")` (ein Tropfen-Symbol) und `color = "blue"` heben die Wasserthematik visuell hervor.

**Warum diese bewusste Unterscheidung?**  
- Das **Text-Label** ist eine konstante Referenzgröße – es zeigt immer die Zahl von ganz Berlin.
- Die **Kacheln** darunter sind agil und reagieren auf die Auswahl im Drop-Down-Menü. 

Durch diese bewusste Trennung ermöglichen Sie den Nutzer:innen, das Engagement in einzelnen Bezirken mit der Gesamtsituation zu vergleichen.
````

````{dropdown} Automatisches Abwählen von Bezirken
```r
prev_bezirk <- reactiveVal("Alle Bezirke")
  
  observeEvent(input$bezirk, {
    if (is.null(input$bezirk)) {
      updateSelectInput(session, "bezirk", selected = "Alle Bezirke")
      prev_bezirk("Alle Bezirke")
      return()
    }
    
    curr_bezirk <- input$bezirk
    prev <- prev_bezirk()
    
    if ("Alle Bezirke" %in% curr_bezirk && !("Alle Bezirke" %in% prev)) {
      updateSelectInput(session, "bezirk", selected = "Alle Bezirke")
      prev_bezirk("Alle Bezirke")
    } else if ("Alle Bezirke" %in% curr_bezirk && length(curr_bezirk) > 1) {
      new_selection <- curr_bezirk[curr_bezirk != "Alle Bezirke"]
      updateSelectInput(session, "bezirk", selected = new_selection)
      prev_bezirk(new_selection)
    } else {
      prev_bezirk(curr_bezirk)
    }
  }, ignoreNULL = FALSE, ignoreInit = TRUE)
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

Dieser Code-Block löst ein logisches Problem: Aktuell ist es möglich die Option "Alle Bezirke" gleichzeitig mit spezifischen Bezirken (z.B. "Treptow-Köpenick") auswählen. Der Code macht das Dropdown-Menü „intelligent“ und schließt diese Optionen gegenseitig aus.

**`prev_bezirk <- reactiveVal("Alle Bezirke")`** 
Dies ist eine Art Kurzzeitgedächtnis (`reactiveVal`). Die App merkt sich hier, was der Nutzer *vor* dem letzten Klick ausgewählt hatte. Der Startwert ist „Alle Bezirke“.

**`observeEvent(input$bezirk, { ... })`** 
Dies ist ein Beobachter. Er wartet im Hintergrund und führt den Code in den geschweiften Klammern `{}` *jedes Mal* aus, sobald der Nutzer im Dropdown-Menü (`input$bezirk`) etwas anklickt oder ändert.

**`req(input$bezirk)`**
Ein Sicherheitscheck. Der Code bricht hier sofort ab, falls die Auswahl komplett leer ist (z. B. wenn der Nutzer alles herausgelöscht hat).

**Die if-else-Bedingung:**
Zuerst werden der aktuelle Zustand (`curr_bezirk`) und der vorherige Zustand (`prev`) in Variablen gespeichert. Dann prüft die App drei Fälle:

*   **Fall 1 (`if`):** `("Alle Bezirke" %in% curr_bezirk && !("Alle Bezirke" %in% prev))`
    *Wurde „Alle Bezirke“ gerade frisch angeklickt?* (Es ist in der aktuellen Auswahl, war aber vorher nicht da).
    *Reaktion:* `updateSelectInput` zwingt das Dropdown-Menü dazu, nur noch „Alle Bezirke“ anzuzeigen. Alle vorher ausgewählten Einzelbezirke werden gelöscht.
*   **Fall 2 (`else if`):** `("Alle Bezirke" %in% curr_bezirk && length(curr_bezirk) > 1)`
    *Wurde ein neuer Bezirk angeklickt, während „Alle Bezirke“ noch aktiv war?* („Alle Bezirke“ ist in der Auswahl, aber die Liste ist jetzt länger als 1).
    *Reaktion:* „Alle Bezirke“ wird aus der aktuellen Auswahl herausgefiltert (`curr_bezirk != "Alle Bezirke"`) und das Dropdown-Menü wird auf diese neue, um „Alle Bezirke“ bereinigte Auswahl aktualisiert.
*   **Fall 3 (`else`):** 
    Wenn weder Fall 1 noch Fall 2 zutreffen, speichert die App einfach die aktuelle Auswahl im Kurzzeitgedächtnis (`prev_bezirk`), um für den nächsten Klick bereit zu sein.

**`ignoreInit = TRUE`**
Dies steht ganz am Ende und sagt der App: „Führe diese Überprüfung nicht sofort beim Start der App aus, sondern erst, wenn der Nutzer wirklich das erste Mal selbst klickt.“
````

### Einheiten clever umrechnen

Bei der Darstellung von Wassermengen stehen Sie nun vor einer Herausforderung: Die Rohdaten enthalten Literangaben, die je nach Größenordnung unterschiedlich formatiert werden sollten. Eine Menge von 50 Litern ist überschaubar, aber 1.250.000 Liter sind schwer zu erfassen. Von Vorteil wäre es, wenn das Dashboard automatisch in sinnvolle Einheiten umrechnet – etwa Kubikmeter (m³) oder Megaliter (ML).

Um dies zu erreichen, erstellen Sie Hilfsfunktionen, die die Umrechnung übernehmen und gleichzeitig die passende Einheit auswählen.

````{dropdown} Code
```r
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
    "m³" = "Kubikmeter", 
    "L" = "Liter",
    unit
  )
}
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

**`convert_units(liters)`**  
Diese Funktion nimmt einen Wert in Litern entgegen und entscheidet anhand der Größenordnung, welche Einheit am sinnvollsten ist:
- `if (liters >= 1e6)` – Falls die Menge 1.000.000 Liter oder mehr beträgt, rechne in Megaliter (ML) um (`1e6` = 1.000.000)
- `else if (liters >= 1e3)` – Falls die Menge 1.000 Liter oder mehr beträgt, rechne in Kubikmeter (m³) um (`1e3` = 1.000)
- `else` – Für kleinere Mengen bleiben Liter (L) die passende Einheit
- `round(..., 2)` rundet auf zwei Nachkommastellen für bessere Lesbarkeit
- Die Funktion gibt sowohl den umgerechneten Wert als auch die Einheit als Liste zurück

**`full_unit(unit)` – Einheiten ausschreiben**  
Diese Hilfsfunktion wandelt Kurzformen in ausgeschriebene Bezeichnungen um. Das verbessert die Verständlichkeit für Nutzer:innen:
- `switch(unit, ...)` ist eine elegante Alternative zu mehreren `if`-Anweisungen – je nach Wert des Parameters wird der passende Text zurückgegeben
- Falls keine Übereinstimmung gefunden wird, gibt die Funktion die Kurzform unverändert zurück

**Beispiel:**  
Ein Wert von `1.250.000 Litern` wird zu `1,25 ML`, angezeigt als `"1,25 Mega Liter"`.
````

Das Dashboard ist nun funktionsfähig: Nutzer:innen können Bezirke auswählen und sehen sofort, wie viele Bäume in diesen Bezirken gegossen wurden – im Verhältnis zum Gesamtbestand. Die Trennung von UI und Server ermöglicht es Amir, später weitere Analysen hinzuzufügen, ohne die bestehende Struktur grundlegend ändern zu müssen.


Überblick der Funktionen/Operatoren


| Funktion/Operator | Bedeutung |
|---|---|
| `<-` | weist einer Variable einen Wert zu |
| `if (...) / else` | Bedingte Ausführung |
| `%in%` | prüft, ob ein Wert in einer Liste ist |
| `switch()` | wählt abhängig vom Wert einen Fall |
| `filter()` | filtert Zeilen in einem Datensatz |
| `is.na()` | prüft auf fehlende Werte |
| `%>%` | Pipe-Operator: leitet Ergebnis einer Funktion weiter |
| `reactive({})` | erstellt einen reaktiven Ausdruck im Server |
| `req()` | stellt sicher, dass ein Eingabewert vorhanden ist |
| `renderValueBox()` | rendert eine `valueBox` reaktiv im Server |
| `valueBox()` | erstellt eine farbige Kennzahlen-Box in der UI |
| `valueBoxOutput()` | Platzhalter in der UI für eine reaktive `valueBox` |
| `icon()` | bindet ein Font-Awesome-Icon ein |
| `selectInput()` | erstellt ein Dropdown-Auswahlmenü |
| `fluidRow()` | erstellt eine responsive Zeile im Grid-Layout |
| `column()` | definiert eine Spaltenbreite innerhalb einer `fluidRow` |
| `box()` | erstellt eine umrahmende Inhaltsbox in der UI |
| `tabItems()` / `tabItem()` | strukturiert Inhalte in Tab-Bereiche |
| `dashboardBody()` | definiert den Hauptinhaltsbereich des Dashboards |
| `dashboardSidebar()` | definiert die Seitenleiste |
| `sidebarMenu()` / `menuItem()` | erstellt ein Navigationsmenü in der Seitenleiste |
| `dashboardHeader()` | definiert den Kopfbereich mit Titel |
| `dashboardPage()` | erstellt das Grundlayout der Shiny-Dashboard-Seite |
| `shinyApp()` | startet die Shiny-Anwendung mit UI und Server |


````{admonition} Gesamter Code
:class: solution, dropdown

```r
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home"))
    )
  )  
),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "start",
        fluidRow(
          box(width = 12,
              # Label: Einfacher Text, Zahl hervorgehoben
              div(style = "padding: 10px 15px 0 15px;",
                  p(style = "font-size: 15px; margin-bottom: 2px;",
                    "Gesamter Baumbestand in Berlin:"),
                  span(style = "font-size: 28px; font-weight: bold; color: #3C6E97; margin-top: 0;",
                    textOutput("total_trees_label"))
              ),
          
              # Dropdown-Filter in voller Breite darüber
              fluidRow(
                column(width = 12,
                       div(style = "padding: 10px 15px;", 
                           selectInput("bezirk", "Bezirk auswählen (Mehrfachauswahl möglich):", 
                                       choices = c("Alle Bezirke", sort(na.omit(unique(df_merged$bezirk)))), 
                                       selected = "Alle Bezirke", multiple = TRUE)
                       )
                )
              ),
            
              # Zwei dynamische Kacheln nebeneinander
              fluidRow(
                valueBoxOutput("total_trees_filtered", width = 6),
                valueBoxOutput("total_tree_watered", width = 6)
              )
          )
        )
      )
    )
  )

# Server-Logik
server <- function(input, output, session) {
  
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
  
  # --- Reaktive Bezirksauswahl ---
  prev_bezirk <- reactiveVal("Alle Bezirke")
  
  observeEvent(input$bezirk, {
    if (is.null(input$bezirk)) {
      updateSelectInput(session, "bezirk", selected = "Alle Bezirke")
      prev_bezirk("Alle Bezirke")
      return()
    }
    
    curr_bezirk <- input$bezirk
    prev <- prev_bezirk()
    
    if ("Alle Bezirke" %in% curr_bezirk && !("Alle Bezirke" %in% prev)) {
      updateSelectInput(session, "bezirk", selected = "Alle Bezirke")
      prev_bezirk("Alle Bezirke")
    } else if ("Alle Bezirke" %in% curr_bezirk && length(curr_bezirk) > 1) {
      new_selection <- curr_bezirk[curr_bezirk != "Alle Bezirke"]
      updateSelectInput(session, "bezirk", selected = new_selection)
      prev_bezirk(new_selection)
    } else {
      prev_bezirk(curr_bezirk)
    }
  }, ignoreNULL = FALSE, ignoreInit = TRUE)
  
  # ---- Gefilterte Daten ----
  filteredData <- reactive({
    req(input$bezirk)
    
    df <- df_merged
    df_filtered <- df
    
    if (!("Alle Bezirke" %in% input$bezirk)) {
      df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
    }
    
    df_filtered
  })
  
  # ---- ValueBoxes ----
  
  # Label 1: Gesamtzahl (Immer ganz Berlin)
  output$total_trees_label <- renderText({
    formatC(n_distinct(df_merged$gisid), format = "d", big.mark = ".")
  })
  
  # Box 2: Gefilterte Zahl (Reagiert auf den Filter)
  output$total_trees_filtered <- renderValueBox({
    valueBox(
      formatC(n_distinct(filteredData()$gisid), format = "d", big.mark = "."),
      "erfasste Bäume (Bezirksauswahl)",
      icon = icon("tree"),
      color = "olive" 
    )
  })
  
  # Box 3: Gegossene Bäume (Reagiert auf den Filter)
  output$total_tree_watered <- renderValueBox({
    valueBox(
      formatC(n_distinct(filteredData()$gisid[!is.na(filteredData()$timestamp)]), 
              format = "d", big.mark = "."),
      "bewässerte Bäume (Bezirksauswahl)",
      icon = icon("tint"),
      color = "blue"
    )
  })
}

shinyApp(ui = ui, server = server)
```
````

## Was muss Amir beim Bau eines Dashboards beachten? *(vorläufig)* 
Bei der Gestaltung der Startseite sollten Sie darauf achten, dass die wichtigsten Informationen klar, gut lesbar und ohne unnötige Ablenkungen präsentiert werden. Besonders für einen ersten Überblick gilt: Weniger ist oft mehr.

Für die Startseite heißt das vor allem:

- **Klarheit**: Keine überladene Darstellung, eindeutige Beschriftungen, selbsterklärende Kennzahlen.

- **Lesbarkeit**: Vermeidung von 3D-Elementen oder komplexen Grafiken, wenn ein einfacher Indikator genügt.

- **Fokus**: Nur die wirklich zentralen Kennzahlen aufnehmen, um den Blick nicht zu zerstreuen.

- **Konsistenz**: Einheitliche Farb- und Formatwahl, damit Nutzer:innen sich sofort orientieren können.

- **Kontext**: Kurze Hinweise oder Legenden, damit die Zahlen richtig interpretiert werden können.

## Leitfrage und Ausblick

Die zentrale Leitfrage von Ihrer Fallstudie lautet: **Wo ist das höchste Bürgerengagement?**

Die Startseite des Dashboards ermöglicht einen ersten Überblick darüber, in welchen Bezirken absolut gesehen die meisten Bäume gegossen wurden. In absoluten Zahlen zeigt sich dabei das höchste Engagement bei den Bürger:innen in **Mitte**, gefolgt von **Tempelhof-Schöneberg** und **Charlottenburg-Wilmersdorf**. Für eine abschließende Beantwortung der Leitfrage reicht diese Betrachtung jedoch nicht aus, da ohne Normalisierung – etwa durch das Verhältnis gegossener Bäume zur Gesamtbaumzahl je Bezirk – keine validen Vergleiche zwischen den Bezirken gezogen werden können. 

**Übung:**
```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question = [
    {
        "question": "Berechnen Sie nun für jeden Berliner Bezirk das relative Bürger:innenengagement, indem Sie die Anzahl der gegossenen Bäume zur Gesamtbaumzahl des jeweiligen Bezirks ins Verhältnis setzen. Welcher Bezirk weist dabei den höchsten Anteil auf?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Friedrichshain-Kreuzberg",
                "correct": True,
                "feedback": """✓ Korrekt! """
            },
            {
                "answer": "Mitte",
                "correct": False,
                "feedback": """× Nicht korrekt!"""
            },
            {
                "answer": "Spandau",
                "correct": False,
                "feedback": """× Nicht korrekt!"""
            },
            {
                "answer": "Neukölln",
                "correct": False,
                "feedback": """× Nicht korrekt!"""
            }
        ]
    }
]
display_quiz(question, colors=colors.jupyterquiz)
```

<br>
Damit ist die Leitfrage zwar beantwortet, jedoch nicht die **Geschichten hinter den Zahlen**.

Es bleibt offen, welche **Kontextfaktoren** zu den Unterschieden führen könnten:

- **Räumlich** – etwa Unterschiede zwischen Bezirken oder die Baumdichte in einem Gebiet.

- **Zeitlich** – wie sich das Engagement im Jahresverlauf entwickelt oder, ob das Pflanzjahr der Bäume eine Rolle spielt.

````{admonition} Daraus ergeben sich neue Fragen:
:class: frage-feedback

- Wo treten die höchsten Ausprägungen des Bürgerengagements auf?

- Welche zusätzlichen Datensätze lassen sich einbeziehen, um die Analyse zu vertiefen?

- Wie können interaktive Dashboards diese Faktoren verständlich und vergleichbar darstellen?
````

Mit diesen Überlegungen ist der Grundstein für die **nächste Übung** gelegt – den Bau eines interaktiven Dashboards, das nicht nur die Kernaussage liefert, sondern auch die Hintergründe sichtbar macht.
