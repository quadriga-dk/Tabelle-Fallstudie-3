# Umsetzung mit R Shiny

## Vorbereitung der Daten: Einlesen und Bereinigung

Nachdem die Datenbasis bekannt ist, beginnt der erste praktische Schritt in der Datenverarbeitung: Das Einlesen der Datei in R und das Vorbereiten der Daten für eine spätere Analyse oder Visualisierung, z. B. auf einer Karte.

**CSV-Datei in R einlesen**

```bash
    df <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8")
```

Mit diesem Befehl wird die heruntergeladene CSV-Datei in das Programm geladen. Sie wird in einer Tabelle namens `df` gespeichert, vergleichbar mit einem Arbeitsblatt in Excel.
Wichtig dabei:

- Die Spalten in der Datei sind durch Semikolons (;) getrennt.

- Texte sollen nicht automatisch in spezielle „Kategorien“ umgewandelt werden (stringsAsFactors = FALSE).

- Die Kodierung UTF-8 sorgt dafür, dass Umlaute und Sonderzeichen korrekt gelesen werden.

**Datentypen anpassen**

Manche Spalten, etwa das Pflanzjahr und die bewässerte Menge in Litern, wurden beim Einlesen als Text erkannt. Damit man damit rechnen oder sie filtern kann, müssen sie als Zahlen vorliegen. Mit diesen Befehlen wird das sichergestellt.

```bash
    df$pflanzjahr <- as.numeric(df$pflanzjahr)
    df$bewaesserungsmenge_in_liter <- as.numeric(df$bewaesserungsmenge_in_liter)
```

**Was sind „NA“-Werte?**

In echten Datensätzen fehlen oft einzelne Angaben – z. B. eine Koordinate oder ein Zahlenwert. In R werden solche fehlenden Werte mit dem Kürzel „NA“ (Not Available) dargestellt.

Beispiel:

Wenn bei einem Baum die Wassermenge nicht eingetragen wurde, steht dort „NA“.

Warum sind NA-Werte problematisch?

- Sie verhindern sinnvolle Berechnungen (z. B. Durchschnittswerte).

- Sie stören die Darstellung auf Karten, da Koordinaten fehlen.

- Sie können Analysen verfälschen, wenn sie nicht beachtet werden.

Deshalb ist es üblich, diese unvollständigen Zeilen zu entfernen oder gezielt zu bereinigen.

**Daten bereinigen und vereinheitlichen**

```bash
df_clean <- df %>%
  drop_na(lng, lat, bewaesserungsmenge_in_liter) %>%
  mutate(strname = str_to_title(trimws(tolower(strname)))) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))
```

Dieser Schritt sorgt dafür, dass die Tabelle wirklich nur vollständige und sinnvolle Daten enthält:

- `drop_na(...)`: Entfernt alle Zeilen, bei denen:

    - Koordinaten (lat/lng) fehlen → notwendig für die Kartendarstellung.

    - Bewässerungsmenge fehlt → nötig für Auswertungen.

- `mutate(...)`: Vereinheitlicht die Straßennamen:

    - Alles wird klein geschrieben, Leerzeichen am Rand entfernt und dann korrekt formatiert, z. B. aus „ ALTENALLEE “ wird „Altenallee“.

- `filter(...)`: Entfernt unbrauchbare Einträge:

    - Wenn der Straßenname fehlt oder nur „Undefined“ enthält.

    - Wenn sich in der Baumgattung Zahlen befinden (z. B. „Ahorn23“), was auf fehlerhafte Einträge hinweist.

Das Ergebnis ist `df_clean`: eine bereinigte Version der ursprünglichen Tabelle – sauber, einheitlich und bereit für alle weiteren Schritte.