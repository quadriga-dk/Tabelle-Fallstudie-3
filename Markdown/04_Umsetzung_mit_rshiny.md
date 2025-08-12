---
lang: de-DE
---

(umsetzung)=
# Vorbereitung der Daten: Einlesen und Bereinigung


**Zielsetzung**
Ziel dieses Schrittes ist es, verschiedene Datensätze – insbesondere den Berliner Baumkataster sowie manuell dokumentierte Gießdaten – zusammenzuführen und so aufzubereiten, dass sie für weitere Analysen und Visualisierungen (z. B. in einer interaktiven Karte) verwendet werden können.

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
Die beiden Baumdatenquellen werden vereinheitlicht (gemeinsames Koordinatensystem EPSG:4326) und zusammengeführt. Danach werden die Koordinaten explizit extrahiert und die Geometriedaten entfernt, um die Dateigröße zu reduzieren und die Weiterverarbeitung zu erleichtern.

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
Die aufbereiteten Daten werden als CSV-Datei gespeichert. Eine Ausgabe relevanter Kennzahlen (z. B. Anzahl verknüpfter Bäume) dient der Kontrolle.

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
- Eine Tabelle mit Baumdaten wird eingelesen. Jeder Eintrag beschreibt einen Baum: z. B. seine Art, Pflanzjahr und die Koordinaten, wo er steht.
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
- Die geografischen Informationen werden wieder „fallen gelassen“, damit es wieder eine normale Tabelle ist.

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

### Reduktion der Pumpendaten
**Zielsetzung**
Die Originaldaten der Wasserpumpen enthalten viele unnötige Spalten. Um Ressourcen zu schonen, wird ein reduzierter Datensatz erzeugt.

**Vorgehen**
Nur die relevanten Informationen (z. B. ob die Pumpe funktionstüchtig ist, ihre ID, der Pumpentyp und die Geometrie) werden beibehalten.

**Code Erklärung:**
**1. Die vollständigen Pumpendaten einlesen**
```bash
pumpen_full <- st_read("data/pumpen.geojson")
```
- Es wird die vollständige Datei mit allen Wasserpumpen geöffnet.

**2. Nur die relevanten Spalten auswählen**
```bash
pumpen <- pumpen_full %>%
  select(pump, pump.style, pump.status, geometry, man_made, id)
```
Was passiert hier?
- Es wird eine neue Tabelle erstellt, die nur die wichtigsten Infos aus der großen Datei übernimmt:

|Spalte | Bedeutung |
|-------|-----------|
|`pump` | Ist die Pumpe funktionsfähig? (z. B. "ja" oder "nein") |
|``pump.style`` | Welche Art von Pumpe ist es? (z. B. Handschwengelpumpe) |
| ``geometry`` | 	Der Standort der Pumpe auf der Karte (Längen- und Breitengrad) |
| ``man_made`` | Allgemeine Einordnung: Es handelt sich um ein von Menschen gebautes Objekt |
| ``id`` | Eine eindeutige ID, um die Pumpe zu identifizieren | 
|`` pump.status`` | Information ob die Pumpe Funktionsfähig ist |
- Alles andere wird weggelassen.

**3. Die reduzierte Datei abspeichern**
```bash
st_write(pumpen, "data/pumpen_minimal.geojson",
         driver = "GeoJSON", delete_dsn = TRUE)
```
- Die neue, kleinere Datei mit nur den benötigten Infos wird unter dem Namen ``pumpen_minimal.geojson`` gespeichert.
- Format bleibt weiterhin GeoJSON – das ist ein gängiges Format für geografische Daten.
- ``delete_dsn = TRUE ``sorgt dafür, dass eine eventuell vorhandene Datei mit demselben Namen überschrieben wird.

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
# --- pumpen minimieren ---
pumpen_full <- st_read("data/pumpen.geojson")

pumpen <- pumpen_full %>%
  select(pump, pump.style, geometry, man_made, id)

st_write(pumpen, "data/pumpen_minimal.geojson",
         driver = "GeoJSON", delete_dsn = TRUE)

```
</details>


### Bezirkszuordnung für Pumpen
**Zielsetzung**
Analog zur Baumzuordnung sollen auch Pumpen mit ihrem Bezirk verknüpft werden, um regionale Analysen zu ermöglichen.

**Vorgehen**
Ein räumlicher Join ermittelt für jede Pumpe, in welchem Bezirk sie liegt.

**Code Erklärung:** 
**1. Die reduzierten Pumpendaten laden**
```bash
pumpen <- st_read("data/pumpen_minimal.geojson")
```
- Es wird die kleinere, bereits vorbereitete Datei mit den wichtigsten Pumpendaten geöffnet.
- Jede Zeile beschreibt eine einzelne Pumpe.

**2. Die Bezirksgrenzen laden**

```bash
bezirksgrenzen <- st_read("data/bezirksgrenzen.geojson")
```
- Es wird eine Datei geöffnet, in der die Umrisse der Berliner Bezirke enthalten sind.
- Jeder Bezirk ist als Fläche auf einer Karte dargestellt.

**3. Einheitliches Koordinatensystem sicherstellen**
```bash
pumpen <- st_transform(pumpen, crs = 4326)
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = 4326)
```
- Damit die Vergleiche korrekt funktionieren, müssen beide Datensätze dasselbe geografische Bezugssystem verwenden – hier ``WGS84``, das weltweit verwendet wird.
- Ohne diesen Schritt würden die Pumpenpunkte und Bezirksflächen eventuell an völlig unterschiedlichen Orten erscheinen.

**4. Räumlicher Join: Pumpen bekommen ihren Bezirk`**
```bash
pumpen_mit_bezirk <- st_join(pumpen, bezirksgrenzen[, c("Gemeinde_name")], left = TRUE)
```
- Für jede Pumpe wird automatisch berechnet, in welchem Bezirk sie sich befindet.
- Der Name des Bezirks (``Gemeinde_name``) wird als neue Spalte in die Pumpen-Daten eingefügt.
- ``left = TRUE`` bedeutet: alle Pumpen bleiben erhalten, auch wenn sie aus irgendeinem Grund außerhalb der Bezirksgrenzen liegen sollten.

**5. Spalte umbenennen für Klarheit**

```bash
pumpen_mit_bezirk <- pumpen_mit_bezirk %>% 
  rename(bezirk = Gemeinde_name)
```
Die Spalte mit dem Bezirksnamen wird von ``Gemeinde_name`` in ``bezirk`` umbenannt – damit sie besser verständlich ist.

**6. Datei speichern**

```bash
st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk.geojson", driver = "GeoJSON", delete_dsn = TRUE)
```
- Die fertige Datei wird gespeichert.
- Sie enthält jetzt alle Pumpen, inklusive einer neuen Spalte mit dem Bezirksnamen.
- Das Format bleibt GeoJSON, damit es weiterhin in Kartenanwendungen verwendet werden kann.

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
pumpen <- st_read("data/pumpen_minimal.geojson")
bezirksgrenzen <- st_read(data/bezirksgrenzen.geojson")

# Sicherstellen, dass beide im selben CRS sind (z.B. WGS84)
pumpen <- st_transform(pumpen, crs = 4326)
bezirksgrenzen <- st_transform(bezirksgrenzen, crs = 4326)

# Räumlicher Join: Pumpen bekommt den Namen des Bezirks, in dem sie liegt
pumpen_mit_bezirk <- st_join(pumpen, bezirksgrenzen[, c(Gemeinde_name")], left = TRUE)

pumpen_mit_bezirk <- pumpen_mit_bezirk %>% 
    rename(bezirk = Gemeinde_name)

# GeoJSON-Datei speichern
st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk.geojson", driver = "GeoJSON", delete_dsn = TRUE)
```
</details>

Pumpendatensatz mit Bezirk minimiert: 

```bash
# --- pumpen_mit_bezirk minimieren ---
pumpen_mit_bezirk_full <- st_read("data/pumpen_mit_bezirk.geojson")

pumpen_mit_bezirk <- pumpen_mit_bezirk_full %>%
  select(pump, pump.style, pump.status, bezirk, geometry, man_made, id)

st_write(pumpen_mit_bezirk, "data/pumpen_mit_bezirk_minimal.geojson",
         driver = "GeoJSON", delete_dsn = TRUE)
```

### Entfernung zur nächsten Pumpe berechnen
**Zielsetzung**
Für jede Baumposition soll berechnet werden, wie weit die nächste funktionierende Wasserpumpe entfernt ist.

**Vorgehen**
1. Nur funktionierende Pumpen auswählen.
2. Beide Datensätze in ein metrisches Koordinatensystem (UTM) umwandeln, da Distanzen in Metern berechnet werden.
3. Mit der Funktion st_nn() wird für jeden Baum die nächstgelegene Pumpe ermittelt.
4. Die berechneten Entfernungen werden in einer neuen Spalte gespeichert.

<details>
<summary><strong>gesamter Code: </strong></summary>

```r
library(data.table)
library(sf)
library(dplyr)
library(stringr)
library(tidyr)
library(nngeo)

# # 1. Daten einlesen
 pumpen_mit_bezirk <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
 df_merged_sum <- read.csv("data/df_merged_gesamter_baumbestand_sum1.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")

 pumpen_mit_bezirk_ok <- pumpen_mit_bezirk %>%
   filter(pump.status == "ok")
 
# 2. Koordinaten umwandeln (Komma zu Punkt)
df_merged_sum <- df_merged_sum %>%
  mutate(
    lat = as.numeric(str_replace(lat, ",", ".")),
    lng = as.numeric(str_replace(lng, ",", "."))
  ) %>%
  drop_na(lat, lng)

# 3. sf-Objekte erstellen mit WGS84 (Geodätisch)
df_merged_sum_sf <- st_as_sf(df_merged_sum, coords = c("lng", "lat"), crs = 4326)
pumpen_sf <- st_transform(pumpen_mit_bezirk_ok, crs = 4326)

# 4. In metrisches CRS transformieren (z.B. UTM Zone 33N für Berlin)
df_merged_sum_sf_proj <- st_transform(df_merged_sum_sf, crs = 32633)
pumpen_sf_proj <- st_transform(pumpen_sf, crs = 32633)

# 5. Berechnung der Distanz zur nächsten Pumpe (nur die nächste)
nearest_index <- st_nn(df_merged_sum_sf_proj, pumpen_sf_proj, k = 1, returnDist = TRUE)

# 6. Extrahiere minimale Distanzen (in Meter)
min_dist <- sapply(nearest_index$dist, function(x) x[1])

# 7. Zurück ins ursprüngliche DataFrame
df_merged_sum$distanz_zur_pumpe_m <- as.numeric(min_dist)

write.csv2(df_merged_sum, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", row.names = FALSE, fileEncoding = "UTF-8")

```
</details>

### Anzahl Pumpen im 100-Meter-Umkreis berechnen
**Zielsetzung**
Ein Maß für die Zugänglichkeit zu Wasser ist die Anzahl der Pumpen in unmittelbarer Nähe eines Baumes.

**Vorgehen**
1. Um jeden Baum wird ein 100-Meter-Kreis (Buffer) gezogen.
2. Es wird gezählt, wie viele funktionierende Pumpen sich in diesem Kreis befinden.
3. Das Ergebnis wird im Baumdatensatz gespeichert.

**Code Erklärung:**
```bash
pumpen_mit_bezirk <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
df_merged_sum <- read.csv("data/df_merged_gesamter_baumbestand_sum1.csv", ...)
```
Es werden zwei Dateien geladen:
    - Pumpen mit Positionsdaten und Bezirkszuordnung.
    - Bäume mit Infos wie Standort, Gießmengen, Gießhäufigkeit usw.

**2. Nur funktionierende Pumpen auswählen**

```bash
pumpen_mit_bezirk_ok <- pumpen_mit_bezirk %>%
   filter(pump.status == "ok")
```
- Nur Pumpen, die als "ok" (funktionsfähig) markiert sind, werden berücksichtigt.
- Defekte Pumpen werden ignoriert, weil sie zum Gießen sowieso nicht genutzt werden können.

**3. Dezimalpunkt bei Koordinaten korrigieren**
```bash
df_merged_sum <- df_merged_sum %>%
  mutate(
    lat = as.numeric(str_replace(lat, ",", ".")),
    lng = as.numeric(str_replace(lng, ",", "."))
  ) %>%
  drop_na(lat, lng)
```
- In deutschen Datensätzen wird oft ein Komma statt Punkt für Dezimalzahlen verwendet.
- Das wird hier korrigiert, damit die Koordinaten richtig als Zahlen erkannt werden.
- Danach werden alle Zeilen ohne gültige Koordinaten entfernt.

**4. Umwandlung in "sf"-Objekte für Raumbezug**
```bash
df_merged_sum_sf <- st_as_sf(df_merged_sum, coords = c("lng", "lat"), crs = 4326)
pumpen_sf <- st_transform(pumpen_mit_bezirk_ok, crs = 4326)
```
- Die Bäume werden zu "räumlichen Objekten" gemacht (sog. sf-Objekte), damit man mit ihnen geografisch rechnen kann.
- ``crs = 4326`` steht für das bekannte WGS84-System – das ist gut für Karten, aber nicht für Entfernungen.

**5. Umrechnung ins metrische System (UTM)**

```bash
df_merged_sum_sf_proj <- st_transform(df_merged_sum_sf, crs = 32633)
pumpen_sf_proj <- st_transform(pumpen_sf, crs = 32633)
```
- Jetzt wird das Koordinatensystem umgewandelt in UTM Zone 33N (``crs = 32633``), das für Berlin geeignet ist.
- Nur so kann man exakt in Metern rechnen (z. B. 247 m zur nächsten Pumpe).`

**6. Entfernung zur nächsten Pumpe berechnen**

```bash
nearest_index <- st_nn(df_merged_sum_sf_proj, pumpen_sf_proj, k = 1, returnDist = TRUE)
```
- ``st_nn()`` ist eine Funktion aus dem Paket ``nngeo``.
- Für jeden Baum wird die nächstgelegene Pumpe gefunden.
- ``k = 1`` bedeutet: Es wird nur die nächste Pumpe gesucht.
- ``returnDist = TRUE`` liefert die tatsächliche Entfernung (nicht nur die Position).

**7. Entfernungen extrahieren**

```bash
min_dist <- sapply(nearest_index$dist, function(x) x[1])
```
- Es wird eine Liste von Distanzen erzeugt.
- Jede Zahl gibt an, wie weit ein bestimmter Baum von seiner nächsten Pumpe entfernt ist (in Metern).

**8. Distanz im Baum-Datensatz speichern**

```bash
df_merged_sum$distanz_zur_pumpe_m <- as.numeric(min_dist)
```
- Die berechnete Entfernung wird als neue Spalte in die Baumtabelle geschrieben.
- Jetzt hat jeder Baum einen Messwert wie z. B. 184.72 Meter bis zur nächsten funktionierenden Pumpe.

**9. Neue Datei speichern**
```bash
write.csv2(df_merged_sum, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", ...)
```
- Die Tabelle mit den zusätzlichen Entfernungsdaten wird gespeichert.

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
    library(data.table)
    library(sf)
    library(dplyr)
    library(stringr)
    library(tidyr)
    library(nngeo)

  df_merged_sum_mit_distanzen <- read.csv("data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
  
  df_merged_sum_mit_distanzen$lat <- as.numeric(gsub(",", ".", df_merged_sum_mit_distanzen$lat))
  df_merged_sum_mit_distanzen$lng <- as.numeric(gsub(",", ".", df_merged_sum_mit_distanzen$lng))

  # 1. Rechnen
  df_giess_sf <- st_as_sf(df_merged_sum_mit_distanzen, coords = c("lng", "lat"), crs = 4326)
  pumpen_sf <- st_transform(pumpen_mit_bezirk_ok, crs = 4326)

  df_giess_sf_m <- st_transform(df_giess_sf, 3857)
  pumpen_sf_m <- st_transform(pumpen_sf, 3857)

  giess_buffer <- st_buffer(df_giess_sf_m, dist = 100)
  pumpen_im_umkreis <- lengths(st_intersects(giess_buffer, pumpen_sf_m))

  df_merged_sum_mit_distanzen$pumpen_im_umkreis_100m <- pumpen_im_umkreis

  # 2. Speichern
  write.csv2(df_merged_sum_mit_distanzen, "data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv", row.names = FALSE)

```
</details>

### Integration der Lebensweltlich orientierten Räume (LOR)
**Zielsetzung**
Zur feinräumigen Analyse (unterhalb der Bezirksebene) sollen Bäume zusätzlich einem LOR-Gebiet zugeordnet werden.

**Vorgehen**
1. LOR-Grenzen werden über eine WFS-Schnittstelle geladen.
2. Jeder Baum wird demjenigen LOR zugeordnet, in dessen Fläche er liegt.
3. Ergebnis wird für spätere Analysen gespeichert.

**Code Erklärung:**
**1. LOR-Grenzen aus dem Internet laden**
```bash
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"

lor <- st_read(lor_url) %>%
  st_transform(4326) 
```
- Die LOR-Gebiete (als digitale Stadtkarte) werden direkt aus dem Berliner Geodatenportal geladen.

- Danach wird das Koordinatensystem in WGS84 geändert (damit es zu den Baumdaten passt).

**Was ist WGS84?**
Ein weltweites Koordinatensystem – es nutzt Längen- und Breitengrade (wie in Google Maps).

**2. Baumdaten einlesen**

```bash
df_merged <- read_csv2("data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv", ...)
```
- Hier wird die Tabelle mit allen Bäumen geladen, inklusive Position, Gießdaten, Abstand zur Pumpe usw.

**3. Koordinaten bereinigen**

```bash
mutate(lng = ..., lat = ...) %>%
  filter(!is.na(lng) & !is.na(lat))
```
- Die Koordinaten (Länge, Breite) werden von Text in Zahlen umgewandelt.
- Gleichzeitig werden fehlerhafte Zeilen (z. B. fehlende Koordinaten) aussortiert.

**4. Baumdaten als Geo-Daten vorbereiten**

```bash
trees_sf <- st_as_sf(df_merged, coords = c("lng", "lat"), crs = 4326)
```
- Aus der Tabelle wird ein sogenanntes sf-Objekt gemacht – also ein „räumlich intelligentes“ Datenobjekt.
- Jeder Baum hat jetzt eine echte Position auf der Karte.

**5. Räumlicher Join: Baum ↔ LOR**

```bash
trees_with_lor <- st_join(trees_sf, lor, join = st_within)
```
- Für jeden Baum wird geschaut: „In welchem LOR-Gebiet liegt dieser Punkt?“
- Das passende LOR-Feld (z. B. bzr_id) wird in die Baumtabelle übernommen.

**6. Bäume ohne Zuordnung entfernen**
```bash
filter(!is.na(bzr_id))
```
- Falls ein Baum außerhalb der LOR-Grenzen liegt (z. B. durch falsche Koordinaten), wird er ausgefiltert.

**7. Ergebnis speichern (GeoJSON + CSV)**
```bash
st_write(trees_with_lor, "output.geojson")
write.csv2(trees_csv, "output.csv")
```
Das Ergebnis wird gespeichert:
    - GeoJSON für Kartenanwendungen.
    - CSV für Auswertungen in Excel, R oder Shiny.

Zusätzlich werden aus der Geometrie wieder Breiten- und Längengradspalten erzeugt, bevor man es als CSV speichert.

**8. Fehlerbehandlung mit tryCatch**

```bash
tryCatch({ ... }, error = function(e) { ... })
```
- Sollte beim Einlesen oder Verarbeiten ein Fehler auftreten (z. B. wegen Serverproblemen oder falscher Daten), wird eine Fehlermeldung mit Zusatzinfos ausgegeben, statt dass der ganze Prozess abstürzt.

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
library(sf)
library(dplyr)
library(readr)

# st_layers("https://gdi.berlin.de/services/wfs/lor_2019?REQUEST=GetCapabilities&SERVICE=wfs")

# 1. LOR-Daten korrekt einlesen
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"

lor <- st_read(lor_url) %>%
  st_transform(4326)  # Zu WGS84 transformieren

# 2. Baumdaten einlesen
# df_merged <- read_csv2("data/df_merged_final.csv",
#                       locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "UTF-8"))
# df_merged <- read_csv2("data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok.csv",
#                  locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "UTF-8"))
df_merged <- read_csv2("data/df_merged_sum_mit_distanzen_mit_umkreis_baumbestand_nur_Pumpen_ok.csv",
                       locale = locale(decimal_mark = ",", grouping_mark = ".", encoding = "UTF-8"))

# 3. Koordinaten bereinigen und konvertieren
df_merged <- df_merged %>%
  mutate(
    lng = as.numeric(gsub(",", ".", lng)),
    lat = as.numeric(gsub(",", ".", lat))
  ) %>%
  filter(!is.na(lng) & !is.na(lat))

# 4. In sf-Objekt umwandeln
trees_sf <- st_as_sf(df_merged, coords = c("lng", "lat"), crs = 4326)

# 5. Räumlichen Join durchführen (mit Fehlerbehandlung)
tryCatch({
  trees_with_lor <- st_join(trees_sf, lor, join = st_within)
  
  # 6. Nicht zugeordnete Bäume entfernen
  trees_with_lor <- trees_with_lor %>%
    filter(!is.na(bzr_id))
  
  # 7. Ergebnis speichern
  # st_write(trees_with_lor, "data/trees_with_lor.geojson", driver = "GeoJSON")
  #st_write(trees_with_lor, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok_lor.geojson", driver = "GeoJSON")
  st_write(trees_with_lor, "data/df_merged_sum_mit_distanzen_mit_umkreis_gesamter_Baumbestand_nur_Pumpen_ok_lor.geojson", driver = "GeoJSON")
  
  # Alternativ als CSV
  trees_csv <- trees_with_lor %>%
    mutate(
      lng = st_coordinates(.)[,1],
      lat = st_coordinates(.)[,2]
    ) %>%
    st_drop_geometry()
  
  #write_csv2(trees_csv, "data/trees_with_lor.csv")
  # write.csv2(trees_csv, "data/df_merged_sum_mit_distanzen_gesamter_Baumbestand_nur_Pumpen_ok_lor.csv")
  write.csv2(trees_csv, "data/df_merged_sum_mit_distanzen_mit_umkreis_gesamter_Baumbestand_nur_Pumpen_ok_lor.csv")
  
  message("Verarbeitung erfolgreich abgeschlossen!")
}, error = function(e) {
  message("Fehler bei der Verarbeitung: ", e$message)
  # Debug-Informationen
  message("LOR CRS: ", st_crs(lor)$input)
  message("Bäume CRS: ", st_crs(trees_sf)$input)
  message("Anzahl LOR-Features: ", nrow(lor))
  message("Anzahl Baum-Features: ", nrow(trees_sf))
})

```
<<<<<<< HEAD
</details>

### LOR zuordnung zum Baumbestand
=======
### LOR Zuordnung zum Baumbestand
>>>>>>> f92d1630a2be26834024a436cd01c5350db50f3d

**Zielsetzung**

Ziel ist es, die Baumstandorte den entsprechenden LOR-Gebieten zuzuordnen, um auf dieser feinräumigen Ebene die Gesamtbewässerungsmenge je Gebiet zu analysieren und umsomit spezifische Filterung zu ermöglichen.

**Vorgehen**
1. Einlesen der Baumdaten mit Geokoordinaten.
2. Umwandlung der Daten in ein Geo-Datenobjekt (sf).
3. Einlesen und Vorbereitung der LOR-Geometrien über eine WFS-Schnittstelle.
4. Räumliche Zuordnung (Join) der Baumdaten zu den LOR-Gebieten.
5. Aggregation der Bewässerungsmengen je LOR.
6. Rückführung der Summendaten in ein vollständiges sf-Objekt mit Geometrie.
7. Speicherung des Endergebnisses im GeoJSON-Format.

**Code-Erklärung**
**1. Laden der benötigten Pakete**

```bash
library(dplyr)
library(sf)
library(data.table)
```
- ``dplyr``: Für effiziente Datenmanipulation.
- ``sf``: Für die Arbeit mit räumlichen (Geo-)Daten.
- ``data.table``: Für schnelles Einlesen großer CSV-Dateien.

**2. Einlesen der Baumdaten**

```bash
df_merged <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")
```
Die CSV-Datei enthält Baumdaten inklusive Längen- und Breitengrad sowie Bewässerungsmenge.

**3. Umwandlung in ein sf-Objekt**

```bash
df_merged <- st_as_sf(df_merged, coords = c("lng", "lat"), crs = 4326)
```
- Die Koordinaten-Spalten lng und lat werden in ein Punkt-Objekt überführt.
- Das Koordinatensystem WGS84 (EPSG:4326) wird festgelegt, um Kompatibilität mit anderen Geodaten zu gewährleisten.

**4. Einlesen der LOR-Grenzen**

```bash
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"
lor <- st_read(lor_url) %>%
  select(bzr_id, bzr_name, geom) %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
  st_transform(4326)
```
- Die LOR-Gebiete werden über die WFS-Schnittstelle der Berliner Geodateninfrastruktur abgerufen.
- Es werden nur relevante Spalten ausgewählt (bzr_id, bzr_name, geom).
- Mit st_simplify() werden die Geometrien vereinfacht, um die Datenmenge zu reduzieren und damit die Performance bei der Verarbeitung und Visualisierung zu verbessern. Die Topologie bleibt dabei erhalten.
- Das Koordinatensystem wird ebenfalls auf WGS84 eingestellt.

**5. Räumlicher Join: Baum ↔ LOR**

```bash
df_merged_mit_lor <- st_join(df_merged, lor[, c("bzr_id", "bzr_name")], left = TRUE)
```
- Jeder Baum wird dem LOR-Gebiet zugeordnet, in dem er räumlich liegt (Punkt-in-Polygon-Zuordnung).
- Die entsprechenden LOR-Informationen (bzr_id, bzr_name) werden übernommen.

**6. Aggregation: Summe der Bewässerungsmengen pro LOR**

```bash
df_merged_mit_lor_sum <- df_merged_mit_lor %>%
  group_by(bzr_id, bzr_name) %>%
  summarise(gesamt_bewaesserung_lor = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
  ungroup()
```
- Die Bewässerungsmenge wird für jedes LOR summiert.
- Fehlende Werte (NA) werden bei der Summenbildung ignoriert.

**7. Verknüpfung mit LOR-Geometrie**
```bash
df_merged_sum_with_geom <- lor %>%
  left_join(st_drop_geometry(df_merged_mit_lor_sum), by = "bzr_id")
```
- Die berechneten Summen werden den ursprünglichen LOR-Geometrien wieder hinzugefügt.
- Die Geometrie wird dabei aus dem lor-Objekt übernommen.

**8. Export des Ergebnisses**

```bash
st_write(df_merged_sum_with_geom, "data/df_merged_mit_lor_und_sum.geojson", driver = "GEOJSON", delete_dsn = TRUE)
```
- Das finale Objekt wird im GeoJSON-Format gespeichert 

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
library(dplyr)
library(sf)
library(data.table)

# Daten einlesen
df_merged <- fread("data/df_merged_final.csv", sep = ";", encoding = "UTF-8")

# Falls df_merged keine sf ist
df_merged <- st_as_sf(df_merged, coords = c("lng", "lat"), crs = 4326)

# LOR-Geometrien laden
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"
lor <- st_read(lor_url) %>%
  select(bzr_id, bzr_name, geom) %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
  st_transform(4326)

# Join: Punkte mit LOR verknüpfen
df_merged_mit_lor <- st_join(df_merged, lor[, c("bzr_id", "bzr_name")], left = TRUE)

# Summe je LOR berechnen
df_merged_mit_lor_sum <- df_merged_mit_lor %>%
  group_by(bzr_id, bzr_name) %>%
  summarise(gesamt_bewaesserung_lor = sum(bewaesserungsmenge_in_liter, na.rm = TRUE)) %>%
  ungroup()

# Geometrien hinzufügen
df_merged_sum_with_geom <- lor %>%
  left_join(st_drop_geometry(df_merged_mit_lor_sum), by = "bzr_id")


st_write(df_merged_sum_with_geom, "data/df_merged_mit_lor_und_sum.geojson", driver = "GEOJSON", delete_dsn = TRUE)
```
</details>

### Integration von Pumpenstandorten in Lebensweltlich orientierte Räume (LOR)

**Zielsetzung**
Die Zuordnung von Wasserpumpen zu den entsprechenden LOR-Gebieten ermöglicht räumlich differenzierte Analysen der Infrastruktur auf unterbezirklicher Ebene (z. B. für Planungszwecke oder Gießroutenoptimierung).

**Vorgehen**
- Einlesen der Pumpenstandorte als Geo-Daten.
- Filtern der aktiven („ok“) Pumpen.
- Laden und Vereinfachen der LOR-Grenzen über eine WFS-Schnittstelle.
- Transformation beider Datensätze in ein einheitliches Koordinatensystem (WGS84).
- Räumliche Verknüpfung der Pumpen mit den jeweiligen LOR-Gebieten.
- Speicherung des Endergebnisses im GeoJSON-Format.

**Code-Erklärung**
**1. Laden der benötigten Pakete**
```bash
library(dplyr)   # Für Datenmanipulation (z. B. filter, select, %>%)
library(sf)      # Für das Arbeiten mit Geodaten (Einlesen, räumlicher Join, Transformation)
library(data.table)
```

**2. Einlesen der Pumpendaten**

```bash
pumpen <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
```
- Die Datei enthält Trinkwasserpumpen als Punkt-Geometrien mit weiteren Attributen, u. a. Status und Bezirk.
- Es handelt sich um ein sf-Objekt mit räumlicher Referenz.

**3. Filtern funktionsfähiger Pumpen**

```bash
pumpen <- pumpen %>%
  filter(pump.status == "ok")
```
- Nur funktionstüchtige Pumpen mit dem Status „ok“ werden für die weitere Analyse berücksichtigt.

**4. Einlesen und Vereinfachen der LOR-Gebiete**
```bash
lor <- st_read(lor_url) %>%
  select(bzr_id, bzr_name, geom) %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
  st_transform(4326)
```
- Die LOR-Gebiete werden direkt über die WFS-Schnittstelle des Berliner Geodatenportals geladen.
- Es werden nur relevante Felder (bzr_id, bzr_name) übernommen.
- Mit st_simplify() werden die Geometrien vereinfacht, um die Verarbeitungs- und Darstellungsleistung zu optimieren – besonders bei Webanwendungen ein wichtiger Faktor.
- Die Koordinaten werden auf WGS84 (EPSG:4326) transformiert, um mit den Pumpendaten kompatibel zu sein.

**5. Harmonisierung des Koordinatensystems**

```bash
pumpen <- st_transform(pumpen, crs = 4326)
```
- Sicherstellung, dass beide Datensätze im selben Koordinatensystem (WGS84) vorliegen – Voraussetzung für räumliche Operationen wie Joins

**6. Räumliche Verknüpfung Pumpen ↔ LOR**

```bash
pumpen_mit_lor <- st_join(pumpen, lor[, c("bzr_name", "bzr_id")], left = TRUE)
```
- Jede Pumpe wird dem LOR-Gebiet zugewiesen, in dem sie sich geografisch befindet.
- Die Felder ``bzr_name`` und ``bzr_id`` werden den Pumpendaten hinzugefügt.

**7. Speichern der Ergebnisse**

```bash
st_write(pumpen_mit_lor, "data/pumpen_mit_lor.geojson", driver = "GEOJSON", delete_dsn = TRUE)
```
- Das Ergebnis wird als GeoJSON-Datei gespeichert 
- Die Option delete_dsn = TRUE überschreibt bestehende Dateien automatisch.

<details>
<summary><strong>gesamter Code:</strong></summary>

```r
library(dplyr)   # Für Datenmanipulation (z. B. filter, select, %>%)
library(sf)      # Für das Arbeiten mit Geodaten (Einlesen, räumlicher Join, Transformation)
library(data.table)  


pumpen <- st_read("data/pumpen_mit_bezirk_minimal.geojson")
lor_url <- "https://gdi.berlin.de/services/wfs/lor_2019?service=WFS&version=1.1.0&request=GetFeature&typeName=lor_2019:b_lor_bzr_2019"

pumpen <- pumpen %>%
  filter(pump.status == "ok")

lor <- st_read(lor_url) %>%
  select(bzr_id, bzr_name, geom) %>%
  st_simplify(preserveTopology = TRUE, dTolerance = 0.001) %>%
  st_transform(4326)  # Zu WGS84 transformieren

pumpen <- st_transform(pumpen, crs = 4326)

pumpen_mit_lor <- st_join(pumpen, lor[, c("bzr_name", "bzr_id")], left = TRUE)


st_write(pumpen_mit_lor, "data/pumpen_mit_lor.geojson", driver = "GEOJSON", delete_dsn = TRUE)
```
</details>
