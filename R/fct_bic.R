#' Title
#'
#' @param log_lik 
#' @param n 
#' @param k 
#'
fct_bic <- function(log_lik, n, k){
  return(k*log(n)-2*log_lik)
}