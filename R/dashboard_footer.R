dashboard_footer <- function() {
  
  footer <- shinydashboardPlus::dashboardFooter(
    left = fluidRow(
      " ",
      tags$p(tags$a(href="https://connects.catalyst.harvard.edu/Profiles/display/Person/164317", "Changyu Shen"),
                           "|",
                           tags$a(href="https://github.com/alexanderjwhite", "Alex White"))),
    right = tags$a(
      href = "https://github.com/alexanderjwhite/covid_proportion_estimation",
      tags$img(src = "www/GitHub_Logo.png", width = "40px")
    )
  )
  
  return(footer)
}