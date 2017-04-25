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
# scripts/analysisBN.R
# 
#######################################################

require(gRain)    # Bayesian Networks
require(data.table)
require(dplyr)
require(ggplot2)
require(viridis) # color palette


# Functions ---------------------------------------------------------------

# get combined pair OR probabilities
probPair <- function(pa, pb){
  return(pa + pb - pa*pb)
}

# get combined multiple OR probabilities
prob <- function(lista){
  acc <- lista[1]
  
  if (length(lista) == 1) {return(acc)}
  
  for (i in 2:length(lista)) {
    acc <- probPair(acc,lista[i])
  }
  return(acc)
}

# Generate probabilities in three sections (high /med /low )
generate.probs <- function(n, perc.high, prob.high, perc.med, prob.med, prob.low){
  
  n.high <- floor(n*perc.high/100)
  n.med <- floor(n*perc.med/100)
  n.low <- n - n.high - n.med
  
  cases.high <- rnorm(n.high, mean = prob.high, sd = prob.high/4)
  cases.med <- rnorm(n.med, mean = prob.med, sd = prob.med/4)
  cases.low <- abs(rnorm(n.low, mean = prob.low, sd = prob.low))
  
  sample(c(cases.high,cases.med, cases.low))   
}

# computes the direct costs of blackout using bayesian network: 
# (cost of blackout and repairing)
costs.total <- function(cost.blackout, node.head, data, improved.nodes,
                        verbose = FALSE, prob.landslide = prob.landslide, 
                        plist.init.data = NULL){
  
  # network <- create.network(improved.nodes = improved.nodes, probs.and.costs = data)
  network <- get.plist.gr(node.interest = node.head, probs.and.costs = data,
                          improved.nodes = improved.nodes, 
                          plist.init.data = plist.init.data, 
                          prob.landslide = prob.landslide)
  
  bn <- network[["plist.gr"]]
  c.inv <- network[["c.invest"]] 
  
  prob.black.out <- querygrain(bn, nodes = c(node.head))[[1]]["yes"]
  
  cost.bo.expected <- cost.blackout * prob.black.out
  cost.bo.std <- cost.blackout * sqrt(prob.black.out * (1 - prob.black.out))
  cost.bo.UB <- cost.bo.expected + cost.bo.std
  cost.bo.LB <- cost.bo.expected - cost.bo.std
  cost.bo.UB <- ifelse(cost.bo.UB > cost.blackout, cost.blackout, cost.bo.UB)
  cost.bo.LB <- ifelse(cost.bo.UB < 0, 0, cost.bo.LB)
  
  # c.bo <- cost.blackout * prob.black.out
  c.bo <- (cost.bo.expected + cost.bo.UB + cost.bo.LB)/3
  c.rep <- costs.repairing(prob.black.out, bn, node.head, data)
  
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

# creates the Bayesian network from the probability of nodes
get.plist.elements <- function(improved.nodes, probs.and.costs., 
                               prob.landslide = prob.landslide, 
                               verbose = FALSE){
  setDF(probs.and.costs.)
  c.invest <-  0
  yn <- c("yes", "no")
  elements.all.cptable <- probs.and.costs.[, c("name","marginal")]
  elements.all.cptable$name <- as.character(elements.all.cptable$name)
  
  
  # the ones with preventive measures
  if (length(improved.nodes) > 0) {
    imp <- unlist(improved.nodes)
    names(imp) <- NULL
    indices <- which(probs.and.costs.[, 1] %in% imp)
    improved.aux <- probs.and.costs.[indices, ]
    
    if (sum(c("marginal.better", "cost.rein") %in% names(improved.aux)) != 2) {
      improved.aux <- get.marginal.better.cost.rein(improved.aux, prob.landslide = prob.landslide)
    }
    
    elements.all.cptable[indices, ]$marginal <- improved.aux$marginal.better
    c.invest <- improved.aux$cost.rein %>% sum %>% unlist
    
    
    # Print the best options
    if (verbose) {
      print.improvement(improved.aux)
    }
  }
  
  
  elements.all.cptable$marginal <- 100 * as.numeric(elements.all.cptable$marginal)
  elements.all.cptable$prob.no  <- 100 - as.numeric(elements.all.cptable$marginal)
  colnames(elements.all.cptable) <- c("element", "prob.yes", "prob.no")
  
  setDT(elements.all.cptable)
  plist.elements <- elements.all.cptable[, 
                                         .(aux = list(cptable(element, 
                                                              values = c(prob.yes, 
                                                                         prob.no),
                                                              levels = yn))),
                                         by = element]$aux
  
  return(list(plist.elements, c.invest))
}

# get conditional probabilities given a blackout at node.head
get.conditionals <- function(bn, node.head){
  
  bn.wo.connectivity <- setEvidence(bn, nodes = c(node.head), states = c("yes"))
  
  nodos.fallables <- grep("Station|^m|^h", bn$dag@nodes, value = T)
  
  aux <- data.frame(querygrain(bn.wo.connectivity, nodes = nodos.fallables))
  conditional <- data.table(t(aux))
  conditional[, name := names(aux)]
  
  return(conditional)
}


# expected costs of reapairing elements
costs.repairing <- function(prob.black.out, bn, node.head, data){
  conditional <- get.conditionals(bn, node.head)
  
  buf <- merge(conditional %>% dplyr::select(-no), data %>% dplyr::select(name, cost.rep))
  # /-- Original:
  # prob.black.out * (buf %>% transmute(esp.cost = cost.rep * yes) %>% sum)
  # --/
  
  setnames(buf, "yes", "posterior")
  buf[, aux.std := sqrt(posterior * (1 - posterior)) * cost.rep]
  buf[, aux.expected := posterior * cost.rep]
  buf[, `:=`(cost.rep.LB = aux.expected - aux.std,
             cost.rep.UB = aux.expected + aux.std)]
  buf[cost.rep.LB < 0,        cost.rep.LB := 0]
  buf[cost.rep.UB > cost.rep, cost.rep.UB := cost.rep]
  
  # probs.and.costs.lines <- aux.towers[, .(marginal = prob(marginal),
  #                                         cost.rep = sum((aux.expected + cost.rep.LB +
  #                                                           cost.rep.UB)/3)), 
  #                                     by = "label_line"]
  
  return(prob.black.out * buf[, sum((aux.expected + cost.rep.LB + cost.rep.UB)/3)])
}

# chose subsets
get.subsets <- function(lista, n.max){
  sol <- lapply(X = 1:n.max, 
                FUN = function(x)combn(lista, x, 
                                       simplify = F)) %>% unlist(recursive = F)
  print(paste("Number of combinations: ", length(sol)))
  sol
}


relevancia <- function(conds, subs, indice){
  ifelse(indice > 0,
         paste0(conds[conds$name %in% subs[[indice]], "relevance"],
                collapse = " | "),
         "-")
}

# format printing
mo <- function(x) paste0(round(x/1000, 1), " kEUR")

pe <- function(x) paste0(round(x*100, 1), " %")

print.improvement <- function(x){
  cat(paste("*****Improved:", "\n"))
  for (i in 1:(dim(x)[1])) {
    cat(paste0("  *** [", x[i,]$name, "]: ", pe(x[i,]$marginal), " -> ", 
               pe(x[i,]$marginal.better), " (", mo(x[i,]$cost.rein), ")\n"))
  }
}

risk.profile.plot <- function(conds, num.shown = 10){
  data <- head(conds, num.shown)
  
  data$name2 <- factor(data$name, levels = rev(data$name))
  g <- ggplot(data, aes(name2, 100*yes))
  g + geom_bar(stat = "identity", aes(fill = name2)) + 
    coord_flip() +
    scale_fill_viridis(discrete = T, option = "plasma", begin = 0.65, end = 0.95) +
    theme_bw(base_size = 14) +
    theme(legend.position = "none") +
    labs(x = "", y = "Posterior failure probability (%)", title = "Risk Profile") +
    ylim(0, 100)
  
}

risk.profile.get.conditionals <- function(plist.gr, node.interest){
  conds <- get.conditionals(bn = plist.gr, node.head = node.interest) %>% 
    arrange(desc(yes)) %>% dplyr::select(-no)
  conds$relevance <- rownames(conds)
  return(conds)
}

consequences.investment.assess.all <- function(probs.and.costs,  
                                               node.interest, 
                                               improvement.n.max = 11,
                                               improvement.n.group = 3,
                                               prob.landslide  = prob.landslide, 
                                               shinyProgress = NULL,
                                               plist.init.data = NULL,
                                               cost.blackout = 2500000) {
  
  probs.and.costs. <- copy(probs.and.costs)
  aux <- get.plist.gr(node.interest = node.interest, 
                      probs.and.costs = probs.and.costs.,
                      prob.landslide = prob.landslide,
                      plist.init.data = plist.init.data)
  plist.gr <- aux[["plist.gr"]]
  conds <- get.conditionals(bn = plist.gr,node.head = node.interest) %>% arrange(desc(yes)) %>% dplyr::select(-no)
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
    res <- costs.total(cost.blackout = cost.blackout,
                       node.head = node.interest,
                       data = probs.and.costs.,
                       prob.landslide = prob.landslide,
                       improved.nodes = subs[[i]],
                       plist.init.data = plist.init.data)
    
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
  res <- costs.total(cost.blackout = cost.blackout,
                     node.head = node.interest,
                     data = probs.and.costs.,
                     improved.nodes = c(),
                     plist.init.data = plist.init.data)
  
  res <- c(0, res, NA)
  consequences.investment[nrow(consequences.investment) + 1, ] <- res  
  
  # add the ranking in relevances
  consequences.investment <- consequences.investment %>% dplyr::arrange(total) 
  consequences.investment <- consequences.investment %>% dplyr::rowwise() 
  
  setDT(consequences.investment)
  consequences.investment[, idoneo := prob.fallo * log10(invest)]
  consequences.investment[, l.invest := log10(invest)]
  
  return(consequences.investment)
}

consequences.investment.assess.best <- function(consequences.investment) {
  ids <- c()
  ap <- copy(consequences.investment)
  setDT(ap)
  prob. <- 1
  best.points <- data.table()
  
  while (nrow(ap) > 0) {
    # filter out the already chosen and the worst
    ap <- ap[prob.fallo < prob. & !(id %in% ids)]
    if (dim(ap)[1] > 0) {
      best.points <- rbindlist(list(best.points, ap[l.invest == min(l.invest), ]))
      
      prob. <- best.points[, min(prob.fallo)]
    }
  }
  
  return(best.points)
}

consequences.investment.plot <- function(best.points) {
  # native interactive version (Without coloring)
  xaxis <- list(
    title = "Investment in preventive protection (EUR)",
    rangemode = "tozero",
    titlefont = list(size = 16),
    tickfont = list(size = 14)
  )
  yaxis <- list(
    title = "Blackout occurrence probability (%)",
    rangemode = "tozero",
    titlefont = list(size = 16),
    tickfont = list(size = 14)
  )
  colorbar.props <- list(
    title = "Expected total <br>cost (EUR)",
    titlefont = list(size = 16),
    tickfont = list(size = 14),
    rangemode = "tozero"
  )
  plot. <- plotly::plot_ly(best.points, type = "scatter", mode = "markers",
                           x = ~(invest), y = ~(prob.fallo*100),
                           text = ~paste("Investment in component(s): ", 
                                         comb, "<br>Total cost: ", round(total/1000), " kEUR"), 
                           marker = list(size = 10, colorbar = colorbar.props), #symbol = "circle", size = 1,
                           color = ~ total, hoverinfo = "x+y+text")  %>%
    plotly::layout(xaxis = xaxis, yaxis = yaxis, showlegend = FALSE)
  return(plot.)
}

consequences.investment.plotbars <- function(best.points){
  setorder(best.points, total)
  best.points. <- best.points %>% head(10)
  
  if (dim(best.points.[is.na(comb), ])[1] == 0) {
    best.points. <- rbind(head(best.points., 9), best.points[is.na(comb), ])
  }
  
  a2.best <- melt(best.points. %>% select(invest,blackout,repairing, comb), c("comb"))
  
  a2.best[is.na(comb), comb := "No investment"]
  a2.best.agg <-  a2.best[, sum(value), by = comb]
  levels. <-  a2.best.agg$comb
  
  x <- letters[1:length(levels.)]
  y1 <- a2.best[variable == "invest",    value]
  y2 <- a2.best[variable == "blackout",  value]
  y3 <- a2.best[variable == "repairing", value]
  text <- paste0("Elements improved: ", levels.,
                 "<br>Expected total cost: ", round(a2.best.agg$V1/1000, 2), " kEUR")
  
  data <- data.frame(x, y1, y2, y3)
  
  p <- plotly::plot_ly(data, x = ~x, y = ~y1, type = 'bar', text = text, 
                       name = 'Investment',  marker = list(color = "#ffeda0"),
                       hoverinfo = "y+text") %>%
    plotly::add_trace(y = ~y2, name = 'Blackout',  marker = list(color = "#feb24c")) %>%
    plotly::add_trace(y = ~y3, name = 'Repairing',  marker = list(color = "#f03b20")) %>%
    plotly::layout(title = 'Cost breakdown for protection scenarios',
                   xaxis = list(title = 'Possible investment scenarios',
                                titlefont = list(size = 16),
                                tickfont = list(size = 14)),
                   yaxis = list(title = 'Cost (EUR)',
                                titlefont = list(size = 16),
                                tickfont = list(size = 14)),
                   barmode = 'relative',
                   hovermode = "closest")
  
  return(p)
}