install.packages("igraph")
library(igraph)
library(ggraph)

igraph1 <- read.csv("data/giessdenkiez_bewässerungsdaten.csv", sep = ";", stringsAsFactors = FALSE, fileEncoding = "UTF-8") %>%
  drop_na(lng, lat, bewaesserungsmenge_in_liter) %>%
  filter(strname != "Undefined" & strname != "" & !str_detect(gattung_deutsch, "[0-9]"))

str(igraph1)
summary(igraph1)
head(igraph1)

str(bezirksgrenzen)

# Nodes
datasets <- tibble(
  name = c(
    "anlagenbaeume (WFS)",
    "strassenbaeume (WFS)",
    "giessdenkiez_bewässerungsdaten.csv",
    "baumbestand (intermediate)",
    "df_merged_final.csv"
  ),
  type = c("WFS", "WFS", "CSV", "Intermediate", "Output")
)

# Edges
edges <- tibble(
  from = c(
    "anlagenbaeume (WFS)",
    "strassenbaeume (WFS)",
    "baumbestand (intermediate)",
    "giessdenkiez_bewässerungsdaten.csv"
  ),
  to = c(
    "baumbestand (intermediate)",
    "baumbestand (intermediate)",
    "df_merged_final.csv",
    "df_merged_final.csv"
  ),
  connection = c(
    "bind_rows()",
    "bind_rows()",
    "join on gisid = id",
    "join on gisid = id"
  )
)

# Graph
g <- graph_from_data_frame(d = edges, vertices = datasets, directed = TRUE)

# Wrap long labels for readability
V(g)$label <- str_wrap(V(g)$name, width = 20)

V(g)$label <- recode(V(g)$name,
                     "giessdenkiez_bewässerungsdaten.csv" = "Bewässerung",
                     "anlagenbaeume (WFS)" = "Anlagenbäume",
                     "strassenbaeume (WFS)" = "Straßenbäume",
                     "bezirksgrenzen.geojson" = "Bezirksgrenzen",
                     "df_merged_final.csv" = "Merged CSV",
                     "Dashboard_Startseite" = "Dashboard"
)

V(g)$label <- c(
  "Straßenbäume",       # strassenbaeume (WFS)
  "Anlagenbäume",      # anlagenbaeume (WFS)
  "Gieß den Kiez",      # strassenbaeume (WFS)
  "Baumbestand",    # bezirksgrenzen.geojson
  "Final"        # df_merged_final.csv
)


# Plot with ggraph
coords <- layout_with_fr(g)
coords <- coords * 0.4  # shrink distances by 40%

ggraph(g, layout = coords) +
  geom_edge_link(aes(label = connection),
                 arrow = arrow(length = unit(6, 'mm'), type = "closed"),
                 end_cap = circle(8, 'mm'),
                 start_cap = circle(8, 'mm'),
                 label_size = 3.5,
                 fontface = "italic",
                 angle_calc = "along",
                 label_dodge = unit(2.5, 'mm'),
                 label_colour = "grey20") +
  geom_node_point(aes(color = type), size = 12) +
  geom_node_text(aes(label = label),  # no wrapping, original names
                 fontface = "bold",
                 size = 4,
                 color = "black") +
  scale_color_manual(values = c(
    "WFS" = "lightblue",
    "CSV" = "lightgreen",
    "Intermediate" = "orange",
    "Output" = "tomato"
  )) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  )

# Nodes for second graph
datasets2 <- tibble(
  name = c(
    "df_merged_final.csv (input)",
    "bezirksgrenzen.geojson",
    "df_ohne_bezirk_sf",
    "df_ohne_bezirk_joined",
    "df_baeume_final.csv (output)"
  ),
  type = c("CSV", "GeoJSON", "Intermediate", "Intermediate", "Output")
)

# Edges
edges2 <- tibble(
  from = c(
    "df_merged_final.csv (input)",
    "df_ohne_bezirk_sf",
    "bezirksgrenzen.geojson",
    "df_ohne_bezirk_joined"
  ),
  to = c(
    "df_ohne_bezirk_sf",
    "df_ohne_bezirk_joined",
    "df_ohne_bezirk_joined",
    "df_baeume_final.csv (output)"
  ),
  connection = c(
    "filter NA bezirk",
    "st_join()",
    "st_transform + rename",
    "bind_rows()"
  )
)

# Graph
g2 <- graph_from_data_frame(d = edges2, vertices = datasets2, directed = TRUE)

# Short labels
V(g2)$label <- recode(V(g2)$name,
                      "df_merged_final.csv (input)" = "Input CSV",
                      "bezirksgrenzen.geojson" = "Bezirksgrenzen",
                      "df_ohne_bezirk_sf" = "Baumdaten ohne Bezirk (sf)",
                      "df_ohne_bezirk_joined" = "Join Ergebnis",
                      "df_baeume_final.csv (output)" = "Final CSV"
)

# Plot
coords2 <- layout_with_fr(g2)
coords2 <- coords2 * 0.4

ggraph(g2, layout = coords2) +
  geom_edge_link(aes(label = connection),
                 arrow = arrow(length = unit(6, 'mm'), type = "closed"),
                 end_cap = circle(8, 'mm'),
                 start_cap = circle(8, 'mm'),
                 label_size = 3.5,
                 fontface = "italic",
                 angle_calc = "along",
                 label_dodge = unit(2.5, 'mm'),
                 label_colour = "grey20") +
  geom_node_point(aes(color = type), size = 12) +
  geom_node_text(aes(label = label),
                 fontface = "bold",
                 size = 4,
                 color = "black") +
  scale_color_manual(values = c(
    "CSV" = "lightgreen",
    "GeoJSON" = "lightblue",
    "Intermediate" = "orange",
    "Output" = "tomato"
  )) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  )

# Nodes
nodes3 <- tibble(
  name = c(
    "df_merged_full",
    "bewässerungs_frequenz",
    "df_merged_full (mit Intervall)",
    "df_merged_sum",
    "CSV output"
  ),
  type = c("Input", "Intermediate", "Intermediate", "Output", "Output")
)

# Edges
edges3 <- tibble(
  from = c(
    "df_merged_full",
    "bewässerungs_frequenz",
    "df_merged_full (mit Intervall)",
    "df_merged_full (mit Intervall)",
    "df_merged_sum"
  ),
  to = c(
    "bewässerungs_frequenz",
    "df_merged_full (mit Intervall)",
    "df_merged_full (mit Intervall)",
    "df_merged_sum",
    "CSV output"
  ),
  connection = c(
    "group_by + difftime",
    "left_join",
    "replace NA",
    "group_by + summarise",
    "write.csv2"
  )
)

# Graph
g3 <- graph_from_data_frame(d = edges3, vertices = nodes3, directed = TRUE)

# Node labels
V(g3)$label <- c(
  "Input: df_merged_full",
  "Calc Intervall",
  "Join Intervall",
  "Summarise per Tree",
  "Save CSV"
)

# Plot
ggraph(g3, layout = "fr") +
  geom_edge_link(aes(label = connection),
                 arrow = arrow(length = unit(6, 'mm'), type = "closed"),
                 end_cap = circle(8, 'mm'),
                 start_cap = circle(8, 'mm'),
                 label_size = 3.5,
                 fontface = "italic",
                 angle_calc = "along",
                 label_dodge = unit(2.5, 'mm'),
                 label_colour = "grey20") +
  geom_node_point(aes(color = type), size = 12) +
  geom_node_text(aes(label = label),
                 fontface = "bold",
                 size = 4,
                 color = "black") +
  scale_color_manual(values = c(
    "Input" = "lightblue",
    "Intermediate" = "orange",
    "Output" = "tomato"
  )) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  )



# --- Nodes ---
nodes4 <- tibble(
  name = c(
    "pumpen.geojson",
    "bezirksgrenzen.geojson",
    "pumpen_mit_bezirk",
    "pumpen_mit_bezirk_full",
    "pumpen_mit_bezirk_minimal.geojson"
  ),
  type = c("Input", "Input", "Intermediate", "Intermediate", "Output")
)

# Short labels for readability
nodes4$label <- c(
  "Pumpen", 
  "Bezirksgrenzen", 
  "Pumpen+Bezirk", 
  "Pumpen full", 
  "Pumpen minimal"
)

# --- Edges ---
edges4 <- tibble(
  from = c(
    "pumpen.geojson",
    "bezirksgrenzen.geojson",
    "pumpen_mit_bezirk",
    "pumpen_mit_bezirk_full"
  ),
  to = c(
    "pumpen_mit_bezirk",
    "pumpen_mit_bezirk",
    "pumpen_mit_bezirk_full",
    "pumpen_mit_bezirk_minimal.geojson"
  ),
  connection = c(
    "transform + join + rename",
    "transform + join",
    "write/read",
    "select + write"
  )
)

# --- Create igraph object ---
g4 <- graph_from_data_frame(d = edges4, vertices = nodes4, directed = TRUE)

# --- Plot ---
coords <- layout_with_fr(g4)
coords <- coords * 0.5  # shrink distances for readability

ggraph(g4, layout = coords) +
  geom_edge_link(aes(label = connection),
                 arrow = arrow(length = unit(6, 'mm'), type = "closed"),
                 end_cap = circle(6, 'mm'),
                 start_cap = circle(6, 'mm'),
                 label_size = 3.5,
                 fontface = "italic",
                 angle_calc = "along",
                 label_dodge = unit(2, 'mm'),
                 label_colour = "grey20") +
  geom_node_point(aes(color = type), size = 12) +
  geom_node_text(aes(label = label),
                 fontface = "bold",
                 size = 4,
                 color = "black") +
  scale_color_manual(values = c(
    "Input" = "lightblue",
    "Intermediate" = "orange",
    "Output" = "tomato"
  )) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  )


# --- Nodes ---
nodes5 <- tibble(
  name = c(
    "pumpen_minimal.geojson",
    "df_merged_sum.csv",
    "pumpen_ok",
    "trees_sf (WGS84)",
    "trees_proj (UTM33)",
    "pumpen_proj (UTM33)",
    "trees+distanz.csv",
    "trees+buffer.csv"
  ),
  label = c(
    "Pumpen minimal",
    "Bäume Sum",
    "Pumpen OK",
    "Trees sf",
    "Trees proj",
    "Pumpen proj",
    "Trees+Distanz",
    "Trees+Buffer"
  ),
  type = c(
    "GeoJSON", "CSV", "Intermediate", "Intermediate",
    "Intermediate", "Intermediate", "Output", "Output"
  )
)

# --- Edges ---
edges5 <- tibble(
  from = c(
    "pumpen_minimal.geojson",
    "df_merged_sum.csv",
    "pumpen_ok",
    "trees_sf (WGS84)",
    "trees_proj (UTM33)",
    "pumpen_proj (UTM33)",
    "trees+distanz.csv"
  ),
  to = c(
    "pumpen_ok",
    "trees_sf (WGS84)",
    "pumpen_proj (UTM33)",
    "trees_proj (UTM33)",
    "trees+distanz.csv",
    "trees+distanz.csv",
    "trees+buffer.csv"
  ),
  connection = c(
    "filter(status=='ok')",
    "st_as_sf()",
    "st_transform(32633)",
    "st_transform(32633)",
    "st_nn() -> distanz",
    "st_nn() -> distanz",
    "st_buffer(100m) + st_intersects()"
  )
)

# --- Graph ---
g5 <- graph_from_data_frame(d = edges5, vertices = nodes5, directed = TRUE)

coords5 <- layout_with_fr(g5) * 0.5

ggraph(g5, layout = coords5) +
  geom_edge_link(aes(label = connection),
                 arrow = arrow(length = unit(6, 'mm'), type = "closed"),
                 end_cap = circle(8, 'mm'),
                 start_cap = circle(8, 'mm'),
                 label_size = 3.2,
                 fontface = "italic",
                 angle_calc = "along",
                 label_dodge = unit(2.5, 'mm'),
                 label_colour = "grey20") +
  geom_node_point(aes(color = type), size = 12) +
  geom_node_text(aes(label = label),
                 fontface = "bold",
                 size = 4,
                 color = "black") +
  scale_color_manual(values = c(
    "GeoJSON" = "lightblue",
    "CSV" = "lightgreen",
    "Intermediate" = "orange",
    "Output" = "tomato"
  )) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  )


# --- Nodes ---
nodes6 <- tibble(
  name = c(
    "lor_wfs",
    "trees_csv_in",
    "trees_sf",
    "trees_with_lor",
    "trees_with_lor.geojson",
    "trees_with_lor.csv"
  ),
  label = c(
    "LOR WFS",
    "Trees CSV",
    "Trees sf",
    "Trees+LOR",
    "Trees LOR GeoJSON",
    "Trees LOR CSV"
  ),
  type = c(
    "GeoJSON", "CSV", "Intermediate", "Intermediate", "Output", "Output"
  )
)

# --- Edges ---
edges6 <- tibble(
  from = c(
    "lor_wfs",
    "trees_csv_in",
    "trees_sf",
    "trees_with_lor",
    "trees_with_lor"
  ),
  to = c(
    "trees_sf",
    "trees_sf",
    "trees_with_lor",
    "trees_with_lor.geojson",
    "trees_with_lor.csv"
  ),
  connection = c(
    "st_transform(4326)",
    "clean coords -> st_as_sf()",
    "st_join(lor, st_within)",
    "st_write()",
    "write.csv2()"
  )
)

# --- Graph ---
g6 <- graph_from_data_frame(d = edges6, vertices = nodes6, directed = TRUE)

coords6 <- layout_with_fr(g6) * 0.6

ggraph(g6, layout = coords6) +
  geom_edge_link(aes(label = connection),
                 arrow = arrow(length = unit(6, 'mm'), type = "closed"),
                 end_cap = circle(8, 'mm'),
                 start_cap = circle(8, 'mm'),
                 label_size = 3.2,
                 fontface = "italic",
                 angle_calc = "along",
                 label_dodge = unit(2.5, 'mm'),
                 label_colour = "grey20") +
  geom_node_point(aes(color = type), size = 12) +
  geom_node_text(aes(label = label),
                 fontface = "bold",
                 size = 4,
                 color = "black") +
  scale_color_manual(values = c(
    "GeoJSON" = "lightblue",
    "CSV" = "lightgreen",
    "Intermediate" = "orange",
    "Output" = "tomato"
  )) +
  theme_void() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank()
  )

