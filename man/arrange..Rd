% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/arrange.R
\name{arrange.}
\alias{arrange.}
\alias{dt_arrange}
\title{Arrange/reorder rows by variables}
\usage{
arrange.(.data, ...)

dt_arrange(.data, ...)
}
\arguments{
\item{.data}{A data.frame or data.table}

\item{...}{Variables to arrange by}
}
\description{
Order rows in ascending or descending order
}
\examples{
example_dt <- tidytable(
  a = c(1,2,3),
  b = c(4,5,6),
  c = c("a","a","b"))

example_dt \%>\%
  arrange.(c, -a)

example_dt \%>\%
  arrange.(c, desc.(a))
}
