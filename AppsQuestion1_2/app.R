#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#
if(!require(shiny)) install.packages("shiny", dependencies = TRUE)
library(shiny)
library(datasets)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data( Question 1&2)"),

    # Sidebar with dropdown menu from dataset selection
    sidebarLayout(
        sidebarPanel(
            selectInput("dataset","Choose a dataset:",
                        choices = c("Airpassengers","cars","iris"),
                        selected = "iris"), 
            
                       
            selectInput("bins", "Number of bins",
                        choices = c(5,10,15,20,30,40,50),
                        selected = 30)
             
        ),

        # Main panel for outputs 
        mainPanel(
          verbatimTextOutput("summaryOutput"), #summary of selected dataset
           plotOutput("distPlot") #Histogram output
        )
    )
)

# Define server logic required to draw a histogram

server <- function(input, output) {  
  
  # Function to get dataset
  get_dataset <- function(dataset_name) {
    if (dataset_name == "AirPassengers") {
      return(data.frame(
        Year = as.numeric(time(AirPassengers)),  # Extract time index
        Passengers = as.numeric(AirPassengers)  # Convert to numeric
      ))
    } else if (dataset_name == "cars") {
      return(cars)
    } else if (dataset_name == "iris") {
      return(iris)
    } else {
      return(NULL)  # Fallback in case of an unknown dataset
    }
  }
  
  # Generate summary of selected dataset
  output$summaryOutput <- renderPrint({  
    dataset <- get_dataset(input$dataset)  # Fetch selected dataset
    if (!is.null(dataset)) {
      summary(dataset)
    } else {
      "No data available"
    }
  })
  
  # Generate histogram based on selected number of bins
  output$distPlot <- renderPlot({
    data <- faithful$waiting  # Old Faithful Geyser waiting times
    bins <- seq(min(data), max(data), length.out = as.numeric(input$bins) + 1)
    
    hist(data, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (mins)',
         main = 'Histogram of Waiting Times')
  })
}


# Run the application 
shinyApp(ui = ui, server = server)
