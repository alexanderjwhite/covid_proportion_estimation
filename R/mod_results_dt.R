#' results_dt UI Function#'#' @description A shiny Module.#'
#' @param id,input,output,session Internal parameters for {shiny}.#'#' @noRd 
#'#' @importFrom shiny NS tagList 
mod_results_dt_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
        shinydashboardPlus::boxPlus(
          title = "Results",
          closeable = FALSE,
          collapsible = TRUE,
          solidHeader = FALSE,
          status = "primary",
          width = 6,
          DT::dataTableOutput(ns("results_table")) %>% 
            shinycssloaders::withSpinner(
              # color = cla_colors()$theme[1]
            )
        ),
        shinydashboardPlus::boxPlus(
          title = "Custom Proportion Range",
          closeable = FALSE,
          collapsible = TRUE,
          solidHeader = FALSE,
          status = "primary",
          width = 6,
          sliderInput(ns("slider"), 
                      label = "Cut Range",
                      min = 0,
                      max = 20,
                      step = 1,
                      post  = " %",
                      value = c(0,5)) ,
          actionButton(
            inputId = ns("update_button"),
            label = "Update"
          ),
          DT::dataTableOutput(ns("slide_table")) %>% 
            shinycssloaders::withSpinner(
              # color = cla_colors()$theme[1]
            )
        )
      
    )
  )
}
    #' results_dt Server Function
#'
#' @noRd 
mod_results_dt_server <- function(input, output, session, .data){  
  ns <- session$ns

  
  output$results_table <- DT::renderDataTable(server = TRUE, {
    
    progress <- shiny::Progress$new()
    progress$set(message = "Computing", value = 0)
    on.exit(progress$close())
    
    updateProgress <- function(value = NULL, detail = NULL) {
      progress$inc(amount = 1/value, detail = detail)
    }

    .data() %>%
      fct_bayes_deconv(table = TRUE, updateProgress = updateProgress) %>% 
      select(-c("Low Cut", "SE")) %>% 
      DT::datatable(rownames = FALSE,
                    options = list(dom = 't')) %>% 
      DT::formatPercentage(columns = c("High Cut", "Raw", "Adjusted"),
                           digits = 2)

  })
  
  observe({
    updateSliderInput(session, "slider", 
                      max = (.data() %>% 
                               mutate(rate = (cases/tests)*100) %>% 
                               summarize(max = max(rate)) %>% 
                               pull()))
  })
  
  input_vals <- eventReactive(input$update_button, {
    c(input$slider[1]/100,input$slider[2]/100)
  })
  
  output$slide_table <- DT::renderDataTable(server = TRUE, {
    
    progress <- shiny::Progress$new()
    progress$set(message = "Computing", value = 0)
    on.exit(progress$close())
    
    updateProgress <- function(value = NULL, detail = NULL) {
      progress$inc(amount = 1/value, detail = detail)
    }
    
    vals <- input_vals()
    .data() %>%
      fct_bayes_deconv(lo_cut = vals[1], hi_cut = vals[2], updateProgress = updateProgress) %>%
      select(-SE) %>% 
      DT::datatable(rownames = FALSE,
                    options = list(dom = 't')) %>% 
      DT::formatPercentage(columns = c("Low Cut", "High Cut", "Raw", "Adjusted"),
                           digits = 2)
    
  })
  
  # output$results_table <- renderTable({
  #   
  #   .data()
  #   
  # })
 
}
    ## To be copied in the UI# mod_results_dt_ui("results_dt_ui_1")
    
## To be copied in the server
# callModule(mod_results_dt_server, "results_dt_ui_1") 

