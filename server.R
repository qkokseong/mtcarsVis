# server.R

library(shiny)

palette(c("#E41A1C", "#377EB8", "#4DAF4A", "#984EA3",
          "#FF7F00", "#FFFF33", "#A65628", "#F781BF", "#999999"))

dict <- list()

# list of short variable names
short_names <- c("mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "gear", "carb")

# list of long variable names
long_names <- c("Miles/(US) gallon", "Number of cylinders", "Displacement (cu.in.)", "Gross horsepower", "Rear axle ratio",
                "Weight (lb/1000)", "1/4 mile time", "V/S", "Transmission (0 = automatic, 1 = manual)", "Number of forward gears", "Number of carburetors")

# contruct a list of key-value pairs where key is the short variable name, value is the long one.
for (i in 1:length(short_names)) {
        dict[[short_names[i]]] <- long_names[i]
}


shinyServer(function(input, output, session) {
        
        # Combine the selected variables into a new data frame
        selectedData <- reactive({
                mtcars[, c(input$xcol, input$ycol)]
        })
        
        output$plot1 <- renderPlot({
                plot(selectedData(), main="",
                     xlab="", ylab="", pch=22, bg="gray")
                
                # dynamically generate a simple title for the chart
                title(main=paste("Scatterplot of",dict[[input$ycol]],"vs",dict[[input$xcol]]), 
                      xlab=dict[[input$xcol]], ylab=dict[[input$ycol]])
                
                # when the user wants to see the fit line on the chart
                if (input$showfit==TRUE) {
                        model.1<-lm(as.formula(paste(input$ycol,"~",input$xcol)), data=mtcars)
                        abline(model.1, lty=2, lwd=2, col="red")
                }
        })
        
        # contents for the tab "Fitted Model"
        output$fm <- renderPrint({
          # user needs to tick the checkbox of show-fit-line in order to get the contents displayed
          if (input$showfit==TRUE) {
            model.1<-lm(as.formula(paste(input$ycol,"~",input$xcol)), data=mtcars)
            summary(model.1)
          } else {
            "To view the contents, you need to tick the checkbox of show-fit-line"
          }
        })
        
        # contents for the tab "Fitted Equation"
        output$feqn <- renderText({
          # user needs to tick the checkbox of show-fit-line in order to get the contents displayed
          if (input$showfit==TRUE) {
            model.1<-lm(as.formula(paste(input$ycol,"~",input$xcol)), data=mtcars)
            
            # dynamically generate a quick summary of the lm result
            paste0(
                    '<p>The model we have fitted can also be written in functional form, i.e. in equation, as,</p>',
                    '<br />',
                    '<strong>',
                    paste( 'y ==', round(model.1$coef[2],2), '* x + ', round(model.1$coef[1],2)),
                    '</strong>',
                    '<br />',
                    '<br />',
                    paste0('<p>This means, the effect of <em>',dict[[input$xcol]],'</em> on <em>',dict[[input$ycol]],'</em> of the cars in the model is <strong>',
                           ifelse(model.1$coef[2]>0,"positive","negative"),
                           '</strong> and its magnitude is <strong>',abs(round(model.1$coef[2],2)),'</strong>. In other words, on one unit change of <em>',
                           dict[[input$xcol]],'</em>, there will be <strong>',round(model.1$coef[2],2), ifelse(model.1$coef[2]>0," more"," less"),
                           '</strong> in <em>',dict[[input$ycol]],'</em>.</p>')
                    )
          } else {
            "<p>To view the contents, you need to tick the checkbox of show-fit-line</p>"
          }
              
        })
})
