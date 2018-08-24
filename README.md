# gssurgo_data

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

This repo is a demonstration workflow using the `gssurgo` python package. 

## Prereqs

* Download zip files from: https://nrcs.app.box.com/v/soils

* Have the `arcpy` python module available for the intial `tif` extraction step

* Install the dependencies for the `gssurgo` python package. If using Anaconda, make sure you have the **64bit** version. You can install an Anaconda virtual environment with:

```
conda env create -n gssurgo -f environment.yml
source activate gssurgo
```

## Usage

### 1. Extract tifs and build gpkgs

`make all`

### 2. Extract Area of Interest (AOI) raster(s)

```
import gssurgo
gssurgo.aoi(in_raster_path = "tifs", out_raster = "tests/aoi.tif", xmax = -88.34945, xmin = -88.35470, ymin = 38.70095, ymax = 38.70498)
```

### 2. Pull a specific variable and merge with corresponding tif

Compose an SQL query that give a two column result of `mukey` and `some_variable`. For example, `"SELECT mukey, pwsl1pomu FROM Valu1"`. 

```
gssurgo.query_gpkg(src_tif = "tests/aoi.tif", gpkg_path = "gpkgs", sql_query = "SELECT mukey, pwsl1pomu FROM Valu1", out_raster = "tests/aoi_results.tif")    
```

### 3. Visualize output

```
gssurgo.viz_numeric_output("tests/aoi_results.tif", "tests/aoi_results.png")
```

![](tests/aoi_results.png)
