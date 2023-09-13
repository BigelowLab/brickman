suppressPackageStartupMessages({
  library(stars)
  library(sf)
  library(dplyr)
})

# read in as per example 
# https://r-spatial.github.io/stars/articles/stars1.html#cropping-a-rasters-extent
prec_file = system.file("nc/test_stageiv_xyt.nc", package = "stars")
prec = read_ncdf(prec_file, curvilinear = c("lon", "lat"))

# get the bb as sfc and then transform to a different crs
bb_native = st_bbox(prec) |> st_as_sfc()
bb_4326 = st_transform(bb_native, 4326)

# warp using one layer - success (with a warning)
sf_use_s2(FALSE)
warped = st_warp(slice(prec, 'time', 1), crs = bb_4326)

# try warping the entire multilayer object (fails)
sf_use_s2(FALSE)
warped = st_warp(prec, crs = bb_4326)

sessionInfo()
