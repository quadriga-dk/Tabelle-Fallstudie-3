---
lang: de-DE
---

(daten-vorbereitung)=
# Vorbereitung der Daten: Einlesen und Bereinigung

Bevor Sie mit dem Bau eines Dashboards mit R Shiny beginnen können, müssen Sie die Daten einholen und bearbeiten. Dazu werden verschiedene Datensätze – der Berliner Baumkataster sowie manuell dokumentierte Gießdaten – zusammengeführt und so aufbereitet, dass sie für weitere Analysen und Visualisierungen verwendet werden können.

```{admonition} Story
:class: story
Dr. Amir Weber möchte sich zunächst einen schnellen Überblick verschaffen: Wie werden Bäume in Berlin gegossen und wie engagieren sich die Bürger:innen dabei? 
Bei seiner Recherche stößt er auf die Plattform <a href="https://www.giessdenkiez.de/stats?lang=de" class="external-link" target="_blank">Gieß den Kiez</a>. Besonders beeindruckt ihn, wie anschaulich die Daten dort visualisiert sind (s. Abb. 4.1). Die Mischung aus Zahlen zu Bäumen und Gießenden, Karten und Zeitverläufen inspirieren ihn so sehr, dass er sie für seine eigene R-Shiny-Anwendung übernehmen möchte. Dazu benötigt er folgende Daten:
```


## Daten laden, aggregieren und vorbereiten

````{margin}
```{admonition} Hinweis
:class: hinweis

Der Code ist am Ende jedes Unterkapitels in einer eingeklappten Box 'Gesamter Code' zusammengefasst. So haben Sie die Wahl, ob Sie den Code Stück für Stück oder in ganzen Blöcken eingeben.

```
````

<font color="red">Screenshot einfügen, der zeigt, wie die Eingabe des gesamten Codes bei R Shiny aussieht.</font> Mit Hinweis versehen: Dies ist der Code den Sie im folgenden Schritt für Schritt eingeben werden. Den gesamten Code finden Sie am Ende dieses Abschnitts.

**Installieren der Bibliotheken**

Bevor die Daten eingelesen werden können, müssen Sie folgende Bibliotheken (und, sofern noch nicht geschehen, davor noch die daugehörigen Pakete) laden:


```r
# --- PAKETE: ---
install.packages("sf")
install.packages("tidyverse")

# --- BIBLIOTHEKEN: ---
library(sf)
library(dplyr)
library(tidyr)
library(stringr)
```

**Laden der Baumkatasterdaten**

Die Berliner Baumdaten werden über eine WFS-Schnittstelle (Web Feature Service) bezogen. Dabei werden sowohl Anlagenbäume als auch Straßenbäume geladen. Dies geschieht mit dem Befehl `st_read`.
<font color="red">Hier könnte man dem User den Link zu den Daten geben, damit er diese herunterlädt und in sein Working Directory hinzufügt. Dazu müsste man ihm aber erklären wie man das korret settet, was gar nicht so einfach ist. Solange der Link gültig ist, lädt der Code zwar die Datei automatisch, speichert sie jedoch nicht im Directory.</font>

```r
#0 CSV File lokalisieren bzw. laden

local_path <- "Data/giessdenkiez_bewässerungsdaten.csv"
url_path <- "https://raw.githubusercontent.com/technologiestiftung/giessdenkiez-de-opendata/main/daten/giessdenkiez_bew%C3%A4sserungsdaten.csv"

if (file.exists(local_path)) {
  csv_data <- local_path
} else {
  csv_data <- url_path
}

# 1. Baumbestandsdaten laden
anlagenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:anlagenbaeume")
strassenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")
```

**Laden und Bereinigung der Gießdaten**

Die Gießdaten stammen aus einer CSV-Datei des Projekts „Gieß den Kiez“. Sie werden eingelesen und anschließend bereinigt, d. h.:

- Ungültige oder fehlende Koordinaten (Längen-/Breitengrad) werden entfernt.
- Datensätze ohne Straßenname oder mit fehlerhaften Gattungsbezeichnungen (z. B. numerische Werte) werden ausgeschlossen.

```r
# 2. Bewässerungsdaten laden und bereinigen
df_clean <- read.csv(csv_data, sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
  drop_na(lng, lat, bewaesserungsmenge_in_liter) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))
```

**Vereinheitlichung und Zusammenführung der Baumdaten**

````{margin}
```{admonition} Hinweis
:class: hinweis

EPSG:4326 (WGS 84) beschreibt die Erdoberfläche mit geografischen Koordinaten in Grad (Longitude/Latitude). Es ist das Standard-Koordinatensystem für GPS und die gängigste Grundlage für webbasierte Karten. Weitere Informationen dazu erhalten Sie z. B. in einem <a href="https://opendata.duesseldorf.de/blog/wgs-utm-etrs-ein-paar-informationen-zu-geobasisdaten-und-georeferenzsystemen" class="external-link" target="_blank">Blogbeitrag</a> von Open Data Düsseldorf.

```
````
Die beiden Baumdatenquellen werden vereinheitlicht (gemeinsames Koordinatensystem EPSG:4326) und zusammengeführt. Danach werden die Koordinaten explizit extrahiert und die Geometriedaten, also die technische Standortinformation jedes Baumes in einem speziellen räumlichen Format (z. B. die `geom`-Spalte mit Einträgen wie `c(" 394532.3", "5811461.0")`) entfernt, um die Dateigröße zu reduzieren und die Weiterverarbeitung zu erleichtern. 

```r
# 3. Bäume zusammenführen
baumbestand <- bind_rows(anlagenbaeume, strassenbaeume) %>%
  st_transform(crs = 4326)

# 4. Geometrie extrahieren
coords <- st_coordinates(baumbestand$geom)
baumbestand$lng <- coords[, "X"]
baumbestand$lat <- coords[, "Y"]
```

**Harmonisierung und Verknüpfung der Daten**

Die eindeutige Baumkennung `gisid` wird so angepasst, dass sie mit der id aus den Gießdaten übereinstimmt (Unterstrich wird zu Doppelpunkt). Dadurch können die beiden Datensätze über einen sogenannten "Left Join" zusammengeführt werden.

```r
# 5. Geometrie entfernen
baumbestand <- st_drop_geometry(baumbestand)

# 6. gisid anpassen (Unterstrich → Doppelpunkt)
baumbestand$gisid <- str_replace_all(baumbestand$gisid, "_", ":")

# 7. Bäume und Bewässerungsdaten mergen (über gisid = id)
df_merged <- baumbestand %>%
  left_join(df_clean %>% select(id, bewaesserungsmenge_in_liter, timestamp),
            by = c("gisid" = "id"))
```

**Speichern der kombinierten Daten**

Die aufbereiteten Daten werden als CSV-Datei gespeichert. Eine Ausgabe relevanter Kennzahlen (z. B. Anzahl verknüpfter Bäume) dient der Kontrolle.

```r
# 8. Ergebnis speichern
if (!dir.exists("data")) dir.create("data")
write.csv2(df_merged, "data/df_merged_final.csv", row.names = FALSE, fileEncoding = "UTF-8")
```

Wenn Sie möchten, schauen Sie sich den gesamten Code als einen Block an, bevor wir Baumdaten den Berliner Bezirken zuordnen:

````{admonition} Gesamter Code
:class: hinweis, dropdown

```r
library(sf)
library(dplyr)
library(tidyr)
library(stringr)

#0 CSV File lokalisieren bzw. laden

local_path <- "Data/giessdenkiez_bewässerungsdaten.csv"
url_path <- "https://raw.githubusercontent.com/technologiestiftung/giessdenkiez-de-opendata/main/daten/giessdenkiez_bew%C3%A4sserungsdaten.csv"

if (file.exists(local_path)) {
  csv_data <- local_path
} else {
  csv_data <- url_path
}

# 1. Baumbestandsdaten laden
anlagenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:anlagenbaeume")
strassenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")

# 2. Bewässerungsdaten laden und bereinigen
df_clean <- read.csv(csv_data, sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
  drop_na(lng, lat, bewaesserungsmenge_in_liter) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))

# 3. Bäume zusammenführen
baumbestand <- bind_rows(anlagenbaeume, strassenbaeume) %>%
  st_transform(crs = 4326)

# 4. Geometrie extrahieren
coords <- st_coordinates(baumbestand$geom)
baumbestand$lng <- coords[, "X"]
baumbestand$lat <- coords[, "Y"]

# 5. Geometrie entfernen
baumbestand <- st_drop_geometry(baumbestand)

# 6. gisid anpassen (Unterstrich → Doppelpunkt)
baumbestand$gisid <- str_replace_all(baumbestand$gisid, "_", ":")

# 7. Bäume und Bewässerungsdaten mergen (über gisid = id)
df_merged <- baumbestand %>%
  left_join(df_clean %>% select(id, bewaesserungsmenge_in_liter, timestamp),
            by = c("gisid" = "id"))

# 8. Ergebnis speichern
if (!dir.exists("data")) dir.create("data")
write.csv2(df_merged, "data/df_merged_final.csv", row.names = FALSE, fileEncoding = "UTF-8")

# 9. Kontrolle: Anzahl der Zeilen
cat("Anzahl Bäume nach Merge:", nrow(df_merged), "\n")
cat("Anzahl eindeutiger Bäume (pitid):", n_distinct(df_merged$pitid), "\n")
cat("Anzahl Bäume mit Bewässerungsdaten:", sum(!is.na(df_merged$bewaesserungsmenge_in_liter)), "\n")
```
````


## Geografische Zuordnung zu Berliner Bezirken

**Zielsetzung**

Einige Bäume verfügen nicht über eine Angabe zu ihrem Bezirk. Um eine aggregierte räumliche Analyse (z. B. Gießverhalten nach Bezirk) zu ermöglichen, werden fehlende Bezirksangaben durch räumliches Verschneiden mit offiziellen Bezirkspolygonen ergänzt.

**Methodik**

- Bäume ohne Bezirk werden in räumliche Objekte konvertiert (sf-Objekte).

- Mittels eines „spatial join“ wird ermittelt, in welchem Bezirk sich jeder Baum befindet.

- Das Ergebnis wird mit den ursprünglichen Daten wieder zusammengeführt.

**Code Erklärung:**

<font color="red">Die [Quelle](https://daten.odis-berlin.de/de/dataset/bezirksgrenzen/) der geojson Datei wird im vorherigen Kapitel verlinkt, allerdings wird nicht gesagt, dass man diese herunterzuladen hat. Die Erklärung zur korrekten lokalen Speicherung und Pfadsetzung muss auch noch ausgearbeitet werden, da sich dies von Endgerät zu Endgerät unterscheidet.</font>

**1. Die Bezirkskarte laden**

```r
local_geojson <- "data/bezirksgrenzen.geojson"
url_geojson <- "https://raw.githubusercontent.com/quadriga-dk/Tabelle-Fallstudie-3/6cd488f5f4306f9788bda3166d5929ad64312349/data/bezirksgrenzen.geojson"

if (file.exists(local_geojson)) {
  bezirksgrenzen <- st_read(local_geojson)
} else {
  bezirksgrenzen <- st_read(url_geojson)
}
```
- Es wird eine digitale Karte geladen, auf der die Bezirksgrenzen Berlins eingezeichnet sind.
- Jeder Bezirk hat dabei ein sogenanntes „Polygon“ – eine Art Umrisslinie.

**2. Die Baumdaten laden**

```r
df_baeume <- read.csv("data/df_merged_final.csv", sep = ";", stringsAsFactors = FALSE)
```
- Die Tabelle mit Baumdaten wird eingelesen. Jeder Eintrag beschreibt einen Baum: z. B. seine Art, Pflanzjahr und die Koordinaten, wo er steht.
- Manche Bäume haben schon einen Bezirk eingetragen, andere nicht.

**3. Koordinaten umwandeln**

```r
df_baeume <- df_baeume %>%
  mutate(
    lng = as.numeric(gsub(",", ".", lng)),
    lat = as.numeric(gsub(",", ".", lat))
  )

```
- Manche Koordinaten sind falsch formatiert (mit Komma statt Punkt, z. B. „13,405“ statt „13.405“). Das wird korrigiert, damit der Computer die Zahlen richtig versteht.

**4. Zwei Gruppen bilden:** 

```r
df_mit_bezirk <- df_baeume %>% filter(!is.na(bezirk))
df_ohne_bezirk <- df_baeume %>% filter(is.na(bezirk) & !is.na(lng) & !is.na(lat))
```
- **Gruppe 1:** Bäume, bei denen der Bezirk schon bekannt ist.
- **Gruppe 2:** Bäume, bei denen der Bezirk fehlt, aber die Koordinaten vorhanden sind.

**5. Gruppe ohne Bezirk in geografisches Format umwandeln**

```r
df_ohne_bezirk_sf <- st_as_sf(df_ohne_bezirk, coords = c("lng", "lat"), crs = 4326, remove = FALSE)
```
- Die zweite Gruppe wird in ein spezielles Format (sogenannte sf-Objekte) umgewandelt.
- Das ist notwendig, damit man mit Geodaten (Karten und Punkten auf Karten) arbeiten kann.

**6. Bezirksgrenzen vorbereiten**

```r
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = st_crs(df_ohne_bezirk_sf)) %>%
  rename(bezirk = Gemeinde_name)
```

- Die Karte der Bezirke wird ins gleiche geografische System wie die Baumdaten gebracht (Koordinatensystem).
- Außerdem wird der Name des Bezirksfeldes vereinfacht in „bezirk“.

**7. Räumlicher Vergleich: Welcher Baum liegt in welchem Bezirk?**

```r
df_ohne_bezirk_joined <- st_join(df_ohne_bezirk_sf, bezirksgrenzen["bezirk"], left = TRUE)
```

- Jetzt wird für jeden Baum ohne Bezirk geschaut, ob er innerhalb eines Bezirks liegt.
- Dafür wird überprüft, welches Bezirks-Polygon (d. h. die digitale Umrissfläche eines Bezirks, die dessen geografische Grenzen als geschlossene Fläche auf der Karte abbildet) den jeweiligen Baum „einschließt".
- Dieser Vorgang heißt „spatial join“ – also ein räumliches Verbinden.

**8. Ergebnis bereinigen und in normales Tabellenformat bringen**

```r
df_ohne_bezirk_filled <- df_ohne_bezirk_joined %>%
  mutate(bezirk = ifelse(is.na(bezirk.x), bezirk.y, bezirk.x)) %>%
  select(-bezirk.x, -bezirk.y) %>%
  st_drop_geometry()
```
- Die berechneten Bezirksangaben werden in die Tabelle übernommen.
- Zusätzliche technische Spalten werden entfernt.
- Die geografischen Informationen werden wieder „fallen lassen“, damit es wieder eine normale Tabelle ist.

**9. Beide Gruppen wieder zusammenfügen**
```r
df_baeume_final <- bind_rows(df_mit_bezirk, df_ohne_bezirk_filled)
```

- Jetzt werden alle Bäume wieder in einer Tabelle vereint:

    - Die, die schon einen Bezirk hatten.
    - Und die, denen jetzt ein Bezirk zugeordnet wurde.

**10. Neue, vollständige Tabelle speichern**
```r
if (!dir.exists("data")) dir.create("data")
write.csv2(df_baeume_final, file = "data/df_merged_final.csv", row.names = FALSE)
```
- Die neue Tabelle mit allen Bäumen und Bezirken wird als Datei gespeichert.

Am Ende haben Sie wieder die Möglichkeit, sich den gesamten Code anzusehen, bevor wir im nächsten Kapitel die Entwicklungsumgebung auf den Bau des Dashboards vorbereiten.

````{admonition} Gesamter Code
:class: hinweis, dropdown

```r
library(sf)
library(dplyr)

# 1. Lade die Bezirkspolygone
local_geojson <- "data/bezirksgrenzen.geojson"
url_geojson <- "https://raw.githubusercontent.com/quadriga-dk/Tabelle-Fallstudie-3/6cd488f5f4306f9788bda3166d5929ad64312349/data/bezirksgrenzen.geojson"

if (file.exists(local_geojson)) {
  bezirksgrenzen <- st_read(local_geojson)
} else {
  bezirksgrenzen <- st_read(url_geojson)
}

# 2. Lade die Baumdaten
df_baeume <- read.csv("data/df_merged_final.csv", sep = ";", stringsAsFactors = FALSE)

# 3. Koordinaten korrekt umwandeln
df_baeume <- df_baeume %>%
  mutate(
    lng = as.numeric(gsub(",", ".", lng)),
    lat = as.numeric(gsub(",", ".", lat))
  )

# 4. Zerlege in zwei Gruppen
df_mit_bezirk <- df_baeume %>% filter(!is.na(bezirk))
df_ohne_bezirk <- df_baeume %>% filter(is.na(bezirk) & !is.na(lng) & !is.na(lat))

# 5. Konvertiere nur die ohne Bezirk zu sf
df_ohne_bezirk_sf <- st_as_sf(df_ohne_bezirk, coords = c("lng", "lat"), crs = 4326, remove = FALSE)

# 6. Bezirkspolygone vorbereiten
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = st_crs(df_ohne_bezirk_sf)) %>%
  rename(bezirk = Gemeinde_name)

# 7. Räumlicher Join
df_ohne_bezirk_joined <- st_join(df_ohne_bezirk_sf, bezirksgrenzen["bezirk"], left = TRUE)

# 8. In DataFrame zurückwandeln
df_ohne_bezirk_filled <- df_ohne_bezirk_joined %>%
  mutate(bezirk = ifelse(is.na(bezirk.x), bezirk.y, bezirk.x)) %>%
  select(-bezirk.x, -bezirk.y) %>%
  st_drop_geometry()

# 9. Zusammenführen mit ursprünglichen Daten, die bereits einen Bezirk hatten
df_baeume_final <- bind_rows(df_mit_bezirk, df_ohne_bezirk_filled)

# 10. Ergebnis speichern
if (!dir.exists("data")) dir.create("data")
write.csv2(df_baeume_final, file = "data/df_merged_final.csv", row.names = FALSE)

```
````
