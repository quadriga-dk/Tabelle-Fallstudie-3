---
lang: de-DE
---

(vorbereitung)=
# Vorbereitung

*Vorbereitende Maßnahmen, bevor mit dem Bau eines Dashboards begonnen werden kann...*

## Einrichtung der Entwicklungsumgebung

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
library(leaflet)
library(ggplot2)
library(dplyr)
library(lubridate)
library(shinydashboard)
library(plotly)
library(leaflet.extras)
library(tidyr)
library(stringr)
library(shinyBS)
```

Diese Pakete ermöglichen die Entwicklung der Benutzeroberfläche, die Datenverarbeitung sowie die Visualisierung.
<span style="color:red">*vielleicht noch zuordnen, welche Pakete was genau machen*</span>


## Daten laden und vorbereiten

**Einlesen und Aufbereitung der CSV-Datei**

Die Grundlage für unser Dashboard bildet eine CSV-Datei der Nutzungsdaten aus dem bereits erwähnten Projekt Gieß den Kiez. Diese muss zunächst eingelesen und bereinigt werden. Verwenden Sie dazu folgenden Code; der Text hinter dem `#` zeigt Ihnen an, was die darunter folgenden Codezeilen tun:
<span style="color:red">*die CSV muss verlinkt werden: 1. Link zur "Anbieter" und 2. Link zu unserem Repositorium, wo der Datensatz ebenfalls abgelegt werden muss*</span>


```r
# Daten laden
df <- read.csv("data/nutzungsdatenGiessDenKiez.csv", sep = ";", 
               stringsAsFactors = FALSE, fileEncoding = "UTF-8")

# Konvertierung von Zeichenketten in numerische Werte
df$pflanzjahr <- as.numeric(df$pflanzjahr)
df$bewaesserungsmenge_in_liter <- as.numeric(df$bewaesserungsmenge_in_liter)

# Entfernung fehlender Werte
df_clean <- df %>% drop_na(lng, lat, bewaesserungsmenge_in_liter)
```

Erklärung des Codes:

- `read.csv(...)` lädt die CSV-Datei und interpretiert sie als Tabelle.

- `as.numeric(...)` stellt sicher, dass Zahlenwerte korrekt als numerische Variablen vorliegen.

- `drop_na(...)` entfernt Zeilen mit fehlenden oder unvollständigen Daten.

Diese Schritte sind essenziell, um spätere Analysen und Visualisierungen korrekt durchführen zu können.


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
Die Grundstruktur eines Dashboards wird mit der Funktion dashboardPage() erstellt, die die oben genannten Komponenten kombiniert:

```r
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      menuItem("Karte", tabName = "map", icon = icon("map")),
      menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart")),
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "start"),
      tabItem(tabName = "map"),
      tabItem(tabName = "stats"),
      tabItem(tabName = "analysis")
    )
  )
)

server <- function(input, output) { }

shinyApp(ui = ui, server = server)
```

Die sidebarMenu-Funktion definiert die Navigationselemente, während tabItems die entsprechenden Inhalte für jeden Tab bereitstellt.

**Interaktive Elemente und Reaktivität**

Ein wesentliches Merkmal von Shiny ist die Reaktivität, die es ermöglicht, dass sich Ausgaben automatisch aktualisieren, wenn sich Eingaben ändern. Dies wird durch reaktive Funktionen und Objekte erreicht.

