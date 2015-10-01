
#' Server side logic
#'
#' Constructs table
#'
#' @param input shinyserver input
#' @param output shinyserver output
#' @param session shinyserver session
#' @param dom target dom element name
#' @param values reactive values
#' @author Reinhard Simon
#' @export
server_site <- function(input, output, session, dom="hot_sites", values = values){
  setHot_sites = function(x) values[[dom]] = x

  data("iso_country")
  continents = sort(unique(iso_country$continent))
  cipregions = sort(unique(iso_country$cipregion))


  shiny::observe({
    input$saveBtn
    if (!is.null(values[[dom]])) {
      post_site_table(values[[dom]])
    }

  })

  output[[dom]] = rhandsontable::renderRHandsontable({
    if (!is.null(input[[dom]])) {
      DF = rhandsontable::hot_to_r(input[[dom]])
    } else {
      DF = get_site_table()
    }

    DF$cntry = factor(DF$cntry, levels = iso_country$country)
    DF$cont = factor(DF$cont, levels = continents)
    DF$creg = factor(DF$creg, levels = cipregions)

    setHot_sites(DF)
    rh <- rhandsontable::rhandsontable(DF)
    rhandsontable::hot_table(rh, highlightCol = TRUE, highlightRow = TRUE)
    rhandsontable::hot_cols(rh, columnSorting = TRUE)
  })
}
