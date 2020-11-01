#' results_dt UI Function#'#' @description A shiny Module.#'
#' @param id,input,output,session Internal parameters for {shiny}.#'#' @noRd 
#'#' @importFrom shiny NS tagList 
mod_results_dt_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
        shinydashboardPlus::boxPlus(
          title = "Results",
          closable  = FALSE,
          collapsible = TRUE,
          solidHeader = FALSE,
          status = "primary",
          width = 6,
          DT::dataTableOutput(ns("results_table")) %>% 
            shinycssloaders::withSpinner(
            )
        ),
        shinydashboardPlus::boxPlus(
          title = "Custom Proportion Range",
          closable  = FALSE,
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
  
  model <- shiny::reactive({fct_bayes_deconv(.data())})

  output$results_table <- DT::renderDataTable(server = TRUE, {
    shiny::req(model())

    model() %>%
      fct_report_results(table = TRUE) %>% 
      select(-c("Low Cut")) %>% 
      DT::datatable(rownames = FALSE,
                    colnames = c("High %", "Raw Proportion", "Adjusted Proportion", "95% Confidence"),
                    options = list(dom = 't')) %>% 
      DT::formatPercentage("High Cut")

  })
  
  observe({
    updateSliderInput(session, "slider", 
                      max = (.data() %>% 
                               mutate(rate = (cases/tests)*100) %>% 
                               summarize(max = max(rate)) %>% 
                               pull() %>% 
                               scales::number(accuracy = 0.1)
                             
                             ))
  })
  
  input_vals <- eventReactive(input$update_button, {
    c(input$slider[1]/100,input$slider[2]/100)
  })
  
  output$slide_table <- DT::renderDataTable(server = TRUE, {
    shiny::req(model())

    vals <- input_vals()
    
    model() %>%
      fct_report_results(lo_cut = vals[1], hi_cut = vals[2]) %>%
      DT::datatable(rownames = FALSE,
                    colnames = c("Low %", "High %", "Raw Proportion", "Adjusted Proportion", "95% Confidence"),
                    options = list(dom = 't'))  %>% 
      DT::formatPercentage(c("Low Cut","High Cut"))
    
  })
  
 
}
    ## To be copied in the UI# mod_results_dt_ui("results_dt_ui_1")
    
## To be copied in the server
# callModule(mod_results_dt_server, "results_dt_ui_1") 

