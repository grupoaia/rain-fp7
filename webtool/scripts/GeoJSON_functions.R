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
# scripts/GeoJSON_functions.R
# 
#######################################################


# topoData functions ------------------------------------------------------
#
# functions to deal with GeoJSON datafiles
# 
require(jsonlite)
require(geojsonio)

topoData.import <- function(filename){
  topoData <-
    readLines(filename) %>% paste(collapse = "\n") %>%
    fromJSON(simplifyVector = FALSE)
  return(topoData)
}

topoData.getProperties.feature <- function(dataset, feature){
  if (!is.null(dataset$features)) {
    return(sapply(dataset$features, function(feat) {
      feat$properties[[feature]]
    }))
  } else {
    return(sapply(dataset, function(feat) {
      feat$properties[[feature]]
    }))
  }
}

topoData.getProperties.list <- function(dataset){
  ret <- names(unlist(dataset$features[[1]]$properties))
  if (is.null(ret)) {
    ret <- names(unlist(dataset[[1]]$properties))
  }
  ret
}

topoData.getSingleLine <- function(dataset, id_variablename, variablename = "line_name"){
  if (!is.numeric(id_variablename)) {
    aux <- topoData.getProperties.feature(dataset, variablename)
    # aux <- topoData.getProperties.feature(dataset, "region")
    id_variablename <- which(id_variablename == aux)
  }
  return(list(type = dataset[[1]],
              crs = dataset[[2]],
              features = list(dataset[[3]][[id_variablename]])))
}

topoData.setProperties.duplicateFeature <- function(dataset, oldFeatureName, newFeatureName){
  dataset$features <- lapply(dataset$features, function(feat) {
    feat$properties[[newFeatureName]] <- (feat$properties[[oldFeatureName]])
    feat
  })
}

topoData.setProperties.duplicateFeatureAdd <- function(dataset, oldFeatureName, 
                                                       newFeatureName, add){
  dataset$features <- lapply(dataset$features, function(feat) {
    feat$properties[[newFeatureName]] <- (paste0(add, (feat$properties[[oldFeatureName]])))
    feat
  })
}

topoData.setPopup.single <- function(dataset, label){
  dataset$features <- lapply(dataset$features, function(feat) {
    feat$properties$popup <- label
    feat
  })
}

topoData.setColor.single <- function(dataset, color.){
  dataset$features <- lapply(dataset$features, function(feat) {
    feat$properties$style <- list(
      color = color.
    )
    feat
  })
}

topoData.setColor.factorFeature <- function(dataset, feature){
  features <- topoData.getProperties.feature(dataset, feature)
  pal <- colorFactor("Paired", levels(factor(features)))
  dataset$features <- lapply(dataset$features, function(feat) {
    feat$properties$style <- list(
      color = pal((feat$properties[[feature]]))
    )
    feat
  })
}