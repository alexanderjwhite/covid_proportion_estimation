dashboard_footer <- function() {
  
  footer <- shinydashboardPlus::dashboardFooter(
    left = fluidRow(
      " ",
      tags$p(tags$a(href="https://connects.catalyst.harvard.edu/Profiles/display/Person/164317", "Changyu Shen"),
                           "|",
                           tags$a(href="https://www.linkedin.com/in/alexanderjameswhite", "Alex White"))),
    right = ""
  )
  
  return(footer)
}