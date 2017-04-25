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
# scripts/ElectricalGrid_analysis.R
# 
# 
#######################################################

# Find shorthest simple path from a given substation to an electricity input of the grid: SIHa or SIHb (equivalents), or SIhh. Given that once the path reaches a High Voltage line, it cannot go through a minor line again.

source("scripts/ElectricalGrid.R")
source("scripts/gRain_functions.R")
source("scripts/analysisBN.R")
require(stringr)


# Get grid information ----------------------------------------------------

net <- get.grid("..")
lines.minor <- grep("S0", as_ids(V(net)), value = T)
lines.minor.end <- grep("Se", as_ids(V(net)), value = T)
lines.HV <- grep("S[1-9]", as_ids(V(net)), value = T)
lines.HV <- c(lines.HV, grep("SI", as_ids(V(net)), value = T))
# plot.grid(net)

lines.all <- E(net)$label
stations.all <- paste0("Station_", c(lines.minor, lines.minor.end, lines.HV) )

# save(lines.all, stations.all, file = "lines_stations_names.Rdata")


# Extra functions ---------------------------------------------------------

susc.to.prob <- function(susc, min.susc = 1, max.susc = 5,
                         min.out = 0.0, max.out = 1) {
  return(((susc - min.susc) / (max.susc - min.susc)) * (max.out - min.out) + min.out)
}

status.to.prob <- function(status, min.out = 0.0, max.out = 1) {
  factor. <- (max.out - min.out) + min.out
  aux <- get.type.element(unique(status))[, .(id, prob_failure)][, prob_failure:= prob_failure * factor.]
  unlist(lapply(status, function(x) {
    aux[id == x, prob_failure]
  }))
}

status.to.cost.rep <- function(status) {
  aux <- get.type.element(unique(status))[, .(id, cost_rep)]
  unlist(lapply(status, function(x) {
    aux[id == x, cost_rep] 
  }))
}


# Parameters --------------------------------------------------------------

get.plist.init.data <- function(node.interest = "Sem9", auxPath = "") {
  
  nodes.source <- c("SIHa", "SIHb", "SIhh")
  yn <- c("yes","no")  # yes => failure
  
  # Get paths from interest to source nodes ---------------------------------
  
  aux <- all_simple_paths(net, node.interest, nodes.source)
  
  # avoid using "minor substations" once at 60k: 
  #       a) if there are more than 1 node between two minor substations, it means 
  #       that it went to a non-minor substation in between => not a valid path
  #       b) if the station is already at 60k, it shouldn't be allowed to go to
  #       minor lines again 
  paths <- list()
  node.interest.HV <- node.interest %in% lines.HV
  i <- 1
  for (x in aux) {
    a <- which(as_ids(x) %in% lines.minor | 
                 as_ids(x) %in% lines.minor.end)
    if (node.interest.HV) {
      if (length(a) == 0) {
        paths[[i]] <- x
        i <- i + 1
      }
    } else {
      if (!sum(diff(a) > 1)) {
        paths[[i]] <- x
        i <- i + 1
      } 
    }
  }
  
  # Generate nodes != node.interest -----------------------------------------
  
  paths.nodes.names <- unique(names(unlist(paths)))
  
  paths.nodes.names.origins <- paths.nodes.names[!(paths.nodes.names %in% node.interest)]
  paths.nodes <- data.frame(origins = paths.nodes.names.origins,
                            stations = paste0("Station_", paths.nodes.names.origins),
                            line = paste0("Line_", paths.nodes.names.origins),
                            stringsAsFactors = F)
  
  # Get vertices corresponding to each substation ---------------------------
  # Each substation includes itself, and the lines "going out" from it towards the
  # node.interest.station
  
  lines.list <- list()
  
  for (i in 1:length(paths)) {
    net2 <- delete_vertices(net, !(V(net) %in% paths[[i]]))
    paths.aux <- as_ids(paths[[i]])
    for (j in 2:length(paths.aux)) {
      if (is.null(lines.list[[paths.aux[j]]])) {
        aux <- E(net2)[paths.aux[j - 1] %--% paths.aux[j]]$label
        if (length(aux) > 1) {
          aux <- grep(pattern = "m", aux, value = T, invert = T)
        }
        lines.list[[paths.aux[j]]] <- aux
      }
    }
  }
  
  lines.names <- unique(unlist(lines.list))
  
  
  # Generate CPT for Lines per substation -----------------------------------
  
  plist.probsLines <- list()
  
  for (i in 1:length(lines.list)) {
    plist.probsLines[[i]] <- cptableAND(c(paste0("Line_", names(lines.list[i])),
                                          lines.list[[i]]), levels = yn)
    
  }
  
  # Generate CPT for StationLine substation ---------------------------------
  
  plist.probsStationLine <- list()
  plist.probsStationLine <- lapply(paths.nodes, function(x) {
    x[1]
  })
  
  for (i in 1:dim(paths.nodes)[1]) {
    auxtable <- c(paths.nodes[i, ]$origins, 
                  paths.nodes[i, ]$stations, 
                  paths.nodes[i, ]$line)
    plist.probsStationLine[[i]] <- cptableOR(auxtable, levels = yn)
  }
  
  
  # Generate CPT for each Path ----------------------------------------------
  
  plist.probsPaths <- list()
  paths.names <- paste0("Path_", auxPath, "_", 1:length(paths))
  
  for (i in 1:length(paths)) {
    paths.aux <- as_ids(paths[[i]])
    paths.aux[1] <- paths.names[i]
    plist.probsPaths[[i]] <- cptableOR(paths.aux, levels = yn)
  }
  
  
  # Generate CPT tables for Node Interest -----------------------------------
  
  pathsSuper.names <- paste0("Paths", auxPath)
  plist.probsAND <- list(cptableAND(c(pathsSuper.names, paths.names), 
                                    levels = yn))
  
  
  node.interest.station <- paste0("Station_", node.interest)
  
  plist.probsOR2 <- list(cptableOR(c(paste0(node.interest, auxPath), pathsSuper.names, 
                                     paste0(node.interest.station, auxPath)),
                                   levels = yn))
  
  
  return(list(plist.probsAND = plist.probsAND,
              plist.probsOR2 = plist.probsOR2, 
              plist.probsStationLine = plist.probsStationLine, 
              plist.probsPaths = plist.probsPaths, 
              plist.probsLines = plist.probsLines,
              paths.names = paths.names,
              paths.nodes = paths.nodes,
              pathsSuper.names = pathsSuper.names,
              node.interest.station = node.interest.station,
              lines.names = lines.names ))
  
}

get.plist.init.data.New <- function(node.interest = "Sem9", auxPath = "") {
  
  nodes.source <- c("SIHa", "SIHb", "SIhh")
  yn <- c("yes","no")  # yes => failure
  
  # Get paths from interest to source nodes ---------------------------------
  
  aux <- all_simple_paths(net, node.interest, nodes.source)
  
  # avoid using "minor substations" once at 60k: 
  #       a) if there are more than 1 node between two minor substations, it means 
  #       that it went to a non-minor substation in between => not a valid path
  #       b) if the station is already at 60k, it shouldn't be allowed to go to
  #       minor lines again (new feature from 28/02/17)
  paths <- list()
  node.interest.HV <- node.interest %in% lines.HV
  i <- 1
  for (x in aux) {
    a <- which(as_ids(x) %in% lines.minor | 
                 as_ids(x) %in% lines.minor.end)
    # print(a)
    if (node.interest.HV) {
      if (length(a) == 0) {
        paths[[i]] <- x
        i <- i + 1
      }
    } else {
      if (!sum(diff(a) > 1)) {
        paths[[i]] <- x
        i <- i + 1
      } 
    }
  }
  
  # Generate nodes != node.interest -----------------------------------------
  
  paths.nodes.names <- unique(names(unlist(paths)))
  
  paths.nodes.names.origins <- paths.nodes.names[!(paths.nodes.names %in% node.interest)]
  paths.nodes <- data.frame(origins = paths.nodes.names.origins,
                            stations = paste0("Station_", paths.nodes.names.origins),
                            line = paste0("Line_", paths.nodes.names.origins),
                            stringsAsFactors = F)
  
  # Get vertices connecting two substations --------------------------------
  # and keep track of the lines and stations involved in each path
  
  lines.list <- list()
  paths.lines <- list()
  paths.stations <- list()
  
  for (i in 1:length(paths)) {
    net2 <- delete_vertices(net, !(V(net) %in% paths[[i]]))
    paths.aux <- as_ids(paths[[i]])
    paths.stations[[i]] <- paste0("Station_", paths.aux[paths.aux != node.interest])
    aux.paths.lines <- NULL
    for (j in 2:length(paths.aux)) {
      line.stations.name <- str_replace(as_ids(E(net2)[paths.aux[j - 1] %--% paths.aux[j]][1]),
                                        pattern = "\\|", replacement = "_")
      aux.paths.lines <- c(aux.paths.lines, line.stations.name)
      
      if (is.null(lines.list[[line.stations.name]])) {
        aux <- E(net2)[paths.aux[j - 1] %--% paths.aux[j]]$label
        if (length(aux) > 1) {
          aux <- grep(pattern = "m", aux, value = T, invert = T)
        }
        lines.list[[line.stations.name]] <- aux
      }
    }
    paths.lines[[i]] <- aux.paths.lines
  }
  
  lines.names <- unique(unlist(lines.list))
  
  
  # Generate CPT for Lines --------------------------------------------------
  
  plist.probsLines <- list()
  
  for (i in 1:length(lines.list)) {
    plist.probsLines[[i]] <- cptableAND(c(names(lines.list[i]),
                                          lines.list[[i]]), levels = yn)
    
  }
  
  # Generate CPT for each Path ----------------------------------------------
  
  plist.probsPaths <- list()
  plist.probsPaths.stations <- list()
  plist.probsPaths.lines <- list()
  paths.names <- paste0("Path", auxPath, "_", 1:length(paths))
  paths.names.stations <- paste0("Stations", auxPath, "_", 1:length(paths))
  paths.names.lines <- paste0("Lines", auxPath, "_", 1:length(paths))
  
  
  for (i in 1:length(paths)) {
    plist.probsPaths[[i]] <- cptableOR(c(paths.names[i],
                                         paths.names.stations[i],
                                         paths.names.lines[i]), levels = yn)
    plist.probsPaths.stations[[i]] <- cptableOR(c(paths.names.stations[i],
                                                  paths.stations[[i]]), levels = yn)
    plist.probsPaths.lines[[i]] <- cptableOR(c(paths.names.lines[i],
                                               paths.lines[[i]]), levels = yn)
  }
  
  
  # Generate CPT tables for Node Interest -----------------------------------
  
  pathsSuper.names <- paste0("Paths_", auxPath)
  plist.probsAND <- list(cptableAND(c(pathsSuper.names, paths.names), 
                                    levels = yn))
  
  
  node.interest.station <- paste0("Station_", node.interest)
  
  plist.probsOR2 <- list(cptableOR(c(paste0(node.interest, auxPath), pathsSuper.names, 
                                     paste0(node.interest.station, auxPath)),
                                   levels = yn))
  
  
  return(list(plist.probsAND = plist.probsAND,
              plist.probsOR2 = plist.probsOR2, 
              plist.probsPaths = plist.probsPaths, 
              plist.probsLines = plist.probsLines,
              plist.probsPaths.stations = plist.probsPaths.stations,
              plist.probsPaths.lines = plist.probsPaths.lines,
              paths.names = paths.names,
              paths.names.stations = paths.names.stations,
              paths.names.lines = paths.names.lines,
              paths.nodes = paths.nodes,
              paths.stations = paths.stations,
              paths.lines = paths.lines,
              pathsSuper.names = pathsSuper.names,
              node.interest.station = node.interest.station,
              lines.names = lines.names ))
  
}

get.plist.init.data.multiple.New <- function(node.interest) {
  plist.probsAND <- NULL
  plist.probsOR2 <- NULL
  plist.probsPaths <- NULL
  plist.probsLines <- NULL
  plist.probsPaths.stations <- NULL
  plist.probsPaths.lines <- NULL
  paths.names <- NULL
  paths.names.stations <- NULL
  paths.names.lines <- NULL
  paths.stations <- NULL
  paths.lines <- NULL
  paths.nodes  <- data.frame(origins  = character(),
                             stations = character(),
                             line     = character())
  node.interest.station <- NULL
  lines.names <- NULL
  pathsSuper.names <- NULL
  
  for (i in 1:length(node.interest)) {
    aux <- get.plist.init.data.New(node.interest[i], auxPath = LETTERS[i])
    
    plist.probsAND <- c(plist.probsAND, aux[["plist.probsAND"]])
    plist.probsOR2 <- c(plist.probsOR2, aux[["plist.probsOR2"]])
    plist.probsPaths <- c(plist.probsPaths, 
                          aux[["plist.probsPaths"]])
    plist.probsPaths  <- c(plist.probsPaths, aux[["plist.probsPaths"]])
    plist.probsLines <- c(plist.probsLines, aux[["plist.probsLines"]])
    plist.probsPaths.stations <- c(plist.probsPaths.stations,
                                   aux[["plist.probsPaths.stations"]])
    plist.probsPaths.lines <- c(plist.probsPaths.lines,
                                aux[["plist.probsPaths.lines"]])
    
    paths.names <- c(paths.names, aux[["paths.names"]])
    paths.nodes  <- rbind(paths.nodes, aux[["paths.nodes"]])
    paths.stations <- c(paths.stations, unlist(aux[["paths.stations"]]))
    paths.lines <- c(paths.lines, unlist(aux[["paths.lines"]]))
    node.interest.station <- c(node.interest.station, aux[["node.interest.station"]])
    lines.names <- c(lines.names, aux[["lines.names"]])
    pathsSuper.names <- c(pathsSuper.names, aux[["pathsSuper.names"]])
    paths.names.stations <- c(paths.names.stations, aux[["paths.names.stations"]])
    paths.names.lines <- c(paths.names.lines, aux[["paths.names.lines"]])
  }  
  lines.names <- unique(lines.names)
  paths.nodes <- unique(paths.nodes)
  paths.lines <- unique(paths.lines)
  paths.stations <- unique(paths.stations)
  
  return(list(plist.probsAND = plist.probsAND,
              plist.probsOR2 = plist.probsOR2, 
              plist.probsPaths = plist.probsPaths, 
              plist.probsLines = plist.probsLines,
              plist.probsPaths.stations = plist.probsPaths.stations,
              plist.probsPaths.lines = plist.probsPaths.lines,
              paths.names = paths.names,
              paths.nodes = paths.nodes,
              paths.lines = paths.lines,
              paths.names.stations = paths.names.stations,
              paths.names.lines = paths.names.lines,
              paths.stations = paths.stations,
              pathsSuper.names = pathsSuper.names,
              node.interest.station = node.interest.station,
              lines.names = lines.names ))
}

get.plist.init.data.multiple <- function(node.interest) {
  plist.probsAND <- NULL
  plist.probsOR2 <- NULL
  plist.probsStationLine <- list()
  plist.probsPaths <- list()
  plist.probsLines <- list()
  paths.names <- NULL
  paths.nodes  <- data.frame(origins  = character(),
                             stations = character(),
                             line     = character())
  node.interest.station <- NULL
  lines.names <- NULL
  pathsSuper.names <- NULL
  
  for (i in 1:length(node.interest)) {
    aux <- get.plist.init.data(node.interest[i], auxPath = LETTERS[i])
    
    plist.probsAND <- c(plist.probsAND, aux[["plist.probsAND"]])
    plist.probsOR2 <- c(plist.probsOR2, aux[["plist.probsOR2"]])
    plist.probsStationLine <- c(plist.probsStationLine, 
                                aux[["plist.probsStationLine"]])
    plist.probsPaths  <- c(plist.probsPaths, aux[["plist.probsPaths"]])
    plist.probsLines <- c(plist.probsLines, aux[["plist.probsLines"]])
    
    paths.names <- c(paths.names, aux[["paths.names"]])
    paths.nodes  <- rbind(paths.nodes, aux[["paths.nodes"]])
    node.interest.station <- c(node.interest.station, aux[["node.interest.station"]])
    lines.names <- c(lines.names, aux[["lines.names"]])
    pathsSuper.names <- c(pathsSuper.names, aux[["pathsSuper.names"]])
  }  
  lines.names <- unique(lines.names)
  paths.nodes <- unique(paths.nodes)
  
  return(list(plist.probsAND = plist.probsAND,
              plist.probsOR2 = plist.probsOR2, 
              plist.probsStationLine = plist.probsStationLine, 
              plist.probsPaths = plist.probsPaths, 
              plist.probsLines = plist.probsLines,
              paths.names = paths.names,
              paths.nodes = paths.nodes,
              pathsSuper.names = pathsSuper.names,
              node.interest.station = node.interest.station,
              lines.names = lines.names ))
}


get.plist.gr <- function(node.interest = "Sem9", probs.and.costs = NULL,
                         improved.nodes = NULL, plist.init.data = NULL, 
                         prob.landslide = prob.landslide) {
  
  
  if (length(node.interest) == 1) {
    if (is.null(plist.init.data)) {
      plist.init.data <- get.plist.init.data(node.interest = node.interest)
    }
    plist.probsAND <- plist.init.data[["plist.probsAND"]]
    plist.probsOR2 <- plist.init.data[["plist.probsOR2"]]
    plist.probsStationLine <- plist.init.data[["plist.probsStationLine"]]
    plist.probsPaths  <- plist.init.data[["plist.probsPaths"]]
    plist.probsLines <- plist.init.data[["plist.probsLines"]]
    paths.lines <- NULL
    paths.stations <- NULL
    paths.names.stations <- NULL
    paths.names.lines <- NULL
    plist.probsPaths.stations <- NULL
    plist.probsPaths.lines <- NULL
  } else {
    if (is.null(plist.init.data)) {
      plist.init.data <- get.plist.init.data.multiple.New(node.interest = node.interest)
    }
    plist.probsAND <- plist.init.data[["plist.probsAND"]]
    plist.probsOR2 <- plist.init.data[["plist.probsOR2"]]
    plist.probsPaths <- plist.init.data[["plist.probsPaths"]]
    plist.probsLines <- plist.init.data[["plist.probsLines"]]
    paths.lines <- plist.init.data[["paths.lines"]]
    paths.stations <- plist.init.data[["paths.stations"]]
    plist.probsPaths.stations <- plist.init.data[["plist.probsPaths.stations"]]
    plist.probsPaths.lines <- plist.init.data[["plist.probsPaths.lines"]]
    paths.names.stations <- plist.init.data[["paths.names.stations"]]
    paths.names.lines <- plist.init.data[["paths.names.lines"]]
  }
  
  paths.names <- plist.init.data[["paths.names"]]
  paths.nodes  <- plist.init.data[["paths.nodes"]]
  node.interest.station <- plist.init.data[["node.interest.station"]]
  lines.names <- plist.init.data[["lines.names"]]
  pathsSuper.names <- plist.init.data[["pathsSuper.names"]]
  
  # Set failure probabilities for each element ------------------------------
  
  if (is.null(probs.and.costs)) {
    probs.and.costs <- get.probs.and.costs(probability.landslide = NULL)
  }
  
  probs.and.costs <- probs.and.costs %>% 
    dplyr::filter(probs.and.costs$name %in% c(lines.names, 
                                              paths.nodes$stations, 
                                              node.interest.station))
  
  aux <- get.plist.elements(improved.nodes = improved.nodes, 
                            probs.and.costs. = probs.and.costs, 
                            prob.landslide = prob.landslide, 
                            verbose = FALSE)
  plist.elements <- aux[[1]]
  c.invest <- aux[[2]]
  
  # Generate fault tree: compileCPT -----------------------------------------
  
  if (length(node.interest) > 1) {
    node.interest.station.level <- unlist(lapply(plist.probsOR2, function(x) x$vpa[3]))
    node.interest.level <- str_replace(node.interest.station.level, "Station_", "")
    aux.elements <- unlist(lapply(plist.elements, function(x) x$vpa))
    for (i in 1:length(node.interest.station.level)) {
      aux.el <- plist.elements[[which(str_sub(node.interest.station.level[i], 
                                              end = -2) == aux.elements)]]
      aux.el$vpa <- node.interest.station.level[i]
      plist.elements <- c(plist.elements, list(aux.el))
    }
    plist.failure.OR <- list(cptableOR(c("Electrical_Failure", node.interest.level)))
    plist <- compileCPT(c(plist.failure.OR,
                          plist.probsAND, plist.probsOR2, 
                          plist.probsPaths, plist.probsPaths.stations,
                          plist.probsPaths.lines, plist.elements,
                          plist.probsLines), 
                        forceCheck = T)
  } else {
    node.interest.station.level <- node.interest.station
    node.interest.level <- node.interest
    plist <- compileCPT(c(plist.probsAND, plist.probsOR2, 
                          plist.probsStationLine, plist.probsPaths,
                          plist.probsLines, plist.elements), 
                        forceCheck = T)
  }
  
  plist.gr <- grain(plist)
  
  # save(plist.probsAND, plist.probsOR2, plist.probsStationLine, plist.probsPaths,
  #      plist.probsLines, file = "alpine_auxiliar_CPT.Rdata")
  
  return(list(plist.gr = plist.gr, paths.names = paths.names,
              paths.nodes = paths.nodes,
              pathsSuper.names = pathsSuper.names,
              node.interest.station = node.interest.station,
              node.interest.station.level = node.interest.station.level,
              node.interest.level = node.interest.level, 
              lines.names = lines.names,
              paths.lines = paths.lines,
              paths.names.stations = paths.names.stations,
              paths.names.lines = paths.names.lines,
              paths.stations = paths.stations,
              plist.probsLines = plist.probsLines,
              plist.probsPaths.stations = plist.probsPaths.stations,
              plist.probsPaths.lines = plist.probsPaths.lines,
              c.invest = c.invest))
}  

get.electrical.BN <- function(node.interest = "Sem9", probs.and.costs = NULL,
                              plist.init.data = NULL) {  
  
  aux <- get.plist.gr(node.interest = node.interest,
                      probs.and.costs = probs.and.costs,
                      plist.init.data = plist.init.data)
  plist.gr <- aux[["plist.gr"]]
  paths.names <- aux[["paths.names"]]
  paths.nodes <- aux[["paths.nodes"]]
  paths.lines <- aux[["paths.lines"]]
  paths.stations <- aux[["paths.stations"]]
  node.interest.station <- aux[["node.interest.station"]]
  lines.names <- aux[["lines.names"]]
  node.interest.station.level <- aux[["node.interest.station.level"]]
  node.interest.level <-  aux[["node.interest.level"]]
  pathsSuper.names <- aux[["pathsSuper.names"]]
  plist.probsLines <- aux[["plist.probsLines"]]
  plist.probsPaths.stations <- aux[["plist.probsPaths.stations"]]
  plist.probsPaths.lines <- aux[["plist.probsPaths.lines"]]
  paths.names.stations <- aux[["paths.names.stations"]]
  paths.names.lines <- aux[["paths.names.lines"]]
  
  # Query network -----------------------------------------------------------
  
  # querygrain(plist.gr, nodes = c("S8hhmm", "S3hhm", "Sem9"), type = "joint")
  # querygrain(plist.gr, nodes = c("S01mm", "S1hhmm"), type = "marginal")
  # querygrain(plist.gr, nodes = c("Line_S4hhm"), type = "marginal")
  # querygrain(plist.gr, nodes = c("Line_S7hhmm"), type = "marginal")
  # querygrain(plist.gr, nodes = paths.nodes$line, type = "marginal", result = "data.frame")
  # querygrain(plist.gr, nodes = c("S01mm", "S1hhmm", paths.names), type = "marginal")
  
  
  
  # Get failure probabilities per node --------------------------------------
  
  get.failure.prob.per.node <- function(plist.gr) {
    aux <- lapply(querygrain(plist.gr), function(x) {
      x[1]
    })
    aux <- as.data.table(aux)
    aux <- melt(aux, variable.factor = F, measure.vars = names(aux))
    return(aux)
  }
  
  elements.all.fail.prob <- get.failure.prob.per.node(plist.gr)
  
  # Visualization -----------------------------------------------------------
  
  plot.aux <- igraph.from.graphNEL(plist.gr$dag)
  # plot.aux <- igraph.from.graphNEL(bn.normal$dag)
  # plot(plist.gr)
  
  data <- toVisNetworkData(plot.aux) 
  data.levels <- 0
  if (length(node.interest) == 1) {
    data$nodes[data$nodes$id %in% node.interest.level, "level"] <- data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% c(pathsSuper.names, node.interest.station.level), "level"] <- 
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.names, "level"] <-
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.nodes$origins, "level"] <- 
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.nodes$stations, "level"] <- 
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.nodes$line, "level"] <- data.levels
    data$nodes[data$nodes$id %in% lines.names, "level"] <- 
      data.levels <- data.levels + 1
  } else {
    data$nodes[data$nodes$id %in% c("Electrical_Failure"), "level"] <- data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% node.interest.level, "level"] <- data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% c(pathsSuper.names, node.interest.station.level), "level"] <- 
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.names, "level"] <-
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.names.stations, "level"] <- 
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.names.lines, "level"] <- data.levels 
    data$nodes[data$nodes$id %in% paths.stations, "level"] <- 
      data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% paths.lines, "level"] <- data.levels <- data.levels + 1
    data$nodes[data$nodes$id %in% lines.names, "level"] <- 
      data.levels <- data.levels + 1
  }
  
  data2 <- toVisNetworkData(net) 
  data2$edges
  
  nodesA <- data2$nodes
  setDT(nodesA)
  nodesA[, X := NULL]
  nodesA[, Y := NULL]
  
  nodesB <- data2$edges
  setDT(nodesB)
  nodesB[, `:=`(from = NULL,
                to = NULL, 
                width = NULL)]
  
  nodes1 <- data$nodes
  setDT(nodes1)
  
  
  aux <- merge(nodes1[complete.cases(nodes1)], nodesA, all.x = T)
  nodes. <- merge(aux, nodesB, by = "label", all.x = T)
  nodes.[is.na(color.border), `:=`(color.border = color,
                                   color.highlight.border = color)]
  
  nodes.[, color := NULL]
  nodes.[, opacity := 0.5]
  
  
  failure.colorPal <- colorRampPalette(c("green", "yellow", "orange", "red2"))(100)
  
  # Set failure probabilities according to querygrain() 
  elements.used.fail.prob <- elements.all.fail.prob[variable %in% nodes.$id, 
                                                    .(variable, 
                                                      fail.prob = round(value*100),
                                                      fail.prob.1 = round(value, 2))]
  elements.used.fail.prob[fail.prob == 0 , fail.prob := 1]
  elements.used.fail.prob[ , fail.color := failure.colorPal[fail.prob]]
  
  nodes. <- merge(nodes., elements.used.fail.prob, by.x = "id", by.y = "variable")
  nodes.[, color.background := fail.color]
  
  nodes.[, title := paste0("Failure prob.: ", fail.prob.1)]
  
  network.complete <- list(nodes = nodes., 
                           edges = data$edges)
  return(network.complete)
}

get.probs.and.costs <- function(probability.landslide = NULL) {
  if (is.null(probability.landslide)) {
    # df with marginal failure probabilities + improved failure probs
    probs.and.costs <- data.frame(name = c(lines.all, stations.all))
    probs.and.costs$marginal <- generate.probs(n = dim(probs.and.costs)[1], 
                                               perc.high = 5,
                                               prob.high = .2,
                                               perc.med = 15,
                                               prob.med = .05,
                                               prob.low = .005)
    probs.and.costs$marginal.better <- probs.and.costs$marginal * runif(dim(probs.and.costs)[1],
                                                                        min = .05, max = .3)
    
    # costs
    probs.and.costs$cost.rep <- floor(runif(dim(probs.and.costs)[1],min = .5) * 100) * 10000
    probs.and.costs$cost.rein <- floor(probs.and.costs$cost.rep * runif(dim(probs.and.costs)[1],
                                                                        min = .1, max = .2))
  } else {
    # probs.and.costs original (M's code) columns: 
    #            name, marginal, marginal.better, cost.rep, cost.rein
    # probs.and.costs columns that allow using eng.measures to assess 
    #           marginal.better and cost.rein(forcement): 
    #            name, marginal, cost.rep, id_type_element
    
    # Lines
    probs.and.costs.lines <- data.table(name = lines.all)
    aux.towers <- get.grid.towers.all()
    aux.towers[susc == 0, susc := 1]
    aux.towers[, susc.prob := susc.to.prob(susc)]
    aux.towers[, status.prob := status.to.prob(id_type_element)]
    aux.towers[, cost.rep := status.to.cost.rep(id_type_element)]
    aux.towers[, marginal := susc.prob*status.prob*probability.landslide]
    aux.towers[, aux.std := sqrt(marginal * (1 - marginal)) * cost.rep]
    aux.towers[, aux.expected := marginal * cost.rep]
    aux.towers[, `:=`(cost.rep.LB = aux.expected - aux.std,
                      cost.rep.UB = aux.expected + aux.std)]
    aux.towers[cost.rep.LB < 0,        cost.rep.LB := 0]
    aux.towers[cost.rep.UB > cost.rep, cost.rep.UB := cost.rep]
    
    probs.and.costs.lines <- aux.towers[, .(marginal = prob(marginal),
                                            cost.rep = sum((aux.expected + cost.rep.LB +
                                                              cost.rep.UB)/3)), 
                                        by = "label_line"]
    
    probs.and.costs.lines[, id_type_element := 0]
    setnames(probs.and.costs.lines, "label_line", "name")
    
    # Stations
    probs.and.costs.stations. <- data.table(name = stations.all)
    aux.susc <- get.grid.stations.susc()
    aux.susc[susc == 0, susc := 1]
    aux.status <- get.grid.stations.status()
    probs.and.costs.stations.[, id_station := grid.stations[ name == name, id]]
    probs.and.costs.stations.[, susc := aux.susc[id_station == id_station, susc]]
    probs.and.costs.stations.[, id_type_element := aux.status[id_station == id_station, id_type_element]]
    
    probs.and.costs.stations.[, susc.prob := susc.to.prob(susc)]
    probs.and.costs.stations.[, status.prob := status.to.prob(id_type_element)]
    
    probs.and.costs.stations.[, marginal := susc.prob*status.prob*probability.landslide]
    probs.and.costs.stations.[, cost.rep := status.to.cost.rep(id_type_element)]
    probs.and.costs.stations <- probs.and.costs.stations.[, .(name, marginal, 
                                                              cost.rep, 
                                                              id_type_element)]
    
    # Together
    probs.and.costs <- rbindlist(list(probs.and.costs.lines, probs.and.costs.stations))
  }
  return(probs.and.costs)
}

measures.random.choice <- function(pac) {
  pac.unique.type.element <- pac[, unique(id_type_element)]
  measures.available <- get.eng.measures(id_element. = get.type.element(pac.unique.type.element)$id_element)
  # TODO(xclotet): check id_type_element
  #
  measures.used <- NULL
  for (type. in pac.unique.type.element) {
    aux.measures.available <- measures.available[id_type_element %in% c(0, type.)]
    idx <- round(runif(dim(pac[ id_type_element == type.,])[1], 
                       1, 
                       dim(aux.measures.available)[1]))
    aux.measures.used <- aux.measures.available[idx, .(improvement, cost_improvement)]
    measures.used <- rbindlist(list(measures.used, 
                                    cbind(pac[ id_type_element == type., name], aux.measures.used)))
  }
  
  setnames(measures.used, "V1", "name")
  return(measures.used)
}

get.marginal.better.cost.rein.lines <- function(pac, prob.landslide) {
  
  # aux.towers <- get.grid.towers.all()
  aux.towers <- get.grid.towers.to.improve(label_line = pac$name)
  aux.towers[susc == 0, susc := 1]
  aux.towers[, susc.prob := susc.to.prob(susc)]
  aux.towers[, status.prob := status.to.prob(id_type_element)]
  aux.towers[, cost.rep := status.to.cost.rep(id_type_element)]
  aux.towers[, marginal := susc.prob*status.prob*prob.landslide]
  
  
  # Do the same as for stations but for each line name => each tower + probs() by line name
  # aux.towers <- get.grid.towers.status()
  # aux.tower.lines <- get.grid.towers()[, .(id, label_line)]
  setnames(aux.towers, "id_tower", "name")
  measures.used <- measures.random.choice(aux.towers)
  setnames(measures.used, "name", "id")
  
  aux.towers <- merge(aux.towers, measures.used, by = "id")
  aux.towers[marginal > marginal.thr, marginal.better := marginal*(1 - improvement/100)]
  aux.towers[marginal <= marginal.thr, `:=`(marginal.better = marginal,
                                            cost_improvement = 0)]
  setnames(aux.towers, "cost_improvement", "cost.rein")
  
  pac.aux <- aux.towers[, .(marginal.better = prob(marginal.better),
                            cost.rein = sum(cost.rein)), 
                        by = "label_line"]
  setnames(pac.aux, "label_line", "name")
  pac <- merge(pac, pac.aux, by = "name")
}

get.marginal.better.cost.rein.stations <- function(pac) {
  measures.used <- measures.random.choice(pac)
  pac <- merge(pac, measures.used, by = "name")
  pac[, marginal.better := marginal*(1 - improvement/100)]
  setnames(pac, "cost_improvement", "cost.rein")
  pac[, improvement := NULL]
  return(pac)
}

get.marginal.better.cost.rein <- function(probs.and.costs, prob.landslide = NULL) {
  is.df <- FALSE
  if (is.data.frame(probs.and.costs)) {
    setDT(probs.and.costs)
    is.df <- TRUE
  }
  if (dim(probs.and.costs[id_type_element != 0,])[1] > 0 ) {
    pac.stations <- get.marginal.better.cost.rein.stations(probs.and.costs[id_type_element != 0,])
  } else {
    pac.stations <- NULL
  }
  if (dim(probs.and.costs[id_type_element == 0,])[1] > 0 ) {
    pac.lines <- get.marginal.better.cost.rein.lines(probs.and.costs[id_type_element == 0,], 
                                                     prob.landslide = prob.landslide)
  } else {
    pac.lines <- NULL
  }
  
  probs.and.costs <- rbindlist(list(pac.lines, pac.stations),use.names = TRUE)
  
  if (is.df) {
    setDF(probs.and.costs)
  }
  return(probs.and.costs)
}

get.risk.profile.shiny <- function(node.interest, probs.and.costs = NULL,
                                   plist.init.data = NULL,
                                   improvement.n.max.ctt = NULL) {
  aux <- get.plist.gr(node.interest = node.interest, 
                      probs.and.costs = probs.and.costs,
                      plist.init.data = plist.init.data)
  plist.gr <- aux[["plist.gr"]]
  conds <- risk.profile.get.conditionals(plist.gr, node.interest)
  return(risk.profile.plot(conds, num.shown = improvement.n.max.ctt))
}

get.electric.stations <- function(grid.stations) {
  grid.st <- grid.stations[, .(name_extra, group_, color_background)]
  setnames(grid.st, c("name_extra", "group_", "color_background"),
           c("Name", "Voltage level(s)", "Color"))
  return(grid.st)
}

get.electric.lines <- function(grid.lines) {
  grid.li <- grid.lines[, .(label, group_, from_, to_, num_towers)]
  setnames(grid.li, c("label", "group_", "from_", "to_", "num_towers"),
           c("Name", "Voltage level", "From", "To", "Num. towers/pylons"))
  return(grid.li)
}