# ---- setup ----
library(sf)
library(dplyr)
library(tidyr)
library(mapview)

county_sf <- st_as_sf(maps::map("county", fill = TRUE, plot = FALSE))
county_sf <- tidyr::separate(county_sf, ID, c("state", "county"))
county_test <- filter(county_sf, state == "michigan", county == "ingham")

county_test <- st_transform(county_test, crs = 42303)

bbox <- st_bbox(county_test)

shrink_bbox <- function(bbox, fact = 2){
  bbox[3] <- bbox[1] + ((bbox[3] - bbox[1]) / fact)
  bbox[4] <- bbox[2] + ((bbox[4] - bbox[2]) / fact)
  bbox
}

bbox <- st_as_sfc(shrink_bbox(bbox))

# ----  inspect_poly ----
gdb <- "gSSURGO_MI.gdb"
# st_layers(gdb)

mupolygon <- st_read(gdb, "MUPOLYGON")

mu_intersects <- unlist(lapply(
  st_intersects(mupolygon, bbox), function(x) length(x) > 0))
mupolygon <- mupolygon[mu_intersects,]

mapview(mupolygon)
