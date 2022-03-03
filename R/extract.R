#' Extract values from NCDF by point location
#'
#' No check is performed to test if a point falls within the extent of the grid. Use this
#' only for curvilinear grids; for regular rectilinear grids use \code{\link[stars]{st_extract}}.
#'
#' @export
#' @param X ncdf4 object or a filename to one.  if the latter, then the file will
#'   opened and closed automatically.  Otherwise, the file connection is left open (so
#'   you have to close it yourself when done.)
#' @param vars one or more variable names.  For future scenarios the prefix "d" and/or suffix "_ann"
#' @param pts sf POINT object
#' @param complete logical, if TRUE include index, row, col, lon and lat in result
#' @param simplify_names logical, if TRUE drop "d" prefix and "_ann" suffix from variable names
#' @return tibble with one row per point requested and column per var requested
#'   Note that monthly vars will return a list column (12 elements for each point)
#'   If \code{complete} is \code{TRUE} then index, row, col, lon and lat are added
#'   columns
extract_points <- function(X, vars, pts, complete = FALSE, simplify_names = TRUE){
  
  
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
  mask <- ncdf4::ncvar_get(X, "land_mask")
  ix <- which(mask < 1)
  lon[ix] <- NA
  lat[ix] <- NA

  d <- dim(lon)
  
  index <- sapply(seq_len(nxy),
      function(i, xy, lon, lat){
        ((lon-xy[i,1])^2 + (lat-xy[i,2])^2) |>
          which.min()
      }, xy, lon, lat)
  
  row <- ((index - 1) %% d[1]) + 1  
  col <- floor((index - 1) / d[1]) + 1
  
  v <- sapply(vars,
      function(vn){
        V <- ncdf4::ncvar_get(X, vn)
        if (X$var[[vn]][['ndims']] == 2){
          #v <- sapply(seq_len(nxy), 
          #  function(i){
          #    V[row[i], col[i]]
          #  })  
          v <- V[index]
        } else {
          v <- lapply(seq_len(nxy),
            #function(i){
            # V[row[i], col[i],]
            #})
            function(i){
              V[index[i]]
            })
        }
      }, simplify = FALSE) |>
    dplyr::as_tibble()
  
  if(simplify_names){
    names(v) <- sub("^d", "", names(v), fixed = FALSE)
    names(v) <- sub("_ann$", "", names(v), fixed = FALSE)
  }
  
  if (complete){
    v <- dplyr::tibble(
        olon = unname(xy[,1, drop = TRUE]),
        olat = unname(xy[,2, drop = TRUE]),
        lon = lon[index],
        lat = lat[index],
        index = index,
        row = row,
        col = col
      ) |>
      dplyr::bind_cols(v)
  }
  return(v)
}