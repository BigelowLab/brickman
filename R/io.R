#' Read Brickman ncdf data into stars objects
#'
#' @export
#' @param scenario character, (case insensitive) one of 'RCP45', 'RCP85', or 'PRESENT'
#' @param year integer or character, the year to read, ignored if scenario is 'PRESENT'
#' @param vars character, variable names (leading "d" and no trailing "_ann")
#' @param interval charcater, on of "ann" or "mon"
#' @param path charcater, the root path to the data
#' @param verbose logical, if TRUE output messages
#' @examples 
#' \dontrun{
#' read_layers()
#' }
read_layers <- function(scenario = c('RCP45', 'RCP85', 'PRESENT')[1],
                       year = c(2055, 2075, NA)[1],
                       vars = c('dSST', 'dSSS'),
                       interval = c("ann", "mon")[1],
                       path = get_path("nc"),
                       verbose = FALSE){
  
  filename <- compose_filename(scenario = scenario,
                               year = year,
                               path = path)
  #filename <- switch(toupper(scenario[1]),
  #    "PRESENT" = file.path(path, "PRESENT.nc"),
  #    file.path(path, sprintf("%s_%s.nc", scenario[1], as.character(year[1]))))
  
  if (tolower(interval[1]) == 'ann'){
    # if all ann then read as attributes (one layer each)
    x <- stars::read_stars(filename,
                           sub = paste0(vars, "_ann"),
                           curvilinear = c("nav_lon", "nav_lat"),
                           quiet = !verbose)
  } else {
    # if all ann then read as attributes (one layer each)
    x <- stars::read_stars(filename,
                           sub = vars,
                           along = "month",
                           curvilinear = c("nav_lon", "nav_lat"),
                           quiet = !verbose)
  }
 x
}


#' Retrieve a listing of the variables in a Brickman file
#' 
#' @export
#' @param scenario character, (case insensitive) one of 'RCP45', 'RCP85', or 'PRESENT'
#' @param year integer or character, the year to read, ignored if scenario is 'PRESENT'
#' @param path character, the root path to the data
#' @return character vector of variable names
query_layers <- function(scenario = c('RCP45', 'RCP85', 'PRESENT')[1],
                         year = c(2055, 2075, NA)[1],
                         path = get_path("nc")){
  
  filename <- compose_filename(scenario = scenario,
                               year = year,
                               path = path)
  
  X <- ncdf4::nc_open(filename)
  vars <- names(X$var)
  ncdf4::nc_close(X)
  
  vars
}