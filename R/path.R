#' Retrieve a path for the project data
#' 
#' @export
#' @param ... file path segements, see \code{\link[base]{file.path}}
#' @param path character the root directory
#' @return path description for a directory or file
get_path <- function(..., root = "/mnt/ecocast/coredata/brickman"){
  file.path(root, ...)
}
