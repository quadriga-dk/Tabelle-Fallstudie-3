# --- pumpen minimieren ---
pumpen_full <- st_read("data/pumpen.geojson")

pumpen <- pumpen_full %>%
  select(pump, pump.style, geometry, man_made, id)

st_write(pumpen, "data/pumpen_minimal.geojson",
         driver = "GeoJSON", delete_dsn = TRUE)