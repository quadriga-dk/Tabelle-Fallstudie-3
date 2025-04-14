Das Ziel dieses Abschnitts ist es, eine Startseite für ein Dashboard zu erstellen, das wichtige Informationen über die Baum-Bewässerung in verschiedenen Berliner Bezirken anzeigt. Dabei geht es darum, eine übersichtliche, interaktive Ansicht zu bauen, die Folgendes ermöglicht:

- Zentrale Kennzahlen anzeigen, etwa wie viele Bäume gegossen wurden oder wie viel Wasser verbraucht wurde.

- Daten filtern – also z. B. sagen: „Zeig mir nur die Daten für Friedrichshain-Kreuzberg“ oder „Alle Bezirke“.

Um das zu realisieren, wird die Anwendung in zwei großen Teilen aufgebaut:

1. Benutzeroberfläche (UI – User Interface)

2. Serverlogik (server)

## **1. Interaktive Datenfilterung vorbereiten**

Bevor wir Zahlen anzeigen können, müssen wir sicherstellen, dass die Daten nach Auswahl des Bezirks gefiltert werden. Das bedeutet: Wenn jemand im Menü z. B. „Neukölln“ auswählt, sollen nur die entsprechenden Datensätze aus Neukölln berücksichtigt werden.

Das geschieht mit dieser Funktion:

```bash
    filteredData <- reactive({
    df_clean %>%
        filter(
        input$bezirk == "Alle" | bezirk %in% input$bezirk
        )
    })
```

Schauen wir uns das Zeile für Zeile und Begriff für Begriff an:

### ``filteredData <- reactive({ ... })``
- ``filteredData`` ist ein selbstgewählter Name für eine neue Funktion, die wir erstellen.

- ``<-`` ist der sogenannte Zuweisungsoperator: Er weist etwas (hier eine Funktion) einem Namen zu. Gesprochen: „filteredData bekommt …“

- ``reactive({...})`` ist ein spezieller R-Befehl aus Shiny, der bedeutet:
„Wenn sich etwas am Input (z. B. an der Bezirk-Auswahl) ändert, dann rechne das hier automatisch neu.“

```{admonition} Merke: 
:class: keypoint 

``reactive()`` ist wie ein **intelligenter Beobachter**: Er reagiert **automatisch** auf Eingaben und aktualisiert die Daten.
```

### ``df_clean %>% filter(...)``

``df_clean`` ist die **Daten-Tabelle**, wir bereits vorher im Schritt Datenbereiningung bereinigt wurde.

Das ``%>%`` ist ein sogenannter **Pipe-Operator** (gesprochen: "dann"). Er erlaubt uns, Befehle lesbarer hintereinander zu schreiben.

``filter(...)`` ist eine Funktion aus dem Paket ``dplyr`` und bedeutet: Nur bestimmte Zeilen behalten, nämlich die, auf die unsere Bedingungen zutreffen.

### ``input$bezirk``
- ``input$`` ist die Art, wie man in Shiny auf Eingabefelder zugreift.

- ``input$bezirk`` meint konkret: Was der/die Nutzer*in im Dropdown-Menü „Bezirk auswählen“ gewählt hat.

```{admonition} Beispiel: 
:class: tip
Wenn jemand im Menü „Mitte“ auswählt, steht in ``input$bezirk`` genau das drin: ``"Mitte"``.
```

### ``input$bezirk == "Alle" | bezirk %in% input$bezirk``
Diese Zeile ist die Filter-Bedingung:

1. Wenn „Alle“ ausgewählt wurde, dann sollen **alle Zeilen behalten werden**.

2. Wenn ein **bestimmter Bezirk** ausgewählt wurde, dann sollen **nur die Zeilen mit diesem Bezirk** behalten werden.

- ``|`` bedeutet **ODER**

- ``%in%`` fragt: **Ist ein Wert in einer Liste enthalten?**

```{admonition} Beispiel: 
:class: tip
Wenn ``input$bezirk`` = ``c("Mitte", "Kreuzberg")``, dann wird ``bezirk %in% input$bezirk`` nur die Zeilen durchlassen, die den Bezirk „Mitte“ oder „Kreuzberg“ haben.
```

## 2. Benutzeroberfläche: Elemente anzeigen
Jetzt definieren wir, was auf dem Bildschirm sichtbar sein soll – z. B. Boxen mit Zahlen und das Dropdown-Menü.

**Value Boxes anzeigen**

```bash
    tabItem(tabName = "start",
    fluidRow(
        valueBoxOutput("total_trees"),
        valueBoxOutput("total_water"),
        valueBoxOutput("avg_water")
    ),
```

- ``fluidRow(...)`` erzeugt eine **horizontale Zeile** mit mehreren Elementen.

- ``valueBoxOutput("...")`` reserviert einen **Platzhalter** für eine Kennzahl, z. B. wie viele Bäume gegossen wurden.

    - ``"total_trees"`` ist der Name des späteren Inhalts.

    - Der Inhalt wird im **Server-Teil** gefüllt.


### Filter-Dropdown für Bezirke

```bash
    fluidRow(
        box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
        selectInput("bezirk", "Bezirk auswählen:", 
            choices = c("Alle", unique(df$bezirk)), 
            selected = "Alle", multiple = TRUE
        )
        )
    )
    )
```

Erläuterung der einzelnen Teile:
- ``selectInput(...)`` erstellt ein **Dropdown-Menü** (also eine Auswahlliste).

- ``"bezirk"`` ist der Name, unter dem Shiny diesen Input später erkennt → ``input$bezirk``

- ``"Bezirk auswählen:" `` ist der Text, der über dem Menü steht.

- ``choices = c("Alle", unique(df$bezirk))``

    - ``df$bezirk`` heißt: Aus der Tabelle ``df`` nimm die Spalte ``bezirk``.

    - ``unique(df$bezirk)`` bedeutet: **Nur jeden Bezirk einmal anzeigen** – keine Dopplungen.

    - ``c(...)`` macht daraus eine Liste aller Bezirke plus **"Alle"**.

- ``multiple = TRUE`` heißt: Man darf **mehrere Bezirke gleichzeitig auswählen**.


## 3. Was passiert im Hintergrund? (Server-Logik)
Jetzt legen wir fest, was die Boxen anzeigen sollen, wenn jemand einen Bezirk auswählt.

#### Anzahl gegossener Bäume

```bash
    output$total_trees <- renderValueBox({
        valueBox(
            formatC(nrow(filteredData()), big.mark = "."),
            "Gesamtzahl der gegossenen Bäume",
            icon = icon("tree"),
            color = "green"
        )
    })
```   
- ``output$total_trees`` ist das, was in die Box ``valueBoxOutput("total_trees")`` geschrieben wird.

- ``renderValueBox({...})`` sagt: „Berechne, was in die Box geschrieben wird.“

- ``nrow(filteredData())`` zählt die **Anzahl der Zeilen**, also: Wie viele Bäume wurden gegossen?

- ``formatC(..., big.mark = ",")`` macht die Zahl lesbarer (z. B. 1,000 statt 1000).

- ``icon("tree")`` zeigt ein Baum-Icon.

- ``color = "green"`` färbt die Box grün.

#### Gesamtmenge gegossenes Wasser

Um die Gesamtmenge des Wassers anschaulich darzustellen, rechnen wir sie in passende Einheiten (Liter, Kubikmeter oder Mega Liter) um:

```bash
    output$total_water <- renderValueBox({
        conversion_result <- convert_units(sum(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE))
        converted_value <- conversion_result$value
        unit <- conversion_result$unit
        
        valueBox(
            paste(format(converted_value, big.mark = ","), unit),
            paste("Gesamtbewässerung (", full_unit(unit), ")", sep=""),
            icon = icon("tint"),
            color = "blue"
        )
    })
```  
Hier wird:

- Die Summe aller Wassermengen berechnet: ``sum(...)``

- Dann die Einheit umgerechnet: Liter, Kubikmeter oder Mega Liter, je nach Größe

- ``convert_units()`` ist eine eigene Funktion, die das für uns macht

#### Umrechnungsfunktionen

```bash
    convert_units <- function(liters) {
        if (liters >= 1e6) {
            return(list(value = round(liters / 1e6, 2), unit = "ML"))
        } else if (liters >= 1e3) {
            return(list(value = round(liters / 1e3, 2), unit = "m³"))
        } else {
            return(list(value = round(liters, 2), unit = "L"))
        }
    }
``` 

```bash
    full_unit <- function(unit) {
        switch(unit,
            "ML" = "Mega Liter", 
            "m³" = "Kubikmeter", 
            "L" = "Liter", 
            unit
        )
    }
```  
Logik:

- Wenn über 1 Million Liter → **Mega Liter (ML)**

- Wenn über 1.000 Liter → **Kubikmeter (m³)**

- Sonst → **Liter (L)**

Diese Funktionen helfen dabei, die Wassermenge in verständliche Einheiten zu bringen.

**Durchschnittliche Bewässerungsmenge pro Baum**

Neben der Gesamtmenge an gegossenem Wasser ist es oft auch spannend zu sehen, wie viel Wasser durchschnittlich pro Baum verwendet wurde. Dafür brauchen wir den sogenannten arithmetischen Mittelwert – also den Durchschnitt.

Dieser wird im folgenden Abschnitt berechnet:

```bash
    output$avg_water <- renderValueBox({
        valueBox(
            formatC(mean(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE), digits = 2, big.mark = "."),
            "Durchschnittliche Bewässerung pro gegossenen Baum (Liter)",
            icon = icon("chart-line"),
            color = "aqua"
        )
    })
```
- output$avg_water ist die Stelle, an der die dritte Kennzahl (ValueBox) angezeigt wird. Diese Box wird im UI-Teil über valueBoxOutput("avg_water") eingebunden.

- renderValueBox({...}) ist eine Shiny-Funktion, die dafür sorgt, dass die Inhalte dynamisch aktualisiert werden – je nachdem, welcher Bezirk ausgewählt wurde.

- Im Inneren wird eine valueBox(...) erzeugt. Diese zeigt:

    - Die berechnete Zahl

    - Einen Titeltext

    - Ein passendes Icon

    - Und eine Farbe (hier: aqua, ein helles Blau)


#### Was passiert bei der Berechnung?

```bash
mean(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE)
```

- ``filteredData()`` gibt die **bereits gefilterte Tabelle ** zurück – also nur die Daten aus den ausgewählten Bezirken.

- ``filteredData()$bewaesserungsmenge_in_liter`` greift auf die Spalte zu, in der steht, wie viele Liter Wasser pro Baum gegossen wurden.

- ``mean(...)`` berechnet den Durchschnittswert dieser Zahlen.

- ``na.rm = TRUE`` bedeutet: Wenn es **leere oder fehlende Werte** gibt (``NA``), sollen diese ignoriert werden. Sonst könnte die Berechnung abbrechen.

#### Formatierung der Zahl

```bash
formatC(..., digits = 2, big.mark = ".")
```

- ``formatC(...)`` sorgt dafür, dass die Zahl **schön lesbar formatiert** wird:

    - ``digits = 2`` → zwei Nachkommastellen

    - ``big.mark = "."`` → Punkte als Tausender-Trennzeichen, wie in Deutschland üblich (z. B. „1.234,56“ Liter)



Hier der gesamte Code zur Kontrolle

```bash
ui <- dashboardPage(
    dashboardHeader(title = "Gieß den Kiez Dashboard"),
    dashboardSidebar(
        sidebarMenu(
        menuItem("Startseite", tabName = "start", icon = icon("home")),
        menuItem("Karte", tabName = "map", icon = icon("map")),
        menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart")),
        menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area"))
        )
  ),
  dashboardBody(
    tabItems(
        tabItem(tabName = "start",
                fluidRow(
                  valueBoxOutput("total_trees"),
                  valueBoxOutput("total_water"),
                  valueBoxOutput("avg_water")  
                ),
                fluidRow(
                    box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df$bezirk)), selected = "Alle", multiple = TRUE))
                )

        )
    )
  )

# Server-Logik
server <- function(input, output, session) {

    convert_units <- function(liters) {
    if (liters >= 1e6) {
      return(list(value = round(liters / 1e6, 2), unit = "ML"))
    } else if (liters >= 1e3) {
      return(list(value = round(liters / 1e3, 2), unit = "m³"))
    } else {
      return(list(value = round(liters, 2), unit = "L"))
    }
  }
  
  # Funktion zum Umrechnen von Vektoren
  convert_unit_vector <- function(liters_vector) {
    sapply(liters_vector, function(liters) {
      conversion_result <- convert_units(liters)
      return(list(value = conversion_result$value, unit = conversion_result$unit))
    })
  }
  
  full_unit <- function(unit) {
    if(length(unit) == 1) { 
      switch(unit,
             "ML" = "Mega Liter", 
             "L" = "Liter", 
             "m³" = "Kubikmeter",  
             "kL" = "Kilo Liter",
             unit)  # Default 
    } else {
      return("Unknown unit")  
    }
  }
  
  filteredData <- reactive({
    df_clean %>%
      filter(
        (input$bezirk == "Alle" | bezirk %in% input$bezirk)
      )
  })

   output$total_trees <- renderValueBox({
    valueBox(
      formatC(nrow(filteredData()), big.mark="."),
      "Gesamtzahl der gegossenen Bäume",
      icon = icon("tree"),
      color = "green"
    )
  })


    output$total_water <- renderValueBox({
        # Umrechnung des Werts und Ermittlung der Einheit
        conversion_result <- convert_units(sum(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE))
        
        # Der umgerechnete Wert und die Einheit
        converted_value <- conversion_result$value
        unit <- conversion_result$unit
        
        valueBox(
            paste(format(converted_value, big.mark = "."), unit),
            paste("Gesamtbewässerung (", full_unit(unit), ")", sep=""), 
            icon = icon("tint"),
            color = "blue"
        )
    }) 

    output$avg_water <- renderValueBox({
        valueBox(
            formatC(mean(filteredData()$bewaesserungsmenge_in_liter, na.rm = TRUE), digits = 2, big.mark="."),
            "Durchschnittliche Bewässerung pro gegossenen Baum (Liter)",
            icon = icon("chart-line"),
            color = "aqua"
        )
    })
}  
```