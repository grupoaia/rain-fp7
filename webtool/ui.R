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
# ui.R
# -------------------------------------------------------------------------


# ui ----------------------------------------------------------------------
# 
tags$head(tags$link(rel = "shortcut icon", href = "favicon.ico", 
                    type = "image/x-icon"))

# Header ------------------------------------------------------------------

dbHeader <- dashboardHeader(title =  "RAIN project",
                            dropdownMenuOutput("messageMenu"), 
                            dropdownMenuOutput("notificationeMenu"))
dbHeader$children[[2]]$children <-  tags$a(href = 'http://rain-project.eu/',
                                           target = "_blank", 
                                           tags$img(src = 'logo_RAIN_AIA.png', 
                                                    height = '60'))

# Side bar ----------------------------------------------------------------

sidebar <- dashboardSidebar(
  tags$style(HTML("
                  .main-sidebar{
                  width: 165px;
                  }
                  ")),
  tags$script(HTML("
                   var openTab = function(tabName){
                   $('a', $('.sidebar')).each(function() {
                   if(this.getAttribute('data-value') == tabName) {
                   this.click()
                   };
                   });
                   }
                   ")),
  width = 165,
  sidebarMenu(id = "siderbar",
              menuItem("Initialization", tabName = "basic", icon = icon("tasks")),
              menuItem("Electrical Analysis", tabName = "basic_map", icon = icon("bolt")),
              menuItem("Land Transportation", tabName = "trans_basic_map", icon = icon("road")),
              menuItem("Configuration", tabName = "config", icon = icon("dashboard")),
              menuItem("Weather", tabName = "weather", icon = icon("cloud")),
              menuItem("Technical details", icon = icon("cogs"), tabName = "technical"),
              menuItem("About", icon = icon("info"), tabName = "about")
  )
)


# Body --------------------------------------------------------------------


body <- dashboardBody(
  tabItems(
    # Tab: BASIC -----------------------------------------------
    tabItem(tabName = "basic",
            h2("Initialization"),
            includeHTML("www/initialization.html"),
            p("Now the system is...", textOutput("ready", inline = T))
    ),
    # Tab: ELECTRICAL ANALYSIS --------------------------------------------
    tabItem(tabName = "basic_map",
            fluidRow(
              # <-- Map Configuration ------------------------------------------
              column(width = 3,
                     box(
                       title = "Landslide probability model ", 
                       width = NULL, solidHeader = TRUE, 
                       collapsible = TRUE, collapsed = TRUE,
                       status = "primary",
                       "The probability of landslide given a rainfall event is 
                       computed from historical data of the region.",
                       p("The",
                         strong(textOutput("region.landslide_title",inline = T), "data"),
                         " is currently used. It can be changed at the",
                         a("configuration tab.", onclick = "openTab('config')"), 
                         tags$script(HTML("
                                          var openTab = function(tabName){
                                          $('a', $('.sidebar')).each(function() {
                                          if(this.getAttribute('data-value') == tabName) {
                                          this.click()
                                          };
                                          });
                                          }
                                          "))
                       )
                     ),
                     uiOutput("ewe.config"),
                     box(
                       title = "Landslide probability", 
                       width = NULL, solidHeader = TRUE, 
                       status = "primary",
                       uiOutput("landslide.prob.ui"),
                       p(""),
                       actionButton("reassessButton", "(re)Assess Probabilities", 
                                    icon = icon("retweet")),
                       checkboxInput("demo", "Demo mode")
                     ), 
                     box(
                       title = "Affected town or region", width = NULL, solidHeader = TRUE, 
                       status = "primary",
                       # collapsible = T, 
                       strong("Select")," affected town from the", strong(" list"), 
                       "or pick an electrical station on the", strong(" map."),
                       hr(),
                       selectInput("town", label = "Town list:", 
                                   choices = c("", towns[, unique(name)]), 
                                   selected = "", selectize = T),
                       uiOutput("town_info")
                     ),
                     box(
                       title = "Season & time", width = NULL, 
                       solidHeader = TRUE, status = "primary",
                       sliderInput("hour", label = "Hour of the day", min = 0, 
                                   max = 23, value = 12),
                       radioButtons("season", "Season",
                                    choices = list("Summer" = "summer", "Winter" = "winter"), 
                                    selected = "summer")
                     )
              ),
              # <-- Map Column -------------------------------------------------
              column(width = 9,
                     fluidRow(
                       box(
                         title = "Description of the map", width = NULL, 
                         solidHeader = FALSE, status = "primary", 
                         collapsible = TRUE, collapsed = TRUE,
                         p("Map of the ", strong("Alpine region case study."), 
                           " It includes the municipalities of Malborghetto Valbruna, 
                           Pontebba and Tarviso at Val Canale (Canal Valley) in 
                           the province of Udine, Italy."),
                         p("Each circle corresponds to an ", strong("electrical station."), 
                           "Click on them to get more information (name, voltages...)"),
                         p(strong("Electrical power lines"), 
                           " are plotted in three colours 
                           to distinguish their voltages: 132 kV, 60 kV, 
                           and minor lines (dark to light green)."),
                         p(strong("Telecommunication towers "), "are displayed as
                           grey icons."),
                         p(strong("Susceptibility to a landslide"), 
                           "of each point in the region is plotted on the 
                           background as a colormap."),
                         p("Use the layer options panel on the right top corner
                           to show/hide each layer. It is possible to change the 
                           background map between the CartoDB tiles (Default) 
                           and the Open Sreet Map tiles (OSM)."),
                         actionButton("reloadMap", "Reload map", 
                                      icon = icon("retweet"))
                       ),
                       leafletOutput("map", height = "500px"),
                       # textOutput("test.text2"),
                       uiOutput("mapstations"),
                       uiOutput("maplines"),
                       uiOutput("context"),
                       uiOutput("nodes.BN"),
                       uiOutput("risk.profile.UI"),
                       uiOutput("consequences.investment.ui")
                     )
              )
            )
    ),
    
    # Tab: LAND TRANSPORTATION ------------------------------------
    tabItem(tabName = "trans_basic_map",
            fluidRow(
              # <-- Map Configuration ------------------------------------------
              column(width = 3,
                     box(
                       title = "Landslide probability model ",
                       width = NULL, solidHeader = TRUE,
                       collapsible = TRUE, collapsed = TRUE,
                       status = "primary",
                       "The probability of landslide given a rainfall event is
                       computed from historical data of the region.",
                       p("The",
                         strong(textOutput("trans_region.landslide_title",inline = T), "data"),
                         " is currently used. It can be changed at the",
                         a("configuration tab.", onclick = "openTab('config')")
                       )
                     ),
                     uiOutput("trans_ewe.config"),
                     box(
                       title = "Landslide probability",
                       width = NULL, solidHeader = TRUE,
                       status = "primary",
                       uiOutput("trans_landslide.prob.ui"),
                       p(""),
                       actionButton("trans_reassessButton", "(re)Assess Probabilities",
                                    icon = icon("retweet"))
                     ),
                     box(
                       title = "Season & time", width = NULL, 
                       solidHeader = TRUE, status = "primary",
                       sliderInput("hour", label = "Hour of the day", min = 0, 
                                   max = 23, value = 12),
                       radioButtons("season", "Season",
                                    choices = list("Summer" = "summer", "Winter" = "winter"), 
                                    selected = "summer")
                     )
              ),
              # <-- Map Column -------------------------------------------------
              column(width = 9,
                     fluidRow(
                       box(
                         title = "Description of the map", width = NULL, 
                         solidHeader = FALSE, status = "primary", 
                         collapsible = TRUE, collapsed = TRUE,
                         p("Map of the ", strong("Alpine region case study."), 
                           " It includes the municipalities of Malborghetto Valbruna, 
                         Pontebba and Tarviso at Val Canale (Canal Valley) in 
                         the province of Udine, Italy."),
                         p("Main land transportation routes are shown:",
                           strong("Railway"), " (black) and roads ", strong("A23"), " (blue) and ",
                           strong("SS13"), " (red)."),
                         p("Darker sections correspond to tunnels and 
                         lighter sections to bridges.",
                           "Click on them to get more information (route, name...)."),
                         p(strong("Susceptibility to a landslide"), 
                           "of each point in the region is plotted on the 
                         background as a colormap."),
                         p("Use the layer options panel on the right top corner
                         to show/hide each layer. It is possible to change the 
                         background map between the CartoDB tiles (Default) 
                         and the Open Sreet Map tiles (OSM)."),
                         actionButton("trans_reloadMap", "Reload map", 
                                      icon = icon("retweet"))
                       ),
                       leafletOutput("trans_map", height = "500px"),
                       uiOutput("maproads"),
                       uiOutput("nodes.road.BN"),
                       uiOutput("nodes.train.BN")
                     )
              )
            )
    ),
    
    # Tab: CONFIG ----------------------------------------------
    tabItem(tabName = "config",
            h2("Configuration "),
            box(
              title = "Landslide probability model", width = NULL, 
              solidHeader = TRUE, status = "primary", 
              collapsible = TRUE, collapsed = FALSE,
              uiOutput("region_config"),
              plotlyOutput("p.landslide.model.plot")
            ),
            box(
              title = "Historical data of landslides and update new data", width = NULL, 
              solidHeader = FALSE, status = "primary", 
              collapsible = TRUE, collapsed = TRUE,
              p("Historical data used to obtain the probability model shown above."),
              p("More data can be used to compute a new model. See below the 
                plot to upload and process these data."),
              plotlyOutput("p.landslide.plot"),
              p(""),
              uiOutput('resettableInput.landslides'),
              actionButton("computemodel", label = "Compute new probability model"),
              bsModal("modalExample", "Compute new landslide probability model",
                      "computemodel",# size = "medium",
                      htmlOutput("computemodel.text"),
                      hr(),
                      uiOutput("computemodel.modal")
              )
            ),
            box(
              title = "Engineering measures", width = NULL, 
              solidHeader = TRUE, status = "warning", 
              collapsible = TRUE, collapsed = FALSE,
              p("Available engineering measures considered."),
              DT::dataTableOutput("eng.measures.DT")
            ),
            box(
              title = "Upload new engineering measures to the system", width = NULL, 
              solidHeader = FALSE, status = "warning", 
              collapsible = TRUE, collapsed = TRUE,
              p("New engineering measures can be submitted by uploading a file 
                with the format shown in the next box."),
              p("Copy these lines and modify the second and third rows according 
                to the new measure to be uploaded. More than one measure can be 
                added at a time: add as many rows as new measures to be considered. 
                Specific type of element is not mandatory, but if one measure has 
                this attribute, all others have to (using 'all' in case the 
                measure applies to all elements."),
              verbatimTextOutput("eng.measures.example"),
              HTML(paste0("Notice that ", em("[xxx]"), " part is optional. 
                          If it is to be used, remove the brackets.")),
              br(),
              uiOutput("resettableInput.eng"),
              p("Available elements and specific types:"),
              DT::dataTableOutput("eng.measures.available.type")
            )
    ),
    
    
    # Tab: WEATHER -----------------------------------------------
    tabItem(tabName = "weather",
            h2("Weather data"),
            fluidRow(
              column(width = 12,
                     box(width = NULL,
                         includeHTML("www/weatherIntro.html")
                     ),
                     tabBox(
                       title = "Weather events: ", width = NULL,
                       id = "tabset1", side = "right",
                       tabPanel("Heavy precipitation (intensity)",
                                # htmlOutput("weatherPrecipitationIntensity"),
                                div(img(src = "ReturnTimes_Precipitation_3hr.png", 
                                        width = "85%"), 
                                    style = "text-align: center;"),
                                br()),
                       tabPanel("Heavy precipitation (cumulative)",
                                div(img(src = "ReturnTimes_Precipitation_day.png", 
                                        width = "85%"), 
                                    style = "text-align: center;"),
                                br()),
                       tabPanel("Windstorm",
                                div(img(src = "ReturnTimes_Windstorm.png", 
                                        width = "85%"), 
                                    style = "text-align: center;"),
                                br())
                     )
              )
            )
    ),
    # Tab: Technical details ---------------------------------------
    tabItem(tabName = "technical",
            h2("Technical details"),
            fluidRow(
              column(width = 12,
                     box(
                       title = "Analysis", width = NULL, solidHeader = TRUE, 
                       collapsible = T, collapsed = F, #status = "warning",
                       htmlOutput("technicalDetailsAnalysis")),
                     box(
                       title = "Simulation", width = NULL, solidHeader = TRUE, 
                       collapsible = T, collapsed = F, 
                       htmlOutput("technicalDetailsSimulation"))
              )
            )
    ),
    # Tab: ABOUT -------------------------------------------------
    tabItem(tabName = "about",
            h2("Rain project"),
            fluidRow(
              column(width = 12,
                     box(width = NULL,
                         htmlOutput("about")
                     ),
                     box(
                       title = "Credits", width = NULL, solidHeader = TRUE, 
                       collapsible = T, collapsed = F, #status = "warning",
                       htmlOutput("credits")
                     ),
                     box(title = "Terms & Conditions", width = NULL, solidHeader = TRUE,
                         collapsible = T, collapsed = F,
                         htmlOutput("termsConditions"))
              )
            )
    )
    
  )
)

# # Page --------------------------------------------------------------------
# 
shinyUI(dashboardPage(
  skin = "black",
  dbHeader,
  sidebar,
  body
)
)