---
lang: de-DE
---

(fragestellung)=
# Fragestellung

Die Visualisierung von Daten hat vor allem im Public Sector großes Potential, da es dort viele statistische Erhebungen gibt, die direkt oder indirekt mit den Bürger:innen zusammenhängen.  
Sucht man nach Wegen wie sich diese Daten veranschaulichen und niedrigschwellig an die Gesellschaft (zurück) kommunizieren lassen, stößt man schnell auf Dashboards.  
Dashboards wie das in Abb. 2.1 gezeigte <a href="https://www.digitale-verwaltung.de/Webs/DV/DE/aktuelles-service/dashboard_digitale_verwaltung/dashboard-node.html" class="external-link" target="_blank">Dashboard Digitale Verwaltung</a>, erlauben es, Informationen gebündelt und grafisch aufbereitet präzise darstellen zu können.

```{figure} /assets/DDV_Screenshot_20260317.png
---
align: center
width: 100%
name: Dashboard Digitale Verwaltung 
alt: Das Dashboard Digitale Verwaltung mit Informationen zur Online-Verfügbarkeit von Verwaltungsleistungen für das Land Berlin.
---
Screenshot des Dashoards Digitale Verwaltung mit Fokus auf Online-Verfügbarkeit von Verwaltungsleistungen für das Land Berlin vom 17.03.2026.
```


Um diese Vorteile nachvollziehbar und nutzbar zu machen, wird in dieser Fallstudie ein Dashboard mit R Shiny erstellt.  
Dazu wird auf die Abfrage von Baumkatasterdaten der Fallstudie <a href="https://quadriga-dk.github.io/Tabelle-Fallstudie-2/Titelseite.html" class="external-link" target="_blank">Offene Daten im urbanen Raum</a> aufgebaut. Inspiriert von der Plattform <a href="https://citylab-berlin.org/de/projects/giess-den-kiez/" class="external-link" target="_blank">Gieß den Kiez</a> wird unter Einbindung von Bewässerungsdaten folgende Leitfrage formuliert:

`````{admonition} Forschungsfrage
:class: keypoint
Wo lassen sich die höchsten Ausprägungen des Engagements von Bürger:innen bei der Bewässerung städtischer Bäume in Berlin feststellen? 
`````
