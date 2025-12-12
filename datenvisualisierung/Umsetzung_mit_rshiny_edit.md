---
lang: de-DE
---

(umsetzung)=
# Vorbereitung der Daten: Einlesen und Bereinigung

## Umsetzung mit R Shiny

```{admonition} Zweck dieser Übung
:class: lernziele

Ziel dieses Schrittes ist es, verschiedene Datensätze – insbesondere den Berliner Baumkataster sowie manuell dokumentierte Gießdaten – zusammenzuführen und so aufzubereiten, dass sie für weitere Analysen und Visualisierungen (z. B. in einer interaktiven Karte) verwendet werden können.

```

**Laden der Baumkatasterdaten**
Die Berliner Baumdaten werden über eine WFS-Schnittstelle (Web Feature Service) bezogen. Dabei werden sowohl Anlagenbäume als auch Straßenbäume geladen. 

```bash
anlagenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:anlagenbaeume")
strassenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")
```
**Laden und Bereinigung der Gießdaten**
Die Gießdaten stammen aus einer CSV-Datei des Projekts „Gieß den Kiez“. Sie werden eingelesen und anschließend bereinigt:

Ungültige oder fehlende Koordinaten (Längen-/Breitengrad) werden entfernt.

Datensätze ohne Straßenname oder mit fehlerhaften Gattungsbezeichnungen (z. B. numerische Werte) werden ausgeschlossen.

```bash
# 2. Bewässerungsdaten laden
df_clean <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
  drop_na(lng, lat, bewaesserungsmenge_in_liter) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))
```
**Vereinheitlichung und Zusammenführung der Baumdaten**
Die beiden Baumdatenquellen werden vereinheitlicht (gemeinsames Koordinatensystem EPSG:4326) und zusammengeführt. Danach werden die Koordinaten explizit extrahiert und die Geometriedaten entfernt, um die Dateigröße zu reduzieren und die Weiterverarbeitung zu erleichtern. EPSG:4326 (WGS 84) beschreibt die Erdoberfläche mit geografischen Koordinaten in Grad (Longitude/Latitude). Es ist das Standard-Koordinatensystem für GPS und die gängigste Grundlage für webbasierte Karten.

```bash
# 3. Bäume zusammenführen
baumbestand <- bind_rows(anlagenbaeume, strassenbaeume) %>%
  st_transform(crs = 4326)

# 4. Geometrie extrahieren
coords <- st_coordinates(baumbestand$geom)
baumbestand$lng <- coords[, "X"]
baumbestand$lat <- coords[, "Y"]
```
**Harmonisierung und Verknüpfung der Daten**
Die eindeutige Baumkennung gisid wird so angepasst, dass sie mit der id aus den Gießdaten übereinstimmt (Unterstrich wird zu Doppelpunkt). Dadurch können die beiden Datensätze über einen sogenannten "Left Join" zusammengeführt werden.

```bash
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
Die aufbereiteten Daten werden als CSV-Datei gespeichert. Eine Ausgabe relevanter Kennzahlen (z.B. Anzahl verknüpfter Bäume) dient der Kontrolle.

```bash
# 8. Ergebnis speichern
write.csv2(df_merged, "data/df_merged_final.csv", row.names = FALSE, fileEncoding = "UTF-8")
```
<details>
<summary><strong> gesamter Code</strong></summary>

```r
library(sf)
library(dplyr)
library(tidyr)
library(stringr)

# 1. Bäume laden
anlagenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:anlagenbaeume")
strassenbaeume <- st_read("WFS:https://gdi.berlin.de/services/wfs/baumbestand", layer = "baumbestand:strassenbaeume")

# 2. Bewässerungsdaten laden
df_clean <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
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
write.csv2(df_merged, "data/df_merged_final.csv", row.names = FALSE, fileEncoding = "UTF-8")

# 9. Kontrolle: Anzahl der Zeilen
cat("Anzahl Bäume nach Merge:", nrow(df_merged), "\n")
cat("Anzahl eindeutiger Bäume (pitid):", n_distinct(df_merged$pitid), "\n")
cat("Anzahl Bäume mit Bewässerungsdaten:", sum(!is.na(df_merged$bewaesserungsmenge_in_liter)), "\n")
```

</details>


### Geografische Zuordnung zu Berliner Bezirken
**Zielsetzung**
Einige Bäume verfügen nicht über eine Angabe zu ihrem Bezirk. Um eine aggregierte räumliche Analyse (z. B. Gießverhalten nach Bezirk) zu ermöglichen, werden fehlende Bezirksangaben durch räumliches Verschneiden mit offiziellen Bezirkspolygonen ergänzt.

**Methodik**
- Bäume ohne Bezirk werden in räumliche Objekte konvertiert (sf-Objekte).

- Mittels eines „spatial join“ wird ermittelt, in welchem Bezirk sich jeder Baum befindet.

- Das Ergebnis wird mit den ursprünglichen Daten wieder zusammengeführt.

**Code Erklärung:**
**1. Die Bezirkskarte laden**
```bash
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")
```
- Es wird eine digitale Karte geladen, auf der die Bezirksgrenzen Berlins eingezeichnet sind.
- Jeder Bezirk hat dabei ein sogenanntes „Polygon“ – eine Art Umrisslinie.

**2. Die Baumdaten laden**
```bash
df_baeume <- read.csv("data/df_merged_final.csv", sep = ";", stringsAsFactors = FALSE)
```
- Die Tabelle mit Baumdaten wird eingelesen. Jeder Eintrag beschreibt einen Baum: z. B. seine Art, Pflanzjahr und die Koordinaten, wo er steht.
- Manche Bäume haben schon einen Bezirk eingetragen, andere nicht.

**3. Koordinaten umwandeln**
```bash
df_baeume <- df_baeume %>%
  mutate(
    lng = as.numeric(gsub(",", ".", lng)),
    lat = as.numeric(gsub(",", ".", lat))
  )

```
- Manche Koordinaten sind falsch formatiert (mit Komma statt Punkt, z. B. „13,405“ statt „13.405“). Das wird korrigiert, damit der Computer die Zahlen richtig versteht.

**4. Zwei Gruppen bilden:** 
```bash
df_mit_bezirk <- df_baeume %>% filter(!is.na(bezirk))
df_ohne_bezirk <- df_baeume %>% filter(is.na(bezirk) & !is.na(lng) & !is.na(lat))
```
- **Gruppe 1:** Bäume, bei denen der Bezirk schon bekannt ist.
- **Gruppe 2:** Bäume, bei denen der Bezirk fehlt, aber die Koordinaten vorhanden sind.

**5. Gruppe ohne Bezirk in geografisches Format umwandeln**

```bash
df_ohne_bezirk_sf <- st_as_sf(df_ohne_bezirk, coords = c("lng", "lat"), crs = 4326, remove = FALSE)
```
- Die zweite Gruppe wird in ein spezielles Format (sogenannte sf-Objekte) umgewandelt.
- Das ist notwendig, damit man mit Geodaten (Karten und Punkten auf Karten) arbeiten kann.

**6. Bezirksgrenzen vorbereiten**

```bash
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = st_crs(df_ohne_bezirk_sf)) %>%
  rename(bezirk = Gemeinde_name)
```

- Die Karte der Bezirke wird ins gleiche geografische System wie die Baumdaten gebracht (Koordinatensystem).
- Außerdem wird der Name des Bezirksfeldes vereinfacht in „bezirk“.

**7. Räumlicher Vergleich: Welcher Baum liegt in welchem Bezirk?**

```bash
df_ohne_bezirk_joined <- st_join(df_ohne_bezirk_sf, bezirksgrenzen["bezirk"], left = TRUE)
```

- Jetzt wird für jeden Baum ohne Bezirk geschaut, ob er innerhalb eines Bezirks liegt.
- Dafür wird überprüft, welches Bezirks-Polygon den jeweiligen Baum „einschließt“.
- Dieser Vorgang heißt „spatial join“ – also ein räumliches Verbinden.

**8. Ergebnis bereinigen und in normales Tabellenformat bringen**

```bash
df_ohne_bezirk_filled <- df_ohne_bezirk_joined %>%
  mutate(bezirk = ifelse(is.na(bezirk.x), bezirk.y, bezirk.x)) %>%
  select(-bezirk.x, -bezirk.y) %>%
  st_drop_geometry()
```
- Die berechneten Bezirksangaben werden in die Tabelle übernommen.
- Zusätzliche technische Spalten werden entfernt.
- Die geografischen Informationen werden wieder „fallen lassen“, damit es wieder eine normale Tabelle ist.

**9. Beide Gruppen wieder zusammenfügen**
```bash
df_baeume_final <- bind_rows(df_mit_bezirk, df_ohne_bezirk_filled)
```

- Jetzt werden alle Bäume wieder in einer Tabelle vereint:

    - Die, die schon einen Bezirk hatten.
    - Und die, denen jetzt ein Bezirk zugeordnet wurde.

**10. Neue, vollständige Tabelle speichern**
```bash
write.csv2(df_baeume_final, file = "data/df_merged_final.csv", row.names = FALSE)
```
- Die neue Tabelle mit allen Bäumen und Bezirken wird als Datei gespeichert.

<details>
<summary><strong>gesamter Code</strong></summary>

```r
library(sf)
library(dplyr)

# 1. Lade die Bezirkspolygone
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")

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
write.csv2(df_baeume_final, file = "data/df_merged_final.csv", row.names = FALSE)

```
</details>

###  Voraggregation: Erstellung von df_merged_sum

**Zielsetzung**
Um die Performance in der Shiny-App zu verbessern, werden pro Baum aggregierte Kennzahlen berechnet, wie z. B.:

- Gesamte Bewässerungsmenge
- Durchschnittliches Gießintervall in Tagen

**Methodik**
1. Gruppierung aller Gießeinträge nach Baum-ID (gisid).
2. Sortierung der Gießvorgänge nach Datum.
3. Berechnung der Zeitabstände zwischen den Gießungen.
4. Zusammenfassung zu Mittelwerten und Summen.

**Erklärung des Codes:**
**1. Einlesen der Daten**
```bash
df_merged_full <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")
```
- Die CSV-Datei mit allen Gießvorgängen wird eingelesen.
- Jeder Eintrag steht für eine Gießung eines bestimmten Baums.
- gisid ist die eindeutige Kennung (ID) jedes Baumes.

**2. Berechnung der durchschnittlichen Gießabstände pro Baum**
```bash
bewässerungs_frequenz <- df_merged_full %>%
  group_by(gisid) %>%                           # Alle Einträge eines Baums zusammenfassen
  filter(n() > 1) %>%                           # Nur Bäume, die mehr als einmal gegossen wurden
  arrange(gisid, timestamp) %>%                 # Nach Zeit sortieren
  mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%  
  summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
  ungroup()
```
Was passiert hier?
- Für jeden Baum, der mehr als einmal gegossen wurde:
    1. Die Gießtermine werden chronologisch sortiert.
    2. Für jeden Gießvorgang wird berechnet, wie viele Tage seit dem letzten Mal vergangen sind (``differenz``).
    3. Aus allen Abständen wird ein Durchschnittswert gebildet: „Wie oft wird dieser Baum im Schnitt gegossen?“

**3. Ergebnis (die Durchschnittswerte) mit den Gießdaten verbinden**

```bash
df_merged_full <- df_merged_full %>%
  left_join(bewässerungs_frequenz, by = "gisid")
```
- Diese neu berechneten Durchschnittswerte werden jetzt zurück in die Gesamttabelle eingefügt, damit man alle Infos in einer Tabelle hat.

**4. Fehlende Werte ersetzen**
```bash
df_merged_full$durchschnitts_intervall[is.na(df_merged_full$durchschnitts_intervall)] <- 0
```
- Manche Bäume wurden nur einmal gegossen – da lässt sich kein Abstand berechnen.
- Für diese Bäume wird der Durchschnitt einfach auf 0 gesetzt.

**5. Endgültige Zusammenfassung: Ein Eintrag pro Baum**
```bash
df_merged_sum <- df_merged_full %>%
  group_by(gisid) %>%
  summarise(
    gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
    durchschnitts_intervall = unique(durchschnitts_intervall),
    lat = first(lat),
    lng = first(lng),
    gattung_deutsch = first(gattung_deutsch),
    art_dtsch = first(art_dtsch),
    hausnr = first(hausnr),
    strname = first(strname),
    bezirk = first(bezirk),
    bewaesserungsmenge_in_liter = first(bewaesserungsmenge_in_liter),
    timestamp = first(timestamp),
    .groups = "drop"
  )
```

Was passiert hier?
- Jetzt wird die Tabelle so zusammengefasst, dass es nur noch eine Zeile pro Baum gibt.
- Dabei werden:
    - Summen gebildet (z. B. wie viel Liter insgesamt gegossen wurde),
    - oder einfach ein erster Wert übernommen (z. B. der Straßenname, Koordinaten usw. – weil diese sich bei einem Baum nicht ändern).

**6. Speichern des Endergebnisses**
```bash
write.csv2(df_merged_sum, file = "data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";")
```
- Die neue, kompakte Tabelle wird gespeichert.
- Diese Datei enthält einen Eintrag pro Baum, mit den wichtigsten zusammengefassten Infos.

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
df_merged_full <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")

# 1. Intervall berechnen
bewässerungs_frequenz <- df_merged_full %>%
    group_by(gisid) %>%
    filter(n() > 1) %>%
    arrange(gisid, timestamp) %>%
    mutate(differenz = as.numeric(difftime(timestamp, lag(timestamp), units = "days"))) %>%
    summarise(durchschnitts_intervall = mean(differenz, na.rm = TRUE)) %>%
    ungroup()

# 2. Mit df_merged zusammenführen
df_merged_full <- df_merged_full %>%
    left_join(bewässerungs_frequenz, by = "gisid")

# 3. 0 setzen für fehlende Intervalle
df_merged_full$durchschnitts_intervall[is.na(df_merged_full$durchschnitts_intervall)] <- 0

# 4. df_merged_sum <- df_merged_full %>%
group_by(gisid) %>%
summarise(
gesamt_bewaesserung = sum(bewaesserungsmenge_in_liter, na.rm = TRUE),
durchschnitts_intervall = unique(durchschnitts_intervall),
lat = first(lat),
lng = first(lng),
gattung_deutsch = first(gattung_deutsch),
art_dtsch = first(art_dtsch),
hausnr = first(hausnr),
strname = first(strname),
bezirk = first(bezirk),
bewaesserungsmenge_in_liter = first(bewaesserungsmenge_in_liter),
timestamp = first(timestamp),
.groups = "drop"
)

write.csv2(df_merged_sum, file = "data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";")
```
</details>