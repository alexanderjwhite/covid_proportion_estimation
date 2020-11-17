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
          selected = "Instructions",
          width = 6,
          height = "150%",
          tabPanel(
            title = "Upload", 
            fluidRow(
              column(12,
            
            fileInput(ns("file"), "Choose File (see Instructions Tab)",
                      accept = c(
                        "text/csv",
                        "text/comma-separated-values,text/plain",
                        ".csv",
                        ".xls",
                        ".xlsx")
            ))
              )
            
            
          ),
          tabPanel(
            title = "Instructions",
            p(
              "Welcome to the dashboard of the distribution of test positivity rate. This application is designed to estimate the distribution of test positivity rate among local communities. As an example, a sample of the COVID-19 testing data in each zip code collected by the city of Chicago from 8/30/2020 to 9/5/2020 has been pre-loaded. In the ",
              tags$em("View Data"),
              " section, the loaded data are displayed with each row representing data from a zip code. The ",
              tags$em("Results"),
              " section displays the estimates of the proportion of zip code areas with a test positivity rate below various upper thresholds. The ",
              tags$em("Proportion Between Lower and Upper Thresholds"),
              " section displays the proportion of zip code areas with a test positivity rate between arbitrary lower threshold and upper threshold."
            ),
            tags$strong("Steps"),
            tags$div(
              tags$ol(
                tags$li(
                  "Format your data as shown in the image below. The first row should contain the column names. Each row in the column named",
                  tags$em("tests"), 
                  "should contain the number of tests performed. Each row in the column named", 
                  tags$em("cases"), 
                  "should contain the number of positive test results. Acceptable formats include ",
                  tags$em(".csv,"), 
                  tags$em(".xlsx"), 
                  ", and ",
                  tags$em(".xls.")
                  ),
                imageOutput(ns("example_format"), inline = TRUE),
                tags$li("Navigate to the ",tags$b("Upload")," tab."),
                tags$li("Select ",tags$b("Browse")," and upload your file."),
                tags$li("A table of default positive rate proportion will populate in the ",tags$b("Results")," table. Estimate the positive rate proportion for a custom range by adjusting the sliding bar and selecting ",tags$b("Update"),".")
                )
            ),
            tags$br(),
            p("For information regarding the background of this dashboard, please visit the ",tags$b("Background")," tab.")
            
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
  
  output$instructions <- renderText({
    
  })
  
  output$example_format <- renderImage({
    
    # Return a list containing the filename
    list(src = "./inst/data/example_format.png",
         contentType = 'image/png',
         width = 178,
         height = 100,
         alt = "")
  }, deleteFile = FALSE)
  
  userFile <- reactive({
    
    if(is.null(input$file)){
      return(list(datapath = "./inst/data/chicago_data.csv"))
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
  
  
  output$n_obs <- shinydashboard::renderValueBox({
    shinydashboard::valueBox(
      datafile() %>% nrow(), "Observations", icon = icon("list"),
      color = "blue"
    )
  })
  
  output$data_table <- DT::renderDataTable(server = TRUE, {
    
    datafile() %>%
      mutate(pos = cases/tests) %>% 
      DT::datatable(colnames = c("Tests", "Cases", "Positive Rate"), 
                    options = list(dom = 'tp', pageLength = 10)) %>% 
      DT::formatPercentage(columns = "pos", digits = 2)
    
  })
  
  return(datafile)
}
    
## To be copied in the UI
# mod_import_data_ui("import_data_ui_1")
    
## To be copied in the server
# callModule(mod_import_data_server, "import_data_ui_1")
 
