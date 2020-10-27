fct_report_results <- function(model, lo_cut = 0, hi_cut = 0.05, table = FALSE){
  
  grid <- model %>% purrr::pluck("grid")
  bayes_mod <- model %>% purrr::pluck("model")
  
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
  
  if(model %>% purrr::pluck("boot")){
    
    sample <- model %>% 
      purrr::pluck("sample")

    
    results <- list(lo,hi) %>%
          purrr::pmap_dfr(.f = function(.x, .y){

            selection <- which(grid >= .x & grid <= .y)
            
            bayes_est <- bayes_mod %>% 
              purrr::pluck("stats") %>% 
              as_tibble() %>% 
              slice(selection) %>% 
              pull(g) %>% 
              sum()
            
            boot_sample <- sample %>% 
              t() %>% 
              as_tibble() %>% 
              slice(selection) %>% 
              summarize_all(sum) %>% 
              t() %>% 
              as.vector()
            
            boot_sample %>% 
              quantile(probs=c(0.975,0.025))
            
            quant <- boot_sample %>% 
              quantile(probs=c(0.975,0.025))
            
            ci_lo <- (2*bayes_est-quant[1]) %>% 
              max(0) %>% 
              scales::number(accuracy = 0.0001)
            
            ci_hi <- (2*bayes_est-quant[2]) %>% 
              min(1) %>% 
              scales::number(accuracy = 0.0001)
            
            raw <- mean(positive_rate >= .x & positive_rate <= .y) %>% 
              scales::number(accuracy = 0.0001)
            
            ci_format <- paste0("(",ci_lo,",",ci_hi,")")
            
            est_format <- bayes_est %>% 
              scales::number(accuracy = 0.0001)
            
            tibble("Low Cut" = .x, "High Cut" = .y, "Raw" = raw, "Adjusted" = est_format, "Confidence" = ci_format)
          })
    
  } else{
    
    results <- list(lo,hi) %>%
      purrr::pmap_dfr(.f = function(.x, .y){
        
        selection <- which(grid >= .x & grid <= .y)
        
        bayes_est <- bayes_mod %>% 
          purrr::pluck("stats") %>% 
          as_tibble() %>% 
          slice(selection) %>% 
          pull(g) %>% 
          sum()
        
        
        bayes_se <- bayes_mod %>% 
          purrr::pluck("cov.g") %>% 
          as_tibble() %>% 
          select(selection) %>%
          slice(selection) %>% 
          sum() %>% 
          sqrt()
        
        raw <- mean(positive_rate >= .x & positive_rate <= .y) %>% 
          scales::number(accuracy = 0.0001)

        z <- 0.975 %>% 
          qnorm()
        
        ci_lo <- (bayes_est-z*bayes_se) %>% 
          max(0) %>% 
          scales::number(accuracy = 0.0001)
        
        ci_hi <- (bayes_est+z*bayes_se) %>% 
          min(1) %>% 
          scales::number(accuracy = 0.0001)
        
        ci_format <- paste0("(",ci_lo,",",ci_hi,")")
        
        est_format <- bayes_est %>% 
          scales::number(accuracy = 0.0001)
        
        tibble("Low Cut" = .x, "High Cut" = .y, "Raw" = raw, "Adjusted" = est_format, "Confidence" = ci_format)
      })
    
  }
}