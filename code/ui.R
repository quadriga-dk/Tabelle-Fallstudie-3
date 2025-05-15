# UI-Definition
ui <- dashboardPage(
  dashboardHeader(title = "Gieß den Kiez Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Startseite", tabName = "start", icon = icon("home")),
      menuItem("Karte", tabName = "map", icon = icon("map")),
      menuItem("Baumstatistik", tabName = "stats", icon = icon("bar-chart")),
      menuItem("Bewässerungsanalyse", tabName = "analysis", icon = icon("chart-area")),
      menuItem("Bürgerengagement", tabName = "engagement", icon = icon("hands-helping"))
    )
  ),
  dashboardBody(
    tags$script(HTML("
      $(document).ready(function() {
        var map = $('#map').find('div.leaflet-container')[0];
        if (map) {
          var leafletMap = $(map).data('leaflet-map');
          leafletMap.on('zoomend', function() {
            Shiny.setInputValue('map_zoom', leafletMap.getZoom());
          });
        }
      });
    ")),
    tabItems(
      tabItem(tabName = "start",
              box(title = "Overview", status = "primary", solidHeader = TRUE, width = 12,
                  fluidRow(
                    uiOutput("dynamic_tree_box"),
                    valueBoxOutput("total_water"),
                    valueBoxOutput("avg_water")
                  ),
                  fluidRow(
                    column(width = 6,
                           selectInput("start_year", "Jahr der Bewässerung auswählen:", 
                                       choices = c("2020-2024", unique(year(df_merged_clean$timestamp))), 
                                       selected = "2020-2024", multiple = TRUE)
                    ),
                    column(width = 6,
                           selectInput("bezirk", "Bezirk auswählen:", 
                                       choices = c("Alle", unique(df_merged_clean$bezirk)), 
                                       selected = "Alle", multiple = TRUE)
                    )
                  )
              )
      ),
      tabItem(tabName = "map",
              fluidRow(
                box(title = "Filter", status = "primary", solidHeader = TRUE, width = 12,
                    column(width = 6,
                           selectInput("map_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    ),
                    column(width = 6,
                           selectInput("map_lor", "Lebensweltlich orientierte Räume auswählen:", choices = c("Alle", unique(df_merged_sum_distanz_umkreis_pump_ok_lor$bzr_name)), selected = "Alle", multiple = TRUE)
                           ),
                    column(width = 6,
                           selectInput("map_year", "Jahr auswählen:", choices = c("2020-2024",unique(year(df_merged_clean$timestamp))), selected = "2020-2024", multiple = TRUE),
                    ),
                    column(width = 6,
                           selectInput("map_saison", "Saison auswählen:", choices = c("Alle", "Winter", "Frühling", "Sommer", "Herbst"), selected = "Alle", multiple = TRUE),
                    ),
                    column(width = 6,
                           selectInput("map_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df_merged_clean$gattung_deutsch)), selected = "Alle", multiple = TRUE)
                    ),
                )
              ),
              leafletOutput("map", height = "800px")
      ),
      tabItem(tabName = "stats",
              fluidRow(
                box(status = "primary", solidHeader = TRUE, width = 12, title = tagList("Baumverteilung der gegossenen Bäume nach Bezirk", 
                                                                                        div(actionButton("info_btn", label = "", icon = icon("info-circle")),  # Info-Button 
                                                                                            style = "position: absolute; right: 15px; top: 5px;")),
                    selectInput("stats_baumvt_year", "Jahr auswählen:",
                                choices = c("2020-2024", "Baumbestand Stand 2025", sort(unique(na.omit(year(df_merged$timestamp))))),
                                selected = "Baumbestand Stand 2025",
                                multiple = TRUE),
                    
                    plotlyOutput("tree_distribution")
                ),
                box(title = tagList("Häufig gegossene Baumarten im Verhältnis zu ihrem Vorkommen", 
                                    div(actionButton("info_btn_hb", label = "", icon = icon("info-circle")),  # Info-Button 
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12, height = "auto", 
                    selectInput("pie_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    plotlyOutput("tree_pie_chart"),
                    fill = TRUE
                )
              )
      ),
      tabItem(tabName = "analysis",
              fluidRow(
                box(title = tagList("Bewässerung pro Bezirk (2020-2024)", 
                                    div(actionButton("info_btn_hbpb", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12,
                    radioButtons("water_mode", "Anzeige wählen:", 
                                 choices = c("Durchschnittliche Bewässerung" = "avg", 
                                             "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                                 selected = "avg", inline = TRUE),
                    
                    conditionalPanel(
                      condition = "input.water_mode == 'avg'",
                      plotOutput("hist_bewaesserung_pro_bezirk")
                    ),
                    
                    conditionalPanel(
                      condition = "input.water_mode == 'ratio'",
                      plotlyOutput("hist_bewaesserung_verhaeltnis")
                    )
                ),
                # box(title = "Verhältnis von Bäumen zu durchschnittlicher Bewässerung pro Bezirk", status = "primary", solidHeader = TRUE, width = 6,
                #     plotOutput("bar_water_vh")
                # )
              ),
              fluidRow(
                box(title = tagList("Trend der Bewässerung je Pflanzjahr", 
                                    div(actionButton("info_btn_tdbjp", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12,
                    sliderInput("trend_year", "Jahre filtern:", 
                                min = 1900, 
                                max = max(df_merged$pflanzjahr, na.rm = TRUE), 
                                value = c(min(df_merged$pflanzjahr, na.rm = TRUE), max(df_merged$pflanzjahr, na.rm = TRUE)), 
                                step = 1),
                    
                    selectInput("trend_bezirk_pj", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    plotlyOutput("trend_water")
                )
              ), 
              fluidRow(
                box(title = tagList("Trend der Bewässerung", 
                                    div(actionButton("info_btn_tdb", label = "", icon = icon("info-circle")),  # Info-Button
                                        style = "position: absolute; right: 15px; top: 5px;")),
                    status = "primary", solidHeader = TRUE, width = 12, 
                    radioButtons("trend_mode", "Anzeige wählen:", 
                                 choices = c("Monatsweise (pro Jahr)" = "month", "Jahresweise (2020-2024)" = "year"),
                                 selected = "month", inline = TRUE),
                    
                    conditionalPanel(
                      condition = "input.trend_mode == 'month'",
                      selectInput("trend_year_ts", "Jahr auswählen:", 
                                  choices = unique(year(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)), 
                                  selected = max(year(df_merged_sum_distanz_umkreis_pump_ok_lor_clean$timestamp)))
                    ),
                    selectInput("trend_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    selectInput("trend_baumgattung", "Baumgattung auswählen:", choices = c("Alle", unique(df_merged$gattung_deutsch)), selected = "Alle", multiple = TRUE),
                    
                    plotlyOutput("trend_water_ts")
                )
              ),
              fluidRow(
                box(title = "Ranking",status = "primary", solidHeader = TRUE, width = 12,
                    selectInput("bar_bezirk", "Bezirk auswählen:", choices = c("Alle", unique(df_merged_clean$bezirk)), selected = "Alle", multiple = TRUE),
                    
                    box(title = tagList("Top 10 Straßen mit höchster Bewässerung (2020-2024)", 
                                        div(actionButton("info_btn_top", label = "", icon = icon("info-circle")),  # Info-Button 
                                            style = "position: absolute; right: 15px; top: 5px;")),
                        status = "primary", solidHeader = TRUE, width = 6,
                        radioButtons("water_mode_Top", "Anzeige wählen:", 
                                     choices = c("Durchschnittliche Bewässerung" = "avg", 
                                                 "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                                     selected = "avg", inline = TRUE),
                        
                        conditionalPanel(
                          condition = "input.water_mode_Top == 'avg'",
                          plotOutput("hist_Top_10_best")
                        ),
                        
                        conditionalPanel(
                          condition = "input.water_mode_Top == 'ratio'",
                          plotOutput("hist_Top_10_best_verhaeltnis_baum")
                        )
                    ),
                    box(title = tagList("Bottom 10 Straßen mit geringster Bewässerung (2020-2024)", 
                                        div(actionButton("info_btn_bottom", label = "", icon = icon("info-circle")),  # Info-Button 
                                            style = "position: absolute; right: 15px; top: 5px;")),
                        
                        status = "primary", solidHeader = TRUE, width = 6,
                        radioButtons("water_mode_Bottom", "Anzeige wählen:", 
                                     choices = c("Durchschnittliche Bewässerung" = "avg", 
                                                 "Verhältnis Bewässerung / Anzahl Bäume" = "ratio"),
                                     selected = "avg", inline = TRUE),
                        conditionalPanel(
                          condition = "input.water_mode_Bottom == 'avg'",
                          plotOutput("hist_Top_10_worst")   
                        ),
                        
                        conditionalPanel(
                          condition = "input.water_mode_Bottom == 'ratio'",
                          plotOutput("hist_Top_10_worst_verhaeltnis_baum")
                        )
                    ),
                    box(title = "Bewässerung pro Straße", status = "primary", solidHeader = TRUE, width = 12,
                      plotOutput("hist_bewaesserung_pro_strasse")
                    )
                )
              )
      ),
      tabItem(tabName = "engagement",
              fluidRow(
                box(title = "Pumpenanzahl und Bewässerung pro Bezirk",status = "primary", solidHeader = TRUE, width = 12,
                    plotlyOutput("balken_plot"), plotlyOutput("balken_plot_mit_kaputten_Pumpen_nebeneinander"), plotlyOutput("balken_plot_mit_kaputten_Pumpen")
                ),
                # box(title = "Pumpengesamtanzahl und Bewässerung pro Bezirk",status = "primary", solidHeader = TRUE, width = 12,
                #     plotlyOutput("balken_plot_mit_kaputten_Pumpen")
                # ),
                box(title = "Durchschnittliche Gießmenge nach Pumpen-Kategorie im 100 m Umkreis",status = "primary", solidHeader = TRUE, width = 12,
                    plotOutput("pumpenkategorien_plot", height = "400px"), plotOutput("pumpenkategorien_plot_pump_ok", height = "400px")
                ),
                box(title = "Gießverhalten nach Bezirk",status = "primary", solidHeader = TRUE, width = 12,
                    leafletOutput("karte_giessverhalten")
                ),
                box(title = "Gießverhalten nach Bezirk mit kaputten Pumpen",status = "primary", solidHeader = TRUE, width = 12,
                    leafletOutput("karte_giessverhalten_mit_kaputten_Pumpen")
                ),
              )
      )
    ),
    bsModal("info_modal", "Erklärung: Baumverteilung", "info_btn", size = "medium",
            p("Dieses Diagramm zeigt die Anzahl der gegossenen Bäume pro Bezirk in Berlin.")),
    
    bsModal("info_modal_hb", "Erklärung: Häufigste Baumarten", "info_btn_hb", size = "medium",
            p("Dieses Diagramm zeigt die am häufigsten gegossenen Baumarten in Berlin.")),
    
    bsModal("info_modal_hbpb", "Erklärung: Bewässerung pro Bezirk", "info_btn_hbpb", size = "medium",
            p("Dieses Diagramm zeigt die gesamte Menge an Wasser, die in jedem Bezirk für die Bewässerung verwendet wurde.")),
    
    bsModal("info_modal_tdbjp", "Erklärung: Bewässerungstrend je Pflanzjahr", "info_btn_tdbjp", size = "medium",
            p("Dieses Diagramm zeigt, wie sich die Bewässerung der Bäume entwickelt hat, die in bestimmten Jahren gepflanzt wurden.")),
    
    bsModal("info_modal_tdb", "Erklärung: Gesamttrend der Bewässerung", "info_btn_tdb", size = "medium",
            p("Dieses Diagramm zeigt die Bewässerung der Bäume über verschiedene Zeiträume hinweg.")),
    
    bsModal("info_modal_top", "Erklärung: Top 10 Straßen mit höchster Bewässerung", "info_btn_top", size = "medium",
            p("Dieses Diagramm zeigt die zehn Straßen mit der höchsten Gesamtbewässerung im Zeitraum 2020-2024.")),
    
    bsModal("info_modal_bottom", "Erklärung: Bottom 10 Straßen mit geringster Bewässerung", "info_btn_bottom", size = "medium",
            p("Dieses Diagramm zeigt die zehn Straßen mit der geringsten Gesamtbewässerung im Zeitraum 2020-2024."))
  )
)