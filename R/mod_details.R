#' details UI Function
#'#' @description A shiny Module.#'#' @param id,input,output,session Internal parameters for {shiny}.
#'#' @noRd #'#' @importFrom shiny NS tagList 
mod_details_ui <- function(id){
  ns <- NS(id)  
  tagList( 
    fluidRow(
      withMathJax(),
      h1("Technical Details", align = "center"),
      column(2,""),
      column(8,
      helpText("Suppose there are \\(n\\) communities. Let \\(t_i\\) and \\(c_i\\) be the number of tests and cases in a given period of time for community \\(i\\) \\( (i = 1,2,\\cdots,n)\\). The naïve estimate of the test positivity rate for community \\(i\\), \\(\\hat{r}_i = c_i/t_i\\), has a margin of error in estimating the",tags$em("true"),"test positivity rate \\(r_i\\). Here the true test positivity rate refers to the rate that would have been calculated had we been able to test all eligible subjects in the community. The margin of error associated with \\(\\hat{r}_i\\)  in estimating \\(r_i\\) can be estimated by \\( 1.96 \\times \\sqrt{\\hat{r}_i (1-\\hat{r}_i)/t_i} \\)."),
      helpText("The naïve estimate of the proportion of communities with test positivity rate below threshold \\(r_0\\) is $$ \\hat{p}(r_0)=\\frac{\\sum_{i=1}^n I(\\hat{r}_i \\leq r_0)}{n}, $$"),
      helpText("where \\(I(\\cdot)\\) is the indicatory function. Because of the margin of errors associated with \\(\\hat{r}_i, \\hat{p}(r_0)\\) could be a biased estimate of the true proportion $$ p(r_0)=\\frac{\\sum_{i=1}^n I(r_i \\leq r_0)}{n}. $$"),
      helpText("A solution that accounts for the margin of errors is the empirical Bayes deconvolution method. In this approach, the distribution induced by the rates \\(r_i (i=1,2,\\cdots,n), g(r)\\), is assumed to be a natural cubic spline with knots at equally spaced quantiles and can be estimated through either maximum likelihood or regularized maximum likelihood method using data \\( (t_i,c_i) (i=1,2,\\cdots,n)\\). We used maximum likelihood method with Bayesian Information Criteria (BIC) as the tool to select model degrees of freedom up to 5. Once we obtain an estimate \\(\\hat{g}(r)\\), we can estimate \\(p(r_0)\\) by $$\\tilde{p}(r_0) = \\int_0^{r_0}\\hat{g}(r)dr. $$"),
      helpText("\\(\\tilde{p}(r_0)\\) can be a much more accurate estimate of \\(p(r_0)\\) than \\(\\hat{p}(r_0)\\)."),
      tags$strong("References"),
      tags$ol(
        tags$li(helpText("Efron B. Empirical Bayes deconvolution estimates. Biometrika. 2016;103(1):1-20.")),
        tags$li(helpText("Narasimhan B, Efron B. deconvolveR: A G-Modeling Program for Deconvolution and Empirical Bayes Estimation. Journal of Statistical Software. 2020;94(11)."))
      )
      ),
      column(2,"")
    )
     

  )}

    
#' details Server Function#'#' @noRd 
mod_details_server <- function(input, output, session){  
  ns <- session$ns
  
  output$ex1 <- renderUI({
    withMathJax(helpText('Dynamic output 1:  $$\\alpha^2$$'))
  })
 
}    ## To be copied in the UI
# mod_details_ui("details_ui_1")    
## To be copied in the server# callModule(mod_details_server, "details_ui_1")
 
