
################################# CONTROLLER   LAYER  USING SHINY (V1.0) #####################################


library(shiny)


source("./model.R")

shinyServer(function(input, output) {
    
    getPath  <- eventReactive(input$myFile, {
        myPath <- input$myFile$datapath
        if (is.null(myPath))
            return()
        else
            return(myPath)
        
    })
    
    reactiveClusterPlot <- eventReactive(input$compute, { 
        myPath = getPath()
        reduced = getImage(path = myPath, show = F)
        #reduced = observeEvent()
        if(!as.logical(input$col)){
            return(kmeansImage(image = reduced, k = input$k))
            
        }
        
        else{
            return(kmeansImageCol(image = reduced, k = input$k,  pixW = input$pixW, xCordW = input$coordW, input$coordW))
            
        }
        
    })
    
    
    output$imageLoad  <- renderPlot({
        myPath = getPath()
        reduced = getImage(path = myPath, show = T)
    })
    
    output$imagePlot <- renderPlot({
        result = reactiveClusterPlot()
        OpenImageR::imageShow(result)
        
    })
    
    
})



