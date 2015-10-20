# ui.R

library(shiny)

shinyUI(pageWithSidebar(
        headerPanel('Exploratory View of the relationship of selected variables on mtcars data set'),
        sidebarPanel(
                selectInput('xcol', 'X - Axis', names(mtcars),
                            selected=names(mtcars)[[2]]),
                selectInput('ycol', 'Y - Axis', names(mtcars),
                            selected=names(mtcars)[[1]]),
                checkboxInput("showfit", label = "Show fit line?", value = TRUE),
                br(), br(),
                h4("User Guide"),
                helpText(strong("Input"), br(),
                         "* Select a variable from X-Axis/Y-Axis dropdown, the plot will be updated automatically", br(),br(),
                         "* Tick the show-fit-line checkbox to see the linear regression line (y~x).", br(), 
                         "  ", strong("NOTE"), " that if this checkbox is not checked, the linear line will not shown on the plot, and no contents displayed in other 2 tabs", br(), 
                         br(),
                         strong("Output"), br(),
                         "* Plot : A scatterplot based on the input values;", br(),br(),
                         "* Fitted Model : Summary of the linear model (y~x) from R;", br(),br(),
                         "* Fitted Equation : Dynamically generated contents based on the input values and coefficients of linear model.")
                
        ),
        mainPanel(
                tabsetPanel(
                        tabPanel("Plot", plotOutput('plot1')),
                        tabPanel("Fitted Model", "The Output is ", verbatimTextOutput("fm")),
                        tabPanel("Fitted Equation", htmlOutput("feqn"))
                )
        )
))
