#' @title  updated information of corona
#' @description Provides tidy data of corona outbreak.output is data frame and no input required.
#' @examples
#' updated_data = updating_data() #returns a tidy data frame of corona outbreak data
#'@export


updating_data <- function() {

  library(tidyverse)
  date = unlist(strsplit(as.character(Sys.Date()-1),split = '-'))
  date = paste(date[2],date[3],date[1],sep = '-')
  appropriate_date = paste0(date,'.csv')
  base_url ='https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/'
  url = paste0(base_url,appropriate_date)

  download_status = download.file(url = url ,destfile = appropriate_date)

   latest_daily_report = read.csv(appropriate_date)

   latest_daily_report %>%
    filter(max(as.Date(latest_daily_report$Last_Update)) == as.Date(Last_Update)) %>%
    group_by(Country_Region) %>%
    summarise(Country_Region,Last_Update,Confirmed = sum(Confirmed),Deaths = sum(Deaths),Active = sum(Active),
              Recovered = sum(Recovered))  %>%distinct() %>% ungroup()-> cleaned_data

    return(cleaned_data)
  }

