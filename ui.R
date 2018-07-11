library(shiny)
library(shinydashboard)
library(visNetwork)

## ui.R ##
library(shinydashboard)

dashboardPage(
  dashboardHeader(title='Network Monitor'),
  dashboardSidebar(sidebarMenu(
    menuItem("Visualize", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Data", tabName = "spreadsheet", icon = icon("th"))), width = '120px'),
  dashboardBody(tabItems(
    tabItem(tabName='dashboard',box(),box(title = "Network Visualization",actionButton("gogobutt","Go"),
                    actionButton("stopbutt","Stop"),
                    actionButton("resetbutt","Reset"),
                    visNetworkOutput("network", height = '900px'), width = "90%", height = "100%"
  )),tabItem(tabName = 'spreadsheet', fluidRow(box(title = 'Network Data', 
                                                   dataTableOutput('datatable')
                                                   ,width=12)
                                               ,width=12)#row
             ))
  
  )
)
