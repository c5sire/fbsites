library(shinydashboard)
library(rhandsontable)
library(fbsites)

tabName <- "resource_site"

dashboardPage(skin = "yellow",

              dashboardHeader(title = "Demo Site"),

              dashboardSidebar(
                sidebarMenu(id = "menu",
                    menuSubItem("Sites", icon = icon("location-arrow"),
                                tabName = tabName)
                )
              ),
              dashboardBody(
                tabItems(
                  fbsites::ui_site(name = tabName)
                )
              )

)
