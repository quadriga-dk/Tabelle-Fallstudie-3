---
lang: de-DE
---

(vergleich)=
# Vergleich von Visualisierungstools


```{admonition} Story
:class: story
Nachdem Amir Weber sich über die Grundlagen der Visualisierung und das Bauen von Dashboards informiert hat, fragt er sich, welches Tool er zum Bauen eines Dashboards verwenden soll. Dazu sieht er sich mehrere Optionen an.
```


**Weshalb ist ein Vergleich zwischen anderen Visualisierungswerkzeugen sinnvoll ist:**

Der Vergleich zwischen R Shiny und anderen Visualisierungswerkzeugen wie Python Dash, Power BI oder Tableau ist für datengetriebene Projekte besonders relevant, da jedes dieser Tools unterschiedliche Stärken, Funktionalitäten und Zielgruppen adressiert. Die Auswahl eines geeigneten Visualisierungstools hängt maßgeblich von den konkreten Zielen, Anforderungen und Rahmenbedingungen eines Projekts ab – ebenso wie von den technischen Vorkenntnissen und persönlichen Präferenzen der Nutzer:innen. Während Power BI und Tableau häufig im unternehmerischen Umfeld zum Einsatz kommen, werden R Shiny und Python-basierte Lösungen vor allem im wissenschaftlichen und analytischen Kontext verwendet. Als Verwaltungsmitarbeiter:in oder im Management benötigen Sie in der Regel zügig erstellte, standardisierte Berichte und Dashboards zur Überwachung von KPIs. Programmierkenntnisse sind oft nicht vorhanden, weshalb eine intuitive Bedienung per Drag-and-Drop und eine nahtlose Integration in Office-Umgebungen im Vordergrund stehen. <span class="rot">Quelle finden</span>

Im Folgenden werden die jeweiligen Werkzeuge und ihre Besonderheiten näher erläutert und miteinander verglichen.

## Erläuterung der ausgewählten Visualisierungswerkzeugen

**<u>R Shiny:</u>**  R Shiny ist ein Open Source Webanwendungs-Framework für R, welches von RStudio entwickelt worden ist. Das Shiny Framework ermöglicht es R-Nutzern, ihre R-Analysen und Visualisierungen um webbasierte grafische Benutzeroberflächen (GUIs) funktional zu erweitern. [@walker_tools_2016]

Der Hauptzweck von Shiny ist es, R-Analysen direkt in besgate GUIs zu übersetzen, ohne dass sie dafür die Programmiersprache wechseln müssen. Das Ziel ist es, die Kluft zwischen Datenanalyse und Endanwender zu schließen, sodass auch Personen ohne Programmierkenntnisse mit den Ergebnissen interagieren können. [@walker_tools_2016]

**<u>Python Dash:</u>** Python Dash ist ein leistungsfähiges Open-Source-Framework, welches von Plotly für Python Entwickler entwickelt worden ist. Dash ermöglicht es, vollständig ausgestaltete analytische Datenanwendungen und interaktive Dashboards zu kreieren, ohne Kenntnisse in Frontend-Technologien wie HTML, CSS oder JavaScript. Gerade diese technische Abstraktion macht einen wesentlichen Vorteil von Dash aus. [@dabbas_interactive_2021]

**<u>Power BI:</u>** Das von Microsoft entwickelte Power BI ist ein Analysetool für Unternehmen, welches die Analyse von Daten und das Teilen von Erkenntnissen über Berichte und Dashboards ermöglicht. Entwickelt wurde Power BI mit dem Ziel, Business Intelligence und Datenanalyse zu vereinfachen, indem es Einzelpersonen und Organisationen ermöglicht, mit minimalem Zeit- und Arbeitsaufwand Daten beizutragen und somit Berichte zu erstellen oder automatisch generieren (über die Quick Insights Funktion) zu lassen. Zusammengefasst werden können diese Berichte in Dashboards, welche anschließend freigegeben werden können.[@krishnan_research_nodate]

**<u>Tableau:</u>** Bei Tableau handelt es sich um eine Software für die Erstellung von Visualisierungen. Entwickelt wurde Tableau von Tableau Inc. als Visualisierungstool für die Erstellung oder Programmierung von Dashboards im Business-Intelligence-Bereich. [@wood_diabetes_2019] [@vasundhara_data_nodate] Die Besonderheit an Tableau ist, dass die Verwendung durch die GUI mit drag and drop relativ unkompliziert ist.[@vasundhara_data_nodate]

## Direkter Vergleich nach ausgewählten Kriterien

**Lizenzmodell und Einsatzszenarien**
**Dash** und **Shiny** sind beide Open Scource Anwendungen können diese Frameworks kostenlos verwendet werden. [@dabbas_interactive_2021] Im Gegensatz dazu setzen **Power BI** und **Tableau** für die vollständigen Versionen auf kommerzielle Lizenzmodelle. Power BI und Tableau bieten beide zusätzlich auch noch eine kostenfreie Version an, die allerdings nicht alle Funktionen bereitstellt, die auch die kostenpflichtige Version bereitstellt, besonders für kleine und mittlere Unternehmen stellt die kostenlose Option über ausreichende Funktionen und Features zur Verfügung. [@krishnan_research_nodate]

**Programmiersprache, Zielgruppe, Bedienbarkeit, Erweiterbarkeit**
**R Shiny** ist vollständig auf der Programmiersprache R aufgebaut und eignet sich besonders für Nutzer: innen aus Wissenschaft und Datenanalyse. [@khedr_interactive_2021] Diese Verbundenheit mit dem R Ökosystem ist für Shiny enormer Vorteil, da Shiny dadurch leicht erweiterbar ist,diese verwenden zu können, setzt aber Vorkenntnisse in der Programmiersprache R voraus. [@walker_tools_2016]

**Python Dash** hingegen basiert auf der Programmiersprache Python und wird häufig in den Bereichen Data Science und Analytics verwendet und richtet sich an Nutzer: innen, die bereits mit Datenanalyse-Tools wie pandas oder scikit-learn, die auf Python basieren auskennen. [@odonnell_interaktive_2020] Der Vorteil in Dash liegt in der Verwendung der modernen Frontend-Technologie mit React, zudem wird dem Nutzer vollständige Freiheit über die Gestaltung gegeben mit dem Code. Wie auch bei R Shiny ist es verbundenheit mit dem Python Ökosystem für Dash vom Vorteil da auch hier die Anwendung leicht erweiterbar ist. [@dabbas_interactive_2021]

Auf Grund dessen dass **Power BI** und **Tableau** dafür entwickelt wurden um im Bereich Business-Intelligence und Unternehmenssektor angewendet zu werden wird größtenteils auf  herkömmliche Programmierung verzichtet, obwohl Tableau mit R verbunden werden kann, um die Darstellung besser auf die Erwartungen des Anwenders anpassen zu können. Anstelle von Programmierung nutzen beide Tools GUI’s mit einer Drag-and-Drop-Funktionalität. [@odonnell_interaktive_2020] [@vasundhara_data_nodate]In Bezug auf Erweiterbarkeit bieten Tableau und Power BI eher schlechtere Erweiterbarkeiten, da die Plugin Optionen niedrig sind. 

**Architektur**

```{figure} ../assets/R_Shiny_Aufbau.png
---
name: R_Shiny_Aufbau
alt: Ein Screenshot, der zeigt, wie man ein R Shiny Anwendung aufbauen kann.
width: 300px
---
R Shiny Aufbau (Quelle: <a href="https://www.inwt-statistics.com/blog/best-practice-development-of-robust-shiny-dashboards-as-r-packages" target="_blank">Best Practice: Shiny Dashboards</a> )
``` 

Eine **Shiny</u> Anwendung besteht aus einer serverseitigen Logik und einer Benutzeroberfläche (UI). Beide Komponenten werden häufig in einer gemeinsamen Datei (app.R) implementiert. Eine Trennung ist jedoch möglich, indem Server- und UI-Teil in die Dateien server.R beziehungsweise ui.R ausgelagert und anschließend über app.R integriert werden. [@walker_tools_2016]

**Dash** und **Tableau** basieren ebenfalls auf ähnlichen Client-Server-Architekturen.

Die Architektur von **Power BI** hingegen ist cloud-zentriert und umfasst mehrere Module. Eine cloud-zentrierte Architektur bezeichnet ein Systemdesign, bei dem die wesentlichen Prozesse der Datenverwaltung, Bereitstellung und Kollaboration in einer vernetzten Online-Infrastruktur stattfinden. Im Fall von **Power BI** dient die lokale Anwendung (**Power BI Desktop**) primär als Entwicklungsumgebung für die Datenmodellierung und das Berichtsdesign. Die zentrale Logik der Distribution und Nutzerinteraktion ist hingegen in den **Power BI Service** ausgelagert, der als Cloud-Plattform auf der Microsoft-Azure-Infrastruktur basiert. Diese Infrastruktur unterteilt sich in ein Front End Cluster zur Authentifizierung und ein Back End Cluster, welches die Datenverarbeitung und Visualisierung übernimmt. Durch den Einsatz eines **Power BI Gateways** wird zudem eine hybride Architektur ermöglicht, die lokale Datenquellen sicher mit der Cloud-Umgebung verbindet.[@arkharov_power_2024]

```{figure} ../assets/PowerBI_Aufbau.png
---
name: Power BI Aufbau 
alt: Ein Screenshot, der zeigt, wie man eine Power BI Anwendung aufbauen kann.
width: 300px
---
Power BI Aufbau (Quelle: <a href="https://blog.coupler.io/power-bi-architecture/" target="_blank">Power BI Architecture: a Complete Guide to Mastering the Platforms</a> )
``` 

**Interaktivität und Visualisierungstiefe**

In Bezug auf Interaktivität bieten **Shiny** und **Dash** das höchste Maß an Flexibilität, da die beiden auf einem reaktiven Programmiermodell basieren. In Shiny Anwendungen können Benutzer aktiv in den Analyseprozess eingebunden werden, anhand von Slidern die erlauben die Daten zum Beispiel für einen Bestimmten Zeitraum zu analysieren, Dropdowns oder Karten mit den interagiert werden kann, durch diese interaktionsmöglichkeiten wird die Visualisierung bei jeder Eingabe serverseitig aktualisiert. Dash regelt das auf eine ähnliche Art und Weise, durch sogenannte Callback- Funktionen werden UI- Elemente mit Diagrammen verknüpft, was explorative Datenanalyse ermöglicht. [@dabbas_interactive_2021]

Auch **Power BI** und **Tableau** bieten Interaktivität, dies jedoch innerhalb ihrer Benutzeroberflächen.  Standardmäßig sind Filter, Drilldowns und Highlighting-Funktionen vorhanden. [@walker_tools_2016] Im Vergleich zu Shiny und Dash ist die Interaktivität Tiefe jedoch begrenzt, da es schwieriger und komplexer ist, benutzerdefinierte Logiken umzusetzen. 

**Einbindung externer Daten**

**R Shiny** ist extrem flexibel im Bereich der Datenintegration, da es auch hier von den Vorteilen der Anbindung des R-Ökosystems profitiert. Dies ermöglicht es R Nutzern, mit einer Vielzahl von Datenquellen zu arbeiten, darunter CSV-, Excel- und JSON-Dateien, relationale Datenbanken. [@attali_shiny_2020] 

**Python Dash** ist vergleichbar in der Flexibilität der Datenverbindung mit Shiny. Dash profitiert genauso wie Shiny vom R-Ökosystem vom Python-Ökosystem deshalb lassen sich auch hier zahlreiche Datenquellen einbinden, wie zum Beispiel lokale Dateien, SQL- oder NoSQL-Datenbanken, REST-APIs oder Cloud-basierte Speicherlösungen. [@noauthor_managing_nodate]

**Power BI** bietet eine umfangreiche Anzahl an Datenkonnektoren, die eine unkomplizierte Verbindung zu verschiedenen Datenquellen ermöglichen. Hierzu gehören unter anderem Excel, CSV-Dateien, relationale Datenbanken wie SQL Server, Oracle oder MySQL sowie Cloud-Dienste wie Azure, Salesforce oder Google Analytics. [@davidiseminger_data_nodate] Es ermöglicht zusätzlich die Integration von ETL-Prozess (Extract, Transform, Load) zum Datenbereinigen. [@odonnell_interaktive_2020]

**Tableau**  erlaubt ebenso eine Vielzahl an Datenanbindungen. Es unterstützt strukturierte Daten aus Datenbanken (z. B. MySQL, PostgreSQL, Snowflake) sowie Daten aus Cloud-Diensten und unstrukturierte Quellen wie Excel oder Textdateien. [@noauthor_supported_nodate]


**Zusammenfassung** 

Die folgende Tabelle fasst die Unterschiede der Werkzeuge mithilfe eines Vergleichs entlang relevanter Kriterien zusammen:

| **Kriterium**                | **R Shiny**                             | **Python Dash**                        | **Power BI**                                      | **Tableau**                     |
|-----------------------------|-----------------------------------------|----------------------------------------|---------------------------------------------------|----------------------------------|
| **Programmiersprache**      | R                                       | Python                                 | Softwareanwendung                                | Softwareanwendung                |
| **Zielgruppe**              | Wissenschaft, Datenanalyse              | Data Science, Analytics                | Business, Management                              | Business, Management             |
| **Bedienbarkeit durch Erstellende**  | Mittel (Erfahrung in R)                 | Mittel (Erfahrung in Python)           | Sehr einfach (Drag & Drop)                        | Sehr einfach (Drag & Drop)       |
| **Nutzerfreundlichkeit von Konsumentenseite**    | Mittel                                  | Mittel                                 | Hoch                                              | Hoch                             |
| **Interaktivität**          | Sehr hoch (frei programmierbar)         | Sehr hoch (frei programmierbar)                 | Hoch (vorgefertigte Elemente)                          | Hoch (vorgefertigte Elemente)         |
| **Erweiterbarkeit**         | Sehr hoch (eigener R-Code)              | Sehr hoch (eigener Python-Code)        | Gering (Plugins)                                  | Gering (Plugins)                 |
| **Einsatzgebiet**           | Forschung, Open Data, Reports           | Data Science Apps, ML-Dashboards       | Business-Intelligence-Berichte                    | Business-Intelligence-Berichte   |
| **Lizenz/Kosten**           | Open Source, kostenlos                  | Open Source, kostenlos                 | Proprietär, kostenpflichtig (mit Free Tier)       | Proprietär, kostenpflichtig      |
| **Visualisierungstiefe**    | Hoch (flexibel anpassbar)              | Hoch (flexibel anpassbar)              | Mittel (vordefinierte Visuals)                    | Mittel (vordefinierte Visuals)   |
| **Einbindung externer Daten** | Sehr einfach (R-Pakete)               | Sehr einfach (pandas, APIs)            | Sehr einfach (GUI-Connectoren)                    | Sehr einfach (GUI-Connectoren)   |
| **Programmiererfahrung nötig?** | Ja (R-Grundkenntnisse)             | Ja (Python-Grundkenntnisse)           | Nein                                              | Nein                             |
| **Architektur**             | Client-Server          | Client-Server          | Cloud- oder Serverbasiert                         | Client-Server         |
| **Einbettung in Webprojekte** | Einfach (ShinyApps.io, Server)       | Einfach (Deployment auf Servern)       | Eingeschränkt (hauptsächlich Business Reporting)  | Eingeschränkt                    |
| **Lernkurve**               | Moderat bis steil                         | Moderat bis steil                        | Flach                                           | Flach                          |

## Fazit
Die Entscheidung für R Shiny als primäres Visualisierungswerkzeug in diesem Projekt begründet sich durch die spezifischen Anforderungen an analytische Tiefe, methodische Transparenz und Flexibilität. Als kostenloses Open-Source-Framework fügt sich Shiny ideal in den wissenschaftlichen sowie verwaltungstechnischen Kontext (Open Data) ein und vermeidet die Pfadabhängigkeiten und Einschränkungen proprietärer Lizenzmodelle, wie sie bei Power BI oder Tableau bestehen.
Da Shiny auf der Programmiersprache R basiert, profitieren Erstellende von einer guten Erweiterbarkeit durch das R-Ökosystem. Zwar erfordert dies, im Gegensatz zu intuitiven Drag-and-Drop-Lösungen, fundierte Programmierkenntnisse bei der Erstellung, jedoch überwiegt der analytische Nutzen: Die Client-Server-Architektur von Shiny ermöglicht es, komplexe Prozesse der Datenbereinigung und die Anbindung vielfältiger externer Datenquellen nahtlos mit der visuellen Ausgabe zu verzahnen. Dies sichert die Datenkontrolle und die wissenschaftliche Reproduzierbarkeit der Ergebnisse.
Darüber hinaus bietet Shiny eine bessere Visualisierungstiefe und Interaktivität. Im Gegensatz zu den vordefinierten Funktionen standardisierter Business-Intelligence-Software lassen sich mit Shiny maßgeschneiderte, interaktive Weboberflächen (GUIs) frei programmieren. Dies erlaubt es der Zielgruppe, auch Endanwender:innen ohne Programmierkenntnisse, tief in die explorative Datenanalyse einzutauchen. Zusammenfassend stellt R Shiny in unserem Anwendungsfall das passenste Werkzeug dar, um komplexe, datengetriebene Modelle transparent, reproduzierbar und mit großem Gestaltungsspielraum in eine interaktive Webanwendung zu übersetzen.

