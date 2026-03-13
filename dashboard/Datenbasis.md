---
lang: de-DE
---

(datenbasis)=
# Datenbasis

```{admonition} Story
:class: story
Amir Weber macht sich Gedanken, welche Daten er braucht und woher er sie beziehen kann... Dabei fällt ihm das Berliner Projekt Gieß den Kiez ein, welches diese Daten bereits erhebt und zur Verfügung stellt. Er prüft zudem, welche Daten noch relevant sind und auf welche Weise sie beschafft werden können.
```


In diesem Kapitel stellen wir Ihnen die Daten vor, die wir zur Beantwortung unserer Forschungsfrage benötigen und warum sie von Interesse sind.

Die Daten werden für die Datenvisualisierung in RShiny benötigt. Dazu brauchen wir zwei zentrale Datensätze: 
- Daten über den Berliner Baumbestand
- Bewässerungsdaten des Projekts <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a>
 
Diese Datengrundlage ermöglicht eine fundierte Analyse der urbanen Bewässerungsinfrastruktur in Berlin.
 


## Gieß den Kiez – Bewässerungsdaten (Govdata)

Die Datenplattform <a href="https://citylab-berlin.org/en/projects/giessdenkiez/" class="external-link" target="_blank">Gieß den Kiez</a> ist eine digitale Beteiligungsplattform, die Bewässerungsbedarfe von Straßenbäumen in Berlin erfasst und es Bürger*innen ermöglicht, Gießaktivitäten zu dokumentieren und zu koordinieren. Wir beziehen die Bewässerungsdaten über das Portal <a href="https://www.govdata.de/suche/daten/giess-den-kiez-nutzungsdaten" class="external-link" target="_blank">GovData</a>. Der Datensatz enthält Informationen über einzelne Bewässerungsvorgänge.
Jeder Eintrag ist einem bestimmten Baum zugeordnet (zu erkennen an der ID) und umfasst unter anderem:

- Geokoordinaten (Längengrad: ``lng``, Breitengrad: ``lat``)
- Baumart: ``art_dtsch`` und Gattung: ``gattung_deutsch``
- Pflanzjahr: ``pflanzjahr``, Straßenname: ``strname`` und Bezirk: ``bezirk``
- Zeitpunkt der letzten Bewässerung: ``timestamp`` 
- Menge der Bewässerung in Litern: ``bewaesserungsmenge_in_liter``

Diese Daten ermöglichen Rückschlüsse auf Muster im Gießverhalten der Bevölkerung in dem Zeitraum 2020-2024 und versorgen die Visualisierung mit räumlich und zeitlich differenzierten Informationen zur städtischen Baumbewässerung.


```{figure} ../assets/Karte_mit_Personen.png
---
name: Karte_mit_Personen
alt: Ein Screenshot, der ein comicartiges Bild einer Berlin-Karte zeigt, auf der Bäume von Personen gegossen werden.
width: 400px
---
Karte mit Personen darauf. (KI generiert)
```

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
- Botanische Klassifikation, z. B. Baumart: ``art_dtsch``, ``art_bot``, Gattung: ``gattung_deutsch``, ``gattung`` und Gruppe: ``art_gruppe``)
- Standortmerkmale wie Straße: ``strname``, Hausnummer: ``hausnr``, Zusatz: ``zusatz``, Bezirk: ``bezirk``, Geometrie: ``geom`` (enthält Längen- und Breitengrad in anderem Format) und Standortnummer: ``standortnr``
- Pflanzjahr: ``pflanzjahr``

Sie dienen dazu, die Struktur des städtischen Baumbestands besser zu verstehen und in Beziehung zu den Gießdaten zu setzen. Das ist besonders wichtig, weil sich über die Identifikatoren die Informationen zu jedem einzelnen Baum sinnvoll zusammenführen lassen.

## Bezirksgrenzen (Berlin Open Data)

Für die geografische Einordnung des Baumbestands wurde zusätzlich der Datensatz zu den <a href="https://daten.odis-berlin.de/de/dataset/bezirksgrenzen/" class="external-link" target="_blank">Berliner Bezirksgrenzen</a> genutzt. Dieser enthält die polygonalen Abgrenzungen aller Berliner Bezirke im <a href="https://de.wikipedia.org/wiki/GeoJSON" class="external-link" target="_blank">GeoJson-Format</a> und ermöglicht damit eine präzise räumliche Zuordnung von Punktdaten und enthalten pro Bezirk unter anderem folgende Attribute:
- ``Gemeinde_name``: Name des Bezirks (z. B. Reinickendorf)
- ``Gemeinde_schluessel``: Dreistelliger Schlüssel des Bezirks
- ``Land_name`` und ``Land_schluessel``: Verwaltungszuordnung zu Berlin
- ``Schluessel_gesamt``: Vollständiger Gebietsschlüssel
- ``geometry``: Geometrische Beschreibung der Bezirksgrenzen als Multi-Polygon

Ebenso dient die Zuordnung als Grundlage für Visualisierungen und statistische Auswertungen auf Bezirksebene.

## Öffentliche Wasserbrunnen (OpenStreetMap via Overpass API) - Kapitel wird noch rausgeschmissen

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

## Bezirksflächen (Grünflächeninformationssystem (GRIS))  - Kapitel wird noch rausgeschmissen
Um die Verteilung und Dichte öffentlicher Wasserpumpen innerhalb der Berliner Bezirke besser quantifizieren zu können, wurden ergänzend Flächendaten aus dem Grünflächeninformationssystem (GRIS) des Landes Berlin herangezogen. Die Flächenangaben dienen insbesondere dazu, die Pumpendichte pro Hektar (ha) auf Bezirksebene zu berechnen und damit die infrastrukturelle Versorgung vergleichbar darzustellen.

Die Flächendaten wurden aus einer tabellarischen Quelle des GRIS extrahiert und manuell in ein strukturiertes Dataframe überführt. Dieses enthält pro Bezirk folgende Informationen:

- ``bezirk``: Name des Berliner Bezirks

- ``flaeche_ha``: Bezirksfläche in Hektar

```{figure} /assets/Bezirksfläche.png
---
name: Tabelle mit Angaben zu Bezirksflächen
alt: Ein Screenshot, der eine Tabelle zu den größen der Bezirksflächen in Berlin in Hektar enthält.
---
Tabelle mit Angaben zu Bezirksflächen
```

```bash
bezirksflaechen <- data.frame(
  bezirk = c("Mitte", "Friedrichshain-Kreuzberg", "Pankow", "Charlottenburg-Wilmersdorf",
             "Spandau", "Steglitz-Zehlendorf", "Tempelhof-Schöneberg", "Neukölln",
             "Treptow-Köpenick", "Marzahn-Hellersdorf", "Lichtenberg", "Reinickendorf"),
  flaeche_ha = c(3.940, 2.040, 10.322, 6.469, 9.188, 10.256, 5.305, 4.493, 16.773, 6.182, 5.212, 8.932)
)
```

Diese Daten ermöglichen flächenbezogene Vergleiche der Pumpendichte und bilden eine wichtige Grundlage für die Bewertung der Verteilung öffentlicher Wasserquellen im urbanen Raum.
