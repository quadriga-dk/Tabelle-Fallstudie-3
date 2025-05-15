# Technische Voraussetzungen

## Installieren von R und RStudio

Um der Übungseinheit effektiv folgen zu können, installieren Sie bitte vorab **R**. Zudem benötigen Sie eine geeignete Entwicklungsumgebung. Hierfür bietet sich **RStudio** an. Die Computersprache **R** und **RStudio** können Sie direkt vom Entwickler bzw. Maintainer <a href="https://posit.co/download/rstudio-desktop/" target="_blank">Posit</a> beziehen.  

**Hinweis**  
Die Übungen sind auf der Basis von R 4.4.3 entwickelt worden und zur Nutzung von RStudio 2024.09.0 Build 375 über Windows konzipiert. Bei der Nutzung einer anderen RStudio Version oder eines anderen Betriebssystems können Funktionen eventuell variieren.  
Eine Anleitung für die ersten Schritte in RStudio findet sich weiter unten in diesem Abschnitt.  

## Nutzung dieses JupyterBooks

Dieses JupyterBook besteht aus mehreren Kapiteln, die jeweils als einzelne Open Educational Resource (OER) gelten. Sie sind anhand einer Forschungsfrage durch einen roten Faden verbunden, können aber auch einzeln absolviert werden.


------------------------------------------------------------------------

## Erste Schritte in RStudio

**Neues R Skript anlegen**  
1. Öffnen Sie RStudio.  
2. Ein Shiny Web App Skript, in dem Sie Befehle eingeben können, öffnen Sie
unter *Files*: 
 
```{figure} _images/R_Studio_open_new_script.png
---
name: screenshot-r-1
alt: Ein Screenshot, der zeigt, wie man ein neues R-Skript öffnet.
---
Anleitung zum Öffnen eines neuen R-Skriptes.
``` 

**RStudio Umgebung für Shiny:** 

```{figure} _images/R_Studio_Interface.png
---
name: screenshot-r-2
alt: Ein Screenshot, der das Interface von R-Studio zeigt.
---
Interface von RStudio.
```

**RStudio besteht aus vier Hauptbereichen:**

**R Skript:**  
Im R Skript werden Befehle eingegeben, die **R** ausführen soll.
Um einen Befehl auszuführen, drücken Sie `Strg + Enter`, um eine einzelne Zeile zu starten, oder markieren Sie den gewünschten Code-Abschnitt und drücke erneut `Strg + Enter`, um mehrere Zeilen gleichzeitig auszuführen. Alternativ können Sie den Run-App-Button in der oberen rechten Ecke des Fensters nutzen oder die Tastenkombination `Strg + Shift + S` verwenden.
Ein Beispielbefehl ist das vorab eingetragene Skript, das automatisch beim Erstellen einer neuen Shiny-Web-App generiert wird.
Das Skript kann gespeichert und später erneut geöffnet werden.

**Console:**  
Hier werden Befehle direkt ausgeführt und deren Ergebnisse sowie eventuelle Fehlermeldungen angezeigt.

**Environment:**  
Dieser Bereich zeigt alle geladenen Objekte, Datensätze und Variablen an. Auch selbst erstellte Listen oder Datenframes werden hier verwaltet.  

**Files:**  
Hier können Sie Dateien anzeigen, verwalten und importieren. Zudem bietet dieser Bereich Zugriff auf Verzeichnisse und gespeicherte Projekte.


Ein weiteres Anzeigefenster ist die **Web-App:** In diesem Bereich wird die visuelle Ausgabe der Shiny-App dargestellt. Je nach Einstellung öffnet sich das Fenster entweder direkt in RStudio oder in einem externen Browser.  

```{figure} _images/R_Studio_Shiny_App.png
---
name: screenshot-shiny-2
alt: Ein Screenshot, der die Shiny-App zeigt.
---
Interface einer Shiny-App in RStudio.
```
