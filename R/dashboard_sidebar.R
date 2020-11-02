#' @title Shinydashboard Sidebar
#'
#' @family Shiny Dashboard Functions
#' @description The sidebar is where we declare wanted menu items/tabs. This function is a key component to the [shinydashboard::dashboardPage()]. In our dashboard we use an extension library to `shinydashboard` called `shindydashboardPlus` where we use [shinydashboardPlus::dashboardPagePlus()] for added features. In the [dashboard_page()] function you will find where these different shinydashboard components come together to form the dashboard.
#' 
#' @importFrom shiny icon
#' @importFrom shinydashboard dashboardSidebar sidebarMenu menuItem
dashboard_sidebar <- function() {
  sidebar <- shinydashboard::dashboardSidebar(
    shinydashboard::sidebarMenu(
      id = "tabs",
      shinydashboard::menuItem(
        tabName = "main_tab",
        text = "Results",
        icon = shiny::icon("table")
      ),
      shinydashboard::menuItem(
        tabName = "background_tab",
        text = "Background",
        icon = shiny::icon("align-left")
      ),
      shinydashboard::menuItem(
        tabName = "details_tab",
        text = "Details",
        icon = shiny::icon("brain")
      )
    )
  )
  return(sidebar)
}