---
lang: de-DE
---

(datenvisualisierung-methoden-werkzeuge)=
# Datenvisualisierung in Dashboards
 
````{margin}
```{admonition} Hinweis
:class: hinweis

Dieses Unterkapitel soll nicht der grundlegenden Einführung in Methoden und Werkzeuge der Datenvisualisierung dienen, denn diesbezüglich gibt es bereits viele Materialien. Weiter unten finden Sie eine Auswahl an nützlichen Links zu Blogs, Kursen, Videos u. a. m., die helfen können in das Thema einzusteigen oder Wissen aufzufrischen.  
Stattdessen erfahren Sie hier etwas zur kritischen Reflexion von Datenvisualisierungen.

```
````
Vor allem bei Dashboards, die in der Regel mehrere Visualisierungen zeigen, müssen einzelne Grafiken noch schneller erfasst werden (s. z. B. {numref}`Dashboard Gieß den Kiez`). Diese Fülle von Informationen bei gleichzeitiger Abstraktion der Datenbasis bietet vielfältiges Potential, sollte aber immer auch kritisch hinterfragt werden.


```{figure} /assets/GdK_Screenshot_20260313.png
---
align: center
width: 75%
name: Dashboard Gieß den Kiez 
alt: Das Dashboard des Projektes "Gieß des Kiez" mit Visualisierungen zur Bewässerung von Bäumen in Berlin.
---
Screenshot des Dashoards des Projekts Gieß den Kiez vom 13.03.2026, das verschiedene Darstellungen zum Thema Bewässerung von Stadtbäumen zeigt.
```

## Wiederholung: Grundlagen der Datenvisualisierung

Visualisierungen sind bildliche Darstellungen von Daten und sollen deren Verständnis erleichtern. Sie können mit unterschiedlichen Methoden erstellt werden und viele verschiedene Darstellungsformen haben {cite}`freyberg_visualisierung_2023`. Darüber hinaus ist die Umsetzung von Datenvisualisierung zunehmend eine Frage der Beherrschung von Code bzw. Programmiersprachen {cite}`heinicker_anderes_visualisieren_2024`.   
Da es bereits einige Lernressourcen zum Thema Datenvisualisierung gibt, finden Sie hier einige Empfehlungen:

**Einstiegslevel:**
- Wenn Sie noch wenig Erfahrung mit Datenvisualisierung haben, finden Sie im  <a href="https://civic-data.de/datenvisualisierung-einfuehrung/" class="external-link" target="_blank">Blog-Eintrag</a> des Civic Data Labs</a> einen zugänglichen Einstieg ins Thema (ganz ohne Programmierkenntnisse).
- Das <a href="https://future-skills-journey.de/was-ist-datenvisualisierung?show_status_form=1" class="external-link" target="_blank">Einsteigervideo</a> der RWTH Aachen erklärt in 14 Minuten kompakt, was Datenvisualisierung ist und welche Arten von Visualisierungen es gibt – ergänzt durch Reflexionsfragen zur Vertiefung.

**Fortgeschrittene:**
- Wenn Sie bereits Grundkenntnisse mitbringen, finden Sie im <a href="https://www.skala-campus.org/artikel/tipps-daten-visualisieren-excel/" class="external-link" target="_blank">Blog-Beitrag</a> „Daten visualisieren (III): Datenvisualisierungs-Tools im Überblick" von Nina Hauser auf dem Skala Campus einen strukturierten Überblick über gängige Tools zur Datenvisualisierung. 

**Übersichtsseiten:**
- Wenn Sie auf der Suche nach weiteren Lernressourcen zu Datenvisualisierung sind, finden Sie beim <a href="https://civic-data.de/datenlebenszyklus/daten-visualisieren/" class="external-link" target="_blank">Civic Data Lab</a>  eine umfassende Sammlung an externen Empfehlungen – strukturiert nach Anfänger:in, Fortgeschrittene und Expert:in, mit passenden Kursen, Cheat Sheets und Praxistipps zu Tools wie Datawrapper, Excel, ggplot2, Tableau und Power BI. Schauen Sie dort gerne rein, um Ihre Vorerfahrungen mit dem Thema besser einschätzen zu können.  
- Das Civic Data Lab hat darüber hinaus einen eigenen Lernraum geschaffen, in dem es einen Kurs zu <a href="https://moodle.gi.de/moodle/enrol/index.php?id=16" class="external-link" target="_blank">Datenvisualisierung und Storytelling</a> gibt. Der Kurs vermittelt in drei aufeinander aufbauenden Modulen sowohl die Konzepte hinter Visualisierung und Storytelling als auch praktische Methoden und lehrt, warum und wie man Daten als Geschichte erzählt.
- In der <a href="https://www.datawrapper.de/academy" class="external-link" target="_blank">Datawrapper Academy</a> lernen Sie, wie Sie mit dem gleichnamigen Tool, das auch kostenfrei nutzbar ist, Visualisierungen erstellen.

```{admonition} Weitere Einblicke
:class: seealso
- Die Webseite <a href="https://ourworldindata.org/" class="external-link" target="_blank">Our World in Data</a> (englisch) bietet zu zahlreichen Themen, die aus verwaltungswissenschaftlicher Sicht interessant sind, visualisierte Daten an. Ein Browsen lohnt sich allein wegen der Fülle der gezeigten Darstellungsformen.
- Im Rahmen von <a href="https://www.quadriga-dk.de/de/" class="external-link" target="_blank">Quadriga</a> wurde in einer anderen Fallstudie über Studentische Filme bereits ein <a href="https://quadriga-dk.github.io/Bewegtes-Bild-Fallstudie-2/auswertung/visualisierung.html" class="external-link" target="_blank">Kapitel über Visualisierung</a> kreiert, in das ein Blick auch aus Perspektive der Verwaltung(swissenschaft) lohnt.
- Auf der Webseite von <a href="https://lisacharlottemuth.com/articles" class="external-link" target="_blank">Lisa Charlotte Muth</a> finden Sie viele Beiträge und Wissenswertes rund um das Thema Datenvisualisierungen (auf Englisch).
- Die <a href="https://r-graph-gallery.com/ggplot2-package.html" class="external-link" target="_blank">R Graph Gallery – ggplot2</a> bietet zahlreiche Beispiele für Visualisierungen mit <code>ggplot2</code>. Sie eignet sich besonders, um verschiedene Diagrammtypen und deren Umsetzung in R anhand konkreter Beispiele kennenzulernen. 
- Das frei verfügbare Buch <a href="https://r4ds.hadley.nz/" class="external-link" target="_blank">R for Data Science</a> ist eine umfassende Ressource für die Arbeit mit R. Es behandelt unter anderem die Datenvisualisierung mit <code>ggplot2</code> und bietet sich daher sowohl für den Einstieg in R als auch zur Vertiefung der Arbeit mit Visualisierungen an.
```


## Visualisierung als Kommunikation

Visuelle Darstellungen können helfen, Komplexes verständlich zu machen und auf das Wesentliche zu reduzieren {cite}`heinicker_anderes_visualisieren_2024`.  
Visualisierungen wie Diagrammen wird eine gewisse Wissenschaftlichkeit, Sachlichkeit und damit Richtigkeit zugeschrieben, wodurch sie für Wissenschaftskommunikation besonders relevant sind. So wirken Texte mit Visualisierungen glaubhafter als solche ohne Darstellungen. Umso entscheidender ist das Design von interaktiven Grafiken, denn die Voreinstellungen prägen die Meinung der Nutzer:innen {cite}`greussing_datenvisualisierung_2019`.
Im Zuge der Corona-Pandemie (SARS-CoV-2, ca. 2019–2022) sind Datenvisualisierungen und Dashboards als Darstellungen großer Datenmengen der breiten Öffentlichkeit ins Bewusstsein getreten. Besonders häufig wurden gefärbte Flächenkarten (Choroplethenkarten) verwendet, um die Daten für Laien verständlich aufzubereiten {cite}`schmidt_blick_2020`. Auf diese Darstellungsform geht das Kapitel [5.3 Eine Karte erstellen](map) genauer ein. Die Darstellungen sind immer Aggregationen der dahinter stehenden Zahlen und nicht als „absolut“ zu sehen.
Ein Problem sind beispielsweise fehlende Daten, denn diese sind nur sehr umständlich visualisierbar {cite}`schmidt_blick_2020`. Es muss entschieden werden, bis zu welchem Detailgrad Visualisierung erfolgt. Eine Detailtiefe ist nicht zwingend wünschenswert – auch von Nutzer:innenseite {cite}`greussing_datenvisualisierung_2019`.


## Reflexion

Datenvisualisierungen bilden nicht die Realität ab,sondern sollen einen komplexen Sachverhalt vereinfacht darstellen. Dadurch sind sie immer auf Wesentliches fokussiert {cite}`heinicker_anderes_visualisieren_2024` und können den Blick der Nutzenden (z. B. durch den Einsatz von Farben: Rot signalisiert „Stopp“, „Warnung“; Grün signalisiert „Hoffnung“, „Okay“) und deren Meinungen lenken. Entsprechend müssen Datenvisualisierungen Zielgruppenspezifisch kritisch reflektiert werden (z. B. Adressat*innenvorkenntnisse, {cite}`greussing_datenvisualisierung_2019`), da sie ansonsten zu Missinterpretationen führen können.

Visuelle Darstellungen können über die Nutzung von beispielsweise Farben erst Datenmuster sichtbar werden lassen {cite}`freyberg_visualisierung_2023`, welche nicht unkritisch übernommen werden sollen. Visualisierungen sind immer auch Konstruktionen, die EINEN Blickwinkel festhalten. Sie müssen im Kontext der Gesellschaften und Vorstellungswelten, denen sie entstammen, gesehen werden ({cite}`heinicker_anderes_visualisieren_2024`).

Durch Farbgebungen lässt sich ein starker Fokus setzen, was auch missbraucht werden kann, um vom Hauptaugenmerk abzulenken {cite}`greussing_datenvisualisierung_2019`.  

Quellen bzw. Links zu den Originaldaten sollten immer angegeben werden. Interessanterweise werden die Quellen zwar so gut wie nicht aufgerufen, obwohl ihr Vorhandensein als wichtig genannt wird {cite}`greussing_datenvisualisierung_2019`. Aber vor allem im wissenschaftlichen Kontext entsprichen Quellenangaben natürlich der <a href="https://zenodo.org/records/14281892" class="external-link" target="_blank">Guten wissenschaftlichen Praxis</a>.


```{admonition} Zusätzliche Materialien
:class: seealso
Das <a href="https://civic-data.de/" class="external-link" target="_blank">Civic Data Lab</a> hat eine <a href="https://civic-data.de/app/uploads/Checkliste-Datenvisualisierung.pdf" class="external-link" target="_blank">Checkliste</a> veröffentlicht, die dabei helfen kann, Visualisierungen kritisch zu lesen. Im Fokus steht dabei, woher die Daten kommen und wie sie grafisch dargestellt werden. 
```


```{admonition} Merke
:class: keypoint

Visualisierungen sind immer eine **vereinfachte Darstellung** eines Sachverhalts.

Die Gestaltung der Visualisierung (Verwendung bestimmter Farben, Anordnung einzelner Aspekte etc.) hat bereits Einfluss darauf, wie sie von anderen wahrgenommen wird.

Die Manipulation einer Visualisierung erfolgt daher nicht zwangsweise bewusst. 

Wer sich der **Manipulationsmöglichkeiten** bewusst ist und **Visualisierungen kritisch analysiert**, läuft weniger Gefahr, Visualisierungen zu missinterpretieren.
```

**Literatur**

```{bibliography}
:filter: docname in docnames
```
