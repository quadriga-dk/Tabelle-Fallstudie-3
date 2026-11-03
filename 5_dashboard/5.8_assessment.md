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

# 🏆Selbsttest: Dashboard

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
        "question": "Sie möchten Ihrem eigenen Dashboard einen neuen Tab hinzufügen. Welche Schritte sind dafür mindestens notwendig?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Einen neuen Menüpunkt in der Seitenleiste ergänzen und einen passenden Inhaltsbereich mit den gewünschten Visualisierungen anlegen.",
                "correct": True,
                "feedback": """✓ Richtig! Jeder neue Tab benötigt zwei zusammengehörige Bestandteile: einen Menüpunkt zur Navigation und einen dazu passenden Inhaltsbereich, der die eigentlichen Inhalte zeigt. Fehlt einer der beiden Teile, funktioniert die Navigation nicht wie gewünscht."""
            },
            {
                "answer": "Einen neuen Menüpunkt in der Seitenleiste ergänzen – der Inhalt wird automatisch generiert.",
                "correct": False,
                "feedback": """× Nicht korrekt. Ein Menüpunkt allein erzeugt keinen automatischen Inhalt. Ohne einen eigens angelegten Inhaltsbereich bliebe die Seite nach dem Klick leer."""
            },
            {
                "answer": "Einen Inhaltsbereich mit den gewünschten Visualisierungen erstellen – eine Navigation ist dafür nicht notwendig.",
                "correct": False,
                "feedback": """× Nicht korrekt. Ohne einen entsprechenden Menüpunkt in der Seitenleiste gäbe es keine Möglichkeit, zu diesem neuen Inhaltsbereich zu navigieren."""
            },
            {
                "answer": "Lediglich den Titel im Header des Dashboards anpassen.",
                "correct": False,
                "feedback": """× Nicht korrekt. Der Header zeigt nur den übergeordneten Titel des gesamten Dashboards und hat keinen Bezug zu einzelnen, neu hinzugefügten Tabs."""
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
        "question": "Welche Diagrammart eignet sich in der Regel am besten, um eine Entwicklung über einen kontinuierlichen Zeitraum (z. B. mehrere Jahre) darzustellen?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Ein Liniendiagramm, da es quantitative Werte über eine chronologische Abfolge hinweg abbildet und Trends auf einen Blick erkennbar macht.",
                "correct": True,
                "feedback": """✓ Richtig! Liniendiagramme eignen sich besonders für kontinuierliche, zeitliche Verläufe: Eine steigende Linie zeigt intuitiv eine Zunahme, eine fallende Linie eine Abnahme. Dadurch werden Trends und Muster über die Zeit hinweg schnell sichtbar."""
            },
            {
                "answer": "Ein Kreisdiagramm, da es Anteile an einem Gesamtwert am übersichtlichsten darstellt.",
                "correct": False,
                "feedback": """× Nicht korrekt. Kreisdiagramme eignen sich, um Anteile zu einem einzelnen Zeitpunkt zu vergleichen, nicht um eine Entwicklung über die Zeit hinweg zu zeigen. Für zeitliche Verläufe ist ein Liniendiagramm besser geeignet."""
            },
            {
                "answer": "Eine Karte, da sie zeitliche Muster am klarsten visualisiert.",
                "correct": False,
                "feedback": """× Nicht korrekt. Karten sind für räumliche, nicht für zeitliche Informationen konzipiert. Sie zeigen, wo etwas passiert, nicht wann sich etwas über die Zeit entwickelt."""
            },
            {
                "answer": "Eine Tabelle, da sie präzisere Werte liefert als jede grafische Darstellung.",
                "correct": False,
                "feedback": """× Nicht korrekt. Auch wenn Tabellen exakte Einzelwerte zeigen, sind Trends und Muster über die Zeit darin deutlich schwerer zu erkennen als in einem Liniendiagramm, das den Verlauf visuell zusammenfasst."""
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
        "question": "Welche allgemeinen Zwecke erfüllen typische interaktive Elemente in einem Dashboard? Wählen Sie alle zutreffenden Aussagen.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Schieberegler ermöglichen es, einen Wertebereich (z. B. einen Zeitraum) frei einzugrenzen.",
                "correct": True,
                "feedback": """✓ Richtig! Schieberegler erlauben es Nutzer:innen, gezielt einen bestimmten Ausschnitt der Daten auszuwählen, statt immer den gesamten Datensatz betrachten zu müssen."""
            },
            {
                "answer": "Dropdown-Menüs erlauben die Auswahl einzelner oder mehrerer Kategorien zur Filterung der angezeigten Daten.",
                "correct": True,
                "feedback": """✓ Richtig! Dropdown-Menüs strukturieren die Auswahl aus einer Liste von Kategorien (z. B. Regionen oder Gruppen) und ermöglichen es, die Darstellung gezielt einzugrenzen."""
            },
            {
                "answer": "Info-Buttons liefern zusätzlichen Kontext oder Erklärungen, ohne die dargestellten Daten selbst zu verändern.",
                "correct": True,
                "feedback": """✓ Richtig! Anders als Filter verändern Info-Buttons keine Daten – sie unterstützen Nutzer:innen lediglich beim Verständnis einer Visualisierung durch zusätzliche Hintergrundinformationen."""
            },
            {
                "answer": "Interaktive Elemente verändern grundsätzlich automatisch auch alle anderen, unabhängigen Ansichten im Dashboard.",
                "correct": False,
                "feedback": """× Nicht korrekt. Interaktive Elemente wie Filter wirken sich in der Regel nur auf den Inhaltsbereich aus, in dem sie platziert sind. Andere, unabhängige Tabs bleiben von dieser Filterung unberührt."""
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
    title="Ordnen Sie die folgenden allgemeinen Bausteine eines Dashboards ihrer jeweiligen Funktion zu:",
    descriptions=[
        "Der sichtbare Bereich, der den übergeordneten Titel der gesamten Anwendung zeigt",
        "Die Navigationsleiste, über die zwischen verschiedenen Inhaltsbereichen gewechselt werden kann",
        "Der Hauptbereich, in dem die zum gewählten Menüpunkt passenden Inhalte angezeigt werden",
        "Ein Element, mit dem Nutzer:innen einen Wertebereich frei eingrenzen können"
    ],
    options=[
        "Header",
        "Sidebar",
        "Body / Inhaltsbereich",
        "Filterelement (z. B. Schieberegler)"
    ],
    correct_mapping={
        "Der sichtbare Bereich, der den übergeordneten Titel der gesamten Anwendung zeigt": "Header",
        "Die Navigationsleiste, über die zwischen verschiedenen Inhaltsbereichen gewechselt werden kann": "Sidebar",
        "Der Hauptbereich, in dem die zum gewählten Menüpunkt passenden Inhalte angezeigt werden": "Body / Inhaltsbereich",
        "Ein Element, mit dem Nutzer:innen einen Wertebereich frei eingrenzen können": "Filterelement (z. B. Schieberegler)"
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
        "question": "Damit ein neuer Menüpunkt in der Seitenleiste eines Dashboards beim Anklicken auch tatsächlich Inhalte zeigt, muss zusätzlich ein passender Inhaltsbereich angelegt werden.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Richtig",
                "correct": True,
                "feedback": """✓ Richtig! Menüpunkt und Inhaltsbereich gehören immer als Paar zusammen. Ein Menüpunkt in der Sidebar ist nur der 'Wegweiser' – ohne einen passend zugeordneten Inhaltsbereich bliebe die Seite nach dem Klick leer."""
            },
            {
                "answer": "Falsch",
                "correct": False,
                "feedback": """× Nicht korrekt. Die Aussage ist tatsächlich richtig: Ein Menüpunkt allein zeigt noch keine Inhalte an. Er muss stets mit einem entsprechenden Inhaltsbereich verknüpft sein, der festlegt, was beim Anklicken sichtbar wird."""
            }
        ]
    }
]
display_quiz(question5, colors=colors.jupyterquiz, max_width=1000)

question6 = [
    {
        "question": "Jedes Dashboard-Element muss zwingend interaktiv sein (z. B. über Filter), damit es für Nutzer:innen einen Mehrwert bietet.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Richtig",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards können sowohl statische als auch interaktive Elemente enthalten. Eine statische Übersichtsgrafik oder ein einführender Text auf einer Startseite kann ebenfalls wertvollen Nutzen bieten, ganz ohne Interaktivität."""
            },
            {
                "answer": "Falsch",
                "correct": True,
                "feedback": """✓ Richtig! Die Aussage ist falsch. Nicht jedes Element muss interaktiv sein – statische Darstellungen sind eine gültige und häufig sinnvolle Ergänzung, etwa für einen ersten Überblick, während interaktive Elemente vor allem dort sinnvoll sind, wo Nutzer:innen gezielt Teilbereiche der Daten erkunden möchten."""
            }
        ]
    }
]
display_quiz(question6, colors=colors.jupyterquiz, max_width=1000)

question7 = [
    {
        "question": "Ein Liniendiagramm ist grundsätzlich besser geeignet, um eine zeitliche Entwicklung darzustellen, als um Anteile verschiedener Kategorien an einem Gesamtwert zu einem einzelnen Zeitpunkt zu vergleichen.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Richtig",
                "correct": True,
                "feedback": """✓ Richtig! Liniendiagramme sind auf die Darstellung kontinuierlicher, chronologischer Verläufe spezialisiert. Für den Vergleich von Anteilen an einem Gesamtwert zu einem festen Zeitpunkt eignen sich andere Diagrammtypen (z. B. Kreis- oder Balkendiagramme) in der Regel besser."""
            },
            {
                "answer": "Falsch",
                "correct": False,
                "feedback": """× Nicht korrekt. Die Aussage ist richtig: Liniendiagramme sind für zeitliche Trends optimiert, während Anteilsvergleiche zu einem festen Zeitpunkt meist klarer mit anderen Diagrammtypen wie Kreis- oder Balkendiagrammen dargestellt werden."""
            }
        ]
    }
]
display_quiz(question7, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 6

**Frage:** Stellen Sie sich vor, Sie möchten für ein eigenes Projekt (z. B. zu einem anderen Thema als Baumbewässerung) ein einfaches Dashboard mit den zwei Komponenten **Startseite** und **Zeitverlauf** planen.

1. Welche grundlegenden Struktur-Bausteine benötigen Sie dafür, damit beide Komponenten sichtbar und nutzbar sind?
2. Welche Art von Fragestellung könnte Ihr Zeitverlauf-Tab sinnvollerweise beantworten?

```{code-cell} ipython3
:tags: [remove-input]
import sys
sys.path.append("../quadriga")
from assessment import create_answer_box

create_answer_box('dashboard-aufbau-1')
```

````{admonition} Reflexionshinweise
:class: solution, dropdown

**1. Notwendige Struktur-Bausteine:**

- Ein **Header** mit dem Titel des eigenen Dashboards.
- Eine **Sidebar** mit mindestens zwei Menüpunkten: einem für die Startseite und einem für den Zeitverlauf.
- Für jeden Menüpunkt einen passenden **Inhaltsbereich im Body**: Für die Startseite z. B. eine kurze Einführung und zentrale Kennzahlen, für den Zeitverlauf ein Diagramm (z. B. ein Liniendiagramm) sowie ggf. Filtermöglichkeiten wie ein Schieberegler oder Dropdown.
- Ohne diese Paarung aus Menüpunkt und Inhaltsbereich für beide Komponenten bliebe eine der beiden Seiten beim Anklicken leer.

**2. Mögliche Fragestellungen für einen Zeitverlauf-Tab:**

Ein Zeitverlauf eignet sich immer dann, wenn eine Entwicklung über die Zeit im Mittelpunkt steht, zum Beispiel:

- Wie hat sich eine Kennzahl (z. B. Anzahl an Ereignissen, verbrauchte Ressourcen, Teilnehmendenzahlen) über mehrere Jahre oder Monate entwickelt?
- Gibt es saisonale Muster, Spitzenwerte oder rückläufige Trends?
- Lassen sich bestimmte Gruppen (z. B. Regionen, Kategorien) im zeitlichen Verlauf miteinander vergleichen?

Wichtig ist, dass sich die gewählte Fragestellung auf eine chronologische, kontinuierliche Entwicklung bezieht – genau dafür ist ein Liniendiagramm besonders geeignet.
````