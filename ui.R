library(shiny)
library(rCharts)

shinyUI(navbarPage("Verizon Application",
                  tabPanel(("Highcharts Heat Map"),
                            tags$head(tags$script(src = "https://code.highcharts.com/highcharts.js"),
                                      tags$script(src = "https://code.highcharts.com/highcharts-more.js"),
                                      tags$script(src = "https://code.highcharts.com/modules/exporting.js"),
                                      tags$script(src = "https://code.highcharts.com/modules/heatmap.js")
                            ),
                  
                  showOutput('heatmap', 'highcharts')),
                                                        
                   tabPanel(
                      "Incidents Line Charts",
#                             showOutput("chart1", "polycharts")
                                   
                              sidebarPanel(
                                selectInput(inputId = "pattern",
                                            label = "Select pattern to compare years",
                                            choices = sort(unique(as.character(mydata1$pattern))),
                                            selected = "Point of Sale")),
                              
                              mainPanel(
                                showOutput("chart1", "polycharts")
                              )
                            
                            )
                   
))
# 
# shinyUI(pageWithSidebar(
#   
#   headerPanel ("Incidents Explorer"),
#   
#   sidebarPanel(
#     selectInput(inputId = "pattern",
#                 label = "Select pattern to compare years",
#                 choices = sort(unique(as.character(mydata1$pattern))),
#                 selected = "Point of Sale")),
#   
#   mainPanel(
#     tabsetPanel(
#       tags$head(tags$script(src = "https://code.highcharts.com/highcharts.js"),
#                 tags$script(src = "https://code.highcharts.com/highcharts-more.js"),
#                 tags$script(src = "https://code.highcharts.com/modules/exporting.js"),
#                 tags$script(src = "https://code.highcharts.com/modules/heatmap.js")
#       ),
#       
#       tabPanel("Highcharts Heat Map",
#                showOutput("heatmap","highcharts")),
#       
#       tabPanel("Incidents Line Charts",
#         showOutput("chart1", "polycharts"))
#       )
#     )
#   
# ))