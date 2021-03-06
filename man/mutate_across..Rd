% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mutate_across.R
\name{mutate_across.}
\alias{mutate_across.}
\alias{dt_mutate_across}
\title{Mutate multiple columns simultaneously}
\usage{
mutate_across.(.data, .cols = everything.(), .fns, ..., by = NULL)

dt_mutate_across(.data, .cols = everything.(), .fns, ..., by = NULL)
}
\arguments{
\item{.data}{A data.frame or data.table}

\item{.cols}{vector \code{c()} of bare column names for \code{mutate_across.()} to use.
\code{tidyselect} compatible.}

\item{.fns}{Functions to pass. Can pass a list of functions.}

\item{...}{Other arguments for the passed function}

\item{by}{Columns to group by}
}
\description{
Mutate multiple columns simultaneously.
}
\examples{
example_dt <- data.table::data.table(
  x = c(1,1,1),
  y = c(2,2,2),
  z = c("a", "a", "b"))

example_dt \%>\%
  mutate_across.(is.numeric, as.character)

example_dt \%>\%
  mutate_across.(c(x, y), ~ .x * 2)

example_dt \%>\%
  mutate_across.(everything.(), as.character)

example_dt \%>\%
  mutate_across.(c(x, y), list(new = ~ .x * 2,
                               another = ~ .x + 7))
}
