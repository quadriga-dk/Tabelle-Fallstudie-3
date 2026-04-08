---
lang: de-DE
---

(technische_voraussetzungen)=
# Technische Voraussetzungen


Diese Fallstudie umfasst erklärende Texte, Code in der Programmiersprache R sowie Übungen und Assessments zur Selbstüberprüfung. 

Wir bieten drei verschiedene Zugangswege:

📘 Book-Only Mode: Im Browser lesen Sie unser interaktives Lehrbuch mit eingeschränkten Interaktionsmöglichkeiten. Dies erfordert keine Programmierkenntnisse oder Erfahrung mit Jupyter Notebooks.  
🌨️ Cloud Mode: Ausführen und Anpassen der enthaltenen Jupyter Notebooks über Google Colab oder Binder. Kapitel mit ausführbaren Notebooks sind durch ein Raketen-Symbol (🚀) gekennzeichnet - klicken Sie darauf, um das Notebook in Colab zu öffnen.  
💻 Local Mode: Herunterladen der Jupyter Notebooks auf Ihren Computer zur lokalen Ausführung (z.B. im Anaconda Navigator). Ermöglicht die Nutzung lokaler Daten und umfassende Anpassungen.  

Sie können den R-Code parallel zum Lesen des Jupyter Books in RStudio bearbeiten. Dazu müssen Sie sich R und RStudio installieren. Eine Anleitung dazu finden Sie im nächsten Abschnitt.

Wählen Sie den Ansatz, der am besten zu Ihren Anforderungen passt. Sie können jederzeit zwischen den Methoden wechseln.


## Installieren von R und RStudio

Um der Übungseinheit effektiv folgen zu können, installieren Sie bitte vorab **R**. Zudem benötigen Sie eine geeignete Entwicklungsumgebung. Hierfür bietet sich **RStudio** an. Die Computersprache **R** und **RStudio** können Sie direkt vom Entwickler bzw. Maintainer <a href="https://posit.co/download/rstudio-desktop/" class="external-link" target="_blank">Posit</a> beziehen.  

**Hinweis**  
Die Übungen sind auf der Basis von R 4.4.3 entwickelt worden und zur Nutzung von RStudio 2024.09.0 Build 375 über Windows konzipiert. Bei der Nutzung einer anderen RStudio Version oder eines anderen Betriebssystems können Funktionen eventuell variieren.  
Eine Anleitung für die ersten Schritte in RStudio findet sich weiter unten in diesem Abschnitt.  

## Nutzung dieses JupyterBooks

Dieses JupyterBook besteht aus mehreren Kapiteln, die jeweils als einzelne [Open Educational Resource (OER)](https://de.wikipedia.org/wiki/Open_Educational_Resources) gelten. Sie sind anhand einer Forschungsfrage durch einen roten Faden verbunden, können aber auch einzeln absolviert werden.


------------------------------------------------------------------------

## Erste Schritte in RStudio

**Neues R Skript anlegen**  
1. Öffnen Sie RStudio.  
2. Ein Shiny Web App Skript, in dem Sie Befehle eingeben können, öffnen Sie
unter *Files*:
<span style="color:red">*Nachdem man "Shiny Web App" ausgefwählt hat, öffnet sich ein Fenster mit potenziell unklaren Speicherpräferenzen. Dieses würde ich erklären*</span>
 
```{figure} ../assets/R_Studio_open_new_script.png
---
name: screenshot-r-1
alt: Ein Screenshot, der zeigt, wie man ein neues R-Skript öffnet.
---
Anleitung zum Öffnen eines neuen R-Skriptes.
``` 

**RStudio Umgebung für Shiny:** 

```{figure} ../assets/R_Studio_Interface.png
---
name: screenshot-r-2
alt: Ein Screenshot, der das Interface von R-Studio zeigt.
---
Interface von RStudio.
```

**RStudio besteht aus vier Hauptbereichen:**

**R Skript:**  
Im R Skript werden Befehle eingegeben, die **R** ausführen soll.
Um einen Befehl auszuführen, drücken Sie `Strg + Enter`, um eine einzelne Zeile zu starten, oder markieren Sie den gewünschten Code-Abschnitt und drücke erneut `Strg + Enter`, um mehrere Zeilen gleichzeitig auszuführen. Alternativ können Sie den Run-App-Button in der oberen rechten Ecke des Skript-Fensters nutzen oder die Tastenkombination `Strg + Shift + S` verwenden.
Ein Beispielbefehl ist das vorab eingetragene Skript, das automatisch beim Erstellen einer neuen Shiny-Web-App generiert wird.
Das Skript kann gespeichert und später erneut geöffnet werden.

**Console:**  
Hier werden Befehle direkt ausgeführt und deren Ergebnisse sowie eventuelle Fehlermeldungen angezeigt.

**Environment:**  
Dieser Bereich zeigt alle geladenen Objekte, Datensätze und Variablen an. Auch selbst erstellte Listen oder Datenframes werden hier verwaltet.  

**Files:**  
Hier können Sie Dateien anzeigen, verwalten und importieren. Zudem bietet dieser Bereich Zugriff auf Verzeichnisse und gespeicherte Projekte.

**Web-App:**  
Ein weiteres Anzeigefenster ist die Web-App: Dieses öffnet sich, sobald der dazugehörige Befehl im R-Skript ausgeführt wurde, automatisch.  In diesem Bereich wird die visuelle Ausgabe der Shiny-App dargestellt. Je nach Einstellung öffnet sich das Fenster entweder direkt in RStudio oder in einem externen Browser.  

```{figure} ../assets/R_Studio_Shiny_App.png
---
name: screenshot-shiny-2
alt: Ein Screenshot, der die Shiny-App zeigt.
---
Interface einer Shiny-App in RStudio.
```
