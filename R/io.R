#' Easy Brickman ncdf data into stars, tibble or sf objects
#' 
#' Lazily fixes variable names to drop "d" prefix and "_ann" suffix which permits
#' user to request variables ala "SST", "SSS" etc regardless of scenario.
#'
#' @export
#' @param scenario character, (case insensitive) one of 'RCP45', 'RCP85', or 'PRESENT'
#' @param year integer or character, the year to read, ignored if scenario is 'PRESENT'
#' @param vars character, variable names (leading "d" and no trailing "_ann")
#' @param interval character, on of "ann" or "mon"
#' @param path character, the root path to the data
#' @param verbose logical, if TRUE output messages
#' @param add stars object or NULL  If not NULL then add this to the result.
#' @param form character, one of 'stars', 'tibble' or 'sf' to control output form
#' @examples 
#' \dontrun{
#' present <- read_brickman(scenario = "PRESENT")
#' rcp45_2075 <- read_brickman(year = 2075, form = "tibble", add = present)
#' }
read_brickman <- function(scenario = c('RCP45', 'RCP85', 'PRESENT')[1],
                          year = c(2055, 2075, NA)[1],
                          vars = c('SST', 'SSS'),
                          interval = c("ann", "mon")[1],
                          path = get_path("nc"),
                          verbose = FALSE,
                          add = NULL,
                          form = c("stars", "tibble", "sf")[1]){
  
  if (toupper(scenario[1]) != "PRESENT"){
    is_present <- FALSE
    varnames <- paste0("d", vars)
  } else {
    is_present <- TRUE
    varnames <- vars
  }
  x <- read_layers(scenario = scenario, year = year, vars = varnames,
                   interval = interval, path = path, verbose = verbose)
  if (!is_present) names(x) <- gsub("d", "", names(x), fixed = TRUE)
  if (tolower(interval[1]) == "ann") names(x) <- gsub("_ann", "", names(x), fixed = TRUE)
  
  if (!is.null(add)){
    x <- x + add
  }
  
  switch(tolower(form[1]),
         'tibble' = dplyr::as_tibble(x),
         'sf' = sf::st_as_sf(x, as_points = TRUE, na.rm = FALSE),
         x)
}


#' Read Brickman ncdf data into stars objects
#'
#' @export
#' @param scenario character, (case insensitive) one of 'RCP45', 'RCP85', or 'PRESENT'
#' @param year integer or character, the year to read, ignored if scenario is 'PRESENT'
#' @param vars character, variable names (leading "d" and no trailing "_ann")
#' @param interval character, on of "ann" or "mon"
#' @param path character, the root path to the data
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
    x <- suppressWarnings(stars::read_stars(filename,
                           sub = paste0(vars, "_ann"),
                           curvilinear = c("nav_lon", "nav_lat"),
                           quiet = !verbose)) |>
      rlang::set_names(paste0(vars, "_ann"))
  } else {
    # if all ann then read as attributes (one layer each)
    x <- suppressWarnings(stars::read_stars(filename,
                           sub = vars,
                           along = "month",
                           curvilinear = c("nav_lon", "nav_lat"),
                           quiet = !verbose)) |>
      rlang::set_names(vars)
    
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