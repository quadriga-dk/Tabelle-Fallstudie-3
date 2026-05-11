---
lang: de-DE
---

(datenbasis)=
# Datenbasis

```{admonition} Story
:class: story
Dr. Amir Weber macht sich Gedanken, welche Daten er braucht und woher er sie beziehen kann. Wichtig sind vor allem Daten über den Baumbestand und Bewässerungsdaten.  
Dabei fällt ihm das Berliner Projekt <a href="https://www.giessdenkiez.de/stats?lang=de" class="external-link" target="_blank">Gieß den Kiez</a> ein, welches diese Daten bereits erhebt und zur Verfügung stellt. Er prüft zudem, welche Daten noch relevant sind und auf welche Weise sie beschafft werden können.
```

In diesem Abschnitt werden Ihnen die Daten vorgestellt, die zur Beantwortung der Leitfrage und als Datenbasis für ein Dashboard benötigt werden. Im nächsten Abschnitt werden Sie diese dann einlesen.

Dabei handelt es sich um drei zentrale Datenquellen: 
- **Baumbestandsdaten** (Zugriff über WFS-Schnittstelle)
- **Bezirksgrenzen** (GeoJSON-Format)
- **Bewässerungsdaten** des Projekts <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a> (CSV-Format)

## Baumbestandsdaten (Berlin Open Data)

````{margin}
```{admonition} Hinweis
:class: hinweis
WFS steht für Web Feature Service, also einen Zugriff auf Geo-Objekte über eine definierte Schnittstelle. Dabei werden in der Regel Vektordaten mit Sachinformationen abgefragt (s. beispielsweise den entsprechenden <a href="https://de.wikipedia.org/wiki/Web_Feature_Service" class="external-link" target="_blank">Wikipedia-Artikel</a> oder die Anleitung von <a href="https://offenedaten-koeln.de/blog/anleitung-zur-nutzung-von-geodatendiensten-wie-wms-und-wfs" class="external-link" target="_blank">Open Data Köln</a>).
```
````
Die Baumbestandsdaten stammen aus dem <a href="https://daten.berlin.de/" class="external-link" target="_blank">Berliner Open-Data-Portal</a> und umfassen sowohl Straßenbäume als auch Anlagebäume. Die Daten liegen im WFS-Format vor. 

Die Datensätze enthalten u.a. Informationen zu:
- Identifikatoren wie ``gml_id`` (ermöglicht Unterscheidung zwischen Anlagen- und Straßenbäumen), ``gisid`` ((eindeutiger GIS-Bezeichner des Baums, zusammengesetzt aus einem Bereichscode und einer individuellen Baum-ID, z. B. 00008100_000bf613; auch als ``pitid`` mit Doppelpunkt-Trennzeichen vorhanden)
- Botanische Klassifikation, z. B. Baumart: ``art_dtsch``, ``art_bot``, Gattung: ``gattung_deutsch``, ``gattung`` und Gruppe: ``art_gruppe``
- Standortmerkmale wie Straße: ``strname``, Hausnummer: ``hausnr``, Zusatz: ``zusatz``, Bezirk: ``bezirk``, Geometrie: ``geom`` (enthält Längen- und Breitengrad in anderem Format) und Standortnummer: ``standortnr``
- Pflanzjahr: ``pflanzjahr``

Zweck dieser Informationen ist das Verständnis über die Struktur des städtischen Baumbestands zu verbessern und diese in Beziehung zu den Gießdaten zu setzen. Das ist besonders wichtig, weil sich über die Identifikatoren die Informationen zu jedem einzelnen Baum sinnvoll zusammenführen lassen.

```{figure} /assets/WFS_Screenshot_20260324.png
---
align: center
width: 100%
name: WFSExplorer Baumbestand Berlin 
alt: Anzeige der beiden Layer Anlagenbäume und Straßenbäume im WFSExplorer von der Open Data Informationsstelle Berlin.
---
Screenshot des WFSExplorers der Open Data Informationsstelle mit <a href="https://wfsexplorer.odis-berlin.de/?wfs=https%3A%2F%2Fgdi.berlin.de%2Fservices%2Fwfs%2Fbaumbestand" class="external-link" target="_blank">Anzeige</a> der verfügbaren Layer vom 24.03.2026.
```


## Bezirksgrenzen (Berlin Open Data)

Für die geografische Einordnung des Baumbestands wurde zusätzlich der Datensatz zu den <a href="https://daten.odis-berlin.de/de/dataset/bezirksgrenzen/" class="external-link" target="_blank">Berliner Bezirksgrenzen</a> genutzt. Dieser enthält die polygonalen Abgrenzungen aller Berliner Bezirke u. a. im <a href="https://de.wikipedia.org/wiki/GeoJSON" class="external-link" target="_blank">GeoJson-Format</a> und ermöglicht damit eine präzise räumliche Zuordnung von Punktdaten. Enthalten sind zudem folgende Attribute:
- ``Gemeinde_name``: Name des Bezirks (z. B. Reinickendorf)
- ``Gemeinde_schluessel``: Dreistelliger Schlüssel des Bezirks
- ``Land_name`` und ``Land_schluessel``: Verwaltungszuordnung zu Berlin
- ``Schluessel_gesamt``: Vollständiger Gebietsschlüssel
- ``geometry``: Geometrische Beschreibung der Bezirksgrenzen als Multi-Polygon

Ebenso dient die Zuordnung als Grundlage für Visualisierungen und statistische Auswertungen auf Bezirksebene.

```{figure} /assets/ODIS_Screenshot_20260324.png
---
align: center
width: 100%
name: Berliner Bezirksgrenzen 
alt: Einfache Visualisierung der Bezirksgrenzen in Berlin.
---
Screenshot der Visualisierung der Berliner Bezirksgrenzen auf der Seite des Datensatzes vom 24.03.2026.
```

````{margin}
```{admonition} Daten herunterladen
:class: hinweis

Speichern Sie diese in Ihrem in Kapitel 1.2 erstellten Projektverzeichnis im Unterordner `data/` (erstellen Sie diesen, falls noch nicht vorhanden):  
**Bewässerungsdaten (CSV)**  
*Tipp: Machen Sie einen Rechtsklick auf den Link und wählen Sie "Link speichern unter..." (oder "Ziel speichern unter..."), um die Datei direkt herunterzuladen.*  
<a href="https://raw.githubusercontent.com/technologiestiftung/giessdenkiez-de-opendata/main/daten/giessdenkiez_bew%C3%A4sserungsdaten.csv" class="download-link" target='_blank'>🔗 Quelle</a> | <a href="https://raw.githubusercontent.com/quadriga-dk/Tabelle-Fallstudie-3/refs/heads/main/data/giessdenkiez_bew%C3%A4sserungsdaten.csv" class="download-link" target='_blank'>Backup</a>  

**Bezirksgrenzen (GeoJSON)**  
<a href="https://tsb-opendata.s3.eu-central-1.amazonaws.com/bezirksgrenzen/bezirksgrenzen.geojson" class="download-link" target='_blank'>🔗 Quelle</a> | <a href="https://raw.githubusercontent.com/quadriga-dk/Tabelle-Fallstudie-3/refs/heads/main/data/bezirksgrenzen.geojson" class="download-link" target='_blank'>Backup</a>  

*Baumbestandsdaten werden später direkt über WFS-Schnittstelle abgefragt.*
```
````
## Gieß den Kiez – Bewässerungsdaten (Govdata)

Die Datenplattform <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a> ist eine digitale Beteiligungsplattform, die Bewässerungsbedarfe von Straßenbäumen in Berlin erfasst und es Bürger:innen ermöglicht, Gießaktivitäten zu dokumentieren und zu koordinieren. Die Bewässerungsdaten stammen vom Portal <a href="https://www.govdata.de/suche/daten/giess-den-kiez-nutzungsdaten" class="external-link" target="_blank">GovData</a>. Der Datensatz enthält Informationen über einzelne Bewässerungsvorgänge.
Jeder Eintrag ist einem bestimmten Baum zugeordnet (zu erkennen an der ID) und umfasst unter anderem:

- Geokoordinaten (Längengrad: ``lng``, Breitengrad: ``lat``)
- Baumart: ``art_dtsch`` und Gattung: ``gattung_deutsch``
- Pflanzjahr: ``pflanzjahr``, Straßenname: ``strname`` und Bezirk: ``bezirk``
- Zeitpunkt der letzten Bewässerung: ``timestamp`` 
- Menge der Bewässerung in Litern: ``bewaesserungsmenge_in_liter``

Diese Daten ermöglichen Rückschlüsse auf Muster im Gießverhalten der Bevölkerung in dem Zeitraum 2020-2024 und versorgen die Visualisierung mit räumlich und zeitlich differenzierten Informationen zur städtischen Baumbewässerung.


