---
jupytext:
  formats: md:myst
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  display_name: Python 3
  language: python
  name: python3
---

# 🏆Selbsttest: Dashboard-Vorbereitung

````{admonition} Hinweis
:class: hinweis, dropdown
Diese Übungsaufgaben dienen Ihrer Selbsteinschätzung und helfen Ihnen, das im Kapitel Gelernte zu reflektieren.

Sie können die Fragen in beliebiger Reihenfolge beantworten und auch mehrfach versuchen. 

**So funktioniert es:**
- Wählen Sie bei jeder Frage die Antwort(en), die Sie für richtig halten
- Lesen Sie das Feedback zu den einzelnen Antwortoptionen sorgfältig durch
- Die Erklärungen helfen Ihnen, Ihr Verständnis zu vertiefen – auch bei korrekten Antworten 

Es erfolgt keine Bewertung oder Speicherung Ihrer Ergebnisse. Nutzen Sie dieses Assessment, um Wissenslücken zu identifizieren und gegebenenfalls die entsprechenden Abschnitte des Kapitels noch einmal zu bearbeiten. 

**Geschätzte Zeit**: XX Minuten

Viel Erfolg!
````
## Frage 1

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question1 = [
    {
        "question": "Was unterscheidet ein Dashboard von einer einzelnen Visualisierung, wie z. B. einem einzelnen Diagramm?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Ein Dashboard bündelt mehrere thematisch verwandte Visualisierungen übersichtlich an einem Ort.",
                "correct": True,
                "feedback": """✓ Richtig! Ein Dashboard zeigt nicht nur eine, sondern mehrere Visualisierungen zu gleichen oder verwandten Themen gleichzeitig an. Genau diese Bündelung ermöglicht es Nutzenden, sich schnell einen Gesamtüberblick zu verschaffen, statt einzelne Grafiken separat betrachten zu müssen."""
            },
            {
                "answer": "Ein Dashboard verwendet ausschließlich Karten zur Darstellung von Daten.",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards nutzen ganz unterschiedliche Darstellungsformen – Diagramme, Tabellen, Karten und mehr. Karten sind nur eine mögliche Komponente unter vielen."""
            },
            {
                "answer": "Ein Dashboard zeigt im Gegensatz zu einzelnen Diagrammen niemals die zugrunde liegenden Rohdaten an.",
                "correct": False,
                "feedback": """× Nicht korrekt. Im Gegenteil: Dashboards erlauben es typischerweise, die ursprünglichen Daten einzusehen, auf denen eine Zusammenfassung basiert, damit Nutzende Elemente korrekt interpretieren können."""
            },
            {
                "answer": "Ein Dashboard ist per Definition eine gedruckte Zusammenfassung von Daten.",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards sind digitale Darstellungsformen, die häufig sogar interaktiv sind – das Gegenteil einer statischen, gedruckten Zusammenfassung."""
            }
        ]
    }
]
display_quiz(question1, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 2

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question2 = [
    {
        "question": "Der Begriff 'Dashboard' stammt ursprünglich aus der Automobilproduktion (Armaturenbrett). Welche Eigenschaft dieses Ursprungs erklärt am besten, warum der Begriff auf digitale Datenvisualisierungen übertragen wurde?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Ein Armaturenbrett zeigt den Status mehrerer unterschiedlicher Systeme gebündelt und auf einen Blick an – genau wie ein digitales Dashboard mehrere Datenvisualisierungen gebündelt darstellt.",
                "correct": True,
                "feedback": """✓ Richtig! Die Kernidee eines Armaturenbretts ist es, Informationen aus verschiedenen Systemen (Geschwindigkeit, Tankstand, Motortemperatur) an einem Ort zusammenzuführen, sodass sie mit einem Blick erfassbar sind. Genau dieses Prinzip der gebündelten Übersicht wurde auf digitale Datendashboards übertragen."""
            },
            {
                "answer": "Ein Armaturenbrett wird ausschließlich von Fachpersonal bedient, ebenso wie digitale Dashboards nur für Expert:innen gedacht sind.",
                "correct": False,
                "feedback": """× Nicht korrekt. Im Gegenteil: Sowohl Armaturenbretter als auch gute Dashboards sind so gestaltet, dass auch Laien sie ohne Fachwissen schnell verstehen können. Genau diese Zugänglichkeit ist ein zentrales Ziel von Dashboards."""
            },
            {
                "answer": "Ein Armaturenbrett kann nicht verändert werden, ebenso wie digitale Dashboards grundsätzlich statisch sind.",
                "correct": False,
                "feedback": """× Nicht korrekt. Digitale Dashboards sind häufig sogar interaktiv und lassen sich durch Filter oder Regler anpassen. Die Analogie bezieht sich auf die gebündelte Übersicht, nicht auf fehlende Interaktivität."""
            },
            {
                "answer": "Ein Armaturenbrett speichert historische Daten über die gesamte Lebensdauer eines Fahrzeugs, wie es auch Dashboards tun.",
                "correct": False,
                "feedback": """× Nicht korrekt. Die Speicherung historischer Daten ist nicht der Kern der Analogie. Entscheidend ist die gleichzeitige, gebündelte Anzeige verschiedener Statusinformationen an einem Ort."""
            }
        ]
    }
]
display_quiz(question2, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 3

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question3 = [
    {
        "question": "Alle Dashboards sind zwingend interaktiv und lassen sich von Nutzer:innen durch Filter oder Regler verändern.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Richtig",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards können sowohl statisch als auch interaktiv sein. Statische Dashboards zeigen feste Abbildungen, die von Nutzenden nicht verändert werden können. Interaktive Dashboards sind zwar mittlerweile häufiger, aber keine zwingende Voraussetzung."""
            },
            {
                "answer": "Falsch",
                "correct": True,
                "feedback": """✓ Richtig! Die Aussage ist falsch. Dashboards können sowohl statisch als auch interaktiv sein. Während interaktive Dashboards heute häufiger vorkommen und es erlauben, Variablen wie Kennzahlen oder Jahreszahlen selbst anzupassen, bleiben statische Dashboards weiterhin eine gültige, wenn auch weniger flexible Form der Datenvisualisierung."""
            }
        ]
    }
]
display_quiz(question3, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 4

```{code-cell} ipython3
:tags: [remove-input]
import sys
sys.path.append("../quadriga")
from assessment import DragDropQuiz

quiz = DragDropQuiz()

quiz.create_matching_quiz(
    title="Ordnen Sie die folgenden Beschreibungen dem passenden Grundbegriff der Datenvisualisierung zu:",
    descriptions=[
        "Der sichtbare Teil einer Anwendung, den Nutzer:innen sehen und mit dem sie interagieren können",
        "Die Daten und Prozesse im Hintergrund, die die angezeigten Inhalte erzeugen, aber für Nutzer:innen nicht direkt sichtbar sind",
        "Eine Darstellung, die von Nutzer:innen nicht verändert werden kann",
        "Eine Darstellung, die sich durch Regler, Filter oder Dropdowns von Nutzer:innen anpassen lässt"
    ],
    options=[
        "Statisches Dashboard",
        "Interaktives Dashboard",
        "Frontend",
        "Backend"
    ],
    correct_mapping={
        "Der sichtbare Teil einer Anwendung, den Nutzer:innen sehen und mit dem sie interagieren können": "Frontend",
        "Die Daten und Prozesse im Hintergrund, die die angezeigten Inhalte erzeugen, aber für Nutzer:innen nicht direkt sichtbar sind": "Backend",
        "Eine Darstellung, die von Nutzer:innen nicht verändert werden kann": "Statisches Dashboard",
        "Eine Darstellung, die sich durch Regler, Filter oder Dropdowns von Nutzer:innen anpassen lässt": "Interaktives Dashboard"
    }
)
```

## Frage 5

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question5 = [
    {
        "question": "Welche Aussagen zur Bedeutung von Dashboards für die Kommunikation von Public-Sector-Daten sind korrekt? Wählen Sie alle zutreffenden Aussagen.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Dashboards erhöhen die Transparenz, indem sie von Bürger:innen erhobene Daten offenlegen und in die Gesellschaft zurückkommunizieren.",
                "correct": True,
                "feedback": """✓ Richtig! Die Offenlegung erhobener Daten als Dashboard schafft einen Win-Win-Effekt: Verwaltungen machen ihre Arbeit nachvollziehbar, während Bürger:innen leicht verständliche, aufbereitete Informationen erhalten."""
            },
            {
                "answer": "Dashboards ermöglichen ein schnelles Monitoring, da kompakt visualisierte Daten einen zügigen Überblick über eine Thematik erlauben.",
                "correct": True,
                "feedback": """✓ Richtig! Neben Transparenz und Service ist das Monitoring ein zentraler Vorteil: Dashboards fassen komplexe Informationen so zusammen, dass sich Verantwortliche schnell orientieren können, ohne Rohdaten manuell durchsuchen zu müssen."""
            },
            {
                "answer": "Dashboards ersetzen vollständig die Notwendigkeit einer inhaltlichen Datenanalyse.",
                "correct": False,
                "feedback": """× Nicht korrekt. Ein Dashboard ist ein Kommunikations- und Darstellungswerkzeug für bereits erhobene und teilweise ausgewertete Daten. Es ersetzt nicht die vorherige inhaltliche Analyse, sondern macht deren Ergebnisse zugänglich."""
            },
            {
                "answer": "Dashboards unterstützen die Politikbewertung, da sich Daten nach Zeitraum und Region filtern lassen, um Auswirkungen von Maßnahmen zu verfolgen.",
                "correct": True,
                "feedback": """✓ Richtig! Durch Filtermöglichkeiten nach Jahr und Bezirk lassen sich beispielsweise Auswirkungen konkreter politischer Maßnahmen über Zeit und Raum verfolgen, was empirische Forschung und Programmevaluation unterstützt."""
            },
            {
                "answer": "Dashboards sind für den Public Sector ungeeignet, da sie ausschließlich für kommerzielle Unternehmensanwendungen entwickelt wurden.",
                "correct": False,
                "feedback": """× Nicht korrekt. Zahlreiche Beispiele wie das Zensus-Dashboard des Amts für Statistik Berlin-Brandenburg oder das Mobilitätsdashboard der Stadt Aachen zeigen, dass Dashboards gerade im öffentlichen Sektor erfolgreich zur Datenkommunikation eingesetzt werden."""
            }
        ]
    }
]
display_quiz(question5, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 6

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question6 = [
    {
        "question": "Eine Verwaltungswissenschaftlerin möchte die Ergebnisse ihrer Analyse zum Bürger:innen-Engagement bei der Baumbewässerung sowohl an Entscheidungsträger:innen als auch an die breite Öffentlichkeit kommunizieren. Warum eignet sich ein Dashboard hierfür besonders gut?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Weil ein Dashboard komplexe Daten in einer klaren, zugänglichen Form darstellt, die für unterschiedliche Zielgruppen gleichermaßen verständlich ist.",
                "correct": True,
                "feedback": """✓ Richtig! Dashboards bieten eine klare, zugängliche Darstellung komplexer Daten, was für die Kommunikation von Ergebnissen an Entscheidungsträger, die Öffentlichkeit oder andere Stakeholder:innen unerlässlich ist und gleichzeitig die Transparenz administrativer Prozesse fördert."""
            },
            {
                "answer": "Weil ein Dashboard nur von technisch versierten Personen mit Programmierkenntnissen gelesen werden kann und dadurch Exklusivität schafft.",
                "correct": False,
                "feedback": """× Nicht korrekt. Ganz im Gegenteil: Ziel eines Dashboards ist gerade, Daten auch für Personen ohne technisches Fachwissen verständlich zu machen – nicht Exklusivität zu erzeugen."""
            },
            {
                "answer": "Weil ein Dashboard die Rohdaten vollständig verbirgt und nur die Schlussfolgerungen der Autorin zeigt.",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards erlauben es typischerweise gerade, die zugrunde liegenden Rohdaten einzusehen, damit Nutzende Ergebnisse selbst nachvollziehen und korrekt interpretieren können."""
            },
            {
                "answer": "Weil ein Dashboard ausschließlich für interne Verwaltungszwecke bestimmt ist und nicht für die Öffentlichkeit zugänglich gemacht werden kann.",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards werden explizit auch für die Öffentlichkeit bereitgestellt, wie die Beispiele Zensus-Dashboard und Mobilitätsdashboard Aachen zeigen. Sie dienen sowohl interner als auch externer Kommunikation."""
            }
        ]
    }
]
display_quiz(question6, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 7

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question7 = [
    {
        "question": "Welche Aussagen zum Vergleich unterschiedlicher Visualisierungswerkzeuge (z. B. R Shiny, Power BI, Tableau) sind korrekt? Wählen Sie alle zutreffenden Aussagen.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Werkzeuge mit Drag-and-Drop-Bedienung richten sich eher an Personen ohne Programmierkenntnisse, bieten dafür aber meist weniger Gestaltungsspielraum.",
                "correct": True,
                "feedback": """✓ Richtig! Tools wie Power BI und Tableau setzen auf eine intuitive Drag-and-Drop-Bedienung, was den Einstieg erleichtert. Im Gegenzug ist ihre Erweiterbarkeit und Visualisierungstiefe eher begrenzt, da individuelle Anpassungen schwieriger umzusetzen sind."""
            },
            {
                "answer": "Ein zentrales Abwägungskriterium bei der Werkzeugwahl ist der Kompromiss zwischen einfacher Bedienbarkeit und Gestaltungsfreiheit.",
                "correct": True,
                "feedback": """✓ Richtig! Genau dieses Dilemma wird im Kapitel beschrieben: Wer viel programmiert, gewinnt an Flexibilität und Tiefe, verzichtet aber auf die einfache, schnelle Bedienbarkeit vorgefertigter Business-Intelligence-Tools."""
            },
            {
                "answer": "Alle verglichenen Visualisierungswerkzeuge sind vollständig kostenlos und quelloffen.",
                "correct": False,
                "feedback": """× Nicht korrekt. Während R Shiny als Open-Source-Framework kostenlos ist, setzen Power BI und Tableau für ihre vollständigen Versionen auf kommerzielle, kostenpflichtige Lizenzmodelle, auch wenn eingeschränkte kostenlose Versionen existieren."""
            },
            {
                "answer": "Programmierbasierte Werkzeuge wie R Shiny erfordern zwar Vorkenntnisse, bieten dafür aber eine höhere Flexibilität und Erweiterbarkeit.",
                "correct": True,
                "feedback": """✓ Richtig! R Shiny setzt Grundkenntnisse in R voraus, ermöglicht dafür aber maßgeschneiderte, frei programmierbare Visualisierungen und eine sehr hohe Erweiterbarkeit durch das R-Ökosystem – ein deutlicher Unterschied zu vorgefertigten Business-Intelligence-Lösungen."""
            }
        ]
    }
]
display_quiz(question7, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 8

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question8 = [
    {
        "question": "Warum fällt die Wahl in dieser Fallstudie auf R Shiny und nicht auf ein Tool wie Power BI oder Tableau?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Weil R Shiny als Open-Source-Framework kostenlos ist und durch seine Anbindung an R eine hohe analytische Tiefe, Flexibilität und wissenschaftliche Reproduzierbarkeit ermöglicht.",
                "correct": True,
                "feedback": """✓ Richtig! Ausschlaggebend sind die spezifischen Anforderungen des wissenschaftlichen und verwaltungstechnischen Kontexts: Als kostenloses Open-Source-Framework vermeidet R Shiny Lizenzeinschränkungen, während die Anbindung an R komplexe Datenbereinigung, vielfältige Datenquellen und eine hohe Interaktivität ermöglicht – all das unterstützt eine transparente und reproduzierbare Analyse."""
            },
            {
                "answer": "Weil R Shiny von allen verglichenen Tools die einfachste Bedienung ohne jegliche Vorkenntnisse bietet.",
                "correct": False,
                "feedback": """× Nicht korrekt. Tatsächlich ist es umgekehrt: R Shiny erfordert Programmierkenntnisse in R, während Power BI und Tableau für ihre einfache Drag-and-Drop-Bedienung ohne Vorkenntnisse bekannt sind. Die Wahl fiel trotzdem auf R Shiny – wegen der höheren Flexibilität und Tiefe, nicht wegen einfacherer Bedienung."""
            },
            {
                "answer": "Weil Power BI und Tableau technisch nicht in der Lage sind, Daten aus dem öffentlichen Sektor zu verarbeiten.",
                "correct": False,
                "feedback": """× Nicht korrekt. Beide Tools bieten umfangreiche Datenkonnektoren und werden durchaus auch mit öffentlichen oder unternehmensbezogenen Daten genutzt. Der Ausschlag für R Shiny liegt an anderen Kriterien wie Flexibilität, Lizenzmodell und Reproduzierbarkeit."""
            },
            {
                "answer": "Weil R Shiny als einziges der drei Tools über eine Benutzeroberfläche (Frontend) verfügt.",
                "correct": False,
                "feedback": """× Nicht korrekt. Alle drei vorgestellten Tools verfügen über eine Benutzeroberfläche. Der entscheidende Unterschied liegt nicht im Vorhandensein eines Frontends, sondern in Lizenzmodell, Flexibilität und Zielgruppe."""
            }
        ]
    }
]
display_quiz(question8, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 9

**Frage:** Dashboards gelten als wirkungsvolles Werkzeug, um Verwaltungsdaten zu kommunizieren. Reflektieren Sie kurz:

1. Nennen Sie mindestens zwei Vorteile, die Dashboards für die Kommunikation von Verwaltungsdaten mit der Öffentlichkeit bieten.
2. Welche Herausforderung könnte bei der Wahl eines geeigneten Visualisierungswerkzeugs entstehen, wenn eine Verwaltung nur über begrenzte Programmierkenntnisse verfügt?

```{code-cell} ipython3
:tags: [remove-input]
import sys
sys.path.append("../quadriga")
from assessment import create_answer_box

create_answer_box('dashboard-1')
```

````{admonition} Reflexionshinweise
:class: solution, dropdown

**1. Mögliche Vorteile von Dashboards für die Kommunikation von Verwaltungsdaten:**

- **Transparenz:** Erhobene Daten (z. B. zu Bürger:innen-Engagement) werden offengelegt und für alle nachvollziehbar gemacht, was Vertrauen in Verwaltungshandeln stärken kann.
- **Zugänglichkeit:** Komplexe, abstrakte Datenmengen werden in eine leicht verständliche, visuelle Form gebracht, sodass auch Personen ohne Fachwissen die Inhalte erfassen können.
- **Schnelles Monitoring:** Entscheidungsträger:innen können sich in kurzer Zeit einen Überblick über den Status eines Themas verschaffen, ohne Rohdaten manuell auswerten zu müssen.
- **Fundierte Entscheidungsfindung:** Durch Filter- und Vergleichsmöglichkeiten (z. B. nach Bezirk oder Jahr) lassen sich Muster erkennen, die eine evidenzbasierte Politikgestaltung unterstützen.

**2. Mögliche Herausforderung bei begrenzten Programmierkenntnissen:**

Verwaltungen mit wenig Programmiererfahrung stehen vor einem Dilemma zwischen Bedienbarkeit und Gestaltungsfreiheit: Tools wie Power BI oder Tableau sind über Drag-and-Drop schnell erlernbar, bieten aber wenig Spielraum für maßgeschneiderte, komplexe Visualisierungen. Ein flexibleres, programmierbasiertes Werkzeug wie R Shiny würde zwar mehr Gestaltungsfreiheit und Reproduzierbarkeit bieten, erfordert aber Investitionen in Schulung oder externe Unterstützung, um die notwendigen Programmierkenntnisse aufzubauen. Verwaltungen müssen daher abwägen, ob sie auf schnell einsetzbare, aber weniger flexible Standardlösungen setzen oder in den Aufbau technischer Kompetenzen investieren, um langfristig unabhängiger und individueller visualisieren zu können.
````
