# https://ncss-tech.github.io/AQP/soilDB/gSSURGO-SDA.html

library(raster)
library(foreign)
library(dplyr)

# load exported gSSURGO chunk, cell values are NOT map unit keys
r <- raster("tifs/gSSURGO_MI.tif")

# generate a RAT via raster package functionality
r <- ratify(r)

# extract RAT to a data.frame
rat <- levels(r)[[1]]


# load ESRI-specific RAT, generated when gSSURGO was exported
mu <- read.dbf("tifs/gSSURGO_MI.tif.vat.dbf", as.is=TRUE)

# re-name the first coulmn to match our new RAT
names(mu)[1] <- 'ID'

# convert map unit keys from character to integer
mu$MUKEY <- as.integer(mu$MUKEY)

# join map unit keys to gSSURGO integer indices
rat.new <- left_join(rat, mu, by='ID')

# over-write original RAT with new one, containing map unit keys
levels(r) <- rat.new

# make a new raster, this time with map unit keys used as the cell values
r.mu <- deratify(r, att='MUKEY')