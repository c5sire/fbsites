
#' Server side logic
#'
#' Constructs table
#'
#' @param input shinyserver input
#' @param output shinyserver output
#' @param session shinyserver session
#' @param dom target dom element name
#' @author Reinhard Simon
#' @export
server_site <- function(input, output, session, dom="hot_sites"){


  values = shiny::reactiveValues()
  setHot_sites = function(x) values[[dom]] = x

  shiny::observe({
    input$saveBtn
    if (!is.null(values[[dom]])) {
      post_site_table(values[[dom]])
    }

  })

  output$hot_sites = rhandsontable::renderRHandsontable({
    if (!is.null(input[[dom]])) {
      DF = rhandsontable::hot_to_r(input[[dom]])
    } else {
      DF = get_site_table()
    }

    setHot_sites(DF)

    # rhandsontable::rhandsontable(DF) %>%
    #   rhandsontable::hot_table(highlightCol = TRUE, highlightRow = TRUE)
    rh <- rhandsontable::rhandsontable(DF)
    rhandsontable::hot_table(rh, highlightCol = TRUE, highlightRow = TRUE)

  })
}
