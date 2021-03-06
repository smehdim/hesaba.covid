% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_time_series.R
\name{plot_time_series}
\alias{plot_time_series}
\title{plot time series of corona outbreak}
\usage{
plot_time_series(day1, month1, day2, month2, country)
}
\arguments{
\item{day1}{starting day of period. between 1 to 30.}

\item{month1}{starting day of perid. between 1 to 12.}

\item{day2}{ending day of period. between 1 to 30.}

\item{month2}{ending day of perid. between 1 to 12.}

\item{country}{country that plotting its status is wanted.}
}
\description{
Provides a plot to show corona outbreak intensity through wanted period
}
\examples{
plot_time_series(1,8,10,8,'Iran') #plots death and confirmed cases of corona from 1/8/20 till 10/8/20 in iran
}
