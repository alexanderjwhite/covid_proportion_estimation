#' Title
#'
#' @param .data 
#' @import dplyr
fct_bayes_deconv <- function(.data, lo_cut = 0, hi_cut = 0.05, table = FALSE, updateProgress = NULL){
  
  set.seed(0)
  resolution <- 0.001
  M <- 500
  n <- .data %>% nrow()
  
  data_sample <- .data
  
  positive_rate <- data_sample %>%
    mutate(positive_rate = cases/tests) %>% 
    pull(positive_rate)
  
  grid <- seq(min(positive_rate),max(positive_rate),resolution)
  
  if(table){
    if(max(positive_rate) > 0.1){
      hi <- c(seq(0.01,0.05,0.01),seq(0.1,max(positive_rate),0.05))
    } else {
      hi <- c(seq(0.01,0.05,0.01))
    }
    lo <- rep(0, length(hi))
  } else {
    lo <- lo_cut
    hi <- hi_cut
  }
  
  selection <- which(grid >= lo_cut & grid <= hi_cut)
  
  pDegree <- fct_model_select_bic(.data)$k
  
  if(n < 200){
    # progress_count <- 0
    result <- 1:M %>% 
      list() %>% 
      purrr::pmap_dfr(.f = function(.x){
        
        # progress_count <- progress_count + 1
        if (is.function(updateProgress)) {
          # text <- paste0("x:", round(new_row$x, 2), " y:", round(new_row$y, 2))
          updateProgress(M, detail = "bootstrapped sample")
        }
        
        data_sample <- .data %>% 
          sample_n(size = n, replace = TRUE)
        
        model <- deconvolveR::deconv(tau=grid,X=data.frame(data_sample),family="Binomial",pDegree=pDegree,c0=0)
        
        est <- list(lo,hi) %>% 
          purrr::pmap_dfc(.f = function(.x, .y){
            
            selection <- which(grid >= .x & grid <= .y)
            
            est <- model$stats[selection,2] %>% 
              sum()
            
            tibble(!!paste0("est_",.y) := est)
          })
        
        return(est)
        
      })
    
    confidence <- result %>% 
      summarise_all(function(.x){quantile(.x,0.025)}) %>% 
      tidyr::pivot_longer(cols =  tidyselect::starts_with("est")) %>% 
      select("lo" = value) %>% 
      mutate(lo = scales::percent(lo, accuracy = 0.01)) %>% 
      bind_cols(
        result %>% 
          summarise_all(function(.x){quantile(.x,0.975)}) %>% 
          tidyr::pivot_longer(cols =  tidyselect::starts_with("est")) %>% 
          select("hi" = value) %>% 
          mutate(hi = scales::percent(hi, accuracy = 0.01))
      ) %>% 
      mutate("CI" = paste0("(",lo,",",hi,")")) %>% 
      select(CI)
    

    estimate <- result %>% 
      summarize_all(~median(.x)) %>% 
      tidyr::pivot_longer(cols =  tidyselect::starts_with("est")) %>% 
      select("Adjusted" = value)

    
    se <- result %>% 
      summarize_all(~sd(.x)) %>% 
      tidyr::pivot_longer(cols =  tidyselect::starts_with("est")) %>% 
      select("SE" = value)
    
    results <- tibble(estimate, se, confidence)
    

  } else {
    
    data_sample <- .data
    model <- deconvolveR::deconv(tau=grid,X=data.frame(data_sample),family="Binomial",pDegree=pDegree,c0=0)
    
    
    results <- list(lo,hi) %>% 
      purrr::pmap_dfr(.f = function(.x, .y){
        
        selection <- which(grid >= .x & grid <= .y)
        
        est <- model$stats[selection,2] %>% 
          sum()
        se <- model$cov.g[selection,selection] %>% 
          sum() %>% 
          sqrt()
        confidence <- paste0("(",
                             (est -  qnorm(0.975)*se) %>% 
                               scales::percent(accuracy = 0.01)
                             ,",",
                             (est +  qnorm(0.975)*se) %>% 
                               scales::percent(accuracy = 0.01)
                             ,")")
        
        tibble("Adjusted" = est,
               "SE" = se,
               "CI" = confidence)
      })
    
    
  }
  
  res <- tibble("lo" = lo,
                "hi" = hi) %>% 
    rowwise() %>% 
    mutate("Raw" = mean(positive_rate >= lo & positive_rate <= hi)) %>% 
    bind_cols(results) %>% 
    rename("Low Cut" = lo, "High Cut" = hi)
  
  
  return(res)
  
}