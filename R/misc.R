#' Warp a Brickman stars object
#' 
#' @export
#' @param x stars object
#' @param crs st_crs object
#' @param ... other arguments for \code{\link[stars]{st_warp}}
#' @return warped stars object
warp_brickman = function(x, crs = get_bb("nwa"), ... ){
  

  d = dim(x)
  if (length(d) > 2){
    x = lapply(seq_len(d[3]),
      function(i, rast = NULL, crs = NULL){
        warp_brickman(dplyr::slice(rast, "month", i), crs = crs, ...)
        }, rast  = x, crs = crs) 
    x = do.call(c, append(x, list(along = "month")))
  } else {
    orig_s2 = sf::sf_use_s2()
    sf::sf_use_s2(FALSE)
    x = suppressMessages(suppressWarnings(stars::st_warp(x, crs = crs, ...)))
    sf::sf_use_s2(orig_s2)
  }
  x
}



#' Retrieve convenient bounding boxes
#' 
#' @export
#' @param name char the name of the bounding box, defaults to "native"
#' @return \code{sf::st_sfc()} object
get_bb = function(name = c("nwa", "native")[2]){
  switch(name[1],
    "nwa" = sf::st_bbox(c(xmin = -77, ymin = 36.5, xmax = -42.5, ymax = 56.7), 
                  crs = "OGC:CRS84"),
    sf::st_bbox(c(xmin = -101.504020690918, ymin = 15.9563217163086, 
      xmax = 24.460205078125, ymax = 75.2476196289062),
      crs = "OGC:CRS84")
  ) |>
  sf::st_as_sfc()
}




#' Remove a prefix from a vector of variable names
#' 
#' @export
#' @param x character vector of variable names
#' @param prefix character, what to strip
#' @return character vector of same length as \code{x} but with prefix stripped
strip_prefix <- function(x = c("nav_lon", "nav_lat", "Bathy_depth", "land_mask", "dXbtm", 
                           "dXbtm_ann", "dMLD", "dMLD_ann", "dSST", "dSST_ann", "dSSS", 
                           "dSSS_ann", "dTbtm", "dTbtm_ann", "dSbtm", "dSbtm_ann", "dU", 
                           "dU_ann", "dV", "dV_ann"),
                         prefix = "d"){
  sub(paste0("^", prefix[1]), "", x)
}


#' Add a prefix to a vector of variable names
#' 
#' @export
#' @param x character vector of variable names
#' @param prefix character the prefix to add
#' @param except character vector of names to *not* modify
#' @return character vector of same length as \code{x} but with prefix added
add_prefix <- function(x = c("nav_lon", "nav_lat", "Bathy_depth", "land_mask", "dXbtm", 
                           "dXbtm_ann", "dMLD", "dMLD_ann", "dSST", "dSST_ann", "dSSS", 
                           "dSSS_ann", "dTbtm", "dTbtm_ann", "dSbtm", "dSbtm_ann", "dU", 
                           "dU_ann", "dV", "dV_ann"),
                       prefix = "d",
                       except = c("nav_lon", "nav_lat", "Bathy_depth", "land_mask")){
  
  ix <- !(x %in% except)
  x[ix] <- paste0(prefix[1], x[ix])
  x
}


#' Remove a suffix from a vector of variable names
#' 
#' @export
#' @param x character vector of variable names
#' @param suffix character, what to strip
#' @return character vector of same length as \code{x} but with suffix stripped
strip_suffix <- function(x = c("nav_lon", "nav_lat", "Bathy_depth", "land_mask", "dXbtm", 
                               "dXbtm_ann", "dMLD", "dMLD_ann", "dSST", "dSST_ann", "dSSS", 
                               "dSSS_ann", "dTbtm", "dTbtm_ann", "dSbtm", "dSbtm_ann", "dU", 
                               "dU_ann", "dV", "dV_ann"),
                         suffix = "_ann"){
  sub(paste0(suffix[1], "$"), "", x)
}


#' Add a suffix to a vector of variable names
#' 
#' @export
#' @param x character vector of variable names
#' @param suffix character the prefix to add
#' @param except character vector of names to *not* modify
#' @return character vector of same length as \code{x} but with suffix added
add_suffix <- function(x = c("nav_lon", "nav_lat", "Bathy_depth", "land_mask", "dXbtm", 
                             "dXbtm_ann", "dMLD", "dMLD_ann", "dSST", "dSST_ann", "dSSS", 
                             "dSSS_ann", "dTbtm", "dTbtm_ann", "dSbtm", "dSbtm_ann", "dU", 
                             "dU_ann", "dV", "dV_ann"),
                       suffix = "_ann",
                       except = c("nav_lon", "nav_lat", "Bathy_depth", "land_mask")){
  
  ix <- !(x %in% except)
  x[ix] <- paste0(x[ix], suffix)
  x
}