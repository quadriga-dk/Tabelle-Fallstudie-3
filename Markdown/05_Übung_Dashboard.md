# Übung Dashboard

**Grundstruktur einer Shiny-Anwendung**

Eine typische Shiny-Anwendung besteht aus zwei Hauptkomponenten: 
1.	User Interface (UI): Definiert das Layout und die Gestaltung der Anwendung, einschließlich aller Eingabe- und Ausgabeelemente.
2.	Server: Beinhaltet die serverseitige Logik, verarbeitet Eingaben und generiert entsprechende Ausgaben.
Diese beiden Komponenten werden schließlich durch den Befehl shinyApp(ui = ui, server = server) zusammengeführt, um die Anwendung zu starten.

Das shinydashboard-Paket erweitert Shiny um Funktionen zur Erstellung von Dashboards. Ein Dashboard besteht typischerweise aus drei Hauptbereichen: Shiny Dashboard Structure 
1.	Header: Der obere Bereich des Dashboards, der den Titel und optionale Steuerungselemente enthält.
2.	Sidebar: Eine seitliche Navigationsleiste, die Links oder Schaltflächen zur Navigation innerhalb des Dashboards bereitstellt.
3.	Body: Der Hauptbereich, in dem die Inhalte wie Diagramme, Tabellen und Texte angezeigt werden.
Die Grundstruktur eines Dashboards wird mit der Funktion dashboardPage() erstellt, die die oben genannten Komponenten kombiniert:

R_Studio_Dashboard

```{figure} _images/R_Studio_Dashboard.png
---
name: R_Studio_Dashboard
alt: Ein Screenshot, der zeigt, die Dashboardstruktur. 
---
Dashboardstruktur
```

Die sidebarMenu-Funktion definiert die Navigationselemente, während tabItems die entsprechenden Inhalte für jeden Tab bereitstellt.

**Interaktive Elemente und Reaktivität**

Ein wesentliches Merkmal von Shiny ist die Reaktivität, die es ermöglicht, dass sich Ausgaben automatisch aktualisieren, wenn sich Eingaben ändern. Dies wird durch reaktive Funktionen und Objekte erreicht.

