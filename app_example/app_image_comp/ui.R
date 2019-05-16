ui <- fluidPage(    
  
  titlePanel("Image Compression - PCA"),
  
  sidebarLayout(      
    
    sidebarPanel(
      sliderInput(inputId = "n_pc", 
                  label = "Number of PC to be used in the compression:",
                  value = 3,
                  min = 1,
                  max = 64)
    ),
    
    mainPanel(
      plotOutput("imgPlot")  
    )
  )
)