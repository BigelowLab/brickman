suppressPackageStartupMessages({
  library(brickman)
  library(stars)
  library(dplyr)
})
vars <- c("Bathy_depth", "MLD", "Sbtm",  "SSS",  "SST",  "Tbtm",  "U",  "V",  "Xbtm")

add <- brickman::read_brickman(scenario="PRESENT",
                                       vars=vars,
                                       interval="ann",
                                       form="stars")

x <- read_brickman(scenario = "RCP45", 
                   vars = vars, 
                   interval = "ann", 
                   form = "stars",
                   add = add)

