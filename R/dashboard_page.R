#' @title Shiny Dashboard Page
#' 
#' @family Shiny Dashboard Functions
#' @description This function brings all the shinydashboard components together; [dashboard_header()], [dashboard_sidebar()], and [dashboard_body()].
#' 
#' @importFrom shiny tags HTML
#' @importFrom shinydashboardPlus dashboardPagePlus
dashboard_page <- function() {
  dashboardPagePlus(
    header = dashboard_header(),
    sidebar = dashboard_sidebar(),
    body = dashboard_body(),
    footer = dashboard_footer(),
    collapse_sidebar = FALSE,
    tags$style(HTML(".info-box-text{text-transform:none;}"))
  )
}