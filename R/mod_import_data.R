#' import_data UI Function
#'#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_import_data_ui <- function(id){
  ns <- NS(id)  
  
  tagList(
    
      fluidRow(
        shinydashboard::tabBox(
          title = "Import Data",
          id = "import_data",
          width = 6,
          tabPanel(
            title = "Upload", 
              fileInput(ns("file"), "Choose CSV File (see File Instructions Tab)",
                        accept = c(
                          "text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv")
              )
            ),
          tabPanel(
            title = "File Instructions",
            p("Upload a .csv file with two columns, as shown below. The first row should contain the column names. Each row in the column named 'tests' should contain the number of tests performed. Each row in the column named 'cases' should contain the number of positive test results.", style = "font-family: 'times'; font-si16pt"),
            imageOutput(ns("example_format"), inline = TRUE)
          )
  
       ),
       shinydashboard::box(
         title = "View Data",
         closeable = FALSE,
         collapsible = TRUE,
         solidHeader = FALSE,
         status = "primary",
         width = 6,
         DT::dataTableOutput(ns("data_table")) %>% 
           shinycssloaders::withSpinner(
             # color = cla_colors()$theme[1]
           )
       )
      )
      

    
  )
  
}
    
#' import_data Server Function
#'
#' @noRd 
mod_import_data_server <- function(input, output, session){  
  ns <- session$ns 
  
  output$example_format <- renderImage({
    
    # Return a list containing the filename
    list(src = "./inst/data/example_format.png",
         contentType = 'image/png',
         width = 267,
         height = 150,
         alt = "This is alternate text")
  }, deleteFile = FALSE)

  
  # output$downloadData <- downloadHandler(
  #   filename = "example_data.csv",
  #   content = function(file) {write.csv(read.csv("./inst/data/example_data.csv"), file, row.names = FALSE)}
  # )
      
  userFile <- reactive({
    validate(need(input$file !="", "Please import a data file"))
    input$file
  })
  
  datafile <- reactive({
    read.csv(userFile()$datapath,header = TRUE)
    
  })
  
  output$data_table <- DT::renderDataTable(server = TRUE, {
    
    datafile() %>%
      mutate(pos = cases/tests) %>% 
      DT::datatable(colnames = c("Tests", "Cases", "Positive Rate"), 
                    options = list(dom = 'tp', pageLength = 5)) %>% 
      DT::formatPercentage(columns = "pos", digits = 2)
    
  })
  
  return(datafile)
}
    
## To be copied in the UI
# mod_import_data_ui("import_data_ui_1")
    
## To be copied in the server
# callModule(mod_import_data_server, "import_data_ui_1")
 
