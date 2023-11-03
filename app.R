
library(shiny)
library(shinyjs)
library(jsonlite)

ui <- fluidPage(
  useShinyjs(),
  tags$head(
    tags$script(src = "dist/sql-wasm.js"),
    tags$script(src = "custom.js")
  ),
  h2("SQLite Database Querying in the Browser with sql.js 🚀"),
  h3("Choose Database"),
  fileInput("file", "Choose SQLite File"),
  actionButton("loadDB", "Load Database"),
  hidden(
    div(id = "query_div",
        h3("Enter SQL Query"),
        textAreaInput("query", "Enter SQL Query", value = "SELECT name, sql\n  FROM sqlite_master\n  WHERE type='table'", rows = 5),
        actionButton("executeQuery", "Execute Query"),
        br(),
        verbatimTextOutput("queryOutput")
    )
  )
)

server <- function(input, output, session) {
  
  observe({
    # SQL query execution with sql.js goes here
    runjs(sprintf('executeQuery("%s")', gsub("\n", "", input$query)))
  }) |>bindEvent(input$executeQuery)
  
  output$queryOutput <- renderPrint({
    req(input$queryResult)
    
    # Execute SQL query here and return results
    if (!is.null(isolate(input$query)) && !is.null(isolate(input$file))) {
      fromJSON(input$queryResult)
    } else {
      "Please load a database file and enter a query to execute."
    }
  })
  
  observe({
    req(input$file)
    file <- input$file
    dbFile <- file$datapath
    
    # Copy the file to the www folder so the browser can access it
    file.copy(dbFile, "www/dist/db.sqlite", overwrite = TRUE)
    
    # Read the file and pass it to JavaScript
    runjs(sprintf("loadDB('%s')", "dist/db.sqlite"))
    
    # Show the query input
    show("query_div")
  }) |>
    bindEvent(input$loadDB)
}

shinyApp(ui, server)
