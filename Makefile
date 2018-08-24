zips = $(wildcard zips/*.zip)
gdbs = $(patsubst zips/%.zip, gdbs/%, $(zips))
tifs = $(patsubst gdbs/%.gdb, tifs/%.tif, $(gdbs))
gpkgs = $(patsubst gdbs/%.gdb, gpkgs/%.gpkg, $(gdbs))

# ME, CT, IL, IN, IA, MN, MO, NH, VT, MA, MI, NJ, NY, OH, PA, RI, WI}

.PHONY: all test tifs clean example reset

test: test_makefile test_query test_gssurgo

test_makefile:
	@echo $(gdbs)
	@echo $(tifs)
	@echo $(gpkgs)

all: $(gdbs) $(tifs) $(gpkgs)

gdbs: $(gdbs)

gdbs/%.gdb: zips/%.gdb.zip
	-unzip -u $< -d gdbs

tifs/%.tif: gdbs/%.gdb
	-extract_gssurgo_tif $</MapunitRaster_10m $@	

gpkgs/%.gpkg: gdbs/%.gdb
	-ogr2ogr -progress -f GPKG $@ $<
	-ogr2ogr -update -f GPKG $@ $<

clean:	
	-rm -rf $(gdbs)	

reset: 
	-rm $(tifs)
	-rm -rf $(gdbs)
	-rm -rf $(gpkgs)
	-rm tifs/*.tfw tifs/*.ovr tifs/*.xml tifs/*.cpg tifs/*.dbf

test_query:
	Rscript tests/make_gpkg.R
	python query_gpkg.py tests/test.gpkg 'SELECT * FROM dt' tests/r1.tif 5 0 5 10 tests/dt.tif

test_gssurgo:
	python query_gpkg.py gSSURGO_MI.gpkg 'SELECT mukey, nonirryield_r FROM mucropyld WHERE (cropname = "Corn")' tifs/gSSURGO_MI.tif 935594 925029.1 2214590 2225584 tests/nonirryield_r.tif

example_kwfact: # erodability factor adjusted for rock fragments
	python query_gpkg.py gSSURGO_MI.gpkg 'SELECT mukey, AVG(kwfact) AS kwfact FROM (SELECT TBL_LEFT.mukey AS mukey, TBL_LEFT.cokey AS cokey, TBL_LEFT.majcompflag AS majcompflag, TBL_RIGHT.hzname AS hzname, TBL_RIGHT.kwfact AS kwfact FROM (SELECT mukey AS mukey, cokey AS cokey, majcompflag AS majcompflag FROM component) AS TBL_LEFT LEFT JOIN (SELECT hzname AS hzname, kwfact AS kwfact, cokey AS cokey FROM chorizon) AS TBL_RIGHT ON (TBL_LEFT.cokey = TBL_RIGHT.cokey)) WHERE (majcompflag = "Yes") GROUP BY mukey' tifs/gSSURGO_MI.tif 967288.6 925029.1 2214590.5 2258563.5 examples/kwfact.tif
