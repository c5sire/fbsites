#' UI Side for adding new trial site in HIDAP
#'
#' Returns user friendly ui
#' @author Omar Benites
#' @param type type of UI element, deault is a tab in a shinydashboard
#' @param title diaply title name
#' @param name UI TabName
#' @export
#'

addsite_ui <- function(type = "tab", title = "New Trial Site", name = "createList"){

  shinydashboard::tabItem(tabName = name,

                          #begin tabItem
                          shiny::h2(title),
                          shinyjs::useShinyjs(),
                          shinyjs::extendShinyjs(text = "shinyjs.refresh = function() { location.reload(); }"),

                          shiny::div(
                            id = "geo-panel",

                            shiny::fluidRow( #begin fluidrow
                              shinydashboard::box( #begin box
                              title = "Geographic Data", width = 12, status = "primary", height = "230px", solidHeader = TRUE,
                              #p("Seleccione un cultivo y una base de datos"),

                              shiny::fluidRow( #Geographic Data Location

                                shiny::column(6,
                                       shiny::uiOutput("continent_addloc")
                                                       ),

                                shiny::column(6,
                                       shiny::uiOutput("country_addloc")
                                           ),

                                shiny::column(6,
                                       shiny::selectizeInput(inputId = "fbsites_cipregion", label = "CIP Region", width="100%",
                                                             choices = c("SSA","SWCA","ESEAP","LAC", "Other"),
                                                             options = list(
                                                               placeholder = 'Please select the crop',
                                                               onInitialize = I('function() { this.setValue(""); }')
                                                             ))#,
                                )#,
                             )#,  #End Geographic Data Location

                            ), #end box

                            shinydashboard::box(title = "New Locality", width = 12, status = "primary", height = "300px", solidHeader = TRUE,

                                       shiny::fluidRow(

                                         shiny::column(6,  shiny::textInput("fbsites_admin1",   label =  "Admin1 (Region)")),
                                         shiny::column(6,  shiny::textInput("fbsites_admin2",   label =  "Admin2 (Province)")),
                                         shiny::column(6,  shiny::textInput("fbsites_admin3",   label =  "Admin3 (District)")),
                                         shiny::column(6,  shiny::textInput("fbsites_LocName",  label = "Locality")),
                                         shiny::column(6,  shiny::textInput("fbsites_LocFull",  label = "Locality Full Name")),
                                         shiny::column(6,  shiny::textInput("fbsites_LocShort", label = "Locality Short Name (Abbreviation)"))#,
                                )#,
                            ) ,

                            shinydashboard::box(title = "Geographic Coordinates", width = 12, status = "primary", height =  NULL, solidHeader = TRUE, #begin box

                                       shiny::column(12,
                                                     shiny::radioButtons("select_geosystem", label = shiny::h4("Type of coordinates system",style = "font-family: 'Arial', cursive;
                                                font-weight: 500; line-height: 1.1; color: #4d3a7d;"),
                                                choices = c("Decimal", "Sexagesimal"),
                                                selected = "Decimal"),
                                                shiny::fluidRow(

                                                  shiny::conditionalPanel(
                                 condition = "input.select_geosystem == 'Decimal'",

                                 shiny::column(8,  shiny::div(style="display:inline-block",
                                             shiny::numericInput(inputId = "fbsites_latitude",  value = 0.0, label = "Latitude"),
                                             shiny::numericInput(inputId = "fbsites_longitude", value = 0.0, label = "Longitude")
                                     )
                                  ) #end column(6,
                                ),

                                shiny::conditionalPanel(
                                  condition = "input.select_geosystem == 'Sexagesimal'",


                                  shiny::column(4,  shiny::div(style="display:inline-block",
                                                        shiny::h4("Longitude"),
                                                        shiny::numericInput(inputId = "fbsites_grade_long", label="Grades (\u00B0)", value = 10),
                                                        shiny::numericInput(inputId = "fbsites_minute_long", label="Minutes (')", value = 10),
                                                        shiny::numericInput(inputId = "fbsites_second_long", label="Seconds ('')", value = 10),
                                                        shiny::selectInput(inputId =  "fbsites_orientation_long", label="Orientation",
                                                           choices = c("E","W"), selected = "E" )#,
                                              ) #end div
                                 ),

                                 shiny::column(4,  shiny::div(style="display:inline-block",
                                                              shiny::h4("Latitude"),
                                                              shiny::numericInput(inputId = "fbsites_grade_lat", label="Grades (\u00B0)", value = 10),
                                                              shiny::numericInput(inputId = "fbsites_minute_lat", label="Minutes (')", value = 10),
                                                              shiny::numericInput(inputId = "fbsites_second_lat", label="Seconds ('')", value = 10),
                                                              shiny::selectInput(inputId  =  "fbsites_orientation_lat", label="Orientation",
                                                            choices  = c("N","S"), selected = "N" )#,
                                              ) #end div
                                  )#,

                                ),
                                shiny::column(8, shiny::numericInput(inputId = "fbsites_elevation", value = 2000, label = "Elevation (masl)", width= "160px" ))

                               )# end fluidrow,

                            ) #  column(3


                           ), #end box

                           shiny::fluidRow(

                             shiny::HTML('<div style="float: right; margin: 0 31px 18px 0px;">'),
                           #div(style="display:inline-block",
                           shinysky::shinyalert("alert_fbsites_add", FALSE, auto.close.after = 10),
                           shiny::actionButton("fbsites_submit", "Submit",
                                               icon = shiny::icon("floppy-saved", lib = "glyphicon"),
                                               width = "100px",
                                               style="color: #fff; background-color: #337ab7; border-color: #2e6da4"
                                               ),
                           shiny::actionButton("fbsites_refreshpage",
                                               "Refresh", icon = shiny::icon("refresh", lib = "glyphicon"),
                                               width = "100px",
                                               style="color: #fff; background-color: #51a351; border-color: #51a351"

                                               ),
                           #), #end div
                           shiny::HTML('</div>')#,
                         ),
                         shiny::br(),
                         shiny::br(),
                         shiny::br()






                          )#, #end fluidrow

  )      ,
  shiny::br(),
  shiny::br(),
  shiny::br()


                      ) #end tabItem


}

#' TextInputRow: Create a side-by-side input using shiny framework




