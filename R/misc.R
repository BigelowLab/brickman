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