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
# scripts/db_operations.R
# 
# 
#######################################################

if (!exists("dbRAIN")) {
  source("scripts/db_access.R")
}

# Available Tables --------------------------------------------------------
# 
#    _Config
#    t.grid
#    t.grid.stations
#    t.grid.stations.susc
#    t.grid.stations.status
#    t.grid.lines
#    t.grid.towers
#    t.grid.towers.status 
#    t.grid.towers.susc
#    t.trans.elements
#    t.trans.elements.status
#    t.trans.elements.susc
#    
#    t.region.map
#    t.region.landslide
#    t.type_element
#    t.elements
#    t.eng.measures
#    
#    _EWEs
#    t.ewes
#    
#    _Cases
#    t.cases
#    t.cases.ewe
#    t.cases.towers.status


# Libraries ---------------------------------------------------------------

require(dplyr)
require(data.table)
require(tools)
require(DBI)


# General functions -------------------------------------------------------

# connection <- dbRAIN$con

# Insert function
db.insert <- function(connection, table, variables, values, verbose = F) {
  query <- paste0("INSERT INTO ", table, 
                  " (", paste(variables, collapse = ","),  ")", 
                  " VALUES ")
  vals  <- paste0("(",paste0( values, collapse = ","),")")
  dbSendQuery(connection, paste0(query, vals))
  if (verbose) {
    cat("-------------------------------------------\n")
    cat(paste0("Properly inserted into DB (", table, ")\n"))
  }
}
# test function:
# db.insert(dbRAIN$con, "grid", "name", "'Alpine Case'")

db.get.last.id <- function(connection, table) {
  query <- paste0("SELECT MAX(id) FROM ", table, ";")
  res <- dbGetQuery(connection, query)
  return(res$max)
}
# test function:
# db.get.last.id(dbRAIN$con, "grid")

# Set ---------------------------------------------------------------------

insert.grid <- function(connection, grid_name){
  db.insert(connection, "grid", "name", paste0("'", grid_name, "'"))
}

insert.grid.stations <- function(connection, stations_data, grid_id = NULL) {
  table. <- "alpine.grid_stations"
  variables <- c("id_grid", "name", "name_extra", "group_", "x", "y", 
                 "color_background", "color_border")
  st_data <- copy(stations_data)
  st_data[, group := paste0("'", group, "'")]
  st_data[, id    := paste0("'", id, "'")]
  st_data[, name  := paste0("'", name, "'")]
  
  if (is.null(grid_id)) {
    grid_id <- db.get.last.id(connection, "grid")
  }
  
  for (i in seq(1, dim(st_data)[1])) {
    values <- paste0(c(grid_id, 
                       st_data[i, 
                               .SD, 
                               .SDcols = c("id", "name", "group", "X", "Y", 
                                           "color.background", "color.border")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
  }
}

insert.grid.stations.status <- function(connection, grid.stations, 
                                        grid_id = NULL) {
  table. <- "grid_stations_status"
  variables <- c("id_grid", "id_station", "type_", "id_type_element")
  for (id in grid.stations$id) {
    values <- c(1, as.integer(id), "'station'", 1)
    db.insert(connection, table., variables, values)
  }
}


update.grid.stations.color <- function(connection, stations_data, grid_id = NULL) {
  table. <- "alpine.grid_stations"
  st_data <- copy(stations_data)
  st_data[, id    := paste0("'", id, "'")]
  st_data[, color.background  := paste0("'", color.background, "'")]
  st_data[, color.border      := paste0("'", color.border, "'")]
  
  if (is.null(grid_id)) {
    grid_id <- db.get.last.id(connection, "grid")
  }
  
  for (i in seq(1, dim(st_data)[1])) {
    name <- st_data[i, id]
    values.1 <- st_data[i, color.background]
    values.2 <- st_data[i, color.border]
    
    query <- paste0("UPDATE ", table., " SET color_background = ", values.1, 
                    " WHERE name = ", name)
    dbSendQuery(connection, query)
    query <- paste0("UPDATE ", table., " SET color_border = ", values.2, 
                    " WHERE name = ", name)
    dbSendQuery(connection, query)
  }
}


insert.grid.lines <- function(connection, lines_data, grid_id = NULL) {
  table. <- "alpine.grid_lines"
  variables <- c("id_grid", "label", "group_", "from_", "to_")
  l_data <- copy(lines_data)
  l_data[, group := paste0("'", group, "'")]
  l_data[, label := paste0("'", label, "'")]
  l_data[, from  := paste0("'", from, "'")]
  l_data[, to    := paste0("'", to, "'")]
  
  if (is.null(grid_id)) {
    grid_id <- db.get.last.id(connection, "grid")
  }
  
  for (i in seq(1, dim(l_data)[1])) {
    values <- paste0(c(grid_id, 
                       l_data[i, 
                              .SD, 
                              .SDcols = c("label", "group", "from", "to")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
  }
}

insert.grid.towers.all <- function(connection, towers_data, grid_id = NULL) {
  table.    <- "alpine.grid_towers"
  variables <- c("id_grid", "label_line", "group_", "x", "y", 
                 "height", "slope", "land_type", "id_osm")
  
  table.status     <- "alpine.grid_towers_status"
  variables.status <- c("id_grid", "id_tower", "id_type_element", "type_")
  
  table.susc     <- "alpine.grid_towers_susc"
  variables.susc <- c("id_grid", "id_tower", "id_map", "susc")
  
  t_data <- copy(towers_data)
  t_data[, group := paste0("'", group, "'")]
  t_data[, power := paste0("'", power, "'")]
  t_data[, full_id  := paste0("'", full_id, "'")]
  t_data[, landType := paste0("'", landType, "'")]
  t_data[, region   := paste0("'", region, "'")]
  type_element <- 2
  id_map <- 1
  
  if (is.null(grid_id)) {
    grid_id <- db.get.last.id(connection, "grid")
  }
  
  for (i in seq(1, dim(t_data)[1])) {
    values <- paste0(c(grid_id, 
                       t_data[i, 
                              .SD, 
                              .SDcols = c("region", "group", "XCOORD", 
                                          "YCOORD", "X30n000e_20", 
                                          "malborghet", "landType",
                                          "osm_id")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
    id_tower <- db.get.last.id(connection, table.)
    values.status <- paste0(c(grid_id, id_tower, type_element,
                              t_data[i, power]),
                            collapse = ",")
    db.insert(connection, table.status, variables.status, values.status)
    values.susc <- paste0(c(grid_id, id_tower, id_map,
                            t_data[i, ifelse(is.na(susceptibi), 
                                             0, susceptibi)]),
                          collapse = ",")
    db.insert(connection, table.susc, variables.susc, values.susc)
  }
}



update.grid.towers.all <- function(connection, towers_data, grid_id = NULL) {
  table.    <- "alpine.grid_towers"
  
  t_data <- copy(towers_data)
  t_data[, full_id  := paste0("'", full_id, "'")]
  
  if (is.null(grid_id)) {
    grid_id <- db.get.last.id(connection, "grid")
  }
  
  for (i in seq(1, dim(t_data)[1])) {
    values <- t_data[i, 
                     .SD, 
                     .SDcols = c("full_id")]
    
    query <- paste0("UPDATE ", table., " SET id_osm = ", values, 
                    " WHERE id = ", i)
    dbSendQuery(connection, query)
  }
}

insert.region.landslide <- function(connection, filename, name = NULL){
  table. <- "region_landslide"
  variables <- c("name", "filename")
  filename <- file_path_sans_ext(filename)
  if (is.null(name)) {
    name <- filename
  }
  name <- paste0("'", name, "'")
  filename <- paste0("'", filename, "'")
  values <- c(name, filename)
  db.insert(connection, table., variables, values)
}


insert.trans.elements <- function(connection, land.elements, 
                                  land.transportation.id = NULL) {
  table. <- "alpine.trans_elements"
  variables <- c("id_land_transportation", "name", "way_name", 
                 "basic_element_type", "means_transportation", "segment_name")
  t_data <- copy(land.elements)
  t_data[, names(t_data) := lapply(.SD, function(x) paste0("'", x, "'"))]
  
  if (is.null(land.transportation.id)) {
    land.transportation.id <- db.get.last.id(connection, "land_transportation")
  }
  
  for (i in seq(1, dim(t_data)[1])) {
    values <- paste0(c(land.transportation.id, 
                       t_data[i, 
                              .SD, 
                              .SDcols = c("name", "way_name",
                                          "basic_element_type", 
                                          "means_transportation",
                                          "segment_name")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
  }
}

insert.trans.elements.status <- function(connection, land.elements.status, 
                                         land.transportation.id = NULL) {
  table. <- "alpine.trans_elements_status"
  variables <- c("id_land_transportation", "id_trans_elements", "id_type_element")
  t_data <- copy(land.elements.status)
  
  if (is.null(land.transportation.id)) {
    land.transportation.id <- db.get.last.id(connection, "land_transportation")
  }
  
  for (i in seq(1, dim(t_data)[1])) {
    values <- paste0(c(land.transportation.id, 
                       t_data[i, 
                              .SD, 
                              .SDcols = c("id_trans_elements",
                                          "id_type_element")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
  }
}

insert.trans.elements.susc <- function(connection, land.elements.susc, 
                                       land.transportation.id = NULL) {
  table. <- "alpine.trans_elements_susc"
  variables <- c("id_land_transportation", "id_trans_elements", "id_map", "susc")
  t_data <- copy(land.elements.susc)
  
  if (is.null(land.transportation.id)) {
    land.transportation.id <- db.get.last.id(connection, "land_transportation")
  }
  
  for (i in seq(1, dim(t_data)[1])) {
    values <- paste0(c(land.transportation.id, 
                       t_data[i, 
                              .SD, 
                              .SDcols = c("id_trans_elements",
                                          "id_map", "susc")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
  }
}

# test eng.measures data.table:
eng.measures <- data.table(id_element = 1, 
                           id_type_element = 0, 
                           name = "Test Measure Station", 
                           description = "Superinvestment in any kind of station.",
                           improvement = 0.5, 
                           cost_improvement = 100000)


insert.eng.measures <- function(connection, eng.measures) {
  table. <- "eng_measures"
  variables <- c("id_element", "id_type_element", 
                 "name", "description",
                 "improvement", "cost_improvement")
  eng.measures[, name        := paste0("'", name, "'")]
  eng.measures[, description := paste0("'", description, "'")]
  for (i in 1:dim(eng.measures)[1]) {
    values <- paste0(c(eng.measures[i , 
                                    .SD, 
                                    .SDcols = c("id_element", "id_type_element", 
                                                "name", "description",
                                                "improvement", 
                                                "cost_improvement")]),
                     collapse = ",")
    db.insert(connection, table., variables, values)
  }
}


# Get ---------------------------------------------------------------------

# get by grid_id ....

get.grid.lines <- function(id_grid. = 1){
  return(as.data.table(collect(filter(t.grid.lines, id_grid == id_grid.))))
}

get.grid.stations <- function(id_grid){
  return(as.data.table(collect(filter(t.grid.stations, id_grid == id_grid))))
}

get.grid.stations.susc <- function(id_grid, id_map){
  return(as.data.table(collect(filter(t.grid.stations.susc, 
                                      id_grid == id_grid,
                                      id_map  == id_map))))
}

get.grid.stations.status <- function(id_grid, id_map){
  return(as.data.table(collect(filter(t.grid.stations.status, 
                                      id_grid == id_grid))))
}


get.grid.lines <- function(id_grid){
  return(as.data.table(collect(filter(t.grid.lines, id_grid == id_grid))))
}

get.grid.towers <- function(id_grid. = 1, label_line. = NULL){
  if (is.null(label_line.)) {
    return(as.data.table(collect(filter(t.grid.towers, id_grid == id_grid.))))
  } else if (length(label_line.) == 1) {
    return(as.data.table(collect(dplyr::filter(t.grid.towers, 
                                               id_grid == id_grid. & label_line == label_line.))))
  } else {
    return(as.data.table(collect(dplyr::filter(t.grid.towers, 
                                               id_grid == id_grid. & (label_line %in% label_line.)))))
  }
}

get.grid.towers.per.line <- function(id_grid. = 1){
  return(as.data.table(filter(t.grid.towers, id_grid == id_grid.) %>% 
                         select(label_line) %>% collect() %>% count(label_line)))
}

get.grid.towers.status <- function(id_grid., id_case = NULL){
  # id_case == NULL => initial condition
  if (is.null(id_case)) {
    return(as.data.table(collect(dplyr::filter(t.grid.towers.status, 
                                               id_grid == id_grid.))))
  } else {
    return(as.data.table(collect(dplyr::filter(t.cases.towers.status, 
                                               id_grid == id_grid., 
                                               id_case == id_case))))
  }
}

get.grid.towers.susc <- function(id_grid, id_map){
  return(as.data.table(collect(filter(t.grid.towers.susc, 
                                      id_grid == id_grid,
                                      id_map  == id_map))))
}

get.grid.towers.to.improve <- function(id_grid = 1, id_case = NULL, id_map = 1,
                                       label_line = NULL){
  grid.towers <- get.grid.towers(id_grid. = id_grid, label_line. = label_line)[, id_tower := id]
  setkey(grid.towers, id_tower)
  grid.towers.status <- get.grid.towers.status(id_grid)[, id_grid := NULL]
  grid.towers.susc   <- get.grid.towers.susc(id_grid, id_map)[, id_grid := NULL]
  grid.towers <- merge(grid.towers, grid.towers.susc) 
  grid.towers <- merge(grid.towers, grid.towers.status)
  grid.towers[, c("x", "y", "height", "slope", "land_type", "id_osm",
                  "id_map", "type_") := NULL]
  return(grid.towers)
}

get.grid.towers.all <- function(id_grid = 1, id_case, id_map = 1){
  grid.towers <- get.grid.towers(id_grid)[, id_tower := id]
  setkey(grid.towers, id_tower)
  grid.towers.status <- get.grid.towers.status(id_grid)[, id_grid := NULL]
  grid.towers.susc   <- get.grid.towers.susc(id_grid, id_map)[, id_grid := NULL]
  grid.towers <- merge(grid.towers, grid.towers.susc) 
  grid.towers <- merge(grid.towers, grid.towers.status)
  return(grid.towers)
}

get.grid.towers.initial <- function(id_grid, id_map = 1){
  return(get.grid.towers.all(id_grid, id_case = NULL, id_map = id_map))
}

get.elements <- function(id. = NULL) {
  if (is.null(id.)) {
    return(as.data.table(collect(t.elements)))
  } else if (length(id.) > 1) {
    return(as.data.table(collect(dplyr::filter(t.elements, 
                                               id %in% id.))))
  } else {
    return(as.data.table(collect(dplyr::filter(t.elements, 
                                               id == id.))))
  }
}

get.type.element <- function(id. = NULL) {
  # print(paste0(">>>>> id. value: ", id.))
  if (is.null(id.)) {
    return(as.data.table(collect(t.type.element)))
  } else if (length(id.) > 1) {
    return(as.data.table(collect(dplyr::filter(t.type.element, 
                                               id %in% id.))))
  } else {
    return(as.data.table(collect(dplyr::filter(t.type.element, 
                                               id == id.))))
  }
}

get.trans.elements <- function(id_land_transportation){
  return(as.data.table(collect(filter(t.trans.elements, 
                                      id_land_transportation == id_land_transportation))))
}

get.trans.elements.susc <- function(id_land_transportation, id_map){
  return(as.data.table(collect(filter(t.trans.elements.susc, 
                                      id_land_transportation == id_land_transportation,
                                      id_map  == id_map))))
}

get.trans.elements.status <- function(id_land_transportation, id_map){
  return(as.data.table(collect(filter(t.trans.elements.status, 
                                      id_land_transportation == id_land_transportation))))
}



get.eng.measures <- function(id_element. = NULL) {
  if (is.null(id_element.)) {
    return(as.data.table(collect(t.eng.measures)))
  } else if (length(id_element.) > 1) {
    return(as.data.table(collect(dplyr::filter(t.eng.measures, 
                                               id_element %in% id_element.))))
  } else {
    return(as.data.table(collect(dplyr::filter(t.eng.measures, 
                                               id_element == id_element.))))
  }
}