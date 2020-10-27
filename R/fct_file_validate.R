fct_file_validate <- function(input){
  col_names <- input %>% 
    colnames() %>% 
    stringr::str_to_lower()
  if(input %>% ncol() < 2){
    "Please verify that your file contains the columns 'tests' and 'cases'."
  } else if(input %>% nrow() < 40){
    "The minimum sample size is 40. Please verify that your file contains at least 50 observations."
  } else if(!("tests" %in% col_names) | !("cases" %in% col_names)){
    "Please verify that your file contains the columns 'tests' and 'cases'."
  } else {
    NULL
  }
  
}