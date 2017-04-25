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
# scripts/eng_measures_analisys.R
# 
# 
#######################################################

name.to.id.element.dict <- function() {
  aux <- get.elements()
  dict <- aux[, id]
  names(dict) <- aux[, tolower(name)]
  return(dict)
}

name.to.id.element <- function(id.) {
  aux <- name.to.id.element.dict()
  unlist(lapply(id., function(x) {
    aux[[x]]
  }))
}

id.element.to.name.dict <- function() {
  aux <- name.to.id.element.dict()
  dict <- names(aux)
  names(dict) <- aux
  return(dict)
}

id.element.to.name <- function(id.) {
  aux <- id.element.to.name.dict()
  unlist(lapply(id., function(x) {
    aux[[as.character(x)]]
  }))
}

name.to.id.type.element.dict <- function() {
  aux <- get.type.element()
  dict <- c(0, aux[, id])
  names(dict) <- c("all", aux[, tolower(name)])
  return(dict)
}

name.to.id.type.element <- function(id.) {
  aux <- name.to.id.type.element.dict()
  unlist(lapply(id., function(x) {
    aux[[x]]
  }))
}

id.type.element.to.name.dict <- function() {
  aux <- name.to.id.type.element.dict()
  dict <- names(aux)
  names(dict) <- aux
  return(dict)
}

id.type.element.to.name <- function(id.) {
  aux <- id.type.element.to.name.dict()
  unlist(lapply(id., function(x) {
    aux[[as.character(x)]]
  }))
}

get.eng.measures.DT <- function() {
  aux <- get.eng.measures()
  aux[, id_element := id.element.to.name(id_element)]
  aux[, id_type_element := id.type.element.to.name(id_type_element)]
  setnames(aux, c("id_element", "id_type_element",  
                  "name", "improvement",
                  "cost_improvement", "description"),
           c("Element affected", "Specific type of element",
             "Name of the measure", "Improvement (%)",
             "Cost measure", "Description"))
  setcolorder(aux, c("id", "Name of the measure", "Element affected", 
                     "Specific type of element", "Improvement (%)",
                     "Cost measure", "Description"))
  return(aux)
}

get.eng.measures.example <- function() {
  eng.text <- "name;       id_element; improvement; cost_improvement;  description                                             [; id_type_element]
  Measure XX; tower;      10.2 ;       314159;            Tecnique XX applied to poles improves their foundations [; pole]
  Measure YY; tower;      22.33;       628318;            Tecnique YY applied to all kind of towers               [; all ]"
}

get.eng.measures.readfile.process <- function(read.data) {
  # filename. <- ("test_data/eng_measures_test.csv")
  if (!("id_type_element" %in% names(read.data))) {
    read.data[, id_type_element := "all"]
  }
  read.data[, id_element := name.to.id.element(tolower(id_element))]
  read.data[, id_type_element := name.to.id.type.element(tolower(id_type_element))]
  insert.eng.measures(dbRAIN$con, read.data)
}