% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/count.R
\name{count.}
\alias{count.}
\alias{dt_count}
\title{Count observations by group}
\usage{
count.(.data, ...)

dt_count(.data, ...)
}
\arguments{
\item{.data}{A data.frame or data.table}

\item{...}{Columns to group by. \code{tidyselect} compatible.}
}
\description{
Returns row counts of the dataset. If bare column names are provided, \code{count.()} returns counts by group.
}
\examples{
example_df <- tidytable(
  x = 1:3,
  y = 4:6,
  z = c("a", "a", "b"))

example_df \%>\%
  count.()

example_df \%>\%
  count.(z)

example_df \%>\%
  count.(is.character)
}
