---
lang: de-DE
---
(reflexion)=
# Zusammenfassung und Reflexion
## Zusammenfassung

In dieser Fallstudie wurde im Rahmen einer Persona-Story um den Forscher Dr. Amir Weber ein Dashboard gebaut. Im Mittelpunkt stand dabei die Leitfrage:
**Wo lassen sich die höchsten Ausprägungen des Engagements von Bürger:innen bei der Bewässerung städtischer Bäume in Berlin feststellen?** Dabei wurde deutlich, dass die Antwort maßgeblich von der gewählten Operationalisierung abhängt.

**Vom Absoluten zum Relativen:** Ein erster Blick auf die absoluten Zahlen der Startseite sah den Bezirk Mitte an der Spitze. Da dies jedoch die unterschiedliche Größe der Bezirke ignoriert, ermöglichte erst die Normalisierung einen fairen Vergleich. Hier verschob sich das Ergebnis: Friedrichshain-Kreuzberg weist den höchsten prozentualen Anteil bewässerter Bäume auf.

**Masse vs. Intensität:** Ein weiterer Perspektivwechsel erfolgte durch die Analyse der Wassermengen. Während der Bezirk Mitte bei der Gesamtmenge (m³) führt, offenbarte die Kennzahl „Liter pro Baum“, dass die Pflegeintensität in Friedrichshain-Kreuzberg am höchsten ist. Die Wahl der Messgröße (Baumanzahl vs. Volumen) formt somit aktiv das Narrativ der Daten.


## Gelerntes
Mit dem Durchlaufen dieser Fallstudie wurden zentrale Datenkompetenzen erworben:

- Operationalisierung: Die Fähigkeit, ein abstraktes Konzept wie „Bürgerengagement“ in messbare Kennzahlen zu übersetzen und die Auswirkungen dieser Wahl auf das Analyseergebnis kritisch zu hinterfragen.
- Datenverarbeitung: Das Einlesen, Bereinigen und Zusammenführen heterogener Datensätze (WFS, CSV, GeoJSON) sowie die Durchführung räumlicher Verschneidungen („Spatial Joins“) in R.
- Visualisierungskompetenz: Der Aufbau eines Dashboards mit R Shiny sowie die Erstellung interaktiver Karten (Leaflet), Balkendiagramme (ggplot2) und Liniendiagramme (Plotly) zur Kommunikation von Forschungsergebnissen.
- Kritische Reflexion: Das Erkennen von Verzerrungen in Darstellungen, wie etwa dem „Area Bias“ bei Choroplethenkarten.


## Reflexion

Die Leitfrage konnte gemäß der vorgenommenen Operationalisierung beantwortet werden. Die Analyse hat jedoch verdeutlicht, dass die Ergebnisse keine statischen Fakten sind, sondern maßgeblich durch die methodischen Entscheidungen während des Forschungsprozesses geformt werden. Für eine vertiefte Analyse sollten zusätzliche Einflussfaktoren berücksichtigt werden:

**Leitfrage und räumliche Kontextfaktoren**  
Die Fallstudie betrachtete die Berliner Bezirke als räumliche Einheiten, ohne deren heterogene städtische Beschaffenheit zu berücksichtigen. Faktoren wie Bevölkerungszahl und -dichte, Baumdichte, Verhältnis von Bäumen zu Einwohner:innen, Nähe zu Gewässern sowie Wetter-, Klima- und Emissionsdaten blieben unbeachtet. Dadurch lassen sich die Ergebnisse kaum einordnen oder Handlungsoptionen ableiten.

**Operationalisierung als Narrativ**  
Die gewählte Operationalisierung ist wie jede wissenschafliche Operationalisierung diskutabel. 
Ein zentraler Befund der Fallstudie ist somit, dass die Wahl der Messgröße das „Narrativ“ der Daten bestimmt. Während die absolute Anzahl gegossener Bäume den Bezirk Mitte als Spitzenreiter ausweist, verschiebt sich das Bild bei einer relativen Betrachtung (Anteil am Gesamtbestand) oder der Gießintensität („Liter pro Baum“) zugunsten von Friedrichshain-Kreuzberg. Dies belegt das Prinzip, dass Daten nicht neutral sind und ihre Aufbereitung die Interpretation des Engagements steuert.

**Datengrundlage und Reliabilität**
Die Nachnutzung der Daten von Gieß den Kiez ermöglichte eine fundierte explorative Analyse, birgt jedoch Unsicherheiten bezüglich der Datenqualität: Da es sich um Selbstangaben der Bürger:innen handelt, bleibt die Reliabilität der Gießmengen schwer überprüfbar. Zudem fehlen in der Fallstudie Kontextdaten wie Wetter- oder Bodenfeuchtewerte, um das Engagement dem tatsächlichen ökologischen Bedarf gegenüberzustellen.

**Methodik der explorativen Untersuchung**
Diese Fallstudie beantwortet die Leitfrage mittels explorativer Analyse, d. h. der Erkennung von Mustern in Visualisierungen. Dieser Ansatz dient einer Sichtung des Datenmaterials und einem Erkennen von Trends. Für einen tiefergehende Analyse sollte eine andere Methodik gewählt werden.

**Wirkung von Visualisierungen**
Sowohl die Art der gewählten Visualisierung als auch die Skalierung der Achsen, die Farbwahl und die Messgrö0en beeinflussen die Lesbarkeit, das Verständnis und die Interpretation von Darstellungen. Vor allem in Bezug auf Datenvisualisierungen sollten sich sowohl Gestaltende als auch Nutzende der Möglichkeit von Verzerrungen oder Missinterpretationen bewusst sein.

**Technische Grenzen des Dashboards**
Das erstellte Dashboard bietet eine interaktive Informationsgrundlage, ist jedoch aufgrund des Lernszenarios technisch begrenzt. Eine aktive Einbindung von Nutzer:innen, die Daten direkt im System pflegen können, wäre eine logische Erweiterung, die jedoch die Möglichkeiten dieser Fallstudie übersteigt.

Die Fallstudie demonstriert, dass Daten nicht neutral sind. Je nach Operationalisierung, ob über die absolute Wassermenge oder die relative Intensität („Liter pro Baum“), fällt die Antwort auf die Leitfrage unterschiedlich aus. Das Zusammenspiel verschiedener Visualisierungen bricht ein eindimensionales Bild auf und macht die multidimensionale Natur des bürgerschaftlichen Engagements sichtbar.
