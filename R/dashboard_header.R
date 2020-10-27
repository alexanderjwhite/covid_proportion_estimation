#' @title Shinydashboard Header
#'
#' @family Shiny Dashboard Functions
#' @description The header is where we declare the title, which in CLA's case will be the logo. We can also enable extra right side bar and more inside of the [shinydashboardPlus::dashboardHeaderPlus()] function. This function is a key component to the [shinydashboard::dashboardPage()]. In our dashboard we use an extension library to `shinydashboard` called `shindydashboardPlus` where we use [shinydashboardPlus::dashboardPagePlus()] for added features. In the [dashboard_page()] function you will find where these different shinydashboard components come together to form the dashboard.
#' 
#' @importFrom shiny tags
#' @importFrom shinydashboardPlus dashboardHeaderPlus
dashboard_header <- function() {
  
  header <- dashboardHeaderPlus(
    # enable_rightsidebar = FALSE,
    # rightSidebarIcon = "bars",
    # title = tags$a(
    #   href = "https://connects.catalyst.harvard.edu/Profiles/display/Person/164317",
    #   tags$img(src = "www/harvard-catalyst-rgb-med.png", width = "100px")
    # )
    title = h4(HTML("Positive Rate<br/>Proportion Dashboard"))
  )
  
  return(header)
}