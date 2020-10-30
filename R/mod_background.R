#' background UI Function
#'#' @description A shiny Module.#'#' @param id,input,output,session Internal parameters for {shiny}.#'#' @noRd #'#' @importFrom shiny NS tagList 
mod_background_ui <- function(id){  ns <- NS(id)
  tagList( 
    fluidRow(
      column(2,""),
      column(8,
      h1("Estimation of the Distribution of COVID-19 Test Positivity Rate in Communities", align = "center"),
      tags$p("The distribution of COVID-19 test positivity rate in communities (e.g. proportion of communities with test positivity rate below certain threshold) is critically important to guide public health and policy responses. If 10 out of 50 zip code areas in a city have a test positivity rate below 5% then  the naïve estimate of the proportion is 10/50=0.2. The naïve estimate, however, ignores the margin of error of the test positivity rate in each zip code, which could lead to either over- or under-estimate of the proportion. This online application uses a statistical method called Bayesian deconvolution to generate a more accurate estimate.")
      ),
      column(2,"")
    ),
    fluidRow(
      column(2,""),
      column(8,
             align = "center",
      imageOutput(ns("figure_1"), inline = TRUE)
      ),
      column(2,"")
    ),
    fluidRow(
      column(2,""),
      column(8,
      tags$br(),
      tags$br(),
      tags$strong("Figure 1"),
      tags$p("Illustration on how the native calculation can result in overly-optimistic or overly-pessimistic estimate of the proportion of community-level test positivity rate below a threshold"),
      tags$strong("Legend"),
      tags$p("The figure on the left side shows one scenario where the naïve estimate will overestimate the proportion of community level test positivity rate of 5% or less as compared with estimate that accounts for the margin of errors (adjusted estimate). The red area indicates the magnitude of over-optimism. The figure on the right side shows one scenario where the naïve estimate will overestimate the proportion of community level test positivity rate of 5% or more. The red area indicates the magnitude of over-pessimism."),
      tags$strong("References"),
      tags$ol(
        tags$li("Efron B. Empirical Bayes deconvolution estimates. Biometrika. 2016;103(1):1-20."),
        tags$li("Narasimhan B, Efron B. deconvolveR: A G-Modeling Program for Deconvolution and Empirical Bayes Estimation. Journal of Statistical Software. 2020;94(11).")
      )
      ),
      column(2,"")
    )
  )
}    

#' background Server Function
#'
#' @noRd 

mod_background_server <- function(input, output, session){  
  ns <- session$ns 
  
  output$figure_1 <- renderImage({
    
    # Return a list containing the filename
    list(src = "./inst/data/figure_1.png",
         contentType = 'image/png',
         width = 750,
         alt = "This is alternate text")
  }, deleteFile = FALSE)
  
}
    
## To be copied in the UI# mod_background_ui("background_ui_1")
    ## To be copied in the server# callModule(mod_background_server, "background_ui_1") 

