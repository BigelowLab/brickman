% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extract.R
\name{extract_points}
\alias{extract_points}
\title{Extract values from NCDF by point location}
\usage{
extract_points(X, vars, pts, complete = FALSE, simplify_names = TRUE)
}
\arguments{
\item{X}{ncdf4 object or a filename to one.  if the latter, then the file will
opened and closed automatically.  Otherwise, the file connection is left open (so
you have to close it yourself when done.)}

\item{vars}{one or more variable names.  For future scenarios the prefix "d" and/or suffix "_ann"}

\item{pts}{sf POINT object}

\item{complete}{logical, if TRUE include index, row, col, lon and lat in result}

\item{simplify_names}{logical, if TRUE drop "d" prefix and "_ann" suffix from variable names}
}
\value{
tibble with one row per point requested and column per var requested
  Note that monthly vars will return a list column (12 elements for each point)
  If \code{complete} is \code{TRUE} then index, row, col, lon and lat are added
  columns
}
\description{
No check is performed to test if a point falls within the extent of the grid. Use this
only for curvilinear grids; for regular rectilinear grids use \code{\link[stars]{st_extract}}.
}
