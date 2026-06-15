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

Die Fallstudie demonstriert, dass Daten nicht neutral sind. Je nach Operationalisierung, ob über die absolute Wassermenge oder die relative Intensität („Liter pro Baum“), fällt die Antwort auf die Leitfrage unterschiedlich aus. Das Zusammenspiel verschiedener Visualisierungen bricht ein eindimensionales Bild auf und macht die multidimensionale Natur des bürgerschaftlichen Engagements sichtbar.

## Gelerntes
Mit dem Durchlaufen dieser Fallstudie wurden zentrale Datenkompetenzen erworben:

- Operationalisierung: Die Fähigkeit, ein abstraktes Konzept wie „Bürgerengagement“ in messbare Kennzahlen zu übersetzen und die Auswirkungen dieser Wahl auf das Analyseergebnis kritisch zu hinterfragen.
- Datenverarbeitung: Das Einlesen, Bereinigen und Zusammenführen heterogener Datensätze (WFS, CSV, GeoJSON) sowie die Durchführung räumlicher Verschneidungen („Spatial Joins“) in R.
- Visualisierungskompetenz: Der Aufbau eines Dashboards mit R Shiny sowie die Erstellung interaktiver Karten (Leaflet), Balkendiagramme (ggplot2) und Liniendiagramme (Plotly) zur Kommunikation von Forschungsergebnissen.
- Kritische Reflexion: Das Erkennen von Verzerrungen in Darstellungen, wie etwa dem „Area Bias“ bei Choroplethenkarten.


## Reflexion

Die Leitfrage konnte gemäß der vorgenommenen Operationalisierung beantwortet werden. Die eingeholten Daten haben es nicht nur ermöglicht, aufzuzeigen in welchen Berliner Bezirken wie viele Bäume gegossen werden, sondern auch wie intensiv und welche Art von Bäumen gegossen wurden. Darüber hinaus konnten die Ergebnisse in Relation mit dem gesamten Baumbestand gebracht werden.  
Für die vorliegende Fallstudie war diese Herangehensweise ausreichend. Für eine tiefere wissenschaftliche Analyse sollten weitere Faktoren beachtet werden:

**Leitfrage**  
Die Leitfrage (**Wo lassen sich die höchsten Ausprägungen des Engagements von Bürger:innen bei der Bewässerung städtischer Bäume in Berlin feststellen?**) zielt auf räumliche Einheiten (Berliner Bezirke) ab, ohne diese in ihrer heterogenen städtischen Beschaffenheit zu beschreiben und zu unterscheiden. Weder die Bevölkerungzahl, noch die Bevölkerungsdichte, die Baumdichte, das Verhältnis von Bäumen zu Einwohner:innen oder die Nähe zu Gewässern etc. wurden einkalkuliert. Auch Wetter-, Klima- oder Emissionsdaten haben keine Beachtung gefunden.
Dadurch ist es kaum möglich, die erhaltenen Ergebnisse einzuordnen oder Handlungsoptionen abzuleiten.

**Operationalisierung**  
Die gewählte Operationalisierung ist wie jede wissenschafliche Operationalisierung diskutabel. Das Engagement der Bürger:innen hätte auch als Menge gegossenen Wassers anstelle der Anzahl gegossener Bäume definiert werden können. Daraus lässt sich die Frage ableiten, wie robust die hier gemachten Befunde gegenüber anderen Operationalisierungen ist.

**Datengrundlage**
Über die Grenzen der Aussage aus den Daten, also was diese sagen können und was nicht, sollte grundsätzlich nachgedacht werden. Die Daten für diese Fallstudie wurden in Bezug auf die Leitfrage und die Operationalisierung gewählt. Zudem wurden bewusst Daten eines bestehenden Projektes (Gieß den Kiez) nachgenutzt. Die Daten hätte aber auch aus anderen Quellen bezogen werden können. In der vorliegenden Fallstudie wurden die Daten nicht auf ihre Qualität überprüft, sodass zumindest theoretisch Unsicherheitsfaktoren auftreten könnten: Sind alle Bäume in den Ausgangsdaten vorhanden? Wir wird die Menge gegossenen Wassers bestimmt? Wie reliabel ist eine Selbstangabe zur Bewässerung durch die Bürger:innen?

**Untersuchung**
Diese Fallstudie beantwortet die Leitfrage mittels explorativer Analyse, d. h. der Erkennung von Mustern in Visualisierungen. Dieser Ansatz dient einer Sichtung des Datenmaterials und einem Erkennen von Trends. Für einen tiefergehende Analyse sollte eine andere Methodik gewählt werden.

**Visualisierungen**
Sowohl die Art der gewählten Visualisierung als auch die Skalierung der Achsen, die Farbwahl und die Messgrö0en beeinflussen die Lesbarkeit, das Verständnis und die Interpretation von Darstellungen. Vor allem in Bezug auf Datenvisualisierungen sollten sich sowohl Gestaltende als auch Nutzende der Möglichkeit von Verzerrungen oder Missinterpretationen bewusst sein.

**Dashboard**
Das Dashboard hat aufgrund des Fallstudien-Charakters dieser Lerneinheit technische Grenzen. So bedarf beispielsweise die aktive Einbindung von Nutzenden (z. B. durch eigenes Eintragen gegossener Wassermengen, wie sie von der Plattform Gieß den Kiez erfolgreich implementiert ist) eines interaktiven Dashboards, das die Möglichkeiten dieses Lernszenarios übersteigt.
