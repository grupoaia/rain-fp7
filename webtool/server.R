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
# server.R
# -------------------------------------------------------------------------


# Server ------------------------------------------------------------------

require(shiny)
require(data.table)

shinyServer(function(input, output, session) {
  
  improvement.n.max.ctt <- 11
  demo.intensity <- 13
  demo.cumulative <- 106
  
  # TAB: Electrical Network Diagram >>> ----------------------------------
  # 
  output$Net.electrical <- renderVisNetwork({
    
    plot.grid(net) %>%
      visEvents(select = "function(nodes) {
                Shiny.onInputChange('current_node_id', nodes.nodes);
                ;}")
  })
  
  # <-- Electrical Network BN ---------------------------------------------
  electrical.BN <- reactiveValues(node.id = NULL,
                                  name = NULL,
                                  plist.init.data = NULL)
  
  network.complete <- reactive({
    if (!is.null(electrical.BN$node.id)) {
      return(get.electrical.BN(electrical.BN$node.id, 
                               probs.and.costs = probs.and.costs.reactive(),
                               plist.init.data = electrical.BN$plist.init.data))
    }
  })
  
  # TODO set to the proper section
  risk.profile.plot.get <- reactive({
    if (!is.null(electrical.BN$node.id)) {
      return(get.risk.profile.shiny(electrical.BN$node.id,
                                    probs.and.costs = probs.and.costs.reactive(),
                                    plist.init.data = electrical.BN$plist.init.data,
                                    improvement.n.max.ctt = improvement.n.max.ctt))
    }
  })
  
  output$risk.profile.plot <- renderPlot({
    risk.profile.plot.get()
  })
  
  output$Net.electrical.BN <- renderVisNetwork({
    if (!is.null(electrical.BN$node.id)) {
      visNetwork(nodes = network.complete()[["nodes"]],
                 edges = network.complete()[["edges"]] ) %>%
        visEdges(arrows = 'to', scaling = list(min = 2, max = 2)) %>%
        visOptions(highlightNearest = TRUE) %>%
        visHierarchicalLayout(enabled = T, levelSeparation = 200)
    }
  })
  
  output$nodes.BN <- renderUI( {
    if (!is.null(electrical.BN$node.id)) {
      aux. <- network.complete()[["nodes"]]
      print(aux.[id == paste0("Station_", electrical.BN$node.id),])
      print(aux.[id == electrical.BN$node.id,])
      box(
        title = paste0("Failure probabilities leading to a blackout at ",
                       electrical.BN$name, " station region"), 
        width = NULL, 
        color = "black", collapsible = T, collapsed = FALSE, status = "success",
        p(strong("Probability of blackout at ", electrical.BN$name, " station: ",
                 network.complete()[["nodes"]][id == electrical.BN$node.id,
                                               fail.prob],
                 "%"),"."),
        p(paste0("Bayesian network of the elements (stations and lines) leading to a
                 blackout at ", electrical.BN$name, " station region. Probabilities of failure
                 of each element are shown in colors from 0 (green) to 1 (red).")),
        p("A popup with the actual value rounded to 2 digits is available 
          on hovering each node. If clicked on a node, its first neighbours are
          highlighted. Zoom in/out using the scroll wheel."),
        visNetworkOutput("Net.electrical.BN", 
                         width = "100%", height = "500px")
      )
    }
  })
  
  output$risk.profile.UI <- renderUI( {
    if (!is.null(electrical.BN$node.id)) {
      box(
        # title = paste0("Risk profile for ", electrical.BN$name, " station affected"), 
        title = "Risk profile", 
        width = NULL, 
        color = "black", collapsible = T, collapsed = F, status = "success",
        p(paste0("Posterior failure probabilities of the electrical components given failure of ", 
                 electrical.BN$name, " station.")),
        p("Electrical components include stations and transmission/distribution lines."),
        plotOutput("risk.profile.plot")
      )
      
    }
  })
  
  
  
  # <-- Ewe -----------------------------------------------------------------
  ewe.info <- reactiveValues(title = character(),
                             text = character())
  get.ewe.info.title <- reactive({
    text <- paste("The main impacts of ", input$ewe, "are...")
  })
  
  get.ewe.info.html <- function(ewe.info.html) {
    return(includeHTML(ewe.info.html))
  }
  # 
  get.ewe.info.text <- eventReactive(input$ewe, {
    ewe.info.html <- paste0("www/", "impact_", "precipitation",".html")
    get.ewe.info.html(ewe.info.html)
  }, ignoreNULL = FALSE)
  
  get.ewe.info.text.trans <- eventReactive(input$ewe, {
    ewe.info.html <- paste0("www/", "trans_impact_", "precipitation",".html")
    get.ewe.info.html(ewe.info.html)
  }, ignoreNULL = FALSE)
  
  
  ewe <- reactiveValues(name = NULL, 
                        props = NULL, 
                        collapsed = FALSE,
                        values = NULL,
                        intensity = 0,
                        cumulative = 0) 
  
  output$ewe.config <- renderUI( {
    box(
      title = "Extreme Weather Event", width = NULL, solidHeader = TRUE, 
      status = "primary",
      collapsible = TRUE,
      collapsed = FALSE, #ewe$collapsed,
      selectInput("ewe", label = "Select EWE", 
                  choices = ewes[, unique(name)], 
                  selected = ewes[1, name]),
      uiOutput("ewe.controls"),
      uiOutput("ewe.return.time"),
      "More information at the ", a("Weather tab.", onclick = "openTab('weather')"),
      uiOutput("ewe.info.box")
    )
  })
  
  observeEvent(input$ewe, {
    ewe$name <- input$ewe
    ewe.info$title <- get.ewe.info.title()
    output$ewe.info.text <- renderUI({get.ewe.info.text()})
    ewe.info$text <- includeHTML("www/impact_precipitation.html")
    #   
    ewe$props <- ewes[name == ewe$name, 
                      stringi::stri_split_fixed(.SD, ","), 
                      .SDcols = c("variable_names", "variable_min", 
                                  "variable_max", "variable_units")]
    setnames(ewe$props, names(ewe$props), c("name", "min", "max", "units"))
    ewe$props[, name  := gsub(" ", name, replacement = "")]
    ewe$props[, units := gsub(" ", units, replacement = "")]
    ewe$props[, min   := as.numeric(min)]
    ewe$props[, max   := as.numeric(max)]
    ewe$props[, value := min]
  })
  
  output$trans_ewe.config <- renderUI( {
    box(
      title = "Extreme Weather Event", width = NULL, solidHeader = TRUE, 
      status = "primary",
      collapsible = TRUE,
      collapsed = FALSE, #ewe$collapsed,
      selectInput("trans_ewe", label = "Select EWE", 
                  choices = ewes[, unique(name)], 
                  selected = ewes[1, name]),
      uiOutput("trans_ewe.controls"),
      uiOutput("trans_ewe.return.time"),
      "More information at the ", a("Weather tab.", onclick = "openTab('weather')"),
      uiOutput("trans_ewe.info.box")
    )
  })
  
  observeEvent(input$trans_ewe, {
    ewe$name <- input$trans_ewe
    ewe.info$title <- get.ewe.info.title()
    output$trans_ewe.info.text <- renderUI({get.ewe.info.text.trans()})
    ewe.info$text <- includeHTML("www/trans_impact_precipitation.html")
    #   
    ewe$props <- ewes[name == ewe$name, 
                      stringi::stri_split_fixed(.SD, ","), 
                      .SDcols = c("variable_names", "variable_min", 
                                  "variable_max", "variable_units")]
    setnames(ewe$props, names(ewe$props), c("name", "min", "max", "units"))
    ewe$props[, name  := gsub(" ", name, replacement = "")]
    ewe$props[, units := gsub(" ", units, replacement = "")]
    ewe$props[, min   := as.numeric(min)]
    ewe$props[, max   := as.numeric(max)]
    ewe$props[, value := min]
  })
  
  output$ewe.info.box <- renderUI({
    box(title = ewe.info$title, collapsible = T, collapsed = T, width = NULL,
        solidHeader = TRUE,
        uiOutput("ewe.info.text"))
  })
  output$trans_ewe.info.box <- renderUI({
    box(title = ewe.info$title, collapsible = T, collapsed = T, width = NULL,
        solidHeader = TRUE,
        uiOutput("trans_ewe.info.text"))
  })
  
  output$ewe.controls <- renderUI({
    lapply(1:ewes[name == ewe$name, as.numeric(variable_n)], function(i) {
      sliderInput(inputId = ewe$props[i, name], 
                  label = paste0(ewe$props[i, name], 
                                 " (", ewe$props[i, units], ")"),
                  min = ewe$props[i, min], max = ewe$props[i, max], 
                  value = ewe$props[i, value])
    })
  })
  
  output$trans_ewe.controls <- renderUI({
    lapply(1:ewes[name == ewe$name, as.numeric(variable_n)], function(i) {
      sliderInput(inputId = paste0("trans_",ewe$props[i, name]), 
                  label = paste0(ewe$props[i, name], 
                                 " (", ewe$props[i, units], ")"),
                  min = ewe$props[i, min], max = ewe$props[i, max], 
                  value = ewe$props[i, value])
    })
  })
  
  return.time <- reactiveValues(rt.intensity = "less than 2",
                                rt.intensity.end21st = "less than 2",
                                rt.cumulative = "less than 2",
                                rt.cumulative.end21st = "less than 2")
  
  output$trans_ewe.return.time <- output$ewe.return.time <- renderUI({
    HTML(paste0(strong("Return times: "), 
                p("for this ", strong("intensity"), " level is ", 
                  return.time$rt.intensity, "years (",  
                  return.time$rt.intensity.end21st, " by the end of 21st century)"),
                p("for this ", strong("accumulated precipitation"), " is ",
                  return.time$rt.cumulative, " years (",
                  return.time$rt.cumulative.end21st, " by the end of 21st century)")))
  })
  
  observe({
    input$cumulative
    if (!is.null(input$ewe) & !is.null(input$cumulative)) {
      ewe$props[name == "cumulative", value := input$cumulative]
      updateSliderInput(session, inputId = "trans_cumulative", value = input$cumulative)
      print(ewe$props)
    }
    rt <- get.rt(ewe.value = input$cumulative, ewe = "cumulative")
    return.time$rt.cumulative <- strong(rt[["value"]])
    return.time$rt.cumulative.end21st <- strong(rt[["end21st"]])
  })
  
  observe({
    input$intensity
    if (!is.null(input$ewe) & !is.null(input$intensity)) {
      ewe$props[name == "intensity", value := input$intensity]
      updateSliderInput(session, inputId = "trans_intensity", value = input$intensity)
      print(ewe$props)
    }
    rt <- get.rt(ewe.value = input$intensity, ewe = "intensity")
    return.time$rt.intensity <- strong(rt[["value"]])
    return.time$rt.intensity.end21st <- strong(rt[["end21st"]])
  })
  
  observe({
    input$trans_cumulative
    if (!is.null(input$trans_ewe) & !is.null(input$trans_cumulative)) {
      ewe$props[name == "cumulative", value := input$trans_cumulative]
      if (!input$demo) {
        updateSliderInput(session, inputId = "cumulative", value = input$trans_cumulative)
      } else {
        updateSliderInput(session, inputId = "trans_cumulative", value = input$cumulative)
      }
      print(ewe$props)
    }
    rt <- get.rt(ewe.value = input$trans_cumulative, ewe = "cumulative")
    return.time$rt.cumulative <- strong(rt[["value"]])
    return.time$rt.cumulative.end21st <- strong(rt[["end21st"]])
  })
  
  observe({
    input$trans_intensity
    if (!is.null(input$trans_ewe) & !is.null(input$trans_intensity)) {
      ewe$props[name == "intensity", value := input$trans_intensity]
      if (!input$demo) {
        updateSliderInput(session, inputId = "intensity", value = input$trans_intensity)
      } else {
        updateSliderInput(session, inputId = "trans_intensity", value = input$intensity)
      }
      print(ewe$props)
    }
    rt <- get.rt(ewe.value = input$trans_intensity, ewe = "intensity")
    return.time$rt.intensity <- strong(rt[["value"]])
    return.time$rt.intensity.end21st <- strong(rt[["end21st"]])
  })
  
  # <-- Consequences assessment ---------------------------------------------
  
  probabilities <- reactiveValues(landslide = NULL, # probabilities.initialize()$p1, 
                                  landslide.perc = NULL, #round(probabilities.initialize()$p1*100), 
                                  best.points = NULL)
  
  observeEvent(input$reassessButton, {
    ewe$collapsed <- TRUE
  })
  
  probabilities.update <- function(cumulative = ewe$cumulative,
                                   intensity  = ewe$intensity) {
    if (cumulative == 0 & intensity == 0) {
      probabilities$landslide <- NULL
      probabilities$landslide.perc <- NULL
    } else {
      data.pred <- data.frame(cumulative = cumulative, 
                              intensity  = intensity)
      data.pred.hex <- as.h2o(data.pred,"data.pred.hex")
      pred <- as.data.frame(h2o.predict(p.landslide$model, data.pred.hex))  
      
      probabilities$landslide <- pred$p1
      probabilities$landslide.perc <- round(probabilities$landslide*100)
    }
    print(probabilities$landslide)
    return()
  }
  
  observeEvent(input$reassessButton, {
    ewe$cumulative <- input$cumulative
    ewe$intensity  <- input$intensity
    probabilities.update()
  })
  
  output$landslide.prob.ui <- renderUI({
    input
    HTML(paste0(strong("Landslide probability in the region")," is ", 
                strong(paste(probabilities$landslide.perc, "%")),
                " given cumulative rainfall  ", 
                ewe$cumulative, " ",
                ewe$props[name == "cumulative", units],
                " and intensity ", 
                ewe$intensity, " ",
                ewe$props[name == "intensity", units],
                "."))
  })
  
  observeEvent(input$trans_reassessButton, {
    ewe$cumulative <- input$trans_cumulative
    ewe$intensity  <- input$trans_intensity
    probabilities.update()
  })
  
  output$trans_landslide.prob.ui <- renderUI({
    input
    HTML(paste0(strong("Landslide probability in the region")," is ", 
                strong(paste(probabilities$landslide.perc, "%")),
                " given cumulative rainfall  ", 
                ewe$cumulative, " ",
                ewe$props[name == "cumulative", units],
                " and intensity ", 
                ewe$intensity, " ",
                ewe$props[name == "intensity", units],
                "."))
  })
  
  probs.and.costs.reactive <- reactive({
    return(get.probs.and.costs(probability.landslide = probabilities$landslide))
  })
  
  observeEvent(input$reassessConsequences, {
    # .------ DEMO / NO DEMO ------------------------------------------------
    if (input$demo) {
      id <- demo.values$demo
      print(paste0("demo.values$id = ", id))
      probabilities$best.points <- readRDS(file = paste0("Demo_", id, 
                                                         "_consequences_investment_best_points.rds"))
    } else {
      if (!is.null(electrical.BN$node.id)) {
        # Create a Progress object
        progress <- shiny::Progress$new()
        progress$set(message = "Assessing consequences... ", value = 0)
        # Close the progress when this reactive exits (even if there's an error)
        on.exit(progress$close())
        
        # Create a callback function to update progress.
        # Each time this is called:
        # - If `value` is NULL, it will move the progress bar 1/5 of the remaining
        #   distance. If non-NULL, it will set the progress to that value.
        # - It also accepts optional detail text.
        updateProgress <- function(value = NULL, detail = NULL) {
          if (is.null(value)) {
            value <- progress$getValue()
            value <- value + (progress$getMax() - value) / 5
          }
          progress$set(value = value, detail = detail)
        }
        
        print("============ assessing consequences")
        print(paste0("============ node: ", electrical.BN$node.id))
        
        consequences.investment <- consequences.investment.assess.all(probs.and.costs.reactive(),  
                                                                      node.interest = electrical.BN$node.id, 
                                                                      improvement.n.max = improvement.n.max.ctt,
                                                                      improvement.n.group = 4, 
                                                                      prob.landslide = probabilities$landslide,
                                                                      shinyProgress = updateProgress,
                                                                      plist.init.data = electrical.BN$plist.init.data)
        
        print("============ obtaining consequences best points")
        probabilities$best.points <- consequences.investment.assess.best(consequences.investment)
        
        saveRDS(consequences.investment, file = "Demo_X_consequences_investment.rds")
        saveRDS(probabilities$best.points, file = "Demo_X_consequences_investment_best_points.rds")
        
      }
    }
  })
  
  
  output$consequences.investment.plot <- renderPlotly(
    consequences.investment.plot(probabilities$best.points)
  )
  output$consequences.investment.plotbars <- renderPlotly(
    consequences.investment.plotbars(probabilities$best.points)
  )
  
  
  output$consequences.investment.ui <- renderUI( {
    if (!is.null(electrical.BN$node.id)) {
      if (is.null(probabilities$best.points)) {
        box(
          title = "Consequences plot", 
          width = NULL, 
          color = "black", collapsible = T, collapsed = FALSE, status = "success",
          p("To assess the economic consequences of a blackout and the possible 
            protection measures to be considered, click the Assess Consequences button."),
          actionButton("reassessConsequences", "Assess Consequences", 
                       icon = icon("retweet"))
        )
      } else {
        box(
          title = "Consequences plot", 
          width = NULL, 
          color = "black", collapsible = T, collapsed = FALSE, status = "success",
          p("To (re)assess the economic consequences of a blackout and the possible 
            protection measures to be considered in the new weather event scenario, 
            click the (r)Assess Consequences button."),
          actionButton("reassessConsequences", "(re)Assess Consequences", 
                       icon = icon("retweet")),
          hr(),
          p(paste0("Probability of occurence of a blackout at", electrical.BN$name,
                   " station region as a function of the investment in preventive protection. 
                   The expected total final cost (considering the expected indirect
                   costs of the blackout, the expected direct repairing costs, and the 
                   costs of the investment. The darker the marker, the better 
                   the investment scenario is.")),
          p("On hovering a datapoint, information regarding the total cost and 
            the components invested in is shown."),
          plotlyOutput("consequences.investment.plot"),
          hr(),
          p("The costs of the ten best investment scenarios are broken down in 
            investment cost, expected blackout cost (considering the probability 
            of blackout occurrence), and expected repairing cost of the affected 
            elements. These values are shown in the folowing figure." ),
          p("On hover, information regarding the investment scenario (elements 
            invested in) and the value of the expected total cost are displayed. 
            Clicking on the legend allows to hide/show each type of cost."),
          plotlyOutput("consequences.investment.plotbars")
        )
      }
    }
  })
  
  # <-- Town ----------------------------------------------------------------
  
  observeEvent(input$town, {
    print(input$town)
    probabilities$best.points <- NULL
    # Update map
    leafletProxy("map") %>%
      clearGroup(group = "Selected town") 
    if (!(input$town %in% c("", "(none)"))) {
      electrical.BN$node.id <- towns[name == input$town, stations]
      print(paste0("electrical.BN$node.id: ", electrical.BN$node.id))
      electrical.BN$name <- input$town
      print(paste0("electrical.BN$name: ", electrical.BN$name))
      grid.stations.aux <- grid.stations[name_extra == towns[name == input$town, 
                                                             stations], ]
      popup.aux <- paste(# sep = "<br/>", 
        paste0("<p style=\"background-color:#BFD9DA;\"><b>Station</b>: ", 
               grid.stations.aux$name_extra, "</p>"), 
        paste0("<b>Voltages</b>: ", grid.stations.aux$group_))
      
      leafletProxy("map") %>%
        addCircleMarkers(data = grid.stations.aux, 
                         label = grid.stations.aux$name, 
                         layerId = "Selected",   
                         color = grid.stations.aux$color_border, opacity = 0, 
                         fillColor = grid.stations.aux$color_background,
                         fillOpacity = 0.8,radius = 25,
                         popup = popup.aux, group = "Selected town") 
      
      output$town_info <- renderUI({
        HTML(paste0("Population affected: between ", 
                    strong(bu.summary[station == electrical.BN$node.id, round(People_min)]),
                    " and ", 
                    strong(bu.summary[station == electrical.BN$node.id, round(People_max)]),
                    " people. They represent between ",
                    bu.summary[station == electrical.BN$node.id, round(People_min_perc*100,
                                                                       digits = 1)],
                    " and ", 
                    bu.summary[station == electrical.BN$node.id, round(People_max_perc*100,
                                                                       digits = 1)],
                    " % of the population of the valley."))
      })
    } else {
      output$town_info <- renderUI({HTML("")})
      electrical.BN$node.id <- NULL
    }
  })
  
  # <-- map -----------------------------------------------------------------
  # 
  style <- isolate(input$style)
  
  telco.icon <- awesomeIcons(icon = "ion-wifi",
                             library = "ion",
                             markerColor = 	"lightgray")
  
  withProgress(message = 'preparing map', value = 0.2, style = style, {
    
    popup <- paste(
      paste0("<p style=\"background-color:#BFD9DA;\"><b>Station</b>: ", 
             grid.stations$name_extra, "</p>",
             "<p><img src = stations/", grid.stations$image, 
             " width = 300, height = '100%'></p>"), 
      paste0("<b>Voltages</b>: ", grid.stations$group_))
    
    incProgress(0.4)
    map_ <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", group =  "Default",
                       options = providerTileOptions(noWrap = TRUE))  %>%
      addTiles(group = "OSM") %>%
      addRasterImage(susc.map, colors = susc.pal, opacity = 0.6, 
                     layerId = "susc.layer", group = "Susceptibility") %>%
      addGeoJSON(topoData.Lines, fill = FALSE, group = "60 kV",
                 color = pal(60000)) %>%
      addGeoJSON(topoData.LinesH, fill = FALSE, group = "132 kV",
                 color = pal(132000)) %>%
      addGeoJSON(topoData.LinesMinor, fill = FALSE, group = "minor",
                 pal(-35)) %>%
      fitBounds(13.24, 46.48, 13.6, 46.55) %>%
      addCircleMarkers(data = grid.stations, 
                       label = grid.stations$name, 
                       layerId = grid.stations$name_extra,   
                       color = grid.stations$color_border, 
                       opacity = 0.4,
                       fillColor = grid.stations$color_background,
                       fillOpacity = 0.5,
                       popup = popup ) %>%
      addAwesomeMarkers(data = telco.towers, 
                        lng = ~X, lat = ~Y,
                        icon = telco.icon,
                        group = "Telco Towers") %>% 
      addLayersControl(
        baseGroups = c("Default", "OSM"),
        overlayGroups = c("Telco Towers", "132 kV", "60 kV", "minor","Susceptibility"),
        options = layersControlOptions(collapsed = T)
      ) 
    incProgress(0.8)
  })
  # Update MAP
  myMap <- reactive({
    map.ret <- map_
    return(map.ret)
  })
  
  output$map <- renderLeaflet({
    myMap()
  })
  
  observeEvent(input$map_marker_click, {
    print(paste0("input$map_marker_click: ", input$map_marker_click))
    print(paste0("input$map_marker_click$id: ", input$map_marker_click$id))
    if (!input$demo) { 
      if (!is.null( input$map_marker_click$id)) {
        aux.id <- gsub(pattern = "_", replacement = "", input$map_marker_click$id)
        # if (!is.null( input$map_marker_click$id) & input$map_marker_click$id != "Selected") {
        if (aux.id %in% towns$stations) {
          if (is.null(electrical.BN$node.id)) {
            electrical.BN$node.id <- aux.id
            electrical.BN$name <- towns[stations == electrical.BN$node.id, name]
            updateSelectInput(session, "town",
                              selected = electrical.BN$name )
          } else {
            if (aux.id != electrical.BN$node.id & aux.id != "Selected") {
              electrical.BN$node.id <- aux.id
              electrical.BN$name <- towns[stations == electrical.BN$node.id, name]
              updateSelectInput(session, "town",
                                selected = electrical.BN$name )
            }
          }
        } else if (aux.id != "Selected") {
          electrical.BN$node.id <- aux.id
          electrical.BN$name <- aux.id
          leafletProxy("map") %>%
            clearGroup(group = "Selected town") 
          updateSelectInput(session, "town", selected = "(none)")
        }
      }
    }
  })
  
  observeEvent(input$reloadMap, {
    output$map <- renderLeaflet({
      myMap()
    })
  })
  
  observeEvent(input$trans_reloadMap, {
    output$trans_map <- renderLeaflet({
      trans_myMap()
    })
  })
  
  
  
  # <-- map : grid station & line info ---------------------------------------
  
  output$grid.stations.DT <- DT::renderDataTable({
    data. <- get.electric.stations(grid.stations)[, Color := NULL]
    cols.names  <- c( "Only minor", "132k", "60k", "60k Minor", "132k 60k Minor")
    cols.values <- c( "cornflowerblue", "gray", "chocolate", "chocolate", "chocolate")
    DT::datatable(data., 
                  extensions = 'Responsive', rownames = FALSE) %>% 
      DT::formatStyle(
        'Voltage level(s)',
        target = 'row',
        backgroundColor = DT::styleEqual(cols.names,cols.values)
      )
  } )
  
  output$grid.lines.DT <- DT::renderDataTable({
    data. <- get.electric.lines(grid.lines)
    cols.names  <- c( "132k", "60k", "minor")
    cols.values <- c( pal(132000), pal(60000), pal(-35))
    cols.values <- c( "#91cfaa", "#8bdfaf", "#bae3d5")
    DT::datatable(data., extensions = 'Responsive', 
                  rownames = FALSE, selection = 'single') %>% 
      DT::formatStyle(
        'Voltage level',
        target = 'row',
        backgroundColor = DT::styleEqual(cols.names,cols.values)
      )
  })
  
  output$mapstations <- renderUI( {
    box(
      title = "List of electrical stations", 
      width = NULL,
      status = "warning",
      collapsible = T, 
      collapsed = T,
      DT::dataTableOutput("grid.stations.DT")
    )
  })
  
  output$maplines <- renderUI( {
    box(
      title = "List of electrical lines", 
      width = NULL,
      status = "warning",
      collapsible = T, 
      collapsed = T,
      DT::dataTableOutput("grid.lines.DT")
    )
  })
  
  
  observe({
    aux <- input$grid.stations.DT_rows_selected
    if (length(aux)) {
      grid.stations.aux <- grid.stations[aux, ]
      popup <- paste(
        paste0("<p style=\"background-color:#BFD9DA;\"><b>Station</b>: ", 
               grid.stations.aux$name_extra, "</p>",
               "<p><img src = stations/", grid.stations.aux$image, 
               " width = 300, height = '100%'></p>"), 
        paste0("<b>Voltages</b>: ", grid.stations.aux$group_))
      leafletProxy("map") %>%
        clearGroup("station") %>%
        addCircleMarkers(data = grid.stations.aux, 
                         # layerId = "station",  
                         layerId = paste0("_", grid.stations.aux$name_extra),
                         color = "black", opacity = 0.8, 
                         fillColor = "black",
                         fillOpacity = 0, radius = 25,
                         group = "station",
                         popup = popup) 
    } else {
      leafletProxy("map") %>%
        clearGroup("station")
    }
  })
  
  
  observe({
    aux <- input$grid.lines.DT_rows_selected
    if (length(aux)) {
      aux.line <- grid.lines[aux, .(label, group_)]
      print(paste0("-------- aux.line: ", aux.line))
      select.topoData <- function(group_){
        switch(group_, 
               `132k` = topoData.LinesH,
               `60k`  = topoData.Lines,
               minor = topoData.LinesMinor)
      }
      print(aux.line)
      grid.lines.aux <- topoData.getSingleLine(select.topoData(aux.line$group_),
                                               id_variablename = aux.line$label)
      grid.lines.aux <- topoData.setColor.single(dataset = grid.lines.aux, 
                                                 color. = "#FFFF00")
      leafletProxy("map") %>%
        clearGroup("lines") %>%
        addGeoJSON(grid.lines.aux, 
                   # layerId = "station", 
                   opacity = 1, 
                   fill = FALSE,
                   group = "lines") 
    } else {
      leafletProxy("map") %>%
        clearGroup("lines")
    }
  })
  
  
  # 
  # <-- context (region) -----------------------------------------------------
  output$context <- renderUI( {
    if (!is.null(electrical.BN$node.id)) {
      box(
        title = paste0("Sectoral distribution of ", 
                       electrical.BN$name), 
        width = NULL, 
        status = "warning",
        collapsible = T, 
        p("Distribution of buildings per sector in the region selected compared 
          to the whole valley (measured in percentage of the area used)."),
        p("This information together with population values allow to obtain the 
          type of electrical consumers and an estimation of their consumption. 
          The indirect cost of the blackout depends on this consumption."),
        plotOutput("bu.area.plot")
        # p(".")
      )
    }
  })
  
  # TODO finish it up: use this information to assess Blackout indirect costs
  
  bu.area <- reactiveValues(selected = NULL)
  
  observeEvent(electrical.BN$node.id, {
    print(paste0("electrical.BN$node.id a: ", electrical.BN$node.id))
    aux <- bu.area.summary[station == electrical.BN$node.id, 
                           .(Label, Area_Perc_by_label/sum(Area_Perc_by_label))]
    setnames(aux, "V2", "Area_Perc_by_label")
    aux <- merge(bu.area.all[, .(Label)], aux, by = "Label", all.x = TRUE)
    aux[, Region := electrical.BN$name]
    aux[is.na(Area_Perc_by_label), Area_Perc_by_label := 0]
    
    bu.area$selected <- rbind(bu.area.all, aux)
    
    if (!is.null(electrical.BN$node.id)) {
      print(paste0("length(electrical.BN$node.id): ", length(electrical.BN$node.id)))
      if (length(electrical.BN$node.id) > 1) {
        print(paste0("electrical.BN$node.id: ", electrical.BN$node.id))
        electrical.BN$plist.init.data <- get.plist.init.data(node.interest = electrical.BN$node.id)
      }
    }
  })
  
  output$bu.area.plot <- renderPlot({
    cols = c("gray", "firebrick")
    
    ggplot(bu.area$selected) + 
      geom_bar(aes(x = factor(Label, 
                              levels = c("Residential", "Residential + Services",
                                         "Services", "Industrial","Public Services",
                                         "Energy Distribution")), 
                   y = Area_Perc_by_label*100, fill = Region),
               stat = "identity", position = "dodge") +
      ylab("Percentage") + ylim(c(0,100)) + xlab("") + 
      scale_fill_manual(values = cols) +
      theme_bw(base_size = 16) + theme(legend.position = c(0.85, 0.8)) +
      coord_flip() 
  })
  
  
  # <<< Demo mode >>> -------------------------------------------------------
  
  demo.options <- fread("Demo_info.csv")
  demo.default.town <- "Valbruna"
  
  demo.values <- reactiveValues(town = demo.default.town,
                                node.id = towns[name == demo.default.town, stations],
                                demo = demo.options[town == demo.default.town, demo],
                                intensity = demo.options[town == demo.default.town, intensity],
                                cumulative = demo.options[town == demo.default.town, cumulative])
  
  demo.values.update <- function(town.) {
    if (is.null(town.)) {
      town. <- demo.default.town
    }
    demo.values$intensity <- demo.options[town == town., intensity]
    demo.values$cumulative <- demo.options[town == town., cumulative]
    demo.values$demo <- demo.options[town == town., demo]
    demo.values$town <- town.
    updateSelectInput(session, "town",
                      selected = demo.values$town)
    updateSelectInput(session, "intensity",
                      selected = demo.values$intensity)
    updateSelectInput(session, "cumulative",
                      selected = demo.values$cumulative)
    electrical.BN$name <- town.
    electrical.BN$node.id <- towns[name == electrical.BN$name, stations]
    ewe$cumulative = input$cumulative
    ewe$intensity  = input$intensity
    probabilities.update(cumulative = demo.values$cumulative,
                         intensity  = demo.values$intensity)
    return()
  }
  
  
  observeEvent(input$demo, {
    if (input$demo) {
      demo.values.update(electrical.BN$name)
    } else {
      
    }
  })
  
  observeEvent(input$cumulative, {
    if (input$demo) {
      updateSelectInput(session, "cumulative",
                        selected = demo.values$cumulative )
    }
  })
  
  observeEvent(input$intensity, {
    if (input$demo) {
      updateSelectInput(session, "intensity",
                        selected = demo.values$intensity )
    }
  })
  
  observeEvent(input$town, {
    if (input$demo) {
      if (input$town != demo.values$town) {
        demo.values.update(input$town)
      }
    }
  })
  
  
  # TAB: Land Transportation >>> ---------------------------------------------
  # 
  # <-- land transportation set up -------------------------------------------
  
  style <- isolate(input$style)
  
  withProgress(message = 'preparing transportation map', value = 0.2, style = style, {
    
    
    incProgress(0.4)
    trans_map_ <- leaflet() %>%
      addProviderTiles("CartoDB.Positron", group =  "Default",
                       options = providerTileOptions(noWrap = TRUE))  %>%
      addTiles(group = "OSM") %>%
      addRasterImage(susc.map, colors = susc.pal, opacity = 0.6, 
                     layerId = "susc.layer", group = "Susceptibility") %>%
      addGeoJSON(railway, fill = FALSE,
                 color = "#485445", group = "Railway") %>%
      addGeoJSON(railway.bridges, fill = FALSE,
                 color = "#C9C9C9", weight = 8, group = "Railway") %>%
      addGeoJSON(railway.tunnels, fill = FALSE,
                 color = "#000000", weight = 8, group = "Railway") %>%
      addGeoJSON(road.SS13, fill = FALSE,
                 color = "#EE2020", group = "Road SS13") %>%
      addGeoJSON(road.SS13.bridges, fill = FALSE,
                 color = "#FD9999", weight = 8, group = "Road SS13") %>%
      addGeoJSON(road.SS13.tunnels, fill = FALSE,
                 color = "#860909", weight = 8, group = "Road SS13") %>%
      addGeoJSON(road.A23, fill = FALSE,
                 color = "#0104C5", group = "Road A23") %>%
      addGeoJSON(road.A23.bridges, fill = FALSE,
                 color = "#999BFD", weight = 8, group = "Road A23") %>%
      addGeoJSON(road.A23.tunnels, fill = FALSE,
                 color = "#040663", weight = 8, group = "Road A23") %>%
      fitBounds(13.24, 46.48, 13.6, 46.55) %>%
      addLayersControl(
        baseGroups = c("Default", "OSM"),
        overlayGroups = c("Railway", "Road A23", "Road SS13","Susceptibility"),
        options = layersControlOptions(collapsed = T)
      ) 
    incProgress(0.8)
  })
  
  # Update MAP
  trans_myMap <- reactive({
    map.ret <- trans_map_
    return(map.ret)
  })
  
  output$trans_map <- renderLeaflet({
    trans_myMap()
  })
  
  
  
  
  # <-- Land Transportation BN : roads ---------------------------------------
  road.BN <- reactiveValues(plist.land.init.data = NULL)
  
  probs.and.costs.land.reactive <- reactive({
    return(get.probs.and.costs.land(probability.landslide = probabilities$landslide))
  })
  
  trans_network.complete <- reactive({
    return(get.road.BN(probs.and.costs.land = probs.and.costs.land.reactive(),
                       plist.land.init.data = road.BN$plist.land.init.data))
  })
  
  output$Net.road.BN <- renderVisNetwork({
    visNetwork(nodes = trans_network.complete()[["nodes"]],
               edges = trans_network.complete()[["edges"]] ) %>%
      visEdges(arrows = 'to', scaling = list(min = 2, max = 2)) %>%
      visOptions(highlightNearest = TRUE) %>%
      visHierarchicalLayout(enabled = T, levelSeparation = 200)
  })
  
  output$nodes.road.BN <- renderUI({
    box(
      title = paste0("Failure probabilities leading to loss of road transportation
                     communication"), 
      width = NULL, 
      color = "black", collapsible = T, collapsed = FALSE, status = "success",
      p(strong("Probability of total road disconnection: ",
               trans_network.complete()$nodes[id == "RoadFailure", fail.prob],
               "%"),"."),
      p(paste0("Bayesian network of the elements (bridges) leading loss of
               connectivity in the valley. Probabilities of failure
               of each element are shown in colors from 0 (green) to 1 (red).")),
      p("A popup with the actual value rounded to 2 digits is available 
        on hovering each node. If clicked on a node, its first neighbours are
        highlighted. Zoom in/out using the scroll wheel."),
      visNetworkOutput("Net.road.BN", 
                       width = "100%", height = "500px")
    )
  })
  
  # <-- Land Transportation BN : train ---------------------------------------
  
  train.BN <- reactiveValues(node.id = c("S9Hhhmmm", "S4hhm"),
                             name = NULL,
                             plist.init.data = NULL)
  
  train_network.complete <- reactive({
    return(get.train.BN(electrical.node.id = train.BN$node.id,
                        probs.and.costs = probs.and.costs.reactive(),
                        plist.init.data = train.BN$plist.init.data))
  })
  
  output$Net.train.BN <- renderVisNetwork({
    visNetwork(nodes = train_network.complete()[["nodes"]],
               edges = train_network.complete()[["edges"]] ) %>%
      visEdges(arrows = 'to', scaling = list(min = 2, max = 2)) %>%
      visOptions(highlightNearest = TRUE) %>%
      visHierarchicalLayout(enabled = T, levelSeparation = 200)
  })
  
  
  output$nodes.train.BN <- renderUI({
    box(
      title = paste0("Failure probabilities leading to loss of train transportation
                     communication"), 
      width = NULL, 
      color = "black", collapsible = T, collapsed = FALSE, status = "success",
      p(strong("Failure probability of the electrical infrastructure ", 
               "feeding the railway: ",
               train_network.complete()$nodes[id == "Electrical_Failure", fail.prob],
               "%"),"."),
      p(paste0("Bayesian network of the electrical elements that feed Pontebba 
               and Ugovizza Valbruna train stations. If electrical failure 
               occurs, train does not work and leads to a loss of train 
               connectivity in the valley. Probabilities of failure of each 
               element are shown in colors from 0 (green) to 1 (red).")),
      p("A popup with the actual value rounded to 2 digits is available 
        on hovering each node. If clicked on a node, its first neighbours are
        highlighted. Zoom in/out using the scroll wheel."),
      visNetworkOutput("Net.train.BN", 
                       width = "100%", height = "500px")
    )
  })
  
  # <-- trans_map : tunnels & bridges info -----------------------------------
  
  get.land.elements <- reactive({
    aux <- copy(land.elements)
    aux[, `Road/Railway Name` := factor(`Road/Railway Name`)]
    aux[, `Road/Railway` := factor(`Road/Railway`)]
    aux[, `Element type` := factor(`Element type`)]
    return(aux)
  })
  
  output$land.bridges.tunnels.DT <- DT::renderDataTable({
    data. <-  get.land.elements()
    DT::datatable(data., extensions = 'Responsive', 
                  rownames = FALSE, selection = 'single',
                  options = list(searchHighlight = TRUE), 
                  filter = 'top')
  })
  
  
  output$maproads <- renderUI( {
    box(
      title = "List of land transportation elements", 
      width = NULL,
      status = "warning",
      collapsible = T, 
      collapsed = T,
      DT::dataTableOutput("land.bridges.tunnels.DT")
    )
  })
  
  observe({
    aux <- input$land.bridges.tunnels.DT_rows_selected
    if (length(aux)) {
      aux.land.element <- land.elements[aux, ]
      print(paste0("-------- aux.land.element: ", aux.land.element))
      select.topoData_trans <- function(aux.land.element){
        if (aux.land.element$`Road/Railway` == "road") {
          aux.land.element[, paste0(`Road/Railway`, ".", 
                                    `Road/Railway Name`, ".",
                                    `Element type`, "s")]
        } else {
          paste0("railway.", aux.land.element$`Element type`, "s")
        }
      }
      land.element.aux <- topoData.getSingleLine(get(select.topoData_trans(aux.land.element)),
                                                 id_variablename = aux.land.element$Name,
                                                 variablename = "Label")
      leafletProxy("trans_map") %>%
        clearGroup("land.element") %>%
        addGeoJSON(land.element.aux, 
                   # layerId = "station", 
                   opacity = 1, 
                   fill = FALSE,
                   color = "#FFFF00", weight = 10,
                   group = "land.element") 
    } else {
      leafletProxy("trans_map") %>%
        clearGroup("land.element")
    }
  })
  
  # TAB: Configuration >>> ---------------------------------------------------
  # 
  withProgress(message = 'preparing landslide data', value = 0.2, style = style, {
    
    # Available landslide model data available
    region.landslide <- reactiveValues(name = region.landslide.initial[1, name],
                                       filename = region.landslide.initial[1, filename],
                                       data = as.data.table(dplyr::collect(t.region.landslide)))
    
    # Current landslide model used
    p.landslide <- reactiveValues(filename =
                                    region.filename.initial, 
                                  data = 
                                    readRDS(file.path(region.filename.path, 
                                                      paste0(region.filename.initial,
                                                             ".rds"))),
                                  modelname = file.path(region.filename.path, 
                                                        paste0(region.filename.initial,
                                                               "_model")),
                                  model = NULL,
                                  modeldata = readRDS(file.path(region.filename.path, 
                                                                paste0(region.filename.initial,
                                                                       "_model_data.rds"))))
    
    incProgress(0.5)
    
    incProgress(0.8)
    withProgress(message = 'Ready!', detail = "There you go!",
                 style = style, value = NULL, {
                   Sys.sleep(0.7)
                 })
  })
  
  
  # Select model to be used
  output$region_config <- renderUI({
    selectInput("region_landslide_selected", 
                label = "Select landslide model", 
                choices = region.landslide$data[, name], 
                selected = region.landslide$data[1, name])
  })
  
  
  observeEvent(input$region_landslide_selected,{
    region.landslide$name <- input$region_landslide_selected
    region.landslide$filename <- region.landslide$data[name == input$region_landslide_selected, filename]
  })
  # 
  output$trans_region.landslide_title <- output$region.landslide_title <- renderText({
    paste0(region.landslide$name)
  })
  
  observeEvent(region.landslide$filename, {
    p.landslide$filename = region.landslide$filename
    p.landslide$data = readRDS(file.path(region.filename.path, 
                                         paste0(region.landslide$filename,
                                                ".rds")))
    p.landslide$modeldata = readRDS(file.path(region.filename.path, 
                                              paste0(region.landslide$filename,
                                                     "_model_data.rds")))
    p.landslide$modelname = file.path(region.filename.path, 
                                      paste0(region.landslide$filename,
                                             "_model"))
  })
  
  
  # Load h2o landslide model (into current landslide model used)
  observeEvent(p.landslide$modelname, {
    p.landslide$model <- p.landslide.load.model(p.landslide$modelname)
    output$ready <- renderText({ 
      "ready!"
    })
  })
  
  values <- reactiveValues(
    file.probs = NULL,
    reset = 0,
    error.msg = NULL
  )
  
  output$resettableInput.landslides <- renderUI({
    input$clearfile.probs
    values$reset
    fileInput('file.probs', 
              'Upload a new landslide historical data file (csv) \n
              [format: cumulative (mm), intensity (mm/h), occurrence (1 or 0)]',
              accept = c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv'))
  })
  
  observeEvent(input$file.probs, {
    values$file.probs <- input$file.probs
    print(values$file.probs)
  })
  
  observe({
    input$clearfile.probs
    values$file.probs <- NULL
  })
  
  
  data.new <- reactiveValues(data = NULL)
  
  data.uploaded <- reactive({ 
    print(values$file.probs)
    if (!is.null(values$file.probs)) {
      print(values$file.probs)
      inFile <- values$file.probs 
      
      read.data <- fread(inFile$datapath)
      
      if (probs.check.readfile.format(read.data)) {
        if (!("cumulative" %in% names(read.data))) {
          setnames(read.data, names(read.data), c("cumulative","intensity", "occurrence"))
        }
        read.data[, origin := "New data"]
      } else {
        read.data <- NULL
        values$reset <- values$reset + 1
      }
    } else {
      read.data <- NULL
    }
    return(read.data)
  })
  
  probs.check.readfile.format <- function(read.data) {
    ret <- 1
    if (dim(read.data)[2] != 3) {
      ret <- 0
      values$error.msg <- "Invalid number or names of columns."
    }
    return(ret)
  }
  
  observeEvent(values$file.probs, {
    data.new$data <- data.uploaded()
  })
  
  probs.wrong.format.Modal <- function() {
    modalDialog(
      title = "Invalid Landslide historical data file format",
      footer = modalButton("Dismiss"),
      size = "m", easyClose = TRUE,
      h4(values.eng$error.msg),
      p("Format: cumulative (mm), intensity (mm/h), occurrence (1 or 0).")
    )
  }
  
  # Show modal when button is clicked.
  observeEvent(values$error.msg, {
    showModal(probs.wrong.format.Modal())
  })
  
  
  output$p.landslide.model.plot <- renderPlotly({
    gg <- ggplot(p.landslide$modeldata) + 
      geom_raster(aes(x = cumulative, y = intensity, fill = probability)) +
      geom_contour(aes(x = cumulative, y = intensity, z = probability), 
                   colour = "white") + 
      scale_fill_viridis("Probability", end = 0.95, direction = -1, 
                         limits = c(0, 1.05)) +
      theme_bw() +
      labs(title = "Probability model of landslide in the region",
           x = "Cumulative precipitation (mm)",
           y = "Intensity (mm/h)")  
    ggplotly(gg)
  })
  
  data.plot <- reactive({
    data.plot.current <- p.landslide$data[, .(cumulative, intensity, occurrence)]
    data.plot.current$origin <- "Currently Used"
    
    # data.plot.new <- data.uploaded()
    data.plot.new <- data.new$data 
    data.plot <- rbind(data.plot.current, data.plot.new)
    return(data.plot)
  })
  
  output$p.landslide.plot <- renderPlotly({
    g <-  ggplot(data.plot(), aes(cumulative, intensity))  + 
      geom_point(aes(color = factor(occurrence), shape = origin)) + 
      scale_shape_discrete("Data origin") + 
      scale_color_discrete("Occurrence", 
                           breaks = c(0,1), 
                           labels = c("No", "Yes")) + 
      theme_bw() +
      labs(title = "Historical data of landslides in the region",
           x = "Cumulative precipitation (mm)",
           y = "Intensity (mm/h)")  
    
    ggplotly(g)
  })
  
  
  # <-- Compute new probability model --------------------------------------
  output$computemodel.modal <- renderUI({
    wellPanel(
      strong("Do you want to compute a new probability model with the new data uploaded?"), 
      br(),
      actionButton("computemodel.yes.all", "Yes, using new uploaded data and previous data"), 
      br(),
      actionButton("computemodel.yes.new", "Yes, using ONLY new uploaded data"),
      br(),
      actionButton("computemodel.no", "No"),
      br(),
      textInput("computemodel.name", label = strong("Model name:"), 
                value = paste0("New_model_",round(runif(1,min = 0, max = 999999))))
    )
  })
  
  observeEvent(input$computemodel.no, {
    print("-------------NO---------------")
    toggleModal(session, "modalExample", toggle = "close")
  })
  
  observeEvent(input$computemodel.yes.all, {
    toggleModal(session, "modalExample", toggle = "close")
    
    progress <- shiny::Progress$new()
    progress$set(message = "Computing new model... ", value = 0)
    on.exit(progress$close())
    
    updateProgress <- function(value = NULL, detail = NULL) {
      if (is.null(value)) {
        value <- progress$getValue()
        value <- value + (progress$getMax() - value) / 5
      }
      progress$set(value = value, detail = detail)
    }
    
    p.landslide.compute.model(model.input = data.plot()[, origin := NULL], 
                              model.name  = input$computemodel.name, 
                              model.filename.path = region.filename.path,
                              updateProgress = updateProgress)
    
    # TO ADD: update reading from DB <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    region.landslide$data <- as.data.table(dplyr::collect(t.region.landslide))
    data.new$data <- NULL
    values$file.probs <- NULL
    values$reset <- values$reset + 1
    updateSelectInput(session, "region_landslide_selected", 
                      selected = input$computemodel.name)
  })
  
  observeEvent(input$computemodel.yes.new, {
    toggleModal(session, "modalExample", toggle = "close")
    
    progress <- shiny::Progress$new()
    progress$set(message = "Computing new model... ", value = 0)
    on.exit(progress$close())
    
    updateProgress <- function(value = NULL, detail = NULL) {
      if (is.null(value)) {
        value <- progress$getValue()
        value <- value + (progress$getMax() - value) / 5
      }
      progress$set(value = value, detail = detail)
    }
    
    p.landslide.compute.model(model.input = data.plot()[origin == "New data"][, origin := NULL], 
                              model.name  = input$computemodel.name, 
                              model.filename.path = region.filename.path, 
                              updateProgress = updateProgress)
    
    # TO ADD: update reading from DB
    region.landslide$data <- as.data.table(dplyr::collect(t.region.landslide))
    data.new$data <- NULL
    values$file.probs <- NULL
    values$reset <- values$reset + 1
    updateSelectInput(session, "region_landslide_selected", 
                      selected = input$computemodel.name)
  })
  
  
  # <-- Insert new engineering measures -------------------------------------
  
  values.eng <- reactiveValues(
    file.eng = NULL,
    reset.eng = 0,
    error.msg = NULL
  )
  
  output$resettableInput.eng <- renderUI({
    input$clearfile.eng
    values.eng$reset.eng
    fileInput('file.eng', 
              'Upload a new engineering measures data file (csv). \n
              See format above and available element options below.',
              accept = c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv'))
  })
  
  observeEvent(input$file.eng, {
    values.eng$file.eng <- input$file.eng
    print(values.eng$file.eng)
  })
  
  observe({
    input$clearfile.eng
    values$file.eng <- NULL
  })
  
  
  
  eng.measures.check.readfile.format <- function(read.data) {
    ret <- 1
    names. <- names(read.data)
    print(names.)
    names.proper <- c("name", "id_element", "improvement", 
                      "cost_improvement", "description", 
                      "id_type_element")
    if (length(names.) == 6) {
      if (sum(names. %in% names.proper) != 6) {
        ret <- 0
        values.eng$error.msg <- "Invalid number or names of columns."
      }
    } else if (length(names.) == 5) {
      if (sum(names. %in% names.proper[1:5]) != 5) {
        ret <- 0
        values.eng$error.msg <- "Invalid number or names of columns."
      }
    } else {
      ret <- 0
      values.eng$error.msg <- "Invalid number of columns."
    }
    return(ret)
  }
  
  observeEvent(values.eng$file.eng, { 
    if (!is.null(values.eng$file.eng)) {
      print(values.eng$file.eng)
      values.eng$error.msg <- 
        inFile <- values.eng$file.eng 
      read.data <- fread(inFile$datapath, sep = ";")
      if (eng.measures.check.readfile.format(read.data)) {
        print(read.data)
        get.eng.measures.readfile.process(read.data)
      }
      values.eng$reset.eng <- values.eng$reset.eng + 1
    } 
  })
  
  eng.measures.wrong.format.Modal <- function() {
    modalDialog(
      title = "Invalid Engineering Measures file format",
      footer = modalButton("Dismiss"),
      size = "m", easyClose = TRUE,
      h4(values.eng$error.msg),
      p("Format: name; id_element; improvement; cost_improvement; description [; id_type_element]")
    )
  }
  
  # Show modal when button is clicked.
  observeEvent(values.eng$error.msg, {
    showModal(eng.measures.wrong.format.Modal())
  })
  
  # <-- Get + DT engineering measures -------------------------------------
  
  get.eng.measures.data <- reactive({
    values.eng$reset.eng
    return(get.eng.measures.DT())
  })
  
  get.eng.measures.available.type <- reactive({
    aux <- get.type.element()[, id_element, name]
    aux[, id_type_element := name][, name := NULL]
    aux[, id_element := id.element.to.name(id_element)]
    return(aux)
  })
  
  output$eng.measures.available.type <- DT::renderDataTable({
    get.eng.measures.available.type()
  })
  
  output$eng.measures.DT <- DT::renderDataTable(
    get.eng.measures.data(),
    options = list(columnDefs = list(list(visible = FALSE, targets = c(1))))
  )
  
  output$eng.measures.example <- renderText(get.eng.measures.example())
  
  # TAB Weather >>> ---------------------------------------------------------
  
  get.weatherWindstorm <- function() {
    return(includeHTML("www/weatherWindstorm.html"))
  } 
  output$weatherWindstorm <-  renderUI({get.weatherWindstorm()})
  
  get.weatherPrecipitationIntensity <- function() {
    return(includeHTML("www/weatherPrecipitationIntensity.html"))
  } 
  output$weatherPrecipitationIntensity <-  renderUI({get.weatherPrecipitationIntensity()})
  
  get.weatherPrecipitationCumulative <- function() {
    return(includeHTML("www/weatherPrecipitationCumulative.html"))
  } 
  output$weatherPrecipitationCumulative <-  renderUI({get.weatherPrecipitationCumulative()})
  
  # TAB Technical Details >>> -----------------------------------------------
  
  get.technicalDetailsAnalysis <- function() {
    return(includeHTML("www/technicalDetailsAnalysis.html"))
  } 
  output$technicalDetailsAnalysis <-  renderUI({get.technicalDetailsAnalysis()})
  
  
  # TAB: About ---------------------------------------------------------
  get.about <- function() {
    return(includeHTML("www/about.html"))
  } 
  
  get.credits <- function() {
    return(includeHTML("www/credits.html"))
  } 
  get.references <- function() {
    return(includeHTML("www/references.html"))
  } 
  get.termsConditions <- function() {
    return(includeHTML("www/termsConditions.html"))
  } 
  
  output$about <- renderUI({get.about()})
  output$credits <- renderUI({get.credits()})
  output$references <- renderUI({get.references()})
  output$termsConditions <- renderUI({get.termsConditions()})
})