

library(shiny)
library(visNetwork)

shinyUI(fluidPage(

  # Application title
  titlePanel("Network Visualization"),
  mainPanel(br(),br(),br(),actionButton("gogobutt","Go"),
            actionButton("stopbutt","Stop"),
            actionButton("resetbutt","Reset"),
            visNetworkOutput("network", height = '900px'), width = "90%", height = "100%"
  )
  # Sidebar with a slider input for number of bins
  
))
