#' @title  plot time series of corona outbreak
#' @description Provides a plot to show corona outbreak intensity through wanted period
#' @param day1 starting day of period. between 1 to 30.
#' @param day2 ending day of period. between 1 to 30.
#' @param month1 starting day of perid. between 1 to 12.
#' @param month2 ending day of perid. between 1 to 12.
#' @param country country that plotting its status is wanted.
#' @examples
#' plot_time_series(1,8,10,8,'Iran') #plots death and confirmed cases of corona from 1/8/20 till 10/8/20 in iran
#'@export




plot_time_series <- function(day1,month1,day2,month2,country) {

  library(tidyverse)
  library(ggplot2)
  require(data.table)
  library(patchwork)

  url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
  download.file(url = url ,destfile = 'confirmed.csv')

  url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'
  download.file(url = url ,destfile = 'death.csv')

  death = fread('death.csv')
  confirmed = fread('confirmed.csv')
  country = "Iran"
  year = 20

  n_th_day1 = 70# which(colnames(death) %in% paste0(month1,'/',day1,'/',year))
  n_th_day2 = 80 #which(colnames(death) %in% paste0(month2,'/',day2,'/',year))

  death %>%
    select(2,(n_th_day1-1):n_th_day2) -> death1

  confirmed %>%
    select(2,(n_th_day1-1):n_th_day2) -> confirmed1

  colnames(death1) <- c('state',colnames(death1)[-1])
  colnames(confirmed1) <- c('state',colnames(confirmed1)[-1])

  death1 %>% filter(state == country) -> wanted_country_death
  confirmed1 %>% filter(state == country) -> wanted_country_confirmed

  rbind(wanted_country_death,wanted_country_death) %>%  select(-1)-> k_death
  rbind(wanted_country_confirmed,wanted_country_confirmed) %>% select(-1) ->k_confirmed

  data.frame(k_death[1,-1] -  k_death[1,1:(n_th_day2 - n_th_day1+1)]) -> rate_death
  data.frame(k_confirmed[1,-1] -  k_confirmed[1,1:(n_th_day2 -n_th_day1+1)]) -> rate_confirmed

  rate_death %>% transpose() %>% cbind(colnames(k_death)[-1]) ->final_death
  rate_confirmed %>% transpose() %>% cbind(colnames(k_death)[-1]) ->final_confirmed

  colnames(final_death)<-(c('rate','day'))
  colnames(final_confirmed)<-(c('rate','day'))

  p1<-
    ggplot(final_death,aes( day,rate)) +
    geom_point(color = 'red',size =2.5,alpha=1) + geom_line(aes(1:length(final_death[,1]) , rate),
                                                    color = 'red',size =0.75) +theme_bw() +
    #xlab('Longitude') + ylab('Latitude') +
    ggtitle(paste('distribution of daily deaths','at',country,'between',
                  paste0(day1,'/',month1,'/',20,year),'till',paste0(day2,'/',month2,'/',20,year)))

  p2 <-
    ggplot(final_confirmed,aes(day ,rate)) +
    geom_point(color = 'orange',size = 2.5) +geom_line(aes(1:length(final_confirmed[,1]),rate),
                                                     size=0.75,color = 'orange') +theme_bw()+
    ggtitle(paste('distribution of daily confirmed cases','at',country,'between',
                  paste0(day1,'/',month1,'/',20,year),'till',paste0(day2,'/',month2,'/',20,year)))

   p1 / p2
}

