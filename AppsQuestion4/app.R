#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(quantmod)
library(TTR)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Stock RSI-Varying the average days for computing RSI"),
  
  # Sidebar with a slider input for number of days for RSI calculation
  sidebarLayout(
    sidebarPanel(
      textInput("symbol", "Enter Stock Symbol (e.g., AAPL, MSFT):", value = "AAPL"),
      dateRangeInput("dates", "Select Date Range",
                     start = Sys.Date() - 365, 
                     end = Sys.Date()),
      sliderInput("rsiPeriod", "Select RSI Period (Number of Days):", 
                  min = 5, max = 50, value = 14, step = 1),
      actionButton("go", "Plot RSI")
    ),
    
    # Main Panel to display plot 
    mainPanel(
      plotOutput("rsiPlot"),
      verbatimTextOutput("errorMsg")
    )
  )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  stock_data <- eventReactive(input$go, {
    symbol <- toupper(input$symbol)
    tryCatch({
      stock <- getSymbols(symbol, src = "yahoo", auto.assign = FALSE, 
                          from = input$dates[1], to = input$dates[2])
      return(stock)
    }, error = function(e) {
      return(NULL)
    })
  })
  
  stock_rsi <- reactive({
    stock <- stock_data()
    if (is.null(stock)) {
      return(NULL)
    }
    
    if (nrow(stock) == 0) {
      return(NULL)
    }
    
    # Compute RSI with user-defined period
    rsi_value <- RSI(Cl(stock), n = input$rsiPeriod)
    return(rsi_value)
  })
  
  output$rsiPlot <- renderPlot({
    rsi_value <- stock_rsi()
    
    if (is.null(rsi_value)) {
      plot(1, type = "n", xlab = "", ylab = "", main = "Stock data not found")
      return()
    }
    
    # Plot RSI 
    plot(index(rsi_value), coredata(rsi_value), type = "l", col = "purple", lwd = 3,
         main = paste("RSI Indicator for", input$symbol),
         xlab = "Date", ylab = "RSI Value")
    abline(h = c(30, 70), col = "red", lty = 3)
  })
  
  output$errorMsg <- renderPrint({
    if (is.null(stock_data())) {
      return("Error: Stock symbol not found. Please enter a valid stock symbol.")
    } else if (is.null(stock_rsi())) {
      return("Error: No RSI data available for the selected date range.")
    }
  })
}

# Run the application
shinyApp(ui = ui, server = server)
