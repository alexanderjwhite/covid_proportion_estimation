#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  data_raw <- callModule(mod_import_data_server, "import_data_ui_1")
  callModule(mod_results_dt_server, "results_dt_ui_1", .data = data_raw) 
  callModule(mod_background_server, "background_ui_1") 
  callModule(mod_details_server, "details_ui_1")

}
