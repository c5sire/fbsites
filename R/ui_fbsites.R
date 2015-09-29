#' shiny UI element
#'
#' returns a re-usable user interface element
#'
#' @author Reinhard Simon
#' @param type of ui Element; default is a tab in a shiny dashboard
#' @param title display title
#' @param name a reference name
#' @export
ui_site <- function(type = "tab", title = "Site configuration", name = "resource_site"){
  # just only one type
  shinydashboard::tabItem(tabName = name,
            shiny::fluidRow(
            #box(plotOutput("plot1", height = 250)),

            shinydashboard::box(width = 12,
                title = title,
                rhandsontable::rHandsontableOutput("hot_sites", height = 600)
            )
          )
  )
}
