---
lang: de-DE
---

(dashboard-vorbereitung)=
# Entwicklungsumgebung vorbereiten

*Vorbereitende Maßnahmen, bevor mit dem Bau eines Dashboards begonnen werden kann...*

## Einrichtung der Entwicklungsumgebung

````{margin}
```{admonition} Hinweis zum Paket leaflet.extras
:class: hinweis

Das Paket leaflet.extras wurde während der Erstellung dieses Lehrbuchs aus dem Repository <a href="https://cran.r-project.org/web/packages/leaflet.extras/index.html" class="external-link" target="_blank">entfernt</a>.

Da das Bauen des Dashboards auch ohne diesen Befehl funktioniert, können Sie ihn auch weglassen.
Da das Paket möglicherweise aber zurückkommt, ist es weiter in dieser Auflistung aufgeführt.

```
````

Bevor wir mit dem Aufbau des Dashboards beginnen können, müssen wir die benötigten Pakete installieren und laden. Öffnen Sie RStudio und führen Sie folgenden Befehl aus, um die erforderlichen Pakete zu installieren:

```r
install.packages(c("shiny", "shinydashboard", 
                   "leaflet", "ggplot2", "dplyr", 
                   "lubridate", "plotly", "tidyr", 
                   "stringr", "leaflet.extras", "shinyBS"))
```

Nachdem die Installation abgeschlossen ist, laden Sie die Pakete in Ihr Skript:

```r
library(shiny)
library(shinydashboard)
library(lubridate)
library(leaflet)
library(dplyr)
library(htmltools)
library(stringr)
library(sf)
library(tidyr)
library(ggplot2)
library(plotly)
library(nngeo)
```

Diese Pakete ermöglichen die Entwicklung der Benutzeroberfläche, die Datenverarbeitung sowie die Visualisierung.
<span style="color:red">*vielleicht noch zuordnen, welche Pakete was genau machen*</span>


## Daten laden und vorbereiten

**Einlesen und Aufbereitung der CSV-Datei**

Die Grundlage für unser Dashboard bildet eine CSV-Datei der Nutzungsdaten aus dem bereits erwähnten Projekt Gieß den Kiez. Diese muss zunächst eingelesen und bereinigt werden. Verwenden Sie dazu folgenden Code; der Text hinter dem `#` zeigt Ihnen an, was die darunter folgenden Codezeilen tun:
<span style="color:red">*die CSV muss verlinkt werden: 1. Link zur "Anbieter" und 2. Link zu unserem Repositorium, wo der Datensatz ebenfalls abgelegt werden muss*</span>


```r
# Bezirksgrenzen laden
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson", quiet = TRUE)

# Bewässerungsdaten laden
df_merged <- read.csv2("data/df_merged_final.csv", fileEncoding = "UTF-8")

# Bezirksgrenzen vorbereiten
berlin_bezirke_sf <- bezirksgrenzen %>%
  rename(bezirk = Gemeinde_name) %>%     # Spalte vereinheitlichen
  mutate(bezirk = str_to_title(bezirk))  # gleiche Schreibweise wie in df_merged
```

Erklärung des Codes:

- `st_read(...)` lädt die GeoJSON-Datei mit den Berliner Bezirksgrenzen als räumliches Objekt ein.

- `read.csv2(...)` lädt die CSV-Datei mit den Bewässerungsdaten und interpretiert sie als Tabelle (semikolon-getrennt).

- `rename(...)` benennt die Spalte `Gemeinde_name` in `bezirk` um, um eine einheitliche Schreibweise sicherzustellen.

- `mutate(bezirk = str_to_title(bezirk))` sorgt dafür, dass die Bezirksnamen in der Geodatei dieselbe Schreibweise wie in `df_merged` haben.


## Dashboard bauen

**Grundstruktur einer Shiny-Anwendung**

Eine typische Shiny-Anwendung besteht aus zwei Hauptkomponenten: 
1.	User Interface (UI): Definiert das Layout und die Gestaltung der Anwendung, einschließlich aller Eingabe- und Ausgabeelemente.
2.	Server: Beinhaltet die serverseitige Logik, verarbeitet Eingaben und generiert entsprechende Ausgaben.
Diese beiden Komponenten werden schließlich durch den Befehl `shinyApp(ui = ui, server = server)` zusammengeführt, um die Anwendung zu starten. 

Das shinydashboard-Paket erweitert Shiny um Funktionen zur Erstellung von Dashboards. Ein Dashboard besteht typischerweise aus drei Hauptbereichen: Shiny Dashboard Structure 
1.	Header: Der obere Bereich des Dashboards, der den Titel und optionale Steuerungselemente enthält.
2.	Sidebar: Eine seitliche Navigationsleiste, die Links oder Schaltflächen zur Navigation innerhalb des Dashboards bereitstellt.
3.	Body: Der Hauptbereich, in dem die Inhalte wie Diagramme, Tabellen und Texte angezeigt werden.
Die Grundstruktur eines Dashboards wird mit der Funktion dashboardPage() erstellt, die die oben genannten Komponenten kombiniert: <span style="color:red">An dieser Stelle fände ich visuellen Input oder Comments hilfteich. Vielleicht erst ein Schaubild zur Server-UI-Beziehung und später eine deutlichere Kennzeichnung was denn genau jetzt Header bzw. Sidebar und Body sind im Block. Es ist zwar aus dem Code ersichtlich, jedoch könnte ich mir dennoch vorstellen, dass das wegen unserer Zielgruppe dem Nutzer entgeht (überflogen, copy/paste etc)</span>

```r
ui <- dashboardPage(
  # 1. HEADER: Titelbereich des Dashboards
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  
  # 2. SIDEBAR: Seitliche Navigationsleiste mit Menüeinträgen
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      menuItem("Karte", tabName = "map", icon = icon("map")),
      menuItem("Zeitverlauf", tabName = "stats", icon = icon("bar-chart")),
      menuItem("Baumstatistik", tabName = "engagement", icon = icon("bar-chart")),
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
    )
  ),
  
  # 3. BODY: Inhaltsbereich
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "start"
        # Hier folgt später der UI-Code für die Startseite (Texte, Bilder, etc.)
      ),
      tabItem(
        tabName = "map"
        # Hier folgen später die UI-Komponenten für die Karte
      ),
      tabItem(
        tabName = "stats"
        # Hier folgen später die UI-Komponenten für den Zeitverlauf
      ),
      tabItem(
        tabName = "engagement"
        # Hier folgen später die UI-Komponenten für die Baumstatistik
      ),
      tabItem(
        tabName = "analysis"
        # Hier folgen später die UI-Komponenten für die Bewässerungsanalyse
      )
    )
  )
)

# 4. SERVER: Backend-Logik, die Daten verarbeitet und an die UI generiert
server <- function(input, output) { 
  # Hier folgt später der R-Code zur Datenverarbeitung (z.B. renderPlot, renderLeaflet), 
  # der die Grafiken und Inhalte für die jeweiligen Tabs im Body erzeugt.
}

# 5. Zusammenführung: Startet die Shiny-Anwendung
shinyApp(ui = ui, server = server)
```

Die sidebarMenu-Funktion definiert die Navigationselemente, während tabItems die entsprechenden Inhalte für jeden Tab bereitstellt.

**Interaktive Elemente und Reaktivität**

Ein wesentliches Merkmal von Shiny ist seine [Reaktivität](https://de.wikipedia.org/wiki/Reaktives_System_(Informatik)), die es ermöglicht, dass sich Ausgaben automatisch aktualisieren, wenn sich Eingaben ändern. Dies wird durch reaktive Funktionen und Objekte erreicht.

