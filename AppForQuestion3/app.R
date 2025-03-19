#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
library(tidyverse)



# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Diamonds related plots"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("caratRange",
                  "Number of bins:",
                  min = min(diamonds$carat),
                  max = max(diamonds$carat),
                  value = c(1,3)),
      
      selectInput(
        inputId = "cutType",
        label = "Select with cut of dimonds you would like to use:",
        choices = unique(diamonds$cut),
        selected ="Good",
      )
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      plotOutput("scatterPlot")
    )
  )
)


#plot histrogram and plot 
# Define server logic required to draw a histogram
 server <- function(input, output) {
  
  # render function only generate the changes facebook post concept if not new post it will not show
  
  output$distPlot <- renderPlot({
    
   print(input$caratRange)
    print(input$caratRange[1])
    print(input$caratRange[2])
   
    # ggplot(diamonds[diamonds$carat])
    diamonds %>%
      filter(carat>= as.numeric(input$caratRange[1]),
             carat<= as.numeric(input$caratRange[2])) %>%
      ggplot() +
       geom_histogram(aes(carat))
  })
  
    # Create scatter plot
    output$scatterPlot <- renderPlot({
      
      
      # ggplot(diamonds[diamonds$carat])
      diamonds %>%
        filter(carat>= as.numeric(input$caratRange[1]),
               carat<= as.numeric(input$caratRange[2]),
               cut== input$cutType) %>%
        ggplot() +
        geom_point(aes(carat, price, colour = color))
    
    
     
  
    #output to UI page 
  })

}
# Run the application 
shinyApp(ui = ui, server = server)
