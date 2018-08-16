# gssurgo_data

[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

The `gSSURGO` data product contains multiple text format datasets referenced to a single raster grid. The raster grids are contained within file geodatabase archives and  can only be extracted using ArcGIS (using the fileGDB driver).

Much of the operation of this repo is facilitated by the `gssurgo` python package.

## Prereqs

* Download zip files from: https://nrcs.app.box.com/v/soils

* Have the `arcpy` python module available for the intial `tif` extraction step

* Have the `ogr2ogr` command available and working with the `GPKG` driver

* Have the python modules listed in [environment.yml](environment.yml) installed. If using Anaconda, make sure you have the **64bit** version. You can install an Anaconda virtual environment with:

```
conda env create -n gSSURGO -f environment.yml
source activate gSSURGO
```

## Usage

### 1. Extract tifs and build gpkgs

`make all`

### 2. Pull a specific variable and merge with corresponding tif

Compose an SQL query that give a two column result of `mukey` and `some_variable`. For example, `'SELECT mukey, nonirryield_r FROM mucropyld WHERE (cropname = "Corn")'`. Pass this query to `query_gpkg.py` along with a bounding box given by `xmax`, `xmin`, `ymin`, `ymax`. For example, the following call produces a tif or non irrigated corn yields clipped to the defined bounding box:

```
python query_gpkg.py gSSURGO_MI.gpkg 'SELECT mukey, nonirryield_r FROM mucropyld WHERE (cropname = "Corn")' tifs/gSSURGO_MI.tif 935594 925029.1 2214590 2225584 tests/nonirryield_r.tif
```

### 3. Visualize output

Pass the name of an output tif to `viz_numeric_output.py`:

```
python viz_numeric_output.py tests/nonirryield_r.tif tests/nonirryield_r.png
```

![](tests/nonirryield_r.png)

