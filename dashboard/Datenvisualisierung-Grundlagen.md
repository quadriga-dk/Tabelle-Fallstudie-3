---
lang: de-DE
---

(datenvisualisierung-methoden-werkzeuge)=
# Datenvisualisierung in Dashboards

Datenvisualisierung ist die grafische Repräsentation von Daten und Informationen und deren Umsetzung wird zunehmend eine Frage der Beherrschung von Code bzw. Programmiersprachen {cite}`heinicker_anderes_visualisieren_2024`.  

Dieses Unterkapitel soll nicht der grundlegenden Einführung in Methoden und Werkzeuge der Datenvisualisierung dienen, denn diesbezüglich gibt es bereits viele Materialien. Weiter unten finden Sie eine Auswahl an nützlichen Links zu Blogs, Kursen, Videos u. a. m., die helfen können in das Thema einzusteigen oder Wissen aufzufrischen.  
Stattdessen erfahren Sie hier etwas zur kritischen Reflexion von Datenvisualisierungen. Vor allem bei Dashboards, die in der Regel mehrere Visualisierungen zeigen, müssen einzelne Grafiken noch schneller erfasst werden. Diese Fülle von Informationen bei gleichzeitiger Abstraktion der Datenbasis bietet vielfältiges Potential, sollte aber immer auch kritisch hinterfragt werden.


```{figure} /assets/GdK_Screenshot_20260313.png
---
align: center
width: 75%
name: Dashboard Gieß den Kiez 
alt: Das Dashboard des Projektes "Gieß des Kiez" mit Visualisierungen zur Bewässerung von Bäumen in Berlin.
---
Screenshot des Dashoards des Projekts Gieß den Kiez vom 13.03.2026.
```

## Grundlagen

Visualisierungen sind bildliche Darstellungen von Daten und sollen deren Verständnis erleichtern. Sie können mit unterschiedlichen Methoden erstellt werden und viele verschiedene Darstellungsformen haben {cite}`freyberg_visualisierung_2023`.
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

**Weitere Einblicke:**
- Die Webseite <a href="https://ourworldindata.org/" class="external-link" target="_blank">Our World in Data</a> (englisch) bietet zu zahlreichen Themen, die aus werwaltungswissenschaftlicher Sicht interessant sind, visualisierte Daten an. Ein Browsen lohnt sich allein wegen der Fülle der gezeigten Darstellungsformen.
- Im Rahmen von <a href="https://www.quadriga-dk.de/de/" class="external-link" target="_blank">Quadriga</a> wurde in einer anderen Fallstudie über Studentische Filme bereits ein <a href="https://quadriga-dk.github.io/Bewegtes-Bild-Fallstudie-2/auswertung/visualisierung.html" class="external-link" target="_blank">Kapitel über Visualisierung</a> kreiert, in das ein Blick auch aus Perspektive der Verwaltung(swissenschaft) lohnt.
- Auf der Webseite von <a href="https://lisacharlottemuth.com/articles" class="external-link" target="_blank">Lisa Charlotte Muth</a> finden Sie viele Beiträge und Wissenswertes rund um das Thema Datenvisualisierungen (auf Englisch).


## Visualisierung als Kommunikation

Visuelle Darstellungen können helfen, Komplexes verständlich zu machen und auf das Wesentliche zu reduzieren. Dabei sind sie seit jeher ein zentrales Hilfsmittel, denn als kulturelle Werkzeuge strukturieren sie seit der frühen Menschheitsgeschichte unsere Vorstellungen von Raum und Zeit. {cite}`heinicker_anderes_visualisieren_2024`.  
Vor allem in der Wissenschaftskommunikation, in Bezug auf das Veranschaulichen von langen Texten, komplexen Analysen oder vielschichtigen Tabellen haben Visualisierungen ihren Reiz. Visualisierungen wie Diagrammen wird ohnehin eine gewissen Wissenschaftlichkeit, Sachlichkeit und damit Richtigkeit zugewiesen, was aber auch in die Irre führen kann. So wirken Texte mit Visualisierungen glaubhafter als solche ohne Darstellungen. Und auch das Design von interaktiven Grafiken ist entscheidend, denn die Voreinstellungen prägen bereits die Meinung der Nutzer:innen {cite}`greussing_datenvisualisierung_2019`.  
Durch die SARS-CoV-2-Pandemie ("Corona") sind Datenvisualisierungen und Dashboards als Darstellungen großer Datenmengen in der breiten Öffentlichkeit ins Bewusstsein getreten. Diese Darstellungsformen wurden gewählt, weil sie einen schnellen Überblick bieten können und bei richtigem Design auch für Laien verständlich sind {cite}`schmidt_blick_2020`.
Oft wurden dabei gefärbte Flächenkarten, so genannte Choroplethenkarten, verwendet. Auf diese Darstellungsform geht das [Kapitel 5.3 Eine Karte erstellen](map) genauer ein. Hier gilt es unter anderem zu beachten, dass die Darstellungen immer Aggregationen der dahinter stehenden Zahlen sind und nicht so "absolut" sind, wie sie erscheinen {cite}`schmidt_blick_2020`.

- Interessanterweise wird das Vorhandensein von Quellenangaben zu Datenvisualisierungen zwar als wichtig genannt, allerdings werden diese so gut wie nicht aufgerufen (ebd)
- generell ist das Interesse an Details von interaktiven Visualisierungen gering (ebd)




## Reflexion

Datenvisualisierungen bilden nicht die Realität ab, sondern sind immer Verzerrungen derselben {cite}`heinicker_anderes_visualisieren_2024`. Es gilt, Visualisierungen kritisch zu reflektieren, da sie bereits eine vereinfachte Darstellung eines komplexen Sachverhaltes sind, einen Abstraktionsgrad aufweisen und den Blick der Nutzenden auch un- bzw. unterbewusst bereits in eine bestimmte Richtung lenken können (Einsatz von Farben, Auswahl der Visualisierungsform etc.). Darüber hinaus dürfen die Kenntnisse der Zielgruppe nicht überschätzt werden, wenn eine Visualisierung der Intention entsprechend interpretiert werden soll {cite}`greussing_datenvisualisierung_2019`.

Die visuelle Darstellung kann mehr Aspekte sichtbar machen als die ursprünglichen Daten. Dies können eben Formen und Farben sein. Eine Sichtbarmachung dieser Aspekte ermöglicht beispielsweise erst eine explorative Analyse {cite}`freyberg_visualisierung_2023`. Allerdings gilt es eben auch, sich von diesen Aspekten nicht blenden zu lassen. 
Zu beachten ist dabei zudem, dass Datenvisualisierungen künstliche Konstruktionen sind, die ein bestimmtes Denken operationalisieren. Sie sind also immer im Kontext der Gesellschaften und Vorstellungswelten zu sehen, aus der sie stammen {cite}`heinicker_anderes_visualisieren_2024`.

Im Gegensatz zu einer Tabelle sind Visualisierungen oft ansprechender gestaltet. Durch Farbgebungen lässt sich ein starker Fokus setzen, was allerdings auch dazu genutzt werden kann, um das Hauptaugenmerk abzulenken {cite}`greussing_datenvisualisierung_2019`.  
Zudem ist eine Visualisierung immer auch eine Abstraktion. Sie bricht das (Forschungs-)Ergebnis auf einige Aspekte herunter und unterstreicht diese damit. Daher liegt darin auch eine Gefahr von Missinterpretationen. Die Gefahr besteht sowohl im Entwerfen eigener Grafiken, als auch in der fälschlichen Wahrnehmung der Grafiken anderer.


```{admonition} zusätzliche Materialien
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
