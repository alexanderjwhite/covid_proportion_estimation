#' @title Shinydashboard Body
#'
#' @family Shiny Dashboard Functions
#' @description  The body is where we will place our UI/modules. This function is a key component to the [shinydashboard::dashboardPage()]. In our dashboard we use an extension library to `shinydashboard` called `shindydashboardPlus` where we use [shinydashboardPlus::dashboardPagePlus()] for added features. In the [dashboard_page()] function you will find where these different shinydashboard components come together to form the dashboard.
#' 
#' @importFrom shiny tags hr h1 
#' @importFrom shinydashboard dashboardBody tabItems tabItem
dashboard_body <- function() {
  db_body <- dashboardBody(
    tabItems(
      ## Main Tab ----
      tabItem(
        tabName = "main_tab",
        mod_import_data_ui("import_data_ui_1"),
        br(),
        mod_results_dt_ui("results_dt_ui_1"),
        # br(),
        # mod_barplots_ui("barplots_ui_1"),
        br(),
        br()
      ),
      
      # Background Tab
      
      tabItem(
        tabName = "background_tab",
        mod_background_ui("background_ui_1")

      )
    )
  )
}