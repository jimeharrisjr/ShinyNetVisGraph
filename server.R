
library(shiny)
library(visNetwork)
library(igraph)
library(Rtins)
library(data.table)
shinyServer(function(input, output, session) {
  rv <- reactiveValues(pcapinput=NULL,run=FALSE)
  
  
  autoInvalidate <- reactiveTimer(intervalMs=500,session)
  observe({
    autoInvalidate()
    isolate({ if (rv$run) { 
      
      pcapinput <- sniff_pcap('en0', num = 10) 
      rv$pcapinput<-rbind(rv$pcapinput, pcapinput, fill=TRUE)
      rv$pcapinput<-rv$pcapinput[!duplicated(rv$pcapinput)]
      } })
  })
  
  observeEvent(input$gogobutt, { isolate({ rv$run=TRUE      }) })
  observeEvent(input$stopbutt, { isolate({ rv$run=FALSE      }) })
  observeEvent(input$resetbutt,{ isolate({ rv$pcapinput<-NULL }) })
  

  output$network <- renderVisNetwork({
    if (is.data.table(rv$pcapinput)){
      
      pcapinput<-rv$pcapinput
      pcapinput[,source:=(ifelse(layer_2_src=="",as.character(layer_1_src),as.character(layer_2_src)))]
      pcapinput[,destination:=(ifelse(layer_2_dst=="",as.character(layer_1_dst),as.character(layer_2_dst)))]
      nodes<-unique(c(as.character(pcapinput$source),as.character(pcapinput$destination)))
      print(nodes)
      
      # make a vector (bunch of entries strung together) for the color.
      # Think of a vector as a line of little boxes - each one numbered - containing some entry
      # In this case, the entry is the name of a color.
      # repeat - rep() the color light blue the same number of times as the number of - length() nodes
      colors<-rep('lightblue',length(nodes))
      
      # Now set different colors and shapes accoring to different properties of the device
      # In this case, grep() is a function that searches for  a pattern in something, and returns
      # a vector of the indices (the numbers on the boxes) where the pattern is found
      # A number of arbitrary examples are below
      
      # Find all the entries in "nodes" with "::" in them and make their color orange instead of light blue
      colors[grep('::', nodes)]<-'orange'
      # Now find everything with fe80:: (which would include some of the "::" entries) and color them light green
      colors[grep('fe80::', nodes)]<-'lightgreen'
      
      # Now set the border color for each shape
      borders<-rep('darkblue',length(nodes))
      borders[grep('::', nodes)]<-'red'
      borders[grep('fe80::', nodes)]<-'green'
      
      # And set the shape of the node the same way
      shapes<-rep('circle', length(nodes))
      shapes[grep('::', nodes)]<-'ellipse'
      shapes[grep('fe80::', nodes)]<-"square"
      
      # Tell it what color to make each node change to (highlight) when I click on it
      highlights<-rep('yellow',length(nodes))
      
      # Now create a set of data frames (which you can think of as a table of column vectors - boxes in a grid)
      # Instead of column numbers, our nodeData frame will have the column names (labels) "id," "color," "shape," and "label"
      # We fill those columns with the vectors we just created
      nodeData<-data.frame(id=nodes, color=list(background=colors,border=borders,highlight=highlights), shape=shapes, label=nodes, stringsAsFactors = FALSE)
      
      
      # Our edge data frame will take our "Source" and "Destination columns from our pcap and make them "from" and "to" of a graph
      # We use the "Protocol" column to label the arrows of our graph
      edgeData<-data.frame(from=as.character(pcapinput$source), label=pcapinput$layer_3_id, to=as.character(pcapinput$destination), tooltip=pcapinput$layer_2_id, length=(pcapinput$layer_1_size)*200, stringsAsFactors = FALSE)
      #print(nodeData)
      visNetwork(nodeData, edgeData, main = "Network Plot", width = "100%", height='1200px')  %>% visEdges(arrows = "to") %>% 
        visIgraphLayout(type='full', layout='layout_with_fr') %>% 
        visOptions(highlightNearest = TRUE) %>%  visIgraphLayout(randomSeed=123,layout = "layout_with_kk")
      
    }
    })

})
