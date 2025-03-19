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

# Define UI for application that draws the moving averages
ui <- fluidPage(
  
  # Application title
  titlePanel("Moving Averages for Stocks"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      textInput("symbol", "Enter Stock Symbol (e.g., AAPL, MSFT):", value = "AAPL"),
      dateInput("startDate", "Start Date:", value = Sys.Date() - 5*365),  # 5 years ago
      actionButton("go", "Plot Moving Averages"),
      
      br(),
      h4("Moving Average Intervals:"),
      numericInput("shortMA", "Short Moving Average Interval (50 by default):", value = 50),
      numericInput("longMA", "Long Moving Average Interval (200 by default):", value = 200)
    ),
    
    # Main Panel to display plot 
    mainPanel(
      plotOutput("maPlot"),
      verbatimTextOutput("errorMsg")
    )
  )
)

# Define server logic required to draw the moving averages
server <- function(input, output, session) {
  
  # Reactive expression to fetch stock data based on user input
  stock_data <- eventReactive(input$go, {
    symbol <- toupper(input$symbol)
    tryCatch({
      stock <- getSymbols(symbol, src = "yahoo", auto.assign = FALSE, 
                          from = input$startDate, to = Sys.Date())
      return(stock)
    }, error = function(e) {
      return(NULL)
    })
  })
  
  # Reactive expression to calculate moving averages
  moving_averages <- reactive({
    stock <- stock_data()
    if (is.null(stock)) {
      return(NULL)
    }
    
    if (nrow(stock) == 0) {
      return(NULL)
    }
    
    # Calculate short and long moving averages
    short_ma <- SMA(Cl(stock), n = input$shortMA)
    long_ma <- SMA(Cl(stock), n = input$longMA)
    
    return(list(short_ma = short_ma, long_ma = long_ma))
  })
  
  # Render the plot for moving averages
  output$maPlot <- renderPlot({
    ma_values <- moving_averages()
    
    if (is.null(ma_values)) {
      plot(1, type = "n", xlab = "", ylab = "", main = "Stock data not found")
      return()
    }
    
    # Plot stock data and moving averages
    plot(index(ma_values$short_ma), Cl(stock_data()), type = "l", col = "purple", 
         lwd = 2, xlab = "Date", ylab = "Price", main = paste("Moving Averages for", input$symbol))
    lines(index(ma_values$short_ma), coredata(ma_values$short_ma), col = "gold", lwd = 2)
    lines(index(ma_values$long_ma), coredata(ma_values$long_ma), col = "brown", lwd = 2)
    legend("topleft", legend = c("Stock Price", "ShortMA", "LongMA"),
           col = c("purple", "gold", "brown"), lwd = 2)
  })
  
  # Render error message if stock data is not found
  output$errorMsg <- renderPrint({
    if (is.null(stock_data())) {
      return("Error: Stock symbol not found. Please enter a valid stock symbol.")
    } else if (is.null(moving_averages())) {
      return("Error: No data available for the selected date range.")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

