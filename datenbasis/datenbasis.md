---
lang: de-DE
---

(datenbasis)=
# Datenbasis

```{admonition} Story
:class: story
Dr. Amir Weber macht sich Gedanken, welche Daten er braucht und woher er sie beziehen kann. Wichtig sind vor allem Daten über den Baumbestand und Bewässerungsdaten.  
Dabei fällt ihm das Berliner Projekt Gieß den Kiez ein, welches diese Daten bereits erhebt und zur Verfügung stellt. Er prüft zudem, welche Daten noch relevant sind und auf welche Weise sie beschafft werden können.
```

In diesem Abschnitt werden Ihnen die Daten vorgestellt, die zur Beantwortung der Leitfrage und als Datenbasis für ein Dashboard benötigt werden. Im nächsten Abschnitt werden diese dann eingelesen.

Dabei handelt es sich um zwei zentrale Datensätze: 
- Daten über den Berliner Baumbestand
- Bewässerungsdaten des Projekts <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a> 

## Baumbestandsdaten (Berlin Open Data)

````{margin}
```{admonition} Hinweis
:class: hinweis
WFS steht für Web Feature Service, also einen Zugriff auf Geo-Objekte über eine definierte Schnittstelle. Dabei werden in der Regel Vektordaten mit Sachinformationen abgefragt (s. beispielsweise den entsprechenden <a href="https://de.wikipedia.org/wiki/Web_Feature_Service" class="external-link" target="_blank">Wikipedia-Artikel</a> oder die Anleitung von <a href="https://offenedaten-koeln.de/blog/anleitung-zur-nutzung-von-geodatendiensten-wie-wms-und-wfs" class="external-link" target="_blank">Open Data Köln</a>).
```
````
Die Baumbestandsdaten stammen aus dem <a href="https://daten.berlin.de/" class="external-link" target="_blank">Berliner Open-Data-Portal</a> und umfassen sowohl Straßenbäume als auch Anlagebäume. Die Daten liegen im WFS-Format vor. 

Die Datensätze enthalten u.a. Informationen zu:
- Identifikatoren wie ``gml_id`` (ermöglicht Unterscheidung zwischen Anlagen- und Straßenbäumen), ``gisid`` und ``pitid``
- Botanische Klassifikation, z. B. Baumart: ``art_dtsch``, ``art_bot``, Gattung: ``gattung_deutsch``, ``gattung`` und Gruppe: ``art_gruppe``
- Standortmerkmale wie Straße: ``strname``, Hausnummer: ``hausnr``, Zusatz: ``zusatz``, Bezirk: ``bezirk``, Geometrie: ``geom`` (enthält Längen- und Breitengrad in anderem Format) und Standortnummer: ``standortnr``
- Pflanzjahr: ``pflanzjahr``

Sie dienen dazu, die Struktur des städtischen Baumbestands besser zu verstehen und in Beziehung zu den Gießdaten zu setzen. Das ist besonders wichtig, weil sich über die Identifikatoren die Informationen zu jedem einzelnen Baum sinnvoll zusammenführen lassen.

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

## Gieß den Kiez – Bewässerungsdaten (Govdata)

Die Datenplattform <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a> ist eine digitale Beteiligungsplattform, die Bewässerungsbedarfe von Straßenbäumen in Berlin erfasst und es Bürger:innen ermöglicht, Gießaktivitäten zu dokumentieren und zu koordinieren. Wir beziehen die Bewässerungsdaten über das Portal <a href="https://www.govdata.de/suche/daten/giess-den-kiez-nutzungsdaten" class="external-link" target="_blank">GovData</a>. Der Datensatz enthält Informationen über einzelne Bewässerungsvorgänge.
Jeder Eintrag ist einem bestimmten Baum zugeordnet (zu erkennen an der ID) und umfasst unter anderem:

- Geokoordinaten (Längengrad: ``lng``, Breitengrad: ``lat``)
- Baumart: ``art_dtsch`` und Gattung: ``gattung_deutsch``
- Pflanzjahr: ``pflanzjahr``, Straßenname: ``strname`` und Bezirk: ``bezirk``
- Zeitpunkt der letzten Bewässerung: ``timestamp`` 
- Menge der Bewässerung in Litern: ``bewaesserungsmenge_in_liter``

Diese Daten ermöglichen Rückschlüsse auf Muster im Gießverhalten der Bevölkerung in dem Zeitraum 2020-2024 und versorgen die Visualisierung mit räumlich und zeitlich differenzierten Informationen zur städtischen Baumbewässerung.


