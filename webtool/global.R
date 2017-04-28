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
# global.R
# -------------------------------------------------------------------------

# libraries ---------------------------------------------------------------

rm(list = ls())
require(raster)
require(rgdal)
require(shiny)
require(shinyBS)
require(shiny)
require(ggplot2)
require(plotly)
require(viridis)
require(dplyr)
require(data.table)
require(jsonlite)
require(geojsonio)
require(shinydashboard)
require(leaflet) 
require(mapview)

# <-- Load DB info --------------------------------------------------------

source("scripts/db_access.R")
source("scripts/db_operations.R")

# <-- Process DB info -----------------------------------------------------

source("scripts/eng_measures_analisys.R")
source("scripts/ElectricalGrid_analysis.R")
source("scripts/LandTransportation_analysis.R")


# <-- GeoJSON functions ---------------------------------------------------

source("scripts/GeoJSON_functions.R")

# <-- Load EWE data -------------------------------------------------------

ewes <- as.data.table(dplyr::collect(t.ewes))


# <-- Load Return Times ---------------------------------------------------

rt.intensity <- fread("data/return_values_Pontebba_1hour_intensity.csv")
rt.intensity[, c("intensity lower 95% confidence interval",
                 "intensity upper 95% confidence interval") := NULL]
rt.intensity.aux <- fread("data/climate_change_1hour_intensity_rcp85.csv")
rt.intensity <- merge(rt.intensity, rt.intensity.aux, by = "return period in years")
setnames(rt.intensity, 
         c("return period in years", "intensity [mm/hour]", "change in percent"),
         c("rt", "value", "change"))
rt.intensity[, end21st := value*(1 + change/100)]

rt.cumulative <- fread("data/return_values_Pontebba_7day_cumulative.csv")
rt.cumulative.aux <- fread("data/climate_change_7day_cumulative_rcp85.csv")
rt.cumulative[, c("cumulative lower 95% confidence interval",
                  "cumulative upper 95% confidence interval") := NULL]
rt.cumulative <- merge(rt.cumulative, rt.cumulative.aux, by = "return period in years")
setnames(rt.cumulative, 
         c("return period in years", "cumulative [mm/week]", "change in percent"),
         c("rt", "value", "change"))
rt.cumulative[, end21st := value*(1 + change/100)]

get.rt <- function(ewe.value, ewe = c("intensity", "cumulative")) {
  data <- switch(ewe,
                 intensity = rt.intensity,
                 cumulative = rt.cumulative,
                 stop("ewe not recognised"))
  rt.max <- paste0("more than ", data[, max(rt)])
  rt <- data[value > ewe.value, rt][1]
  if (is.na(rt)) {
    rt <- rt.max
  } else {
    rt <- paste0("less than ", rt)
  }
  rt.end21st <- data[end21st > ewe.value, rt][1]
  if (is.na(rt.end21st)) {
    rt.end21st <- rt.max
  } else {
    rt.end21st <- paste0("less than ", rt.end21st)
  }
  return(list(value = rt, end21st = rt.end21st))
}
# <-- Consequences assessment ---------------------------------------------
marginal.thr <- 0.005

# <-- Load Landslide data -------------------------------------------------

region.filename.path <- "data"
region.filename.initial <- "landslide_initial"
region.landslide.initial <- setorder(as.data.table(dplyr::collect(t.region.landslide)), id)

library(h2o)
h2o.init()

# Load h2o model
p.landslide.load.model <- function(model.path){
  path. <- file.path(model.path, dir(model.path)[1])
  model.id <- h2o.loadModel(path.)
  return(model.id)
}

# Compute h2o model data
p.landslide.compute.modeldata <- function(model) {
  data.plot <- expand.grid(seq(0, 700, by = 10), seq(0, 60,  by = 1))
  names(data.plot) <- c("cumulative", "intensity")
  
  data.plot.hex <- as.h2o(data.plot,"data.plot.hex")
  pred <- as.data.frame(h2o.predict(model, data.plot.hex))  
  
  data.plot$probability <- pred$p1
  return(data.plot)
}

# Compute h2o model
p.landslide.compute.model <- function(model.input, model.name, 
                                      model.filename.path = "data",
                                      updateProgress = NULL){
  if (is.function(updateProgress)) {
    updateProgress(value = 1/5)
  }
  
  model.input[, occurrence := factor(occurrence)]
  landslides.hex <- as.h2o(model.input,"landslides.hex")
  model <- h2o.naiveBayes(x = 1:2, y = 3, training_frame = landslides.hex, laplace = 3)
  
  if (is.function(updateProgress)) {
    updateProgress(value = 2/5)
  }
  
  filename.path <- model.filename.path
  filename <- gsub(pattern = " ", replacement = "_", x = model.name)
  saveRDS(model.input, file = file.path(filename.path, paste0(filename, ".rds")))
  
  if (is.function(updateProgress)) {
    updateProgress(value = 4/5)
  }
  
  aa <- h2o.saveModel(model, path = file.path(filename.path, paste0(filename, "_model")))
  
  if (is.function(updateProgress)) {
    updateProgress(value = 4/5)
  }
  
  model.data <- p.landslide.compute.modeldata(model)
  saveRDS(model.data, file = file.path(filename.path, paste0(filename, "_model_data.rds")))
  
  insert.region.landslide(dbRAIN$con, filename = filename, name = model.name)
  
  if (is.function(updateProgress)) {
    updateProgress(value = 5/5)
  }
  return(1)
}

probabilities.initialize <- function(){
  data.pred <- data.frame(cumulative = 0, 
                          intensity = 0)
  data.pred.hex <- as.h2o(data.pred,"data.pred.hex")
  model_ <- p.landslide.load.model(file.path(region.filename.path, 
                                             paste0(region.filename.initial,
                                                    "_model")))
  pred <- as.data.frame(h2o.predict(model_, data.pred.hex))  
  return(pred)
}

# <-- Load towns ----------------------------------------------------------

towns <- data.table(name = c("Pontebba", "Malborghetto", "Valbruna", 
                             "Pontebba's Train Station", "(none)"),
                    stations = c("S3hhm", "S07mm", "Sem25", "S4hhm", ""))

# <-- Load Building Information -------------------------------------------

buildings <- fread("data/building_information.csv")

bu.dict <- list( "1" = "Residential",
                 "2" = "Residential + Services",
                 "3" = "Services",
                 "4" = "Industrial",
                 "5" = "Public Services",
                 "6" = "Energy Distribution",
                 "7" = "Others")

bu.summary <- buildings[, .(People_max = sum(PEOPLE_MAX),
                            People_min = sum(PEOPLE_MIN)), 
                        by = "station"]
setorder(bu.summary, station)
bu.summary[, `:=`(People_max_perc = People_max/sum(People_max), 
                  People_min_perc = People_min/sum(People_min))]
bu.area.summary <- buildings[, .(Area_Total = sum(Area*NR_FLOORS)), 
                             by = c("station", "Use_Type")]
setorder(bu.area.summary, station)
bu.area.summary[, Label := as.character(bu.dict[Use_Type])]
bu.area.summary[, Area_Perc := Area_Total/sum(Area_Total)]
bu.area.summary[, Area_Perc_by_label := Area_Total/sum(Area_Total), by = Label]
bu.area.all <- bu.area.summary[, .("Area_Perc_by_label" = sum(Area_Perc),
                                   "Region" = "Valley"), by = Label]

# <-- Load susceptibility map ---------------------------------------------

susc.map <- raster("data/susceptibility_map_3857.tif")
susc.map <- aggregate(susc.map, fact = 3, fun = mean)
susc.pal <- colorNumeric(rev(viridis::inferno(5)), 1:6,
                         na.color = "transparent" )

# <-- Load Electrical Grid diagram ----------------------------------------
source("scripts/ElectricalGrid_analysis.R")

# <-- TOPO DATA : telco towers --------------------------------------------

telco.towers <- fread("data/Telco_towers.csv")
telco.towers <- telco.towers[, .(X, Y,  osm_id, man_made)]

# <-- TOPO DATA : electrical grid -----------------------------------------
#
data.path <- "data/"
data.file <- "Segments_Lines_FINAL.geojson"
topoData.Lines <- topoData.import(paste0(data.path, data.file))
data.file <- "Segments_LinesH_FINAL.geojson"
topoData.LinesH <- topoData.import(paste0(data.path, data.file))
data.file <- "Segments_Minor_FINAL.geojson"
topoData.LinesMinor <- topoData.import(paste0(data.path, data.file))

# >>> color by voltage ----------------------------------------------------

voltage <- c(-35, 60000, 132000)
pal <- leaflet::colorFactor("BuGn", 
                            c("-10000","-1000","-100", levels(factor(voltage))))

# Add a properties$style list to each feature
topoData.Lines$features <- topoData.setColor.single(topoData.Lines, pal(60000))
topoData.LinesH$features <- topoData.setColor.single(topoData.LinesH, pal(132000))
topoData.LinesH$features <- topoData.setProperties.duplicateFeature(topoData.LinesH,
                                                                    "region", "line_name")
topoData.LinesMinor$features <- topoData.setColor.single(topoData.LinesMinor, 
                                                         pal(-35))
topoData.LinesMinor$features <- topoData.setProperties.duplicateFeature(topoData.LinesMinor,
                                                                        "region", "line_name")

# >>> color by line_name/region -------------------------------------------

# topoData.Lines$features <- topoData.setColor.factorFeature(topoData.Lines, "line_name" )
# topoData.LinesH$features <- topoData.setColor.factorFeature(topoData.LinesH, "line_name")
# topoData.LinesMinor$features <- topoData.setColor.factorFeature(topoData.LinesMinor, "line_name")


# <-- TOPO DATA : electrical grid Towers ----------------------------------

grid.stations <- get.grid.stations()
grid.stations[, `:=`(lng = x, lat = y)]

grid.lines <- get.grid.lines()

grid.lines.aux <- get.grid.towers.per.line()
setnames(grid.lines.aux, c("label_line", "n"), c("label", "num_towers"))

grid.lines <- merge(grid.lines, grid.lines.aux, by = "label")
grid.lines.aux <- NULL

# <-- TOPO DATA: Land Transportation --------------------------------------

railway <- topoData.import(paste0(data.path, "Railway.geojson"))
railway.bridges <- topoData.import(paste0(data.path, "Railway_bridges.geojson"))
railway.tunnels <- topoData.import(paste0(data.path, "Railway_tunnels.geojson"))

railway$features <- topoData.setPopup.single(railway, "Railway")
railway.bridges$features <- topoData.setProperties.duplicateFeatureAdd(railway.bridges, 
                                                                       oldFeatureName = "Label",
                                                                       newFeatureName = "popup",
                                                                       add = "Railway Bridge: ")
railway.tunnels$features <- topoData.setProperties.duplicateFeatureAdd(railway.tunnels, 
                                                                       oldFeatureName = "Label",
                                                                       newFeatureName = "popup",
                                                                       add = "Railway Tunnel: ")
road.SS13         <- topoData.import(paste0(data.path, "Road_SS13.geojson"))
road.SS13.bridges <- topoData.import(paste0(data.path, "Road_SS13_bridges.geojson"))
road.SS13.tunnels <- topoData.import(paste0(data.path, "Road_SS13_tunnels.geojson"))

road.SS13$features <- topoData.setPopup.single(road.SS13, "Road SS13")
road.SS13.bridges$features <- topoData.setProperties.duplicateFeatureAdd(road.SS13.bridges, 
                                                                         oldFeatureName = "Label",
                                                                         newFeatureName = "popup",
                                                                         add = "Road SS13 Bridge: ")
road.SS13.tunnels$features <- topoData.setProperties.duplicateFeatureAdd(road.SS13.tunnels, 
                                                                         oldFeatureName = "Label",
                                                                         newFeatureName = "popup",
                                                                         add = "Road SS13 Tunnel: ")
road.A23         <- topoData.import(paste0(data.path, "Road_A23.geojson"))
road.A23.bridges <- topoData.import(paste0(data.path, "Road_A23_bridges.geojson"))
road.A23.tunnels <- topoData.import(paste0(data.path, "Road_A23_tunnels.geojson"))

road.A23$features <- topoData.setPopup.single(road.A23, "Road A23")
road.A23.bridges$features <- topoData.setProperties.duplicateFeatureAdd(road.A23.bridges, 
                                                                        oldFeatureName = "Label",
                                                                        newFeatureName = "popup",
                                                                        add = "Road A23 Bridge: ")
road.A23.tunnels$features <- topoData.setProperties.duplicateFeatureAdd(road.A23.tunnels, 
                                                                        oldFeatureName = "Label",
                                                                        newFeatureName = "popup",
                                                                        add = "Road A23 Tunnel: ")

land.elements <- data.table(Name = character(),
                            `Road/Railway Name` = character(),
                            `Element type` = character(),
                            `Road/Railway` = character())

aux.tunnels <- unlist(lapply(road.A23.tunnels[[3]], function(x) x$properties$Label))
land.elements <- rbindlist(list(land.elements, 
                                data.table(Name = aux.tunnels,
                                           `Road/Railway Name` = "A23",
                                           `Element type` = "tunnel",
                                           `Road/Railway` = "road")))

aux.bridges <- unlist(lapply(road.A23.bridges[[3]], function(x) x$properties$Label))
land.elements <- rbindlist(list(land.elements, 
                                data.table(Name = aux.bridges,
                                           `Road/Railway Name` = "A23",
                                           `Element type` = "bridge",
                                           `Road/Railway` = "road")))
aux.tunnels <- unlist(lapply(road.SS13.tunnels[[3]], function(x) x$properties$Label))
land.elements <- rbindlist(list(land.elements, 
                                data.table(Name = aux.tunnels,
                                           `Road/Railway Name` = "SS13",
                                           `Element type` = "tunnel",
                                           `Road/Railway` = "road")))

aux.bridges <- unlist(lapply(road.SS13.bridges[[3]], function(x) x$properties$Label))
land.elements <- rbindlist(list(land.elements, 
                                data.table(Name = aux.bridges,
                                           `Road/Railway Name` = "SS13",
                                           `Element type` = "bridge",
                                           `Road/Railway` = "road")))
aux.tunnels <- unlist(lapply(railway.tunnels[[3]], function(x) x$properties$Label))
land.elements <- rbindlist(list(land.elements, 
                                data.table(Name = aux.tunnels,
                                           `Road/Railway Name` = "Railway",
                                           `Element type` = "tunnel",
                                           `Road/Railway` = "Railway")))

aux.bridges <- unlist(lapply(railway.bridges[[3]], function(x) x$properties$Label))
land.elements <- rbindlist(list(land.elements, 
                                data.table(Name = aux.bridges,
                                           `Road/Railway Name` = "Railway",
                                           `Element type` = "bridge",
                                           `Road/Railway` = "Railway")))

# TODO : keep only trans.elements instead of land.elements
trans.elements <- as.data.table(get.trans.elements(id_land_transportation = 1))
