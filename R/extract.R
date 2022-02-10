#' Extract values from NCDF by point location
#'
#' No check is performed to test if a point falls within the extent of the grid. Use this
#' only for curvilinear grids; for regular rectilinear grids use \code{\link[stars]{st_extract}}.

#' @export
#' @param X ncdf4 object or a filename to one.  if the latter, then the file will
#'   opened and closed automatically.  Otherwise, the file connectionis left open (so
#'   you have to close it yourself when done.)
#' @param vars one or more variable names
#' @param pts sf POINT object
#' @return tibble with one row per point requested and column per var requested
#'   Note that monthly vars will return a list column (12 elements for each point)
extract_points <- function(X, vars, pts){
  
  
  on.exit({
    if (please_close_me) ncdf4::nc_close(X)
  })
  
  if (inherits(X, "character") && file.exists(X)){
    X <- ncdf4::nc_open(X)
    please_close_me <- TRUE
  } else {
    please_close_me <- FALSE
  }
  
  stopifnot(inherits(X, "ncdf4"))
  stopifnot(all(vars %in% names(X$var)))
  stopifnot(inherits(pts, "sf"))
  
  
  xy <- sf::st_coordinates(pts)
  nxy <- nrow(xy)
  
  
  lon = ncdf4::ncvar_get(X, "nav_lon")
  lat = ncdf4::ncvar_get(X, "nav_lat")
  d <- dim(lon)
  
  index <- sapply(seq_len(nxy),
      function(i, xy, lon, lat){
        ((lon-xy[i,1])^2 + (lat-xy[i,2])^2) |>
          which.min()
      }, xy, lon, lat)
  
  col   <- ((index - 1) %% d[2])  + 1
  row   <- floor((index - 1) / d[2]) + 1
  
  
  sapply(vars,
      function(vn){
        V <- ncdf4::ncvar_get(X, vn)
        if (X$var[[vn]][['ndims']] == 2){
          v <- sapply(seq_len(nxy), 
            function(i){
              V[row[i], col[i]]
            })   
        } else {
          v <- lapply(seq_len(nxy),
            function(i){
              V[row[i], col[i],]
            })
        }
      }, simplify = FALSE) |>
    dplyr::as_tibble()
}