#' Title
#'
#' @param data 
#' @param param 

fct_model_select_bic <- function(data, grid, param = 2:5){
  
  models <- param %>% 
    list() %>% 
    purrr::pmap(
      .f = function(.x){
        model <- deconvolveR::deconv(tau=grid,X=data.frame(data),family="Binomial",pDegree=.x,c0=0)
        
        bic <- fct_bic(model$loglik(model$mle)[1], nrow(data), .x)
        return(list(model = model,k = .x,bic = bic))
      }
    )
  
  model_bic <- models %>% 
    purrr::map_dfr(.f = function(.x){
      tibble("bic" = .x[[3]])
    }) %>% 
    unlist() %>% 
    as.numeric() %>% 
    which.min()
  
  return(list(model = models[[model_bic]]$model, k = models[[model_bic]]$k))
}
