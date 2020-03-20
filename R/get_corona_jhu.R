# TODO: translate to pt-br

# TODO: finish doc

# TODO: include packages via usethis::use_package()

# TODO: devtools::check()

get_corona_jhu <- function(last_update = TRUE, date = NULL) {

  if (last_update && is.null(date) | last_update && !is.null(date)) {

    message("Getting latest data ...\n\n")

    yesterday <- format(as.Date(Sys.Date() - 1, '%Y-%m-%d'), "%m-%d-%Y")

    link <-
      glue::glue("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/{yesterday}.csv")

    covid_data <-
      readr::read_csv(link) %>%
      janitor::clean_names(dat = ., case = "snake")

  }

  if (last_update == FALSE && !is.null(date)) {

    date_begin <- format(as.Date("01-22-2020", '%m-%d-%Y'), "%m-%d-%Y")

    date_end <- format(as.Date(Sys.Date() - 1, '%Y-%m-%d'), "%m-%d-%Y")

    date_wanted <- format(as.Date(date, '%m-%d-%Y'), "%m-%d-%Y")

    if (date_wanted < date_begin | date_wanted > date_end) {

      message(glue::glue("Please provide a date between {date_begin} and {date_end}."))

      covid_data <- NULL

    } else {

      message(glue::glue("Getting data from {date_wanted} ...\n\n"))

      link <-
        glue::glue("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/{date_wanted}.csv")

      covid_data <-
        readr::read_csv(link) %>%
        janitor::clean_names(dat = ., case = "snake")

    }

  }

  if (!is.null(covid_data)) {

    return(covid_data)

  }


}

