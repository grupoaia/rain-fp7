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
# scripts/ElectricalGrid.R
# 
# 
#######################################################

require(data.table)
require(igraph) 
require(visNetwork)

# Functions ---------------------------------------------------------------

get.grid <- function(path.extra = ""){
  if (stringr::str_count(path.extra) != 0) {
    path.data <- file.path(path.extra, "data")
  } else {
    path.data <- "data"
  }
  # Substations
  substations <- fread(file.path(path.data, "Substations.txt"))
  substations.position <- fread(file.path(path.data, "Substations.csv"))
  substations <- merge(substations, 
                       substations.position[, .SD, .SDcols = c("X", "Y", "name")], 
                       by = "name", all.x = T)
  
  setcolorder(substations, colnames(substations)[c(2,1, seq(3,dim(substations)[2]))])
  nodes <- data.frame(substations)
  
  # Lines
  lines <- fread(file.path(path.data, "Lines.txt"))
  links <- data.frame(lines)
  
  
  net <- graph.data.frame(links, nodes, directed = F)
  return(net)
}

plot.grid <- function(net){
  data <- toVisNetworkData(net)
  visNetwork(nodes = data$nodes, edges = data$edges) %>%
    visOptions(
      selectedBy = list(variable = "group", multiple = TRUE)) %>% 
    visLayout(randomSeed = 13) # to have always the same network 
}