# -------------------------------------------------------------------------
# Risk Assessment Tool 
# 
# Tool developed within the "Risk Analysis of Infrastructure Networks in 
# response to extreme weather" (RAIN) FP7 European project (rain-project.eu) 
# by Grupo AIA (www.aia.es).
# 
# Authors: 
# -- xclotet (clotetx@aia.es) @xclotet
# -- mhalat  (halatm@aia.es)
# 
# -------------------------------------------------------------------------
#
#######################################################
# scripts/db_access.R
# 
# 
#######################################################

# Initialization --------------------------------------
require(RPostgreSQL)
require(dplyr)
require(data.table)

source("../scripts/db_hidden_access.R")
dbRAIN <- src_postgres_get()

t.grid <- tbl(dbRAIN, "grid")
t.grid.stations <- tbl(dbRAIN, "grid_stations")
t.grid.stations.susc <- tbl(dbRAIN, "grid_stations_susc")
t.grid.stations.status <- tbl(dbRAIN, "grid_stations_status")
t.grid.lines <- tbl(dbRAIN, "grid_lines")
t.grid.towers <- tbl(dbRAIN, "grid_towers")
t.grid.towers.status <- tbl(dbRAIN, "grid_towers_status")
t.grid.towers.susc <- tbl(dbRAIN, "grid_towers_susc")
t.region.map <- tbl(dbRAIN, "region_map")
t.region.landslide <- tbl(dbRAIN, "region_landslide")
t.trans.elements <- tbl(dbRAIN, "trans_elements")
t.trans.elements.status <- tbl(dbRAIN, "trans_elements_status")
t.trans.elements.susc <- tbl(dbRAIN, "trans_elements_susc")

t.elements      <- tbl(dbRAIN, "elements")
t.type.element  <- tbl(dbRAIN, "type_element")

t.eng.measures  <- tbl(dbRAIN, "eng_measures")

t.ewes <- tbl(dbRAIN, "ewes")

t.cases <- tbl(dbRAIN, "cases")
t.cases.ewe <- tbl(dbRAIN, "cases_ewe")
t.cases.towers.status <- tbl(dbRAIN, "cases_towers_status")