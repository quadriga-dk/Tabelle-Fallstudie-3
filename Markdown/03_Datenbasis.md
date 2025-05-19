(Datenbasis)=
# Datenbasis: 

Im Rahmen dieser Fallstudie beschäftigen wir uns unter anderem mit der Datenvisualisierung in R Shiny. Dabei nutzen wir drei zentrale Datensätze: Zum einen die Bewässerungsdaten des Projekts <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a>, die wir ergänzen, um fehlende Baumdaten auszugleichen. Ergänzend verwenden wir den Berliner Baumbestand sowie Informationen zu öffentlichen Wasserpumpen, um die Visualisierungsergebnisse besser einordnen und vergleichend darstellen zu können. Diese Datengrundlage ermöglicht eine fundierte Analyse der urbanen Bewässerungsinfrastruktur in Berlin.

## Gieß den Kiez – Bewässerungsdaten (Govdata)

Die Datenplattform <a href="https://www.govdata.de/suche/daten/giess-den-kiez-nutzungsdaten" class="external-link" target="_blank">Gieß den Kiez</a> dokumentiert die freiwillige Bewässerung städtischer Bäume durch Bürger:innen. Der Datensatz enthält Informationen über einzelne Bewässerungsvorgänge.
Jeder Eintrag ist einem bestimmten Baum zugeordnet (zu erkennen durch die ID) und umfasst unter anderem:

- Geokoordinaten (Längengrad: ``lng``, Breitengrad: ``lat``)
- Baumart: ``art_dtsch`` und Gattung: ``gattung_deutsch``
- Pflanzjahr: ``pflanzjahr``, Straßenname: ``strname`` und Bezirk: ``bezirk``
- Zeitpunkt der letzten Bewässerung: ``timestamp`` 
- Menge der Bewässerung in Litern: ``bewaesserungsmenge_in_liter``

Diese Daten ermöglichen Rückschlüsse auf Muster im Gießverhalten der Bevölkerung in dem Zeitraum 2020-2024 und versorgen die Visualisierung mit räumlich und zeitlich differenzierten Informationen zur städtischen Baumbewässerung.


```{figure} _images/Karte_mit_Personen.png
---
name: Karte_mit_Personen
alt: Ein Screenshot, der ein comicartiges Bild einer Berlin-Karte zeigt, auf der Bäume von Personen gegossen werden.
---
Karte mit Personen darauf. (KI generiert)
```

## Baumbestandsdaten (Berlin Open Data)

````{margin}
```{admonition}
:class: hinweis
WFS steht für Web Feature Service, also einen Zugriff auf Geo-Objekte über eine definierte Schnittstelle. Dabei werden in der Regel Vektordaten mit Sachinformationen abgefragt (s. beispielsweise den entsprechenden <a href="https://de.wikipedia.org/wiki/Web_Feature_Service" class="external-link" target="_blank">Wikipedia-Artikel</a> oder die Anleitung von <a href="https://offenedaten-koeln.de/blog/anleitung-zur-nutzung-von-geodatendiensten-wie-wms-und-wfs" class="external-link" target="_blank">Open Data Köln</a>).
```
````
Die Baumbestandsdaten stammen aus dem <a href="https://daten.berlin.de/" class="external-link" target="_blank">Berliner Open-Data-Portal</a> und umfassen sowohl Straßenbäume als auch Anlagebäume. Die Daten liegen im WFS-Format vor. 

Die Datensätze enthalten unter anderem Informationen zu:
- Identifikatoren wie ``gml_id`` (ermöglicht Unterscheidung zwischen Anlagen- und Straßenbäumen), ``gisid`` und ``pitid``
- Kennzeichen: ``kennzeichen``
- Botanische Klassifikation, z. B. Baumart: ``art_dtsch``, ``art_bot``, Gattung: ``gattung_deutsch``, ``gattung`` und Gruppe: ``art_gruppe``)
- Standortmerkmale wie Straße: ``strname``, Hausnummer: ``hausnr``, Zusatz: ``zusatz``, Bezirk: ``bezirk``, Geometrie: ``geom`` (enthält Längen- und Breitengrad in anderem Format) und Standortnummer: ``standortnr``
- Baummaße, z. B. Kronendurchmesser: ``kronedurch``, Stammumfang: ``stammumfg`` und Höhe: ``baumhoehe``
- Eigentumsverhältnisse: ``eigentuemer``
- Pflanzjahr: ``pflanzjahr``

Sie dienen dazu, die Struktur des städtischen Baumbestands besser zu verstehen und mit den Gießdaten in Beziehung zu setzen.

## Öffentliche Pumpen (OpenStreetMap via Overpass API)

Zur Identifikation potenzieller Wasserquellen für die Baumgießung wurden Daten zu öffentlichen Wasserpumpen aus <a href="https://overpass-turbo.eu/" class="external-link" target="_blank">Overpass Turbo</a> extrahiert. Dabei handelt es sich um ein Daten-Filterungs-Werkzeug für <a href="https://www.openstreetmap.org/" class="external-link" target="_blank">OpenStreetMap</a> (OSM). Mithilfe einer Abfrage im OpenStreetMap-Tagging-Schema "man_made"="water_well" 

```bash
[out:json][timeout:60];
// Berliner Stadtgrenze (Relation)
{{geocodeArea:Berlin}}->.searchArea;

// Suche nach Wasserpumpen innerhalb Berlins
(
  node["man_made"="water_well"](area.searchArea);
  way["man_made"="water_well"](area.searchArea);
  relation["man_made"="water_well"](area.searchArea);
);
out body;
>;
out skel qt;
```

wurde eine umfangreiche Sammlung relevanter Pumpenstandorte generiert. Die resultierenden Daten enthalten zahlreiche Attribute, von denen besonders relevant sind:

- Geolokation (Punktgeometrie: ``geometry``)
- Zugänglichkeit (``access``)
- Pumpentyp und Stil (``pump.status``, ``pump.style``, Pumpenbedinung: ``pump``)
- Identifikator(``id``)

## Bezirksgrenzen (Berlin Open Data)

Zur besseren geografischen Einordnung der Pumpen wurde zusätzlich der Datensatz zu den <a href="https://daten.odis-berlin.de/de/dataset/bezirksgrenzen/" class="external-link" target="_blank">Berliner Bezirksgrenzen</a> genutzt. Dieser enthält die polygonalen Abgrenzungen aller Berliner Bezirke im <a href="https://de.wikipedia.org/wiki/GeoJSON" class="external-link" target="_blank">GeoJson-Format</a> und ermöglicht damit eine präzise räumliche Zuordnung von Punktdaten und enthalten pro Bezirk unter anderem folgende Attribute:
- ``Gemeinde_name``: Name des Bezirks (z. B. Reinickendorf)
- ``Gemeinde_schluessel``: Dreistelliger Schlüssel des Bezirks
- ``Land_name`` und ``Land_schluessel``: Verwaltungszuordnung zu Berlin
- ``Schluessel_gesamt``: Vollständiger Gebietsschlüssel
- ``geometry``: Geometrische Beschreibung der Bezirksgrenzen als Multi-Polygon

Konkret wurden die Bezirksgrenzen verwendet, um die Lage der Wasserpumpen innerhalb des Stadtgebiets einzelnen Bezirken zuzuweisen. Dies ist insbesondere für die Analyse lokaler Versorgungsdichten, infrastruktureller Ausstattung oder potenzieller Versorgungslücken von Bedeutung. Ebenso dient die Zuordnung als Grundlage für Visualisierungen und statistische Auswertungen auf Bezirksebene.

Bezirksflächen (Grünflächeninformationssystem (GRIS)) 
Zudem wurden auch noch Daten zu den Bezirksfläche aus dem Berliner GRIS Portal  gesammelt, um die Pumpendichte pro Bezirk je Hektar (ha) zu berechnen. 

Dafür wurden diese Informationen aus der Tabelle verwendet um ein Dataframe zu erstellen:  

```{figure} _images/Bezirksfläche.png
---
name: Tabelle mit Angaben zu Bezirksflächen
alt: Ein Screenshot, der eine Tabelle zu den größen der Bezirksflächen in Berlin in Hektar enthält.
---
Tabelle mit Angaben zu Bezirksflächen
```

bezirksflaechen <- data.frame(
  bezirk = c("Mitte", "Friedrichshain-Kreuzberg", "Pankow", "Charlottenburg-Wilmersdorf",
             "Spandau", "Steglitz-Zehlendorf", "Tempelhof-Schöneberg", "Neukölln",
             "Treptow-Köpenick", "Marzahn-Hellersdorf", "Lichtenberg", "Reinickendorf"),
  flaeche_ha = c(3.940, 2.040, 10.322, 6.469, 9.188, 10.256, 5.305, 4.493, 16.773, 6.182, 5.212, 8.932)
)


## Lebensweltlich orientierte Räume auswähle (LOR GovData)
 Für eine feinräumigere Analyse des Gießverhaltens in Berlin wurden zusätzlich die Lebensweltlich orientierten Räume (LOR) berücksichtigt. Dabei handelt es sich um ein offizielles kleinräumiges Gebietsgliederungssystem, das vom Amt für Statistik Berlin-Brandenburg bereitgestellt und gepflegt wird. Die Einteilung der Stadt in sogenannte Planungsräume ermöglicht differenzierte sozialräumliche Auswertungen und bietet eine sinnvolle Ergänzung zu den Bezirksgrenzen.

Die LOR-Daten wurden über das Portal <a href="https://www.govdata.de/suche/daten/lebensweltlich-orientierte-raume-lor-01-01-2019" class="external-link" target="_blank">GovData</a> bezogen und liegen im Geo-Datenformat mit räumlichen Polygonen vor. Der vollständige Datensatz enthält zahlreiche Attribute – für unsere Analyse relevant sind insbesondere:

- ``bzr_id``: ID des Bezirksregionsraums
- ``bzr_name``: Name des Bezirksregionsraums
- ``geom``: Geometrie (räumliche Abgrenzung als Polygon)

Diese Informationen ermöglichen eine detailliertere geografische Segmentierung der Gießaktivitäten und erlauben den Vergleich zwischen verschiedenen Berliner Stadtteilen jenseits der groben Bezirksebene. Die LOR-Zuordnung wurde insbesondere für kleinräumige Visualisierungen sowie für die Untersuchung sozialräumlicher Unterschiede in der Baumgießbeteiligung herangezogen.

