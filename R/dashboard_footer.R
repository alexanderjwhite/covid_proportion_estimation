dashboard_footer <- function() {
  
  footer <- shinydashboardPlus::dashboardFooter(
    left = fluidRow(
      " ",
      tags$p("Changyu Shen |",
                           tags$a(href="https://github.com/alexanderjwhite", "Alex White", target="_blank"))),
    right = tags$a(
      href = "https://github.com/alexanderjwhite/covid_proportion_estimation",
      target="_blank",
      tags$img(src = "www/GitHub_Logo.png", width = "60px")
    )
  )
  
  return(footer)
}