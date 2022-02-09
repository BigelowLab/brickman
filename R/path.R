#' Retrieve a path for the project data
#' 
#' @export
#' @param ... file path segements, see \code{\link[base]{file.path}}
#' @param root character the root directory
#' @return path description for a directory or file
get_path <- function(..., root = "/mnt/ecocast/coredata/brickman"){
  file.path(root, ...)
}


#' Compose a Brickman filepath
#' 
#' @export
#' @param scenario character, (case insensitive) one of 'RCP45', 'RCP85', or 'PRESENT'
#' @param year integer or character, the year to read, ignored if scenario is 'PRESENT'
#' @param path charcater, the root path to the data
#' @examples 
#' \dontrun{
#' read_layers()
#' }
compose_filename <- function(scenario = c('RCP45', 'RCP85', 'PRESENT')[1],
                        year = c(2055, 2075, NA)[1],
                        path = get_path("nc")){
  
  switch(toupper(scenario[1]),
         "PRESENT" = file.path(path, "PRESENT.nc"),
         file.path(path, sprintf("%s_%s.nc", scenario[1], as.character(year[1]))))
}