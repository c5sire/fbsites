
#' Server side logic
#'
#' Constructs table
#'
#' @param input shinyserver input
#' @param output shinyserver output
#' @param session shinyserver session
#' @param values reactive values
#' @author Reinhard Simon
#' @export
#'

server_site <- function(input, output, session, values){

  shiny::observe({
    path <- fbglobal::get_base_dir()
    #print(path)
    geodb_file <- "table_sites.rds"
    #path <- paste(path, geodb_file, sep = "\\")
    path <- file.path(path, geodb_file)
    values$geo_vistable <-  readRDS(file = path)
    #     values$geo_db <-  readRDS(file = "sites_table.rds")

  })


  output$tbl_sites = rhandsontable::renderRHandsontable({

    rhandsontable::rhandsontable(values$geo_vistable)

  })


}

