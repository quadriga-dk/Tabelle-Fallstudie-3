---
lang: de-DE
---

(vorbereitung)=
# Vorbereitung

*Vorbereitende Maßnahmen, bevor mit dem Bau eines Dashboards begonnen werden kann...*

## Einrichtung der Entwicklungsumgebung

Bevor wir mit dem Aufbau des Dashboards beginnen können, müssen wir die benötigten Pakete installieren und laden. Öffnen Sie RStudio und führen Sie folgenden Befehl aus, um die erforderlichen Pakete zu installieren:

```{figure} /assets/R_Studio_Packages.png
---
name: R_Studio_Packages
alt: Ein Screenshot, der das installieren der benöigten Packages zeigt.
---
Befehl zum Installieren der 11 benötigten Packages.
```

Nachdem die Installation abgeschlossen ist, laden Sie die Pakete in Ihr Skript:

```{figure} /assets/R_Studio_Libraries.png
---
name: R_Studio_Libraries
alt: Ein Screenshot, der zeigt, wie man die Pakete lädt.
---
Befehl zum Laden der 11 benötigten Pakete.
```

Diese Pakete ermöglichen die Entwicklung der Benutzeroberfläche, die Datenverarbeitung sowie die Visualisierung.
<span style="color:red">*vielleicht noch zuordnen, welche Pakete was genau machen*</span>


## Daten laden und vorbereiten

**Einlesen und Aufbereitung der CSV-Datei**

Die Grundlage für unser Dashboard bildet eine CSV-Datei der Nutzungsdaten aus dem bereits erwähnten Projekt Gieß den Kiez. Diese muss zunächst eingelesen und bereinigt werden. Verwenden Sie dazu folgenden Code; der Text hinter dem `#` zeigt Ihnen an, was die darunter folgenden Codezeilen tun:
<span style="color:red">*die CSV muss verlinkt werden: 1. Link zur "Anbieter" und 2. Link zu unserem Repositorium, wo der Datensatz ebenfalls abgelegt werden muss*</span>


```{figure} /assets/R_Studio_Einlesen_Aufbereitung.png
---
name: R_Studio_Einlesen_Aufbereitung
alt: Ein Screenshot, der zeigt, wie die Daten eingelesen und aufbereitet werden.
---
Einlesen und Aufbereiten der Daten.
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

R_Studio_Dashboard

```{figure} /assets/R_Studio_Dashboard.png
---
name: R_Studio_Dashboard
alt: Ein Screenshot, der zeigt, die Dashboardstruktur. 
---
Dashboardstruktur
```

Die sidebarMenu-Funktion definiert die Navigationselemente, während tabItems die entsprechenden Inhalte für jeden Tab bereitstellt.

**Interaktive Elemente und Reaktivität**

Ein wesentliches Merkmal von Shiny ist die Reaktivität, die es ermöglicht, dass sich Ausgaben automatisch aktualisieren, wenn sich Eingaben ändern. Dies wird durch reaktive Funktionen und Objekte erreicht.

