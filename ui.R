library(shiny)
library(shinydashboard)
library(visNetwork)

## ui.R ##
library(shinydashboard)

dashboardPage(
  dashboardHeader(),
  dashboardSidebar(),
  dashboardBody(titlePanel("Network Visualization"),box(actionButton("gogobutt","Go"),
                    actionButton("stopbutt","Stop"),
                    actionButton("resetbutt","Reset"),
                    visNetworkOutput("network", height = '900px'), width = "90%", height = "100%"
  ))
)
