#' server_design
#'
#' Design a fieldbook
#'
#' @param input shinyserver input
#' @param output shinyserver output
#' @param session shinyserver session
#' @param values reactive values
#' @author Omar Benites
#' @export
#'
#server_design <- function(input, output, session, dom="hot_fieldbook_design", values){

server_addsite <- function(input, output, session, values){
  #data("iso_country")

  output$continent_addloc <- shiny::renderUI({
    #req(input$fbmlist_select_new)
    #Use of countrycode dataset and package for extracting continent data
    continent_list <- unique(iso_country$continent)
    continent_list <- continent_list[!is.na(continent_list)]
    continent_list <- sort(continent_list)

    #selectInput("fbmlist_continent_new", label = h4("Continent"), choices = continent_list , placeholder = "Choose Continent")
    shiny::selectizeInput(inputId ="fbsites_continent", label = "Select Continent",
                          multiple =  FALSE, width="100%", choices = continent_list,
                          options = list(
                            placeholder = 'Please select continent',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
    )
  })

  output$country_addloc <- shiny::renderUI({

   #create reactive values to store dataframe
    values <- shiny::reactiveValues(geo_db = NULL)


    continent_header <- input$fbsites_continent

    if(continent_header == "" || is.null(continent_header)) {
      country_list <- ""

    } else {
      continent = NULL
      country_list <- dplyr::filter(iso_country, continent == continent_header)
      country_list <- dplyr::select_(country_list, "country")
    }

    shiny::selectizeInput(inputId ="fbsites_country", label = "Select Country",
                            multiple =  FALSE, width="100%", choices = country_list,
                            options = list(
                            placeholder = 'Please select country',
                            onInitialize = I('function() { this.setValue(""); }')
                          )
    )
  })

  shiny::observe({

    #After all this conditions has been made, the submit button will appear to save the information
    shinyjs::toggleState("fbsites_submit", !is.null(input$fbsites_continent) && stringr::str_trim(input$fbsites_continent, side = "both")!= "" &&
                                  !is.null(input$fbsites_country) && stringr::str_trim(input$fbsites_country, side = "both")!= "" &&
                                  !is.null(input$fbsites_LocName) && stringr::str_trim(input$fbsites_LocName, side = "both") != "" &&
                                  !is.null(input$fbsites_LocFull) && stringr::str_trim(input$fbsites_LocFull, side = "both") != "" &&
                                  !is.null(input$fbsites_LocShort) && stringr::str_trim(input$fbsites_LocShort, side = "both")!="" &&
                                  !is.null(input$fbsites_admin1) && stringr::str_trim(input$fbsites_admin1, side = "both")!="" &&
                                  !is.null(input$fbsites_admin2) && stringr::str_trim(input$fbsites_admin2, side = "both")!="" &&
                                  !is.null(input$fbsites_admin3) && stringr::str_trim(input$fbsites_admin3, side = "both")!=""
               )
  })
  shiny::observe({
      path <- fbglobal::get_base_dir()
      geodb_file <- "table_sites.rds"
      path <- file.path(path, geodb_file)
      values$geo_db <-  readRDS(file = path)
  })



  shiny::observeEvent(input$fbsites_submit, {
    #alert("Thank you!")


    # cntry <- fbsites::get_country_list(sites_data =  values$geo_db)
    # print(cntry)

    shiny::withProgress(message = 'Saving the new locality...', value = 0, {

      shiny::incProgress(3/15)
    # use the reactive geo_db data
    #geo_db_data <- geo_db()

    continent <- stringr::str_trim(input$fbsites_continent,side = "both")
    country   <- stringr::str_trim(input$fbsites_country, side = "both")
    cregion <- stringr::str_trim(input$fbsites_cipregion, side = "both")

# Trim all whitespaces for every geovariable ------------------------------

    admin1    <- stringr::str_trim(input$fbsites_admin1, side = "both")
    admin2    <- stringr::str_trim(input$fbsites_admin2, side = "both")
    admin3    <- stringr::str_trim(input$fbsites_admin3, side = "both")
    locFull   <- stringr::str_trim(input$fbsites_LocFull, side = "both")
    locName   <- stringr::str_trim(input$fbsites_LocName, side = "both")
    locShort  <- stringr::str_trim(input$fbsites_LocShort, side = "both")
    locShort <-  gsub("[[:space:]]","", locShort)

    if(input$select_geosystem == "Decimal"){
      latitude <- stringr::str_trim(input$fbsites_latitude, side = "both")
      longitude <- stringr::str_trim(input$fbsites_longitude, side = "both")
    }

    if(input$select_geosystem == "Sexagesimal"){ # for sexagesimal degress

      grade_long <-  input$fbsites_grade_long
      minute_long <- input$fbsites_minute_long
      second_long <- input$fbsites_second_long
      orientation_long <- input$fbsites_orientation_long

      grade_lat <- input$fbsites_grade_lat
      minute_lat <- input$fbsites_minute_lat
      second_lat <- input$fbsites_second_lat
      orientation_lat <- input$fbsites_orientation_lat

      if(orientation_long=="E"){
          longitude <- seg2dec(grade = grade_lat, minute = minute_lat, second = second_lat )
      } else {
          longitude <- seg2dec(grade = grade_lat, minute = minute_lat, second = second_lat)
          longitude <- -longitude
      }

      if(orientation_lat=="N"){
          latitude  <- seg2dec(grade = grade_long, minute = minute_long, second = second_long)
      } else {
          latitude  <- seg2dec(grade = grade_long, minute = minute_long, second = second_long)
          latitude <- -latitude
      }

    } # end for sexagesimal degress

 elevation <- stringr::str_trim(input$fbsites_elevation, side = "both")
###


# Creation of list with geovariables

  lgeovar <- list(id    = nrow(values$geo_db)+1, #to add new row index
                          shortn =  toupper(locShort), #uppercase
                          altern =  NA,
                          fulln  =  locFull,
                          local  =  locName ,#local = adm4
                          latd   =  latitude,
                          lond   =  longitude,
                          elev   =  elevation ,
                          crops  =  NA,
                          aez    =  NA,
                          cont   =  continent,
                          creg   =  cregion,
                          cntry  =  country,
                          adm4   =  locName, #local = localname = adm4
                          adm3   =  admin3,
                          adm2   =  admin2,
                          adm1   =  admin1,
                          comment = NA,
                          user = "local"
                  )
###

  #Appear two conditions

  # print(values$geo_db)
  # print(values$geo_db[,"shortn"][[1]])
  #       print(values$geo_db[,"local"][[1]])
  #             print(values$geo_db[,"fulln"][[1]])
  #
  # print(lgeovar)

      #first condition
      if( is.element(lgeovar$shortn, values$geo_db[,"shortn"][[1]] )){

          msg <- paste("Your locality short name for your location ", lgeovar$shortn, " already exists.", " Please try again.", sep = "")
          #print("no location added")
          shinysky::showshinyalert(session, "alert_fbsites_add", msg, styleclass = "danger")

      } else if(is.element(lgeovar$local, values$geo_db[,"local"][[1]])){

          msg <- paste("Your locality ", lgeovar$local, " already exists." , " Please try again.", sep = "")
          #print("no location added")
          shinysky::showshinyalert(session, "alert_fbsites_add", msg, styleclass = "danger")

      } else if(is.element(lgeovar$fulln, values$geo_db[,"fulln"][[1]])){

          msg <- paste("Your locality ", lgeovar$fulln, " already exists." , " Please try again.", sep = "")
          #print("no location added")
          shinysky::showshinyalert(session, "alert_fbsites_add", msg, styleclass = "danger")

      } else {

          #Convert list in data.frame
          new_instance <- as.data.frame(lgeovar, stringsAsFactors = FALSE)
          #appende the new instance into geo_db()
          values$geo_db <- rbind(values$geo_db, new_instance)


          path <- fbglobal::get_base_dir()
          #print(path)
          geodb_file <- "table_sites.rds"
          #path <- paste(path, geodb_file, sep = "\\")

          path <- file.path(path, geodb_file)

          saveRDS(values$geo_db, file = path)

          msg <- "Your new locality has been successfully added."
          shinysky::showshinyalert(session, "alert_fbsites_add", msg, styleclass = "success")


          shinyjs::reset("geo-panel")


      }

  })

})


  shiny::observeEvent(input$fbsites_refreshpage, {
    shiny::withProgress(message = 'Refreshing HiDAP to update internal tables...', value = 0, {

      shiny::incProgress(3/15)
      shinyjs::js$refresh()

    })
  })

}
