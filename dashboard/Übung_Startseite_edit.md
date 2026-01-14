---
lang: de-DE
---

(landing-page)=
# Eine Startseite für das Dashboard gestalten (Edit)
```{admonition} Story
:class: story
Amir möchte sich zunächst einen schnellen Überblick verschaffen: Wie werden Bäume in Berlin gegossen, und wie engagieren sich die Bürger:innen dabei? Bei seiner Recherche stößt er auf die Plattform *Gieß den Kiez*. Besonders beeindruckt ihn, wie anschaulich die Daten dort visualisiert sind – das möchte er für seine eigene R-Shiny-Anwendung übernehmen.
```

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

Für den Einstieg arbeitet Amir mit dem Datensatz *„Gieß den Kiez – Bewässerungsdaten“* von **GovData**. Dieser Datensatz bietet detaillierte Informationen darüber, wann, wo und wie viel gegossen wurde. Er eignet sich ideal, um erste Analysen zum Gießverhalten zu erstellen, da er sowohl zeitliche als auch räumliche Bezüge enthält und öffentlich zugänglich ist.

![alt text](Dashboard_Startseite.png)
*Abbildung 1: Startseite des Dashboards; Die Startseite zeigt zwei Kacheln mit der Gesamtzahl der Bäume in Berlin sowie der Anzahl der bereits gegossenen Bäume, die einen Teilmenge des gesamten Baumbestands darstellen. Zusätzlich steht ein Filter zur Verfügung, mit dem der Baumbestand nach Bezirken ausgewählt und angezeigt werden kann. (Quelle: eigene Ausarbeitung)*

Für die Startseite seiner Anwendung entscheidet sich Amir für eine **kompakte Kennzahlenübersicht**. Diese soll den Nutzer:innen helfen, sofort die Größenordnung des Gießverhaltens einzuschätzen – etwa, wie viele Bäume gegossen wurden, wie oft und mit welchem Wasservolumen. Der Mehrwert einer Startseite mit Kennzahlenkacheln umfasst also die schnellere Orientierung - Nutzer:innen erfassen auf einen Blick den aktuellen Stand der Gießaktivitäten, ohne durch die Anwendung navigieren zu müssen. Dies spart Zeit und erleichtert den Einstieg. Die Kennzahlen dienen als Ausgangspunkt: man kann von dort aus zu detaillierteren Visualisierungen und Analysen navigieren.

Zusätzlich plant er **Filtermöglichkeiten** nach **Bezirk**, um die Kennzahlen gezielt einzugrenzen und regionale Unterschiede sichtbar zu machen. Damit lassen sich die Daten auch in einer feineren Granularität betrachten – von stadtweiter Übersicht bis hin zu einzelnen Bezirken. Die auf der Startseite dargestellten Kennzahlen werden dabei ausschließlich als **absolute Werte** angezeigt und **nicht ins Verhältnis** zueinander gesetzt.

Als Nächstes bauen wir die Startseite des Dashboards mit R. Nach jedem Codeabschnitt werden kurz die verwendeten Techniken und Befehle erklärt. Wir widmen uns sowohl der Benutzeroberfläche (UI) als auch der Serverseite des R-Shiny-Dashboards.

## Benutzeroberfläche (UI)
Amir entscheidet sich für ein System der Benutzeroberfläche, die aus zwei Teilen besteht:

- einer Seitenleiste (``sidebarMenu``) mit der Navigation

- einem Inhaltsbereich (``tabItem``) mit:

    - ValueBoxen für wichtige Kennzahlen

    - Dropdowns zur Auswahl des Zeitraums und des Bezirks

Somit lässt sich eine übersichtliche Navigationsstruktur etablieren.

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

`sidebarMenu(...)` erzeugt die Navigationsleiste. Jeder `menuItem(...)` darin repräsentiert einen Menüpunkt:
- `"Startseite"` ist der sichtbare Text
- `tabName = "start"` verknüpft diesen Menüpunkt mit dem zugehörigen Inhaltsbereich, welcher Inhalt angezeigt werden soll
- `icon("home")` fügt ein kleines Haus-Symbol zur visuellen Orientierung hinzu

Später kann Amir weitere Menüpunkte ergänzen – etwa für die Karte oder die Baumstatistik. Das Prinzip bleibt gleich: Jeder `menuItem` erhält einen Namen, ein Symbol und eine eindeutige `tabName`, die ihn mit dem entsprechenden Inhaltsbereich verbindet.
````

### Inhaltsbereich

Amir möchte, dass die beiden wichtigsten Zahlen – Gesamtzahl der Bäume und Anzahl gegossener Bäume. Darunter soll ein Filter es ermöglichen, die Ansicht auf bestimmte Bezirke einzugrenzen.

````{dropdown} Code
```r
tabItems(
  tabItem(
    tabName = "start",
    box(
      title = "Overview",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      
      fluidRow(
        valueBoxOutput("total_trees", width = 6),
        valueBoxOutput("total_tree_watered", width = 6)
      ),
      
      fluidRow(
        column(
          width = 6,
          selectInput(
            "bezirk",
            "Bezirk auswählen:",
            choices = c("Alle", unique(df_merged$bezirk)),
            selected = "Alle",
            multiple = TRUE
          )
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
- `title = "Overview"` – die Überschrift der Box
- ``status = "primary"`` (Farbe)
- ``solidHeader = TRUE`` (fester Rand)
- ``width = 12`` (volle Breite – 12 ist die maximale Spaltenanzahl)

**`fluidRow(...)`** ist das zentrale Element für horizontales Layout. Ohne diese Anweisung würden alle Elemente untereinander gestapelt. 
Mit `fluidRow` stehen die beiden Kennzahlenkacheln nebeneinander:
- `valueBoxOutput("total_trees", width = 6)` – reserviert Platz für die erste Kennzahl (halbe Breite)
- `valueBoxOutput("total_tree_watered", width = 6)` – reserviert Platz für die zweite Kennzahl (halbe Breite)

````

#### Filter für Bezirke hinzufügen

Unterhalb der Kennzahlen fügt Amir einen Filter hinzu, mit dem Nutzer:innen einzelne oder mehrere Bezirke auswählen können.
````{dropdown} Code
```r
selectInput(
            "bezirk",
            "Bezirk auswählen:",
            choices = c("Alle", unique(df$bezirk)),
            selected = "Alle",
            multiple = TRUE
          )
          
selectInput("start_year", ...)

```
````
````{admonition} Erläuterung des Codes
:class: hinweis, dropdown

**`selectInput(...)`** erstellt ein Dropdown-Menü (also eine Auswahlliste) mit:
- ``"bezirk"`` ist der Name, unter dem Shiny diesen Input später erkennt → input$bezirk
- ``"Bezirk auswählen:"`` ist der Text, der über dem Menü steht.
- `choices = c("Alle", unique(df$bezirk))` definiert die Auswahlmöglichkeiten:
  - ``df$bezirk`` heißt: Aus der Tabelle df nimm die Spalte bezirk.
  - ``unique(df$bezirk)`` bedeutet: Nur jeden Bezirk einmal anzeigen – keine Dopplungen.
  - ``c(...)`` macht daraus eine Liste aller Bezirke plus **“Alle”**.
- `selected = "Alle"` legt fest, dass beim Start alle Bezirke angezeigt werden.
- ``multiple = TRUE`` heißt: Man darf mehrere Bezirke gleichzeitig auswählen.

Diese Filterauswahl wird im Server verarbeitet und bestimmt, welche Daten für die Kennzahl der gegossenen Bäume verwendet werden.
````

Mit diesem Aufbau hat Amir die **Struktur** seiner Startseite definiert:
- Eine klare Navigation über die Seitenleiste
- Zwei zentrale Kennzahlen in prominenter Position
- Ein Filter zur Eingrenzung nach Bezirken

Was noch fehlt, ist die Intelligenz: Die tatsächliche Berechnung der Kennzahlen und die Reaktion auf Nutzer:inneneingaben. Dafür ist der Server zuständig.

## Server – Die Logik hinter dem Dashboard
In Shiny beobachtet der Server kontinuierlich die Eingabefelder (`input$...`) und **aktualisiert automatisch** alle Ausgaben (`output$...`), die von diesen Eingaben abhängen.

Für Amirs Dashboard bedeutet das konkret:
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
  if (!("Alle" %in% input$bezirk)) {
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

**Die Filterlogik**  
```r
if (!("Alle" %in% input$bezirk)) {
  df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
}
```
Diese Bedingung implementiert die eigentliche Filterung:
- Falls "Alle" in der Auswahl enthalten ist → keine Einschränkung, alle Daten bleiben erhalten
- Falls nur bestimmte Bezirke ausgewählt wurden → behalte nur die Zeilen, deren `bezirk` in der Auswahl (`input$bezirk`) vorkommt

**Warum ist diese Struktur wichtig?**  
Amir muss den Filtercode nur einmal schreiben. Alle Visualisierungen und Kennzahlen, die `filteredData()` verwenden, greifen automatisch auf die aktuell gefilterte Version der Daten zu. Das vermeidet Redundanz und macht den Code wartbar.
````

#### Dynamische Anzeige

Eine dynamische Anzeige bedeutet, dass sich die Inhalte des Dashboards automatisch ändern, abhängig davon, was Sie auswählen.
Um solche dynamischen Anzeigen zu erstellen, muss das Dashboard Entscheidungen treffen: „Wenn dies ausgewählt ist, dann eige das – ansonsten zeige etwas anderes."

In der Programmierung verwendet man dafür **if-else-Anweisungen**:

````{dropdown} Code
```r
if (Bedingung) {
  # wird ausgeführt, wenn die Bedingung wahr ist
} else {
  # wird ausgeführt, wenn die Bedingung falsch ist
}
```
Diese Struktur nennt man **Bedingung**. Sie steuert den Ablauf des Codes abhängig von bestimmten Eingaben.

**Operatoren**
- ``%in%``: prüft, ob ein Wert in einer Liste enthalten ist.
- ``<-``: weist einer Variable einen Wert zu (z. B. ``x <- 3``).
- ``|`` = ODER, ``&`` = UND

````

##### Praktisches Beispiel für das Dashboard

````{dropdown} total_trees oder total_tree_watered
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

Nun kann Amir die beiden Kennzahlenkacheln mit Inhalten füllen. In der UI wurden diese bereits als `valueBoxOutput("total_trees")` und `valueBoxOutput("total_tree_watered")` angelegt – jetzt definiert er, was darin erscheinen soll.


````{dropdown} Alle Bäume
```r
output$total_trees <- renderValueBox({
  valueBox(
    formatC(n_distinct(df_merged$gisid), format = "d", big.mark = "."),
    "Gesamtzahl der Bäume",
    icon = icon("tree"),
    color = "green"
  )
})
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

- ``output$total_trees`` ist das, was in die Box ``valueBoxOutput("total_trees")`` geschrieben wird.
- ``renderValueBox({...})`` sagt: „Berechne, was in die Box geschrieben wird.“
- ``n_distinct(...)``: zählt eindeutige Werte.
- ``formatC(...)``: formatiert Zahlen, z. B. mit Tausenderpunkten.
- ``icon("tree")`` zeigt ein Baum-Icon.
- ``color = "green"`` färbt die Box grün.
````

````{dropdown} Gegossene Bäume
```r
output$total_tree_watered <- renderValueBox({
  valueBox(
    formatC(
      n_distinct(filteredData()$gisid[!is.na(filteredData()$timestamp)]),
      format = "d", big.mark = "."
    ),
    "Gesamtzahl der gegossenen Bäume",
    icon = icon("tint"),
    color = "blue"
  )
})
```
````

````{admonition} Erklärung des Codes
:class: hinweis, dropdown

Hier gibt es einen entscheidenden Unterschied:
- Statt `df_merged` verwendet Amir nun `filteredData()` – die reaktive Datenquelle, die sich je nach Bezirksauswahl ändert
- `!is.na(filteredData()$timestamp)` filtert zusätzlich: Es werden nur Bäume gezählt, die mindestens einmal gegossen wurden (erkennbar an einem gültigen Zeitstempel)
- `icon("tint")` (ein Tropfen-Symbol) und `color = "blue"` heben die Wasserthematik visuell hervor

**Warum diese Unterscheidung zwischen `df_merged` und `filteredData()`?**  
- Die **Gesamtzahl der Bäume** ist eine konstante Referenzgröße – sie soll sich nicht ändern, egal welche Bezirke betrachtet werden
- Die **Anzahl gegossener Bäume** hingegen ist bezirksspezifisch und soll auf die Filterauswahl reagieren

Durch diese bewusste Trennung ermöglicht Amir den Nutzer:innen, das Engagement in einzelnen Bezirken mit der Gesamtsituation zu vergleichen.
````

### Einheiten clever umrechnen

Bei der Darstellung von Wassermengen steht Amir vor einer Herausforderung: Die Rohdaten enthalten Literangaben, die je nach Größenordnung unterschiedlich formatiert werden sollten. Eine Menge von 50 Litern ist überschaubar, aber 1.250.000 Liter sind schwer zu erfassen. Amir möchte, dass das Dashboard automatisch in sinnvolle Einheiten umrechnet – etwa Kubikmeter (m³) oder Megaliter (ML).

Um dies zu erreichen, erstellt er Hilfsfunktionen, die die Umrechnung übernehmen und gleichzeitig die passende Einheit auswählen.

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

| Funktion/Operator | Bedeutung|
|-------------------|----------|
| ``<-``| weist einer Variable einen Wert zu|
|``if (...)`` / ``else`` |	Bedingte Ausführung |
|``%in%``	| prüft, ob ein Wert in einer Liste ist |
| ``mean()`` |	Durchschnitt berechnen |
|``sum()`` |	Summe berechnen |
| ``switch()``	| wählt abhängig vom Wert einen Fall |
| ``mutate()`` |	erzeugt oder verändert Spalten |
| ``filter()`` |	filtert Zeilen in einem Datensatz |
| ``is.na()`` |	prüft auf fehlende Werte |


````{admonition} Gesamter Code
:class: hinweis, dropdown

```r
# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "start",
              box(title = "Overview", status = "primary", solidHeader = TRUE, width = 12,
                  fluidRow(
                    valueBoxOutput("total_trees", width = 6),
                    valueBoxOutput("total_tree_watered", width = 6)
                  ),
                  fluidRow(
                    column(width = 6,
                           selectInput("bezirk", "Bezirk auswählen:", 
                                       choices = c("Alle", unique(df_merged$bezirk)), 
                                       selected = "Alle", multiple = TRUE)
                    )
                  )
              )
      )
    )
  )
)

# Server-Logik
server <- function(input, output, session) {
  
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
  
  filteredData <- reactive({
    req(input$bezirk)
    
    df <- df_merged
    df_filtered <- df
    
    if (!("Alle" %in% input$bezirk)) {
      df_filtered <- df_filtered %>% filter(bezirk %in% input$bezirk)
    }
    
    df_filtered
  })
  
  output$total_trees <- renderValueBox({
    valueBox(
      formatC(n_distinct(df_merged$gisid), format = "d", big.mark = "."),
      "Gesamtzahl der Bäume",
      icon = icon("tree"),
      color = "green"
    )
  })
  
  output$total_tree_watered <- renderValueBox({
    valueBox(
      formatC(n_distinct(filteredData()$gisid[!is.na(filteredData()$timestamp)]), 
              format = "d", big.mark = "."),
      "Gesamtzahl der gegossenen Bäume",
      icon = icon("tint"),
      color = "blue"
    )
  })
}
```
````

## Was muss Amir beim Bau eines Dashboards beachten? *(vorläufig)* 
Bei der Gestaltung der Startseite sollte Amir darauf achten, dass die wichtigsten Informationen klar, gut lesbar und ohne unnötige Ablenkungen präsentiert werden. Besonders für einen ersten Überblick gilt: Weniger ist oft mehr.

Für die Startseite heißt das vor allem:

- **Klarheit**: Keine überladene Darstellung, eindeutige Beschriftungen, selbsterklärende Kennzahlen.

- **Lesbarkeit**: Vermeidung von 3D-Elementen oder komplexen Grafiken, wenn ein einfacher Indikator genügt.

- **Fokus**: Nur die wirklich zentralen Kennzahlen aufnehmen, um den Blick nicht zu zerstreuen.

- **Konsistenz**: Einheitliche Farb- und Formatwahl, damit Nutzer:innen sich sofort orientieren können.

- **Kontext**: Kurze Hinweise oder Legenden, damit die Zahlen richtig interpretiert werden können.

*Diese Punkte bilden den Rahmen – nach weiterer Recherche lassen sich hier noch Best Practices und konkrete Gestaltungsrichtlinien ergänzen.*

## Leitfrage und Ausblick

Die zentrale Leitfrage von Amirs Fallstudie lautet: **Wo ist das höchste Bürgerengagement?**

Mit den Daten aus Gieß den Kiez kann er diese Frage bereits auf der Startseite beantworten: Pro Bezirk lässt sich das Engagement direkt darstellen und vergleichen. Am meisten engagierten sich die Bürger:innen in **Mitte**, danach folgen **Tempelhof-Schöneberg** und **Charlottenburg-Wilmersdorf**. Damit ist die Hauptfrage zwar beantwortet – doch Amir interessiert sich nun für die **Geschichten hinter den Zahlen**.

Er möchte verstehen, welche **Kontextfaktoren** zu den Unterschieden führen könnten:

- **Räumlich** – etwa Unterschiede zwischen Bezirken oder die Baumdichte in einem Gebiet.

- **Zeitlich** – wie sich das Engagement im Jahresverlauf entwickelt oder ob das Pflanzjahr der Bäume eine Rolle spielt.

- **Infrastrukturell** – zum Beispiel, ob die Verfügbarkeit von Pumpen Einfluss auf das Gießverhalten hat.

````{admonition} Daraus ergeben sich neue Fragen:
:class: frage-feedback

- Wo treten die höchsten Ausprägungen des Bürgerengagements auf?

- Welche zusätzlichen Datensätze lassen sich einbeziehen, um die Analyse zu vertiefen?

- Wie können interaktive Dashboards diese Faktoren verständlich und vergleichbar darstellen?
````

Mit diesen Überlegungen ist der Grundstein für die **nächste Übung** gelegt – den Bau eines interaktiven Dashboards, das nicht nur die Kernaussage liefert, sondern auch die Hintergründe sichtbar macht.
