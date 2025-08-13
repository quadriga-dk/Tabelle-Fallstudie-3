# Vergleich

**Weshalb ist ein Vergleich zwischen anderen Visualisierungswerkzeugen sinnvoll ist**

Der Vergleich zwischen R Shiny und anderen Visualisierungswerkzeugen wie Python Dash, Power BI oder Tableau ist für datengetriebene Projekte besonders relevant, da jedes dieser Tools unterschiedliche Stärken, Funktionalitäten und Zielgruppen adressiert. Die Auswahl eines geeigneten Visualisierungstools hängt maßgeblich von den konkreten Zielen, Anforderungen und Rahmenbedingungen eines Projekts ab – ebenso wie von den technischen Vorkenntnissen und persönlichen Präferenzen der Nutzer:innen. Während Power BI und Tableau häufig im unternehmerischen Umfeld zum Einsatz kommen, werden R Shiny und Python-basierte Lösungen vor allem im wissenschaftlichen und analytischen Kontext verwendet. 

Im Folgenden werden die jeweiligen Werkzeuge und ihre Besonderheiten näher erläutert und miteinander verglichen.

## Erläuterung der ausgewählten Visualisierungswerkzeugen

<u>R Shiny:</u>  R Shiny ist ein Open-Source-Web-Anwendungs-Framework für R, welches von RStudio entwickelt worden ist. Das Shiny Framework ermöglicht es R-Nutzern, webbasierte grafische Benutzeroberflächen (GUIs) mit den dazugehörigen R-Analysen und Visualisierungen zu entwickeln. [@walker_tools_2016]

Der Hauptzweck von Shiny ist es, diese erstellten Benutzeroberflächen zu veröffentlichen, damit auch andere, mitsamt Personen ohne Programmierkenntnisse (Nicht-Coder), mit den Daten interagieren und diese selbst visualisieren können. [@walker_tools_2016]

<u>Python Dash:</u> Python Dash ist ein leistungsfähiges Open-Source-Framework, welches von Plotly für Python Entwickler entwickelt worden ist. Dash ermöglicht es vollständig ausgestaltete analytische Datenanwendungen und interaktive Dashboards zu kreieren, ohne Kenntnisse in Frontend-Technologien wie HTML, CSS oder JavaScript. Was einen zentralen Vorteil von Dash darstellt.  [@dabbas_interactive_2021]

<u>Power BI:</u> Das von Microsoft entwickelte Power BI ist eine zusammenkunft von Analysetools für Unternehmen. Das Tool ermöglicht die Analyse von Daten und zum Teilen von Erkenntnissen über Berichte und Dashboards. Entwickelt wurde Power BI mit dem Ziel Business Intelligence und Datenanalyse zu vereinfachen, indem es Einzelpersonen und Organisationen ermöglicht, mit minimalem Zeit- und Arbeitsaufwand Daten beizutragen und somit Berichte zu erstellen oder automatisch generieren (über die Quick Insights Funktion) zu lassen, zusammengefasst werden können diese Berichte in den Dashboards welche anschließend freigegeben werden können.[@krishnan_research_nodate]

<u>Tableau:</u> Bei Tableau handelt es sich um eine Software für die Erstellung von Visualisierungen.  Entwickelt wurde Tableau von Tableau Inc. als Visualisierungstool für die Erstellung oder Programmierung von Dashboards im Business-Intelligence-Bereich. [@wood_diabetes_2019] [@vasundhara_data_nodate] Die Besonderheit an Tableau ist, dass die Verwendung durch die GUI mit drag and drop relativ unkompliziert ist.[@vasundhara_data_nodate] 

## Vergleich im Überblick

Um die unterschiedlichen Stärken und Einsatzbereiche der vier Tools noch klarer zu machen, zeigt die folgende Tabelle einen systematischen Vergleich entlang relevanter Kriterien:

| **Kriterium**                | **R Shiny**                             | **Python Dash**                        | **Power BI**                                      | **Tableau**                     |
|-----------------------------|-----------------------------------------|----------------------------------------|---------------------------------------------------|----------------------------------|
| **Programmiersprache**      | R                                       | Python                                 | Softwareanwendung                                | Softwareanwendung                |
| **Zielgruppe**              | Wissenschaft, Datenanalyse              | Data Science, Analytics                | Business, Management                              | Business, Management             |
| **Bedienbarkeit**           | Mittel (Erfahrung in R)                 | Mittel (Erfahrung in Python)           | Sehr einfach (Drag & Drop)                        | Sehr einfach (Drag & Drop)       |
| **Visualisierungstiefe**    | Hoch (flexibel anpassbar)              | Hoch (flexibel anpassbar)              | Mittel (vordefinierte Visuals)                    | Mittel (vordefinierte Visuals)   |
| **Interaktivität**          | Sehr hoch                               | Sehr hoch                              | Hoch (aber vorgefertigt)                          | Hoch (aber vorgefertigt)         |
| **Erweiterbarkeit**         | Sehr hoch (eigener R-Code)              | Sehr hoch (eigener Python-Code)        | Gering (Plugins)                                  | Gering (Plugins)                 |
| **Einsatzgebiet**           | Forschung, Open Data, Reports           | Data Science Apps, ML-Dashboards       | Business-Intelligence-Berichte                    | Business-Intelligence-Berichte   |
| **Nutzerfreundlichkeit**    | Mittel                                  | Mittel                                 | Hoch                                              | Hoch                             |
| **Lizenz/Kosten**           | Open Source, kostenlos                  | Open Source, kostenlos                 | Proprietär, kostenpflichtig (mit Free Tier)       | Proprietär, kostenpflichtig      |
| **Einbindung externer Daten** | Sehr einfach (R-Pakete)               | Sehr einfach (pandas, APIs)            | Sehr einfach (GUI-Connectoren)                    | Sehr einfach (GUI-Connectoren)   |
| **Programmiererfahrung nötig?** | Ja (R-Grundkenntnisse)             | Ja (Python-Grundkenntnisse)           | Nein                                              | Nein                             |
| **Architektur**             | Client-Server (Shiny UI/Server)         | Client-Server (Flask/React)            | Cloud- oder Serverbasiert                         | Cloud- oder Serverbasiert        |
| **Einbettung in Webprojekte** | Einfach (ShinyApps.io, Server)       | Einfach (Deployment auf Servern)       | Eingeschränkt (hauptsächlich Business Reporting)  | Eingeschränkt                    |
| **Lernkurve**               | Mittel bis hoch                         | Mittel bis hoch                        | Niedrig                                           | Niedrig                          |


**Lizenzmodell und Einsatzszenarien**
<u>Dash</u> und <u>Shiny</u> sind beide Open Scource Anwendungen können diese Frameworks kostenlos verwendet werden. [@dabbas_interactive_2021] Im Gegensatz dazu setzen <u>Power BI</u> und <u>Tableau</u> für die vollständigen Versionen auf kommerzielle Lizenzmodelle. Power BI und Tableau bieten beide zusätzlich auch noch eine kostenfreie Version an, die allerdings nicht alle Funktionen bereitstellt, die auch die kostenpflichtige Version bereitstellt, besonders für kleine und mittlere Unternehmen stellt die kostenlose Option über ausreichende Funktionen und Features zur Verfügung. [@krishnan_research_nodate]

**Programmiersprache, Zielgruppe, Bedienbarkeit, Erweiterbarkeit**
<u>R Shiny</u> ist vollständig auf der Programmiersprache R aufgebaut und eignet sich besonders für Nutzer: innen aus Wissenschaft und Datenanalyse. [@khedr_interactive_2021] Diese Verbundenheit mit dem R Ökosystem ist für Shiny enormer Vorteil, da Shiny dadurch leicht erweiterbar ist,diese verwenden zu können, setzt aber Vorkenntnisse in der Programmiersprache R voraus. [@walker_tools_2016]

<u>Python Dash</u> hingegen basiert auf der Programmiersprache Python und wird häufig in den Bereichen Data Science und Analytics verwendet und richtet sich an Nutzer: innen, die bereits mit Datenanalyse-Tools wie pandas oder scikit-learn, die auf Python basieren auskennen. [@odonnell_interaktive_2020] Der Vorteil in Dash liegt in der Verwendung der modernen Frontend-Technologie mit React, zudem wird dem Nutzer vollständige Freiheit über die Gestaltung gegeben mit dem Code. Wie auch bei R Shiny ist es verbundenheit mit dem Python Ökosystem für Dash vom Vorteil da auch hier die Anwendung leicht erweiterbar ist. [@dabbas_interactive_2021]

Auf Grund dessen dass <u>Power BI</u> und <u>Tableau</u> dafür entwickelt wurden um im Bereich Business-Intelligence und Unternehmenssektor angewendet zu werden wird größtenteils auf  herkömmliche Programmierung verzichtet, obwohl Tableau mit R verbunden werden kann, um die Darstellung besser auf die Erwartungen des Anwenders anpassen zu können. Anstelle von Programmierung nutzen beide Tools GUI’s mit einer Drag-and-Drop-Funktionalität. [@odonnell_interaktive_2020] [@vasundhara_data_nodate]In Bezug auf Erweiterbarkeit bieten Tableau und Power BI eher schlechtere Erweiterbarkeiten, da die Plugin Optionen niedrig sind. 

**Architektur**

```{figure} _images/R_Shiny_Aufbau.png
---
name: R_Shiny_Aufbau
alt: Ein Screenshot, der zeigt, wie man ein R Shiny Anwendung aufbauen kann.
---
R Shiny Aufbau (Quelle: <a href="https://www.inwt-statistics.com/blog/best-practice-development-of-robust-shiny-dashboards-as-r-packages" target="_blank">Best Practice: Shiny Dashboards</a> )
``` 

<u>Shiny</u> Anwendungen nutzen eine serverseitige Logik und eine Benutzeroberfläche (UI), oft in einer einzigen app.R-Datei kombiniert, darin besteht aber kein zwang der Server-Teil und UI-Teil können auch in zwei separate Dateien server.R und ui.R aufgeteilt werden und durch die Datei app.R wieder zusammengeführt werden. [@walker_tools_2016]

```{figure} _images/Python_Architektur.png
---
name: Python_Architektur
alt: Ein Screenshot, der die Architektur von Python Dash zeigt.
---
Python Architektur [@dabbas_interactive_2021]
``` 


<u>Dash</u> basiert ebenfalls auf einer Client-Server-Architektur. Diese besteht aus drei Hauptkomponenten: Flask, Ploty und React zusammen binden diese Dash. Dabei wird 
- Flask als Web Framework für das Backend verwendet und ist essentiell für Flask Apps.
- Zur Erstellung der Diagramme und interaktiven Grafiken wird die Plotly Bibliothek verwendet, diese ist aber nicht Pflichtmäßig zu verwenden bei der Dash Programmierung. Ploty bildet aber das best unterstütze Package für die daten Visualisierung. Es bietet über 50 Diagrammtypen mit inklusive 2D und 3D Visualisierungen. 
- React wird zum Umgang mit allen Komponenten verwendet. Dash-Anwendungen werden als einseitige React-Anwendungen gerendert. Die Dash-Kernkomponenten sind im Wesentlichen in Python verfügbare React-Komponenten. React bildet die UI-Komponente der Dash Anwendung. Dash stellt diese Komponenten über eine einheitliche Python-Schnittstelle bereit, wodurch Datenmanipulation, Visualisierung und Webentwicklung vollständig in einer Programmiersprache erfolgen können. [@dabbas_interactive_2021]

Die Architektur von <u>Power BI</u> ist cloud-zentriert und umfasst mehrere Module. Die wesentlichen Bauteile sind:

- Power BI Desktop ist das lokale Entwicklungstool. Diese Bauteil wird für die Datenanbindung, die Datentransformation (mittels Power Query), für die Modellierung anhand von Power Pivot und für die Erstellung von Berichten verwendet. [@arkharov_power_2024] Für die Berichtsentwichklung ist Power BI Desktop das Hauptwerkzeug. Dafür können Daten aus den verschiedensten Quellen importiert oder über DirectQuery verbunden werden. [@arkharov_power_2024] [@denglishbi_bi-losungsarchitektur_nodate]
- Power BI Service dient der Veröffentlichung und Interaktion, es bildet die Online-Plattform. Online werden Berichte und Dashboards in der Cloud geteil. Der Dienst nutzt die Microsoft-Azure-Infrastruktur. Wodurch Nutzer über mobile Apps oder Browser darauf zugreifen können. Die Dashboards ermöglichen das die Visualisierungen interaktiviert werden, anhand der Power Q&A Funktion können sogar Abfragen mit Hilfe natürlicher Sprache durchgeführt werden. [@arkharov_power_2024] 
    - Die Microsoft Azure Infrastruktur wird in zwei Teile unterteilt: 
        - Das Front End Cluster dient als Interface zwischen Backend Cluster und dem Client (Web oder mobile App) und authentifiziert den Benutzer für  Power BI Service. [@arkharov_power_2024] 
        - Das Backend End Cluster enthält alle Daten, Visualisierungen, Berichte und verarbeitete alle Nutzer interaktionen. Das Backend nutzt die Microsoft Entra ID, um die Identität der Nutzer zu managen. Der Azure Traffic Manager verbindet den Client mit dem nahegelegenen Datencenter und der Inhalt wird über Azure CDN bereitgestellt. [@arkharov_power_2024]  
- Power BI Gateway ist für die Verbindung mit lokalen Datenquellen. Mit diesem Bestandteil wird ein sicherer Zugriff auf die Berichterstattungen in der Cloud gewährleistet. Es ist ein grundlegender Baustein für die hybride Datenarchitektur.[@arkharov_power_2024]  

Genau wie <u>Python Dash</u> und <u>R-Shiny</u> basiert <u>Tableau</u> auch auf einer Client-Server-Architektur. Die wesentlichen Bestandteile sind:
- **Tableau Desktop** dient auch hier als das Tool zur lokalen Entwicklung. Und erfüllt dieselben Aufgaben wie auch Power BI Desktop. Die Benutzeroberfläche besteht aus Menüs, Shelves, Karten und Datenfeldern. [@vasundhara_data_nodate]
- **Tableau Server / Tableau Cloud** ist für die Bereitstellung zuständig. Dabei kann Tableau Server entweder auf einer lokalen oder in einer privaten Cloud installiert werden, wobei Tableau Cloud im Vergleich als SaaS-Lösung (Software as a Service) fungiert. Durch beide wird skalierbare Analytik in Echtzeit, rollenbasierte Zugriffskontrolle ermöglicht und die Zusammenarbeit an Dashboards innerhalb der Organisation. Mittels dieser Architektur ist es mit Tableau möglich, hybride Datenquellen (sowohl lokale als auch Cloud-Daten) zu unterstützen und verwendet für eine sichere Verbindung mit privaten Datenquellen Tableau Bridge. [@noauthor_tableau-plattformarchitektur_nodate]
- **Datenverbindung und Zugriff:** Tableau ermöglicht es großen Datenquellen direkt abzufragen als Live Connection, aber auch die Arbeit mit extrahierten Daten ist mit Tableau möglich, um die Performance zu steigern. Die Anbindung wird über native Treiber zu u.a. PostgreSQL, MySQL, Snowflake, Redshift und Google BigQuery realisiert. [@noauthor_tableau-plattformarchitektur_nodate]
- **VizQL Engine** bildet den Hauptbestandteil der Visualisierung, denn für die Datenabfrage und die damit unmittelbar verbundene visuelle Darstellung nutzt Tableau die VizQL (Visual Query Language).  Dies ist für die zügige und interaktive Visualisierung von großen Datenmengen maßgeblich. [@noauthor_vizql_nodate]



**Interaktivität und Visualisierungstiefe**

In Bezug auf Interaktivität bieten <u>Shiny</u> und <u>Dash</u> das höchste maß an Flexibilität, da die beiden auf einem reaktiven Programmiermodell basieren. In Shiny Anwendungen können Benutzer aktiv in den Analyseprozess eingebunden werden, anhand von Slidern die erlauben die Daten zum Beispiel für einen Bestimmten Zeitraum zu analysieren, Dropdowns oder Karten mit den interagiert werden kann, durch diese interaktionsmöglichkeiten wird die Visualisierung bei jeder Eingabe serverseitig aktualisiert. Dash regelt das auf eine ähnliche Art und Weise, durch sogenannte Callback- Funktionen werden UI- Elemente mit Diagrammen verknüpft, was explorative Datenanalyse ermöglicht. [@dabbas_interactive_2021]

Auch <u>Power BI</u> und <u>Tableau</u> bieten Interaktivität, dies jedoch innerhalb ihrer Benutzeroberflächen.  Standardmäßig sind Filter, Drilldowns und Highlighting-Funktionen vorhanden. [@walker_tools_2016] Im Vergleich zu Shiny und Dash ist die Interaktivität Tiefe jedoch begrenzt, da es schwieriger, komplexer ist, benutzerdefinierte Logiken umzusetzen. 

**Einbindung externer Daten**

<u>R Shiny</u> ist extrem flexibel im Bereich der Datenintegration, da es auch hier von den Vorteilen der Anbindung des R-Ökosystems profitiert. Dies ermöglicht es R Nutzern, mit einer Vielzahl von Datenquellen zu arbeiten, darunter CSV-, Excel- und JSON-Dateien, relationale Datenbanken. [@attali_shiny_2020] 

<u>Python Dash</u> ist vergleichbar in der Flexibilität der Datenverbindung mit Shiny. Dash profitiert genauso wie Shiny vom R-Ökosystem vom Python-Ökosystem deshalb lassen sich auch hier zahlreiche Datenquellen einbinden, wie zum Beispiel lokale Dateien, SQL- oder NoSQL-Datenbanken, REST-APIs oder Cloud-basierte Speicherlösungen. [@noauthor_managing_nodate]

<u>Power BI</u> bietet eine umfangreiche anzahl an Datenkonnektoren, die eine unkomplizierte Verbindung zu verschiedenen Datenquellen ermöglichen. Hierzu gehören unter anderem Excel, CSV-Dateien, relationale Datenbanken wie SQL Server, Oracle oder MySQL sowie Cloud-Dienste wie Azure, Salesforce oder Google Analytics. [@davidiseminger_data_nodate] Es ermöglicht zusätzlich die Integration von ETL-Prozess (Extract, Transform, Load) zum Datenbereinigen. [@odonnell_interaktive_2020]

<u>Tableau</u>  erlaubt ebenso eine Vielzahl an Datenanbindungen. Es unterstützt strukturierte Daten aus Datenbanken (z. B. MySQL, PostgreSQL, Snowflake) sowie Daten aus Cloud-Diensten und unstrukturierte Quellen wie Excel oder Textdateien. [@noauthor_supported_nodate]

## Fazit
Die vier ausgewählten Visualisierungstools - R Shiny, Python Dash, Power BI und Tableau - wurden methodisch analysiert und verglichen, um zu zeigen, dass jedes von ihnen einzigartige Vorteile, Anwendungsbereiche und Zielgruppen hat. Zwei starke Open-Source-Programme, die sich durch ein hohes Maß an Flexibilität, Erweiterbarkeit und Interaktivität auszeichnen, sind R Shiny und Dash. Beide Frameworks erleichtern die Erstellung von dynamischen, anpassungsfähigen Webanwendungen und basieren auf einem reaktiven Programmierparadigma. Aufgrund dieser Eigenschaften sind sie besonders attraktiv für datengesteuerte Projekte und die wissenschaftliche Gemeinschaft, wo komplizierte Visualisierungen und analytische Interaktionen im Vordergrund stehen. Die Einstiegshürde wird dadurch erhöht, dass tiefgreifende Kenntnisse der entsprechenden Programmiersprachen (Python oder R) erforderlich sind.
Allerdings richtet sich Power BI und Tableau hauptsächlich an den Unternehmenssektor, in dem die Benutzer oft keine Programmierkenntnisse besitzen.  Aus diesem Grund verfügen diese Werkzeuge über eine grafische Benutzeroberfläche im Drag-and-Drop-Stil, die das einfache und zügige Erstellen von Visualisierungen ermöglicht.  Allerdings bringt die Benutzerfreundlichkeit einen Nachteil in Form von fehlender Flexibilität mit sich: Power BI und Tableau sind im Vergleich zu Dash oder Shiny vor allem standardisierte Softwareprodukte, weshalb komplexe Interaktionen und maßgeschneiderte Anpassungen nur eingeschränkt realisierbar sind.  Sie bieten jedoch eine Vielzahl von Konnektoren und Integrationen an, insbesondere Power BI, das sich nahtlos in das Microsoft-Ökosystem einfügt.

Ein interessanter Kompromiss besteht in der Integration von R in Tableau. So kann das Tool für wissenschaftliche Anwendungsfälle erweitert werden und ermöglicht die Integration von komplexeren, personalisierten Analysen. Nur Nutzer mit technischen Fähigkeiten nutzen diese Option, da sie entsprechende Programmierkenntnisse voraussetzt.

Zusammenfassend kann festgestellt werden, dass die vier Visualisierungstools zwei verschiedene Zielgruppen ansprechen: Tableau und Power BI sind für Unternehmen gedacht, die Benutzerfreundlichkeit und Geschwindigkeit schätzen, während R Shiny und Python Dash besser für analytische, wissenschaftliche Anwendungen geeignet sind, bei denen Flexibilität, Datenkontrolle und Zugänglichkeit entscheidend sind.  Durch ihre offenen Ökosysteme und die tiefe Integration in ihre jeweiligen Programmiersprachen bieten Dash und Shiny einen größeren Spielraum für Gestaltung und Datenverarbeitung.  Bei der Auswahl geeigneter Tools sollten daher stets der Kontext der Anwendung, die Zielgruppe und das vorhandene technische Know-how beachtet werden.  Ein geeignetes Visualisierungstool kann letztendlich einen wesentlichen Beitrag dazu leisten, Datenerkenntnisse zugänglicher, verständlicher und nützlicher zu machen, unabhängig davon, ob es sich um einen wissenschaftlichen oder wirtschaftlichen Kontext handelt.

