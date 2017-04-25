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
# scripts/gRain_functions.R
# 
# 
#######################################################

require(gRain)

# Get values for OR and AND operators tables ------------------------------

get.valuesOR <- function(n) {
  c(rep(x = c(1,0), (2^n)/2 - 1), 0, 1)
}

get.valuesAND <- function(n) {
  c(1, 0, rep(x = c(0,1), (2^n)/2 - 1))
}

# Get CPTables for OR and AND operators -----------------------------------

cptableOR <- function(vpar, levels = c("yes", "no")) {
  valuesOR <- get.valuesOR(length(vpar))
  plist <- cptable(vpar, values = valuesOR, levels = levels)
  return(plist)
}

cptableAND <- function(vpar, levels = c("yes", "no")) {
  valuesAND <- get.valuesAND(length(vpar))
  plist <- cptable(vpar, values = valuesAND, levels = levels)
  return(plist)
}