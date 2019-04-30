function(input, output) {
  
  output$imgPlot <- renderPlot({
    img <- compression(PCA$x, PCA$eigenvectors, input$n_pc)
    par(mfrow=c(1,2))
    image(img, col=gray(0:100/100), axes=FALSE)
    image(lena, col=gray(0:100/100), axes=FALSE)
  })
}