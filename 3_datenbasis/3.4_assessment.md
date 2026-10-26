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

# 🏆Selbsttest: Datenbasis

````{admonition} Hinweis
:class: hinweis
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
        "question": "Sie möchten für ein Dashboard zwei Datensätze nutzen, die thematisch zusammengehören, aber aus unterschiedlichen Quellen stammen (z. B. Stammdaten aus der einen und Ereignis- oder Messwerte aus der anderen Quelle). Warum reicht es meist nicht aus, beide Datensätze einfach unabhängig voneinander zu laden?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Weil beide Datensätze getrennt entstanden sind und erst über ein gemeinsames Merkmal (z. B. eine eindeutige ID) einander zugeordnet werden müssen, um sinnvoll gemeinsam ausgewertet werden zu können.",
                "correct": True,
                "feedback": """✓ Richtig! Wenn zwei Datensätze aus unterschiedlichen Quellen stammen, 'wissen' sie zunächst nichts voneinander. Damit z. B. eine Messung wirklich dem passenden Objekt zugeordnet wird, benötigt man ein gemeinsames Merkmal, über das beide Datensätze verknüpft werden können – ähnlich wie eine Kundennummer eine Bestellung dem richtigen Kunden zuordnet. Dieses Prinzip gilt unabhängig davon, um welche konkreten Daten es sich handelt."""
            },
            {
                "answer": "Weil geladene Daten grundsätzlich nach einer bestimmten Zeit automatisch gelöscht werden.",
                "correct": False,
                "feedback": """× Nicht korrekt. Es gibt keine automatische Löschung geladener Daten. Der eigentliche Grund für die Weiterverarbeitung liegt in der notwendigen Verknüpfung der Informationen, nicht in einer zeitlichen Begrenzung."""
            },
            {
                "answer": "Weil Dashboards grundsätzlich nur eine einzige Datenquelle gleichzeitig verarbeiten können.",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards können durchaus mehrere Datenquellen nutzen. Entscheidend ist, dass diese vorher sinnvoll miteinander verknüpft wurden, damit zusammengehörige Informationen auch als solche erkennbar sind."""
            },
            {
                "answer": "Weil das gleichzeitige Laden mehrerer Datensätze technisch nicht möglich ist.",
                "correct": False,
                "feedback": """× Nicht korrekt. Mehrere Datensätze können problemlos parallel geladen werden. Die eigentliche Herausforderung liegt darin, sie inhaltlich richtig miteinander zu verknüpfen, nicht im technischen Laden selbst."""
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
        "question": "Welche der folgenden Tätigkeiten gehören typischerweise dazu, wenn man geladene Rohdaten für ein Dashboard 'verändert' bzw. aufbereitet? Wählen Sie alle zutreffenden Aussagen.",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Einträge mit fehlenden oder eindeutig fehlerhaften Angaben (z. B. leere Pflichtfelder) werden entfernt.",
                "correct": True,
                "feedback": """✓ Richtig! Unvollständige oder offensichtlich fehlerhafte Einträge können spätere Auswertungen verfälschen oder zu Darstellungsfehlern führen. Das Entfernen oder Korrigieren solcher Einträge ist ein zentraler Bestandteil der Datenaufbereitung – unabhängig vom konkreten Anwendungsfall."""
            },
            {
                "answer": "Mehrere thematisch zusammengehörige Teildatensätze werden zu einer gemeinsamen Tabelle zusammengeführt.",
                "correct": True,
                "feedback": """✓ Richtig! Häufig liegen zusammengehörige Informationen zunächst getrennt vor (z. B. weil sie aus unterschiedlichen Erhebungen stammen). Das Zusammenführen zu einer gemeinsamen Tabelle ist ein typischer Aufbereitungsschritt vor der Weiterverarbeitung."""
            },
            {
                "answer": "Fehlende Angaben werden, wo möglich, anhand anderer vorhandener Informationen sinnvoll ergänzt.",
                "correct": True,
                "feedback": """✓ Richtig! Wenn eine Angabe fehlt, sich aber aus anderen vorhandenen Informationen ableiten lässt (z. B. eine fehlende Kategorie anhand verwandter Merkmale), kann diese Lücke oft sinnvoll geschlossen werden, statt den Eintrag ganz zu verwerfen."""
            },
            {
                "answer": "Die Sprache der Daten wird grundsätzlich in eine andere Sprache übersetzt.",
                "correct": False,
                "feedback": """× Nicht korrekt. Eine Übersetzung gehört nicht zu den typischen Aufbereitungsschritten. Die Veränderungen dienen dazu, Daten zu bereinigen, zu verknüpfen und nutzbar zu machen – nicht dazu, ihre Sprache zu ändern."""
            },
            {
                "answer": "Der Datensatz wird am Ende auf die Informationen reduziert, die für die geplante Auswertung tatsächlich gebraucht werden.",
                "correct": True,
                "feedback": """✓ Richtig! Um eine Anwendung schlank und performant zu halten, wird die finale Tabelle meist auf die wirklich notwendigen Spalten reduziert, statt alle ursprünglich vorhandenen Informationen mitzuführen."""
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
        "question": "Warum sollten offensichtlich unplausible Werte (z. B. ein Datum in der Zukunft oder eine negative Menge, wo das inhaltlich keinen Sinn ergibt) vor der weiteren Nutzung aus einem Datensatz entfernt oder korrigiert werden?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Damit spätere Auswertungen nicht durch offensichtlich fehlerhafte Angaben verfälscht werden.",
                "correct": True,
                "feedback": """✓ Richtig! Unplausible Werte können nicht korrekt sein und würden jede Auswertung verzerren, die sich auf diese Angabe stützt. Solche offensichtlichen Fehler werden deshalb vorab identifiziert und behandelt, damit die Datenbasis verlässlich bleibt – ein Prinzip, das für jede Art von Daten gilt."""
            },
            {
                "answer": "Damit der Datensatz eine gesetzlich vorgeschriebene Höchstanzahl an Zeilen nicht überschreitet.",
                "correct": False,
                "feedback": """× Nicht korrekt. Es gibt keine gesetzliche Zeilenbegrenzung. Der Grund für das Entfernen liegt in der inhaltlichen Plausibilität der Daten, nicht in einer Mengenbeschränkung."""
            },
            {
                "answer": "Damit alle Einträge im Datensatz denselben Wert erhalten.",
                "correct": False,
                "feedback": """× Nicht korrekt. Ziel ist nicht die Vereinheitlichung der Werte, sondern das Entfernen oder Korrigieren von Einträgen, deren Angaben inhaltlich unmöglich bzw. fehlerhaft sind."""
            },
            {
                "answer": "Damit die Datei schneller heruntergeladen werden kann.",
                "correct": False,
                "feedback": """× Nicht korrekt. Downloadgeschwindigkeit spielt hierbei keine Rolle. Es geht ausschließlich darum, die inhaltliche Qualität und Verlässlichkeit der Daten sicherzustellen."""
            }
        ]
    }
]
display_quiz(question3, colors=colors.jupyterquiz, max_width=1000)
```

## Frage 4

```{code-cell} ipython3
:tags: [remove-input]
from jupyterquiz import display_quiz

import sys
sys.path.append("..")
from quadriga import colors

question4 = [
    {
        "question": "Welche Aussage beschreibt den Unterschied zwischen dem Laden und dem Verändern (Aufbereiten) von Daten am treffendsten?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Laden bedeutet, die Rohdaten aus einer oder mehreren externen Quellen verfügbar zu machen. Verändern bedeutet, diese Rohdaten anschließend zu bereinigen, zu verknüpfen und in eine nutzbare Form zu bringen.",
                "correct": True,
                "feedback": """✓ Richtig! Das gilt für jedes Dashboard-Projekt: Zunächst müssen die relevanten Datenquellen geladen werden. Erst danach folgt ein eigenständiger zweiter Schritt, in dem diese Rohdaten bereinigt, zusammengeführt und auf die relevanten Informationen reduziert werden, bevor sie tatsächlich genutzt werden können."""
            },
            {
                "answer": "Laden und Verändern sind im Grunde derselbe Vorgang und finden gleichzeitig statt.",
                "correct": False,
                "feedback": """× Nicht korrekt. Es handelt sich um zwei aufeinanderfolgende Schritte: Erst müssen die Daten überhaupt verfügbar sein (Laden), bevor sinnvoll etwas an ihnen verändert werden kann (Bereinigen, Verknüpfen)."""
            },
            {
                "answer": "Verändern findet grundsätzlich statt, bevor die Daten geladen werden.",
                "correct": False,
                "feedback": """× Nicht korrekt. Die Reihenfolge ist umgekehrt: Ohne geladene Daten gibt es nichts, das verändert werden könnte. Das Laden ist daher immer der erste Schritt."""
            },
            {
                "answer": "Laden betrifft nur Textdateien, Verändern nur Geodaten.",
                "correct": False,
                "feedback": """× Nicht korrekt. Beide Schritte – Laden und Verändern – betreffen grundsätzlich jede Art von Daten, egal ob es sich um Tabellen, Geodaten oder andere Formate handelt."""
            }
        ]
    }
]
display_quiz(question4, colors=colors.jupyterquiz, max_width=1000)
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
        "question": "Ein Kollege möchte einen neu heruntergeladenen Datensatz direkt und ohne weitere Bearbeitung in ein Dashboard einbinden. Welches Problem tritt dabei am ehesten auf?",
        "type": "multiple_choice",
        "answers": [
            {
                "answer": "Einige Einträge könnten fehlende, doppelte oder unplausible Werte enthalten, die eine korrekte Darstellung oder Auswertung im Dashboard verhindern.",
                "correct": True,
                "feedback": """✓ Richtig! Rohdaten enthalten so gut wie immer fehlerhafte oder unvollständige Einträge – etwa fehlende Werte, doppelte Datensätze oder unplausible Angaben. Ohne vorherige Bereinigung würden solche Einträge die Darstellung und Auswertung im Dashboard verfälschen oder sogar zu Fehlern führen. Dieses Risiko besteht unabhängig davon, um welchen konkreten Datensatz es sich handelt."""
            },
            {
                "answer": "Das Dashboard würde die Rohdaten automatisch und ohne Probleme korrekt darstellen, da moderne Software Fehler selbst erkennt und behebt.",
                "correct": False,
                "feedback": """× Nicht korrekt. Dashboards zeigen die Daten grundsätzlich so an, wie sie vorliegen. Fehlerhafte oder unvollständige Rohdaten müssen daher aktiv bereinigt werden, bevor sie zuverlässig genutzt werden können."""
            },
            {
                "answer": "Es gäbe kein Problem, da neu heruntergeladene Rohdaten grundsätzlich bereits vollständig und fehlerfrei sind.",
                "correct": False,
                "feedback": """× Nicht korrekt. Rohdaten aus externen Quellen enthalten in der Praxis so gut wie immer Lücken oder Unstimmigkeiten. Genau deshalb ist die Aufbereitung ein notwendiger Schritt, bevor Daten in ein Dashboard einfließen."""
            },
            {
                "answer": "Das Dashboard würde in diesem Fall grundsätzlich gar keine Daten anzeigen können.",
                "correct": False,
                "feedback": """× Nicht korrekt. Die Daten würden in der Regel angezeigt, aber möglicherweise fehlerhaft oder unvollständig – etwa mit fehlenden Einträgen oder unplausiblen Werten. Das eigentliche Problem liegt in der Datenqualität, nicht in einer vollständigen Anzeigeverweigerung."""
            }
        ]
    }
]
display_quiz(question5, colors=colors.jupyterquiz, max_width=1000)
```
