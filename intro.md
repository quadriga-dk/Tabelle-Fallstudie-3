---
lang: de-DE
---

(intro)=
# Visualisierung in der Verwaltung: Ein Dashboard für Baum- und Bewässerungsdaten

````{margin}
```{admonition} Fragen oder Feedback 
:class: frage-feedback

<a href="https://github.com/quadriga-dk/Tabelle-Fallstudie-3/issues/new?assignees=&labels=question&projects=&template=frage.yml" class="external-link" target="_blank">
    Stellen Sie eine Frage
</a> <br>
<a href="https://github.com/quadriga-dk/Tabelle-Fallstudie-3/issues/new?assignees=&labels=feedback&projects=&template=feedback.yml" class="external-link" target="_blank">
    Geben Sie uns Feedback
</a>

Mit Ihren Rückmeldungen können wir unser interaktives Lehrbuch gezielt an Ihre Bedürfnisse anpassen.

```
````

`````{margin}
````{admonition} Zitierhinweis
:class: citation-information
```{literalinclude} /CITATION.bib
:language: bibtex
```
Plomin, J., Walter, P., Schmeling, J., Dakruni, S. & Bingöl, C. (2025). _Visualisierung in der Verwaltung: Ein Dashboard für Baum- und Bewässerungsdaten. QUADRIGA Open Educational Resources: Tabelle 3_

````
`````

In dieser Open Educational Resource (OER) wird ein Forschungsverlauf im Bereich der Verwaltungswissenschaft mithilfe eines <a href="https://jupyterbook.org/en/stable/intro.html" class="external-link" target="_blank">JupyterBooks</a> nachgezeichnet. Anhand einer wissenschaftlichen Leitfrage wird mit der Applikation <a href="https://shiny.posit.co/" class="external-link" target="_blank">R Shiny</a> ein Dasboard gebaut. In den einzelnen Kapiteln wird erläutert, welche Daten zur Lösung der Leitfrage und zum Bau des Dashboards benötigt und wie sie bearbeitet und visualisiert werden. Dabei werden Kompetenzen wie Datenvisualisierung und Kommunikation von Forschungsergebnissen behandelt.

<span style="color:red">Bild einfügen: Framework oder etw. zu Dashboards -> UNSER Dashboard</span>.


```{admonition} Die Forschung von Dr. Amir Weber
:class: story
Dr. Amir Weber, ein Verwaltungswissenschaftler mit Interesse an kommunalen Daten und Bürgerbeteiligung, möchte ein Dashboard zur Visualisierung des Bewässerungsverhaltens von Bürger:innen erstellen, das auf offenen Datensätzen basiert.  
In einer vorangegangenen  <a href="https://quadriga-dk.github.io/Tabelle-Fallstudie-2/Titelseite.html" class="external-link" target="_blank">Fallstudie</a> hat er exemplarisch aufgezeigt, wie geeignete Datensätze identifiziert und erschlossen werden können. Auf Grundlage von Datensätzen aus dem Bundesland Berlin möchte er nun eine ergebnisoffene, explorative Analyse durchführen, um darin enthaltende Erkenntnispotenziale zu identifizieren. Die gewonnenen Befunde werden in dieser Fallstudie parallel in Form von Dashboards aufbereitet, um die Daten für Bürger:innen und politische Entscheidungsträger:innen nachvollziehbar darzustellen.  
Hierzu soll insbesondere das Ausmaß sowie die räumliche Verteilung der Bürgerbeteiligung sichtbar gemacht werden. 
Sie werden Dr. Weber mit der Erstellung eines solchen Dashboards helfen.

Er orientiert er sich an folgender Leitfrage: 
```


```{admonition} Leitfrage
:class: keypoint
Wo lassen sich die höchsten Ausprägungen des Engagements von Bürger:innen bei der Bewässerung städtischer Bäume in Berlin feststellen?
```

## Bedeutung dieses Lehrbuchs für die Verwaltungswissenschaft

<span style="color:red">folgendes noch überarbeiten</span>.

Datenvisualisierungen sind ein bewährtes Mittel der …, um zu ... *wird ergänzt = nicht ihre Wichtigkeit, sondern ihre Wirkung/Funktionalität benennen.* (siehe Kapitel 3.2)
Dashboards sind eine Möglichkeit zur Darstellung von Verwaltungsdaten, die zunehmend Verwendung findet (*Verweis auf Beispiele Aachen etc.*)


## Zielgruppe

Grundsätzlich steht das Angebot allen Interessierten offen.  
Aufgrund der Details in Bezug auf das Bauen eines Dashboards mit R Shiny, eignet sich diese OER besonders für technisch interessierte bzw. versierte Personen.  
Thematisch richtet sich das Lernangebot vorwiegend an Verwaltungswissenschaftler:innen und alle Personen, die an digitaler Verwaltung interessiert sind, da das Fallbeispiel und die Datengrundlage aus dieser Disziplin stammen.

Die Zielgruppe sind zudem promovierende und promovierte Wissenschaftler:innen, aber auch Lehrende, die das Angebot für die eigene Lehre nachnutzen wollen.

## Struktur der Fallstudie

<span style="color:red">folgendes noch überarbeiten</span>.

- Im **1. Schritt** wird eine Fragestellung aufgebaut und operationalisiert.

- Im **2. Schritt** wird der Untersuchungsgegenstand - also die Datengrundlage - beleuchtet und die Daten eingelesen und strukturiert.

- Im **3. Schritt** erfahren Sie was Dashboards sind, welche Bedeutung sie für die Verwaltung haben können, mit welchen Tools sie gebaut werden können und schließlich wie R Shiny eingerichtet wird, um damit ein Dashboard zu bauen.

- Im **4. Schritt** führt Sie das Kapitel "Dashboards - Einzelelemente" Schritt für Schritt durch die Erweiterung eines Dashboards mit weiteren Visualisierungen wie Karten oder Zeitverläufen.
