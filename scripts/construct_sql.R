library(dplyr)
library(magrittr)

# ---- test_gssurgo ----
gpkg <- "gSSURGO_MI.gpkg"
con <- src_sqlite(gpkg)
# src_tbls(con)

tbl(con, "mucropyld") %>%
  filter(cropname == "Corn") %>%
  select(mukey, nonirryield_r) %>%
  filter(mukey %in% 186214:267366) %>%
  show_query()

# ---- test_query ----

gpkg <- "tests/test.gpkg"
con <- src_sqlite(gpkg)
src_tbls(con)

tbl(con, "dt") %>%
  show_query()

# ---- example_kwfact ----
gpkg <- "/home/jose/Dropbox/Data/gSSURGO/gpkgs/gSSURGO_MI.gpkg"
con  <- src_sqlite(gpkg)
# src_tbls(con)

tbl(con, "component") %>%
  select(mukey, cokey, majcompflag) %>%
  left_join(tbl(con, "chorizon") %>%
              select(hzname, kwfact, cokey)) %>%
  filter(hzname == "A", majcompflag == "Yes") %>%
  group_by(mukey) %>%
  summarize(kwfact = mean(kwfact, na.rm = TRUE)) %>%
  dbplyr::sql_render() %>%
  stringr::str_replace_all(c("`" = "", "\n" = " ")) %>%
  cat()

# ---- example_pwsl1pomu ----

tbl(con, "Valu1") %>%
  select(mukey, pwsl1pomu) %>%
  dbplyr::sql_render() %>%
  stringr::str_replace_all(c("`" = "", "\n" = " ")) %>%
  cat()