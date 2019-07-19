
################################# USER INTERFACE USING SHINY (V1.0) #####################################

library(shiny)
library(shinythemes)

shinyUI(fluidPage(theme = shinytheme("flatly"),
    
    titlePanel("Image segmentation with K-Means Clustering"),
    
    sidebarLayout(
        sidebarPanel(
            
            fileInput(inputId =  "myFile",label =   "Upload an image",placeholder = "png, jpg or jpeg" ,
                      accept = c('image/png', 'image/jpg', 'image/jpeg')),
            sliderInput("k",
                        "Number of clusters:",
                        min = 1,
                        max = 30,
                        value = 3),
            
            radioButtons("col","Type of Clustering",
                         choices = c(Pixel_Values_BW = "F", 
                                     Pixel_Values_And_Position = "T"), 
                         selected = "F", inline = F),
            
            sliderInput("pixW",
                        "Pixel values weight : ",
                        min = 0.05,
                        max = 2,
                        value = 1, 
                        step = 0.05 ),
            
            sliderInput("coordW",
                        "Pixel coordinates weight : ",
                        min = 0.0,
                        max = 5,
                        value = 1, 
                        step = 0.1 ),
            
            actionButton("compute","Compute and Show")
            
            
        ),
        
        mainPanel(
            tabsetPanel(type  = "tabs",
                        tabPanel("Image Plotting Test ", imageOutput("imageLoad")),
                        tabPanel("Image Clustering Result ", imageOutput("imagePlot")))
            
        ))
    
))