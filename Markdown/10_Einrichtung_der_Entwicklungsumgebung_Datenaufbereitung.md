# Einrichtung der Entwicklungsumgebung

## Einrichtung der Entwicklungsumgebung

Bevor mit der Entwicklung des Dashboards begonnen werden kann, müssen die benötigten Pakete installiert und geladen werden. Öffnen Sie RStudio und führen Sie folgenden Befehl aus, um die erforderlichen Pakete zu installieren:

```{figure} _images/R_Studio_Packages.png
---
name: R_Studio_Packages
alt: Ein Screenshot, der das installieren der benöigten Packages zeigt.
---
Installieren der Packages.
```

Nachdem die Installation abgeschlossen ist, laden Sie die Pakete in Ihr Skript:

```{figure} _images/R_Studio_Libraries.png
---
name: R_Studio_Libraries
alt: Ein Screenshot, der zeigt, wie man die Pakete lädt.
---
Laden der Pakete.
```

Diese Pakete ermöglichen die Entwicklung der Benutzeroberfläche, die Datenverarbeitung sowie die Visualisierung.

## Daten laden und vorbereiten

**Einlesen und Aufbereitung der CSV-Datei**

Die Grundlage für unser Dashboard bildet eine CSV-Datei der Nutzungsdaten aus dem Projekt Gieß den Kiez. Diese muss zunächst eingelesen und bereinigt werden. Verwenden Sie dazu folgenden Code:

```{figure} _images/R_Studio_Einlesen_Aufbereitung.png
---
name: R_Studio_Einlesen_Aufbereitung
alt: Ein Screenshot, der zeigt, wie die Daten eingelesen und aufbereitet werden.
---
Einlesen und Aufbereiten der Daten.
```

Erklärung:

- `read.csv(...)` lädt die CSV-Datei und interpretiert sie als Tabelle.

- `as.numeric(...)` stellt sicher, dass Zahlenwerte korrekt als numerische Variablen vorliegen.

- `drop_na(...)` entfernt Zeilen mit fehlenden oder unvollständigen Daten.

Diese Schritte sind essenziell, um spätere Analysen und Visualisierungen korrekt durchführen zu können.