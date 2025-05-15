# Lade externe Dateien
source("global.R")
source("ui.R")
source("server.R")

# Starte die Shiny-App
shinyApp(ui = ui, server = server)