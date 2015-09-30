library(shiny)
library(rhandsontable)
library(fbglobal)
library(fbsites)

shinyServer <- function(input, output, session) {

  fbsites::server_site(input, output, session)

}
