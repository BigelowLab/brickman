Brickman
================

Convenience tools for accessing Brickman Gulf of `Maine 2050` model
outputs.

> Cf: [Brickman D, Alexander MA, Pershing A, Scott JD, Wang Z.
> Projections of physical conditions in the Gulf of Maine in 2050. Elem
> Sci Anth. 2021 May
> 6;9(1):00055.](https://online.ucpress.edu/elementa/article/9/1/00055/116900/Projections-of-physical-conditions-in-the-Gulf-of)

Contents:

- PRESENT CLIMATE

- RCP45

  - year 2055
  - year 2075

- RCP85

  - year 2055
  - year 2075

Variables:

- Bathy_depth, land_mask
- Annual means: SST, MLD, SSS, Sbtm, Tbtm, U, V, Xbtm
- Monthly means: SST, MLD, SSS, Sbtm, Tbtm, U, V, Xbtm

### Requirements

- [R v4.1+](https://R-project.org)
- [rlang](https://CRAN.R-project.org/package=rlang)
- [dplyr](https://CRAN.R-project.org/package=dplyr)
- [ncdf4](https://CRAN.R-project.org/package=ncdf4)
- [stars](https://CRAN.R-project.org/package=stars)
- [sf](https://CRAN.R-project.org/package=sf)

### Installation

    remotes::install_github("BigelowLab/brickman")

### Usage

#### Reading and plotting

``` r
suppressPackageStartupMessages({
    library(stars)
    library(brickman)
    library(sf)
    library(dplyr)
  })

x <- brickman::read_brickman(scenario ='RCP85', year = 2055, vars = 'SST', interval = "mon")
plot(x)
```

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

#### Plotting a portion

You can display a portion of a curvilinear grid by specifying the
drawing extent. Note that by default R expands the plotting region. The
orange box shows the extent of the bounding box we used to define the
extent.

``` r
bb = c(xmin = -77, ymin = 36.5, xmax = -42.5, ymax = 56.7) |>
  st_bbox(crs = st_crs(x)) 
box = st_as_sfc(bb)  
plot(dplyr::slice(x, "month", 1), 
     main = "January SST anomaly", 
     extent = bb, 
     reset = FALSE,
     axes = TRUE)
plot(box, color = NA, border = "orange", add = TRUE)
```

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

### Subsetting/Cropping

Subsettng and cropping curvilinear grid is not supported by
[stars](https://CRAN.R-project.org/package=stars). But it does mask
regular grids, so transforming to a regular grid can help.

``` r
sf::sf_use_s2(FALSE)
box4326 = st_transform(box, 4326)
warped = st_warp(dplyr::slice(x, "month", 1), crs = box4326)
sub = warped[bb]
plot(sub, reset = FALSE, axes = TRUE)
plot(box4326, add = TRUE, color = NA, border = "orange")
```

![](README_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->
