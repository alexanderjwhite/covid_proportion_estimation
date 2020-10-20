#' Title
#'
#' @param .data 
#'
#' @return
#' @export
#'
#' @examples
#' @import ggplot2
fct_bayes_deconv_plot <- function(.data){
  
  
  positive_rate <- .data %>%
    mutate(positive_rate = cases/tests) %>% 
    pull(positive_rate)
  
  
  resolution <- 0.001
  
  grid <- seq(min(positive_rate),max(positive_rate),resolution)
  out <- deconvolveR::deconv(tau=grid,X=data.frame(.data),family="Binomial",pDegree=4,c0=0)
  hist.grid<-0.01
  hist.area<-100*hist.grid
  
  p <- ggplot() +
    geom_histogram(aes(
      x=positive_rate, 
      y=(..count..)*100/sum(..count..)),
      breaks=seq(0,max(positive_rate)+hist.grid,hist.grid)
    ) +
    xlab("Test Positive Rate for each Area") +
    ylab("Percentage (%)") +
    geom_line(aes(x = grid, y = out$stats[,2]*hist.area/resolution),
              linetype = "dashed",
              color = "steelblue",
              size = 2) +
    theme_classic()
  
  
  p <- plotly::ggplotly(p)
  
  # Sys.sleep(3)
  return(p)
  
}