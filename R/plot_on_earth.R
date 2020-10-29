#' @title  plotting covid on earth
#' @description Provides a plot to show daily distribution of corona pandemic
#' @param day  wanted day. between 1 to 30.
#' @param month wanted month. between 1 to 12.
#' @param kind wanted variable to be plotted.death and confirmed are acceptable answers
#' @param year wanted year.
#' @importFrom stats rnorm
#' @examples
#' plot_on_earth(10,9,20,'death') #plots death distribution of death by corona on 10/9/2020
#' plot_on_earth(10,9,20,'confirmed') #does same as above but plots distribution of confirmed cases
#'@export



plot_on_earth <-  function(day,month,year,kind) {
  library(rnaturalearth)
  library(rnaturalearthdata)
  library(sf)
  library(rgeos)
  library(tidyverse)
  library(data.table)

  world <- ne_countries(scale = 50, returnclass = "sf")

  for (i in seq(1,length(world[,1]$scalerank))) {        #changing name of USA for compatibility
    if (world[i,5]$sov_a3 == 'US1' ) {
      world[i,4]$sovereignt = 'US'
    }
  }

    if (kind == 'death') {
      url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv'
      download.file(url = url ,destfile = 'death.csv')
      }
    else {
      url = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
     download.file(url = url ,destfile = 'confirmed.csv')
     }

  #cleaning got 3 phases . first finding the wanted day then finding cases of each day and
  #finally  selecting wanted columns which are country and daily rate

  data = fread(paste0(kind,'.csv'))
  n_th_day = which(colnames(data) %in% paste0(month,'/',day,'/',year))

   data %>%
      select(2:4,n_th_day-1,n_th_day) ->cleaned

  cleaned %>%
    cbind(daily = (cleaned[,5] -cleaned[,4]))  %>%
    select(c(1:3,6)) ->cleaned2
  colnames(cleaned2) <- c("country","Lat",'Long','daily')
  cleaned2 %>% group_by(country)%>%
    summarise(country = country,daily = sum(daily)) %>% distinct() ->cleaned3

  #next lines are preparing and merging cleaned data and spatial data
  daily_each_country = data_frame(c(cleaned3$country,setdiff(world$sovereignt,cleaned3$country)),
                 c(cleaned3$daily,rep(0,length(setdiff(world$sovereignt,cleaned3$country)))))
  colnames(daily_each_country) <- c(colnames(world)[4],'daily')

  final_table = right_join(world,daily_each_country, by= colnames(world)[4])

  #plotting!
  ggplot(data = final_table) +
    geom_sf(aes(fill = daily)) +
    scale_fill_viridis_c(option = "plasma", trans = "sqrt") +
    coord_sf(ylim = c(-80, 90), expand = FALSE) +
    xlab('Longitude') + ylab('Latitude') + ggtitle(paste('distribution of daily',kind,'at',paste0(day,'/',month,'/',year)))+
    theme(panel.grid.major = element_line(color = gray(.5), linetype = 'dashed', size = 0.5),
        panel.background = element_rect(fill = 'aliceblue'))
    }

plot_on_earth(10,9,20,'death')


