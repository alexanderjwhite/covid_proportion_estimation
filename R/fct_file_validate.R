fct_file_validate <- function(input){
  col_names <- input %>% 
    colnames() %>% 
    stringr::str_to_lower()
  
  invalid_cases <- input %>% 
    mutate(inv = ifelse(cases > tests | cases < 0, 1, 0)) %>% 
    summarize(sum_inv = sum(inv, na.rm = TRUE)) %>% 
    pull(sum_inv)
  
  invalid_tests <- input %>% 
    mutate(inv = ifelse(tests <= 0, 1, 0)) %>% 
    summarize(sum_inv = sum(inv, na.rm = TRUE)) %>% 
    pull(sum_inv)
  
  
  if(input %>% ncol() < 2){
    "Please verify that your file contains the columns 'tests' and 'cases'."
  } else if(input %>% nrow() < 25){
    "The minimum sample size is 25. Please verify that your file contains at least 25 observations."
  } else if(!("tests" %in% col_names) | !("cases" %in% col_names)){
    "Please verify that your file contains the columns 'tests' and 'cases'."
  } else if (invalid_cases > 0) {
    "Please verify that all cases are greater than or equal to 0 and less than or equal to the number of tests."
  } else if (invalid_tests > 0) {
    "Please verify that all tests are greater than 0"
  } else {
    NULL
  }
  
}