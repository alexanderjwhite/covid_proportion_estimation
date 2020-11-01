#' Title
#'
#' @param .data 
#' @import dplyr
fct_bayes_deconv <- function(.data, updateProgress = NULL){
  
  set.seed(0)
  resolution <- 0.001
  M <- 500
  n <- .data %>% nrow()
  
  data_sample <- .data
  
  positive_rate <- data_sample %>%
    mutate(positive_rate = cases/tests) %>% 
    pull(positive_rate)
  
  grid <- seq(min(positive_rate),max(positive_rate),resolution)

  pDegree <- fct_model_select_bic(.data, grid)$k
  model <- deconvolveR::deconv(tau=grid,X=data.frame(.data),family="Binomial",pDegree=pDegree,c0=0)
  
  if(n < 200){
    
    
    progress <- shiny::Progress$new()
    progress$set(message = "Computing", value = 0)
    on.exit(progress$close())
    
    updateProgress <- function(value = NULL, detail = NULL) {
      progress$inc(amount = 1/value, detail = detail)
    }
    
    sample <- array(as.numeric())
    for (i in 1:M){
      
      if (is.function(updateProgress)) {
        
        updateProgress(M, detail = "bootstrapped sample")
      }
      
      iter_sample <- .data %>% 
              sample_n(size = n, replace = TRUE)
      model <- deconvolveR::deconv(tau=grid,X=data.frame(iter_sample),family="Binomial",pDegree=pDegree,c0=0)
      est <- model$stats[,2]
      sample <- est %>% rbind(sample)
    }

    
    return(list(model = model, sample = sample, grid = grid, rate = positive_rate, boot = TRUE))

  } else {
    
    return(list(model = model, sample = NULL, grid = grid, rate = positive_rate, boot = FALSE))
 
  }
}