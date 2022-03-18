library(brickman)
library(azmpcfin)
library(ncdf4)
bfile = brickman::compose_filename("PRESENT")
X <- ncdf4::nc_open(bfile)
pts = azmpcfin::read_calanus(form = "sf")
example <- brickman::extract_points(X = X, 
                                    vars = c("SST"), 
                                    pts = head(pts), 
                                    complete = TRUE,
                                    simplify_names = FALSE)
example