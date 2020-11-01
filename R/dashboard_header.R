#' @title Shinydashboard Header
#'
#' @family Shiny Dashboard Functions
#' @description The header is where we declare the title.
#' 
#' @importFrom shiny tags
#' @importFrom shinydashboardPlus dashboardHeaderPlus
dashboard_header <- function() {
  
  header <- dashboardHeaderPlus(
    title = h4(HTML("Positive Rate<br/>Proportion Dashboard"))
  )
  
  return(header)
}