#' Title
#'
#' @param input 
fct_clean_file <- function(input){
  column_names <- input %>% 
    colnames() %>% 
    stringr::str_to_lower()
  
  clean_file <- input %>% 
    rename_all(function(.x){
      
      .x %>% 
        purrr::map_chr(.f = function(.y){
          val <- stringr::str_to_lower(.y)
          if(stringr::str_detect(val,"test")){
            return("tests")
          } else if(stringr::str_detect(val,"case")){
            return("cases")
          } else {
            return(val)
          }
        })

    })

  return(clean_file)
}