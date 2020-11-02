dashboard_footer <- function() {
  
  footer <- shinydashboardPlus::dashboardFooter(
    left = fluidRow(
      " ",
      tags$p(tags$a(href="https://connects.catalyst.harvard.edu/Profiles/display/Person/164317", "Changyu Shen", target="_blank"),
                           "|",
                           tags$a(href="https://github.com/alexanderjwhite", "Alex White", target="_blank"))),
    right = tags$a(
      href = "https://github.com/alexanderjwhite/covid_proportion_estimation",
      target="_blank",
      tags$img(src = "www/GitHub_Logo.png", width = "60px")
    )
  )
  
  return(footer)
}