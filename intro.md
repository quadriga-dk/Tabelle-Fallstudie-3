---
lang: de-DE
---

(intro)=
# Visualisierung in der Verwaltung
## Bau eines Dashboards für Baumdaten

````{margin}
```{admonition} Fragen oder Feedback 
:class: frage-feedback

<a href="https://github.com/quadriga-dk/Tabelle-Fallstudie-1/issues/new?assignees=&labels=question&projects=&template=frage.yml" class="external-link" target="_blank">
    Stellen Sie eine Frage
</a> <br>
<a href="https://github.com/quadriga-dk/Tabelle-Fallstudie-1/issues/new?assignees=&labels=feedback&projects=&template=feedback.yml" class="external-link" target="_blank">
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
*... wird ergänzt ...*

````
`````

Diese Fallstudie bildet mit Hilfe eines <a href="https://jupyterbook.org/en/stable/intro.html" class="external-link" target="_blank">JupyterBooks</a> einen Handlungsverlauf in der Verwaltung(swissenschaft) nach. Dabei wird anhand einer modellhaften Forschungsfrage auf die Visualisierung von Daten eingegangen. Dazu werden in einzelnen Kapiteln die Themen Datenvisualisierung, Dashboards und Manipulierbarkeit von Visualisierungen *sowie Kommunikation von Forschungsergebnissen* behandelt.

Statt einer zentralen Forschungsfrage wird folgendes Szenario skizziert: 

```{admonition} Story
:class: story
Geschichten, Fallstudien oder narrative Beispiele werden mit diesem Admonition-Typ gekennzeichnet.
Dr. Amir Weber, ein Verwaltungswissenschaftler mit Interesse an kommunalen Daten und Bürgerbeteiligung, möchte ein Dashboard zur Visualisierung der Baumartenvielfalt und dem Bewässerungsverhalten erstellen, das auf offenen Datensätzen basiert. In der 2. Fallstudie (*Link zu Fallstudie 2*) hat er dazu bereits nach passenden Datensätzen gesucht. Nun möchte er er sich die Daten explorativ anschauen und Dashboards zur Visualisierung dieser Daten gestaltet, um die Datensätze für  Bürger:innen und Politik verständlich darzustellen. Hier soll das Ausmaß und die Verteilung der Bürgerbeteiligung sichtbar gemacht werden. 
Dabei orientiert er sich an folgenden Leitfragen: 
```

## Fokus

Leitfragen: 
- Wo zeigen sich die höchsten Ausprägungen des Bürgerengagements bei der Bewässerung städtischer Bäume in Berlin?
- Welche Rolle spielen räumliche (Bezirk, Baumdichte), zeitliche (Pflanzjahr, Jahresverlauf) und infrastrukturelle (Pumpendichte) Faktoren für das Engagement?
- Wie können interaktive Dashboards zur Visualisierung dieser Daten gestaltet werden, um versch. Datensätze einzubeziehen und verständlich darzustellen?


## Bedeutung dieses Lehrbuchs für die Verwaltungswissenschaft

Datenvisualisierungen sind wichtig, weil ... *wird ergänzt*
Dashboards sind eine Möglichkeit zur Darstellung von Verwaltungsdaten, die zunehmend Verwendung findet (*Verweis auf Beispiele Aachen etc.*)


## Zielgruppe

Grundsätzlich steht das Angebot allen Interessierten offen. Es richtet sich jedoch vorwiegend an Verwaltungswissenschaftler:innen und alle Personen, die an digitaler Verwaltung interessiert sind, da die hier vermittelten Inhalte anhand des Datentyps Tabelle aufbereitet sind. Zudem sind die hier entwickelten Lerneinheiten anhand von Fallbeispielen konstruiert, die für diese Disziplin typisch sind.

Die Zielgruppe sind promovierende und promovierte Wissenschaftler:innen, aber auch Lehrende, die das Angebot für die eigene Lehre nachnutzen wollen.

**Voraussetzungen**

Im Kapitel [Dashboard](dashboard) können Sie, wenn Sie Technik affin sind, selbst ein Dashboard bauen. Dies setzt allerdings ein tieferes Verständnis von der Funktionsweise der <a href="https://www.r-project.org" class="external-link" target="_blank">Programmiersprache R</a> voraus, sodass dieses Kapitel für *Fortgeschrittene* konzipiert wurde. 


## Struktur der Fallstudie

- Im **1. Schritt** gilt es, Hintergrundwissen zu vermitteln. Auf Grundlage der Frage *Was braucht es für eine gelungene Datenvisualisierung?* gehen wir auf Methoden und Werkzeuge der Datenvisualisierung ein.

- Im **2. Schritt** fokussieren wir uns auf die Darstellungsmethode Dashboards und ihre Möglichkeiten und zeigen Tools auf, mit denen man Dashboards gestalten kann.

- Im **3. Schritt** zeigen wir Ihnen beispielhaft, wie man mit dem Tool R Shiny ein Dashboard bauen kann.

... *to be continued*
