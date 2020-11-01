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
          side = "right",
          id = "import_data",
          width = 6,
          tabPanel(
            title = "Instructions",
            p("Welcome to the positive rate proportion dashboard. As an example of how the dashboard works, COVID-19 testing data collected by the city of Chicago has been pre-loaded. Follow the steps below to estimate the true positive rate proportion."),
            tags$strong("Steps"),
            tags$div(
              tags$ol(
                tags$li("Format your data as shown in the image below. The first row should contain the column names. Each row in the column named 'tests' should contain the number of tests performed. Each row in the column named 'cases' should contain the number of positive test results. Acceptable formats include .csv, .xlsx, and .xls."),
                imageOutput(ns("example_format"), inline = TRUE),
                tags$li("Navigate to the ",tags$b("Upload")," tab."),
                tags$li("Select ",tags$b("Browse")," and upload your file."),
                tags$li("A table of default positive rate proportion will populate in the ",tags$b("Results")," table. Estimate the positive rate proportion for a custom range by adjusting the sliding bar and selecting ",tags$b("Update"),".")
                # imageOutput(ns("example_format"), inline = FALSE)
                )
            ),
            tags$br(),
            p("For information regarding the background of this dashboard, please visit the ",tags$b("Background")," tab.")
            
          ),
          tabPanel(
            title = "Upload", 
              fileInput(ns("file"), "Choose File (see Instructions Tab)",
                        accept = c(
                          "text/csv",
                          "text/comma-separated-values,text/plain",
                          ".csv",
                          ".xls",
                          ".xlsx")
              )
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
         width = 178,
         height = 100,
         alt = "This is alternate text")
  }, deleteFile = FALSE)
  
  userFile <- reactive({
    
    if(is.null(input$file)){
      return(list(datapath = "./inst/data/example_data_200.csv"))
    } else {
      validate(need(input$file !="", ""))
      return(input$file)
    }  
    })
  
  datafile <- reactive({
    path <- userFile()$datapath
    extension <- path %>% 
      stringr::str_extract("\\w+$") %>% 
      stringr::str_to_lower()
    
    if(extension=="csv"){
      file <- read.csv(path,header = TRUE)
    } else if(extension=="xlsx" | extension=="xls"){
      file <- readxl::read_excel(path)
    }
    
    file <- fct_clean_file(file)
    
    validate(fct_file_validate(file))
    
    clean_file <- file %>% 
      select(tests,cases)

    return(clean_file)
    
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
 
