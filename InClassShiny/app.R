#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)




# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            radioButtons(
              inputId ="fillColor", #variable name 
              label= " I am using this color to fill bars!",
              choices = c("red","blue","green"),
              selected = "blue"
              ),
            selectInput(
              inputId = "binsV1",
              label = "New way of selecting bin --",
              choices = seq(1,50,1),
              selected =30,
              )
            
         ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           tableOutput("dummyTable")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  plotCode<-reactive({
    print(input$fillColor)
    # generate bins based on input$bins from ui.R 
    #render -> collect from UI input and retrun output 
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = as.numeric(input$binsV1) + 1)
    
    #need to convert numberic value 
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = input$fillColor, border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
    
  })
  
  # render function only generate the changes facebook post concept if not new post it will not show

    output$distPlot <- renderPlot({
      plotCode()
      
    })
    
    output$dummyTable<- renderTable({
      print(input$bins)
      head(mtcars)
      #output to UI page 
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
