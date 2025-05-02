(Datenbasis)=
# Datenbasis: 

Im Rahmen dieser Fallstudie beschäftigen wir uns mit der Datenvisualisierung in R Shiny. Dabei nutzen wir drei zentrale Datensätze: Zum einen die Bewässerungsdaten des Projekts <a href="https://citylab-berlin.org/en/projects/giessdenkiez/">Gieß den Kiez</a>, die wir ergänzen, um fehlende Baumdaten auszugleichen. Ergänzend verwenden wir den Berliner Baumbestand sowie Informationen zu öffentlichen Wasserpumpen, um die Visualisierungsergebnisse besser einordnen und vergleichend darstellen zu können. Diese Datengrundlage ermöglicht eine fundierte Analyse der urbanen Bewässerungsinfrastruktur in Berlin.

## Gieß den Kiez – Bewässerungsdaten (Govdata)

Die Datenplattform <a href="https://www.govdata.de/suche/daten/giess-den-kiez-nutzungsdaten" target="_blank"> Gieß den Kiez</a> dokumentiert die freiwillige Bewässerung städtischer Bäume durch Bürger:innen. Der Datensatz enthält Informationen über einzelne Bewässerungsvorgänge.
Jeder Eintrag ist einem bestimmten Baum zugeordnet (zu erkennen durch die Id) und umfasst unter anderem:

- Geokoordinaten (Längengrad: ``lng``, Breitengrad: ``lat``)
- Baumart: ``art_dtsch`` und Gattung: ``gattung_deutsch``
- Pflanzjahr`: ``pflanzjahr``, Straßenname: ``strname`` und Bezirk: ``bezirk``
- Zeitpunkt: ``timestamp`` der letzten Bewässerung
- Menge der Bewässerung in Litern: ``bewaesserungsmenge_in_liter``

Diese Daten ermöglichen Rückschlüsse auf Engagementsmuster der Bevölkerung in dem Zeitraum 2020-2024 und versorgen die Visualisierung mit räumlich und zeitlich differenzierten Informationen zur städtischen Baumbewässerung.


```{figure} _images/Karte_mit_Personen.png
---
name: Karte_mit_Personen
alt: Ein Screenshot, der ein comicartiges Bild einer Berlin-Karte zeigt, auf der Bäume von Personen gegossen werden.
---
Karte mit Personen darauf.
```

## Baumbestandsdaten (Berlin Open Data)

Die Baumbestandsdaten stammen aus dem Berliner Open-Data-Portal und umfassen sowohl Straßenbäume als auch Anlagebäume. Die Daten liegen im WFS-Format vor. 

Die Datensätze enthalten unter anderem Informationen zu:
- Identificatoren wie ```gml_id`` (ermöglicht unterscheidung zwischen Anlagen- und Straßenbäumen), ``gisid`` und ``pitid``, Kennzeichen: ``kennzeichen``
- Botanische Klassifikation (Art: ``art_dtsch``, ``art_bot``, Gattung: ``gattung_deutsch``, ``gattung``, Gruppe: ``art_gruppe``)
- Standortmerkmale (Straße: ``strname``, Hausnummer: ``hausnr``, Zusatz: ``zusatz`` Bezirk: ``bezirk`` , Geometrie: ``geom`` enthält Längen- und Breitengrad in anderem Format, Standortnummer: ``standortnr``)
- Baummaße (Kronendurchmesser: ``kronedurch``, Stammumfang: ``stammumfg``, Höhe: ``baumhoehe``)
- Eigentumsverhältnisse: ``eigentuemer`` und Pflanzjahr: ``pflanzjahr``

Sie dienen dazu, die Struktur des städtischen Baumbestands besser zu verstehen und mit den Gießdaten in Beziehung zu setzen.

## Öffentliche Pumpen (OpenStreetMap via Overpass API)

Zur Identifikation potenzieller Wasserquellen für die Baumgießung wurden Daten zu öffentlichen Wasserpumpen aus <a href="https://overpass-turbo.eu/" target="_blank">Overpass Turbo</a> extrahiert. Mithilfe einer Abfrage im OpenStreetMap-Tagging-Schema "man_made"="water_well" 

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

Zur geografischen besseren Einordnung der Pumpen wurde zusätzlich der Datensatz zu den <a href="https://daten.odis-berlin.de/de/dataset/bezirksgrenzen/"> Berliner Bezirksgrenzen </a> genutzt. Dieser enthält die polygonalen Abgrenzungen aller Berliner Bezirke im GeoJson-Format und ermöglicht damit eine präzise räumliche Zuordnung von Punktdaten und enthalten pro Bezirk unter anderem folgende Attribute:
- ``Gemeinde_name``: Name des Bezirks (z. B. Reinickendorf)
- ``Gemeinde_schluessel``: Dreistelliger Schlüssel des Bezirks
- ``Land_name`` und ``Land_schluessel``: Verwaltungszuordnung zu Berlin
- ``Schluessel_gesamt``: Vollständiger Gebietsschlüssel
- ``geometry``: Geometrische Beschreibung der Bezirksgrenzen als Multi-Polygon

Konkret wurden die Bezirksgrenzen verwendet, um die Lage der Wasserpumpen innerhalb des Stadtgebiets einzelnen Bezirken zuzuweisen. Dies ist insbesondere für die Analyse lokaler Versorgungsdichten, infrastruktureller Ausstattung oder potenzieller Versorgungslücken von Bedeutung. Ebenso dient die Zuordnung als Grundlage für Visualisierungen und statistische Auswertungen auf Bezirksebene.

