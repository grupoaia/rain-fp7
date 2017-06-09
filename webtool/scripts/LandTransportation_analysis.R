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
# scripts/LandTransportation_analysis.R
# 
#######################################################

require(data.table)
source("scripts/gRain_functions.R")

yn <- c("yes", "no")

# functions ---------------------------------------------------------------

get.plist.land.init.data <- function() {
  # <<< Structure of the roads --------------------------------------------
  
  land.elements.OR <- list("A1" = c(paste0("B", 1:4)),
                           "A2" = c(paste0("B", 15:24)),
                           "A3" = c(paste0("B", 5:13)),
                           "A4" = c(paste0("B", 25:36)),
                           "A5" = c(paste0("B", 37:38)),
                           "RoadFailure" = c(paste0("E", 1:3)))
  land.elements.AND <- list("E1" = c(paste0("A", 1:2)),
                            "E2" = c(paste0("A", 3:4)),
                            "E3" = c("A5", "B14"))
  
  plist.land.elements.ORAND <- list()
  for (i in 1:length(land.elements.OR)) {
    auxtable <- c(names(land.elements.OR)[i],
                  land.elements.OR[[i]])
    plist.land.elements.ORAND[[i]] <- cptableOR(auxtable, levels = yn)
  }
  
  lengthOR <- length(plist.land.elements.ORAND)
  for (i in 1:length(land.elements.AND)) {
    auxtable <- c(names(land.elements.AND)[i],
                  land.elements.AND[[i]])
    plist.land.elements.ORAND[[lengthOR + i]] <- cptableAND(auxtable, levels = yn)
  }
  
  return(list(plist.land.elements.ORAND = plist.land.elements.ORAND))
}

get.probs.and.costs.land <- function(probability.landslide = NULL) {
  if (is.null(probability.landslide)) {
    # df with marginal failure probabilities + improved failure probs
    probs.and.costs.land <- data.frame(name = land.elements[`Element type` == "bridge" &
                                                              `Road/Railway` == "road", unique(Name)])
    probs.and.costs.land$marginal <- generate.probs(n = dim(probs.and.costs.land)[1], 
                                                    perc.high = 5,
                                                    prob.high = .3,
                                                    perc.med = 15,
                                                    prob.med = .08,
                                                    prob.low = .005)
    probs.and.costs.land$marginal.better <- probs.and.costs.land$marginal * runif(dim(probs.and.costs.land)[1],
                                                                                  min = .05, max = .3)
    
    # costs
    probs.and.costs.land$cost.rep <- floor(runif(dim(probs.and.costs.land)[1],min = .5) * 100) * 10000
    probs.and.costs.land$cost.rein <- floor(probs.and.costs.land$cost.rep * runif(dim(probs.and.costs.land)[1],
                                                                                  min = .1, max = .2))
  } else {
    # # probs.and.costs.land original (M's code) columns: 
    # #            name, marginal, marginal.better, cost.rep, cost.rein
    # # probs.and.costs.land columns that allow using eng.measures to assess 
    # #           marginal.better and cost.rein(forcement): 
    # #            name, marginal, cost.rep, id_type_element
    # 
    # # Lines
    # Land elements
    probs.and.costs.land <- data.table(name = trans.elements[basic_element_type == "bridge" &
                                                               means_transportation == "road", unique(name)])
    aux.susc <- get.trans.elements.susc(id_land_transportation = 1, id_map = 1)
    aux.susc[susc == 0, susc := 1]
    aux.status <- get.trans.elements.status(id_land_transportation = 1, id_map = 1)
    probs.and.costs.land <- merge(probs.and.costs.land, trans.elements[, .(name, id)], by = "name")
    setnames(probs.and.costs.land, "id", "id_trans_elements")
    probs.and.costs.land <- merge(probs.and.costs.land, aux.susc[, .(id_trans_elements, susc)], 
                                  by = "id_trans_elements")
    probs.and.costs.land <- merge(probs.and.costs.land, aux.status[, .(id_trans_elements, id_type_element)], 
                                  by = "id_trans_elements")
    
    probs.and.costs.land[susc == 0, susc := 1]
    probs.and.costs.land[, susc.prob := susc.to.prob(susc)]
    probs.and.costs.land[, status.prob := status.to.prob(id_type_element)]
    probs.and.costs.land[, cost.rep := status.to.cost.rep(id_type_element)]
    probs.and.costs.land[, marginal := susc.prob*status.prob*probability.landslide]
    
    # # probs.and.costs.land[, marginal.better := marginal * runif(dim(probs.and.costs.land)[1],
    # #                                                       min = .05, max = .3)]
    # # probs.and.costs.land[, cost.rein := floor(probs.and.costs.land$cost.rep * runif(dim(probs.and.costs.land)[1],
    # #                                                                       min = .1, max = .2))]
  }
  return(probs.and.costs.land)
}


get.plist.land.gr <- function(probs.and.costs = NULL,
                              improved.nodes = NULL, plist.land.init.data = NULL, 
                              prob.landslide = prob.landslide) {
  
  if (is.null(plist.land.init.data)) {
    plist.land.init.data <- get.plist.land.init.data()
  }
  
  plist.land.elements.ORAND <- plist.land.init.data[["plist.land.elements.ORAND"]]
  
  # Set failure probabilities for each element ------------------------------
  
  # TODO(xclotet) - possibility to upload a csv file with these data
  # 
  if (is.null(probs.and.costs)) {
    probs.and.costs <- get.probs.and.costs.land(probability.landslide = NULL)
  }
  
  aux <- get.plist.elements(improved.nodes = improved.nodes, 
                            probs.and.costs. = probs.and.costs, 
                            prob.landslide = prob.landslide, 
                            verbose = FALSE)
  plist.land.elements <- aux[[1]]
  c.land.invest <- aux[[2]]
  
  # Generate fault tree: compileCPT -----------------------------------------
  
  plist.land <- compileCPT(c(plist.land.elements,
                             plist.land.elements.ORAND), 
                           forceCheck = T)
  
  plist.land.gr <- grain(plist.land)
  
  return(list(plist.land.gr = plist.land.gr,
              c.land.invest = c.land.invest))
  
}  

get.road.BN <- function(probs.and.costs.land = NULL,
                        plist.land.init.data = NULL) {  
  
  aux <- get.plist.land.gr(probs.and.costs = probs.and.costs.land,
                           plist.land.init.data = plist.land.init.data)
  plist.land.gr <- aux[["plist.land.gr"]]
  
  # Get failure probabilities per node --------------------------------------
  
  get.failure.prob.per.node <- function(plist.land.gr) {
    aux <- lapply(querygrain(plist.land.gr), function(x) {
      x[1]
    })
    aux <- as.data.table(aux)
    aux <- melt(aux, variable.factor = F, measure.vars = names(aux))
    return(aux)
  }
  
  elements.all.fail.prob <- get.failure.prob.per.node(plist.land.gr)
  
  # Visualization -----------------------------------------------------------
  
  plot.aux <- igraph.from.graphNEL(plist.land.gr$dag)
  
  data <- toVisNetworkData(plot.aux) 
  
  aux.B1 <- paste0("B", seq(1, 51, by = 2))
  aux.B2 <- paste0("B", seq(0, 50, by = 2))
  data$nodes[data$nodes$id %in% aux.B2, "level"] <- 4
  data$nodes[data$nodes$id %in% aux.B1, "level"] <- 5
  
  data$nodes[grep(pattern = "A", x = data$nodes$id), "level"] <- 3
  data$nodes[grep(pattern = "E", x = data$nodes$id), "level"] <- 2
  data$nodes[data$nodes$id == "RoadFailure", "level"] <- 1
  
  nodes. <- data$nodes
  setDT(nodes.)
  nodes. <- merge(nodes., unique(land.elements), by.x = "id", by.y = "Name", all.x = T)
  
  set.color.land <- function(name) {
    switch(name,
           A23  = "blue",
           SS13 = "red",
           "black")
  }
  
  nodes.[, color.border := lapply(`Road/Railway Name`, set.color.land)]
  nodes.[, color.highlight.border := color.border]
  
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
  
  nodes.[, `:=`(`Road/Railway Name` = NULL, 
                `Element type` = NULL,  
                `Road/Railway` = NULL)]
  
  nodes. <- nodes.[grep("_", nodes.$id, invert = T), ]
  network.complete <- list(nodes = nodes., 
                           edges = data$edges)
  return(network.complete)
}

get.train.BN <- function(electrical.node.id = c("S9Hhhmmm", "S4hhm"), 
                         probs.and.costs = NULL,
                         plist.init.data = NULL) {
  return(get.electrical.BN(electrical.node.id, 
                           probs.and.costs = probs.and.costs,
                           plist.init.data = plist.init.data))
}



consequences.investment.assess.all.road <- function(probs.and.costs,  
                                                    node.interest, 
                                                    improvement.n.max = 11,
                                                    improvement.n.group = 3,
                                                    prob.landslide  = prob.landslide, 
                                                    shinyProgress = NULL,
                                                    plist.land.init.data. = get.plist.land.init.data(),
                                                    cost.failure = 2500000) {
  
  probs.and.costs. <- copy(probs.and.costs)
  aux <- get.plist.land.gr(probs.and.costs = NULL,
                           improved.nodes = NULL, plist.land.init.data = plist.land.init.data., 
                           prob.landslide = prob.landslide)
  node.interest <- "RoadFailure"
  plist.gr <- aux[["plist.land.gr"]]
  conds <- get.conditionals.land(bn = plist.gr,node.head = node.interest) %>% arrange(desc(yes)) %>% dplyr::select(-no)
  conds$relevance <- rownames(conds)
  
  # improvement.n.max most promising, groups of 0,1,2,...,improvement.n.group elements
  subs <- get.subsets(conds$name %>% head(improvement.n.max), improvement.n.group) 
  
  # Dataframe containing the computed costs and probs for each scenario of protection
  consequences.investment <- data.frame(id = numeric() , invest = numeric(), blackout = numeric(),
                                        repairing = numeric(), total = numeric(), prob.fallo = numeric())
  
  q <- length(subs)
  # q <- 50
  pb <- txtProgressBar(min = 1, max = q, style = 3)
  
  verbose <- F
  
  for (i in 1:q) {
    if (verbose) {
      cat(paste0("-----------------------------------(", i, "/", q, ")\n"))
    }
    res <- costs.total.land(cost.blackout = cost.failure,
                            node.head = node.interest,
                            data = probs.and.costs.,
                            prob.landslide = prob.landslide,
                            improved.nodes = subs[[i]],
                            plist.land.init.data. = plist.land.init.data.)
    
    res <- c(i, res)
    consequences.investment[nrow(consequences.investment) + 1, ] <- res
    setTxtProgressBar(pb, i)
    if (is.function(shinyProgress)) {
      shinyProgress(value = i/q)
    }
  }
  
  # add the names of the protected components
  consequences.investment$comb <- sapply(FUN = function(x) paste(x, collapse = " | "), X = subs[1:q])
  
  # adding the row "without investment"
  res <- costs.total.land(cost.blackout = cost.failure,
                          node.head = node.interest,
                          data = probs.and.costs.,
                          improved.nodes = c(),
                          plist.land.init.data. = plist.land.init.data.)
  
  res <- c(0, res, NA)
  consequences.investment[nrow(consequences.investment) + 1, ] <- res  
  
  # add the ranking in relevances
  consequences.investment <- consequences.investment %>% dplyr::arrange(total) 
  consequences.investment <- consequences.investment %>% dplyr::rowwise() 
  
  setDT(consequences.investment)
  # consequences.investment[, relevancias := relevancia(as.data.frame(conds), subs, id)]
  consequences.investment[, idoneo := prob.fallo * log10(invest)]
  consequences.investment[, l.invest := log10(invest)]
  
  return(consequences.investment)
}


get.conditionals.land <- function(bn, node.head){
  
  bn.wo.connectivity <- setEvidence(bn, nodes = c(node.head), states = c("yes"))
  
  nodos.fallables <- grep("B", bn$dag@nodes, value = T)
  
  aux <- data.frame(querygrain(bn.wo.connectivity, nodes = nodos.fallables))
  conditional <- data.table(t(aux))
  conditional[, name := names(aux)]
  
  return(conditional)
}

costs.total.land <- function(cost.blackout, node.head, data, improved.nodes,
                             verbose = FALSE, prob.landslide = prob.landslide, 
                             plist.land.init.data. = NULL){
  
  network <- get.plist.land.gr(probs.and.costs = data,
                               improved.nodes = improved.nodes, plist.land.init.data = plist.land.init.data., 
                               prob.landslide = prob.landslide)
  
  bn <- network[["plist.land.gr"]]
  c.inv <- network[["c.land.invest"]] 
  
  prob.black.out <- querygrain(bn, nodes = c(node.head))[[1]]["yes"]
  
  cost.bo.expected <- cost.blackout * prob.black.out
  cost.bo.std <- cost.blackout * sqrt(prob.black.out * (1 - prob.black.out))
  cost.bo.UB <- cost.bo.expected + cost.bo.std
  cost.bo.LB <- cost.bo.expected - cost.bo.std
  cost.bo.UB <- ifelse(cost.bo.UB > cost.blackout, cost.blackout, cost.bo.UB)
  cost.bo.LB <- ifelse(cost.bo.UB < 0, 0, cost.bo.LB)
  
  c.bo <- (cost.bo.expected + cost.bo.UB + cost.bo.LB)/3
  c.rep <- costs.repairing.land(prob.black.out, bn, node.head, data)
  
  total <- c.bo + c.rep + c.inv
  
  if (verbose) {
    cat(paste("***BLACKOUT in ", node.head, "*******",
              "\n   Prob =", pe(prob.black.out),
              "\n\n   Cost investment   = ", mo(c.inv),
              "\n   <Cost Blackout>   = ", mo(c.bo),
              "\n   <Cost repairing>  = ", mo(c.rep),
              "\n----------------------",
              "\n       total = ", mo(total),
              "\n\n"
    ))
  }
  
  c(c.invest = c.inv, c.bo = c.bo, 
    c.rep = c.rep, total = total, 
    prob.bo = prob.black.out)
}


costs.repairing.land <- function(prob.black.out, bn, node.head, data){
  conditional <- get.conditionals.land(bn, node.head)
  
  buf <- merge(conditional %>% dplyr::select(-no), data %>% dplyr::select(name, cost.rep))
  
  setnames(buf, "yes", "posterior")
  buf[, aux.std := sqrt(posterior * (1 - posterior)) * cost.rep]
  buf[, aux.expected := posterior * cost.rep]
  buf[, `:=`(cost.rep.LB = aux.expected - aux.std,
             cost.rep.UB = aux.expected + aux.std)]
  buf[cost.rep.LB < 0,        cost.rep.LB := 0]
  buf[cost.rep.UB > cost.rep, cost.rep.UB := cost.rep]
  
  return(prob.black.out * buf[, sum((aux.expected + cost.rep.LB + cost.rep.UB)/3)])
}