Brickman
================

Convenience tools for accessing Brickman Gulf of `Maine 2050` model
outputs.

> Cf: [Brickman D, Alexander MA, Pershing A, Scott JD, Wang Z.
> Projections of physical conditions in the Gulf of Maine in 2050. Elem
> Sci Anth. 2021 May
> 6;9(1):00055.](https://online.ucpress.edu/elementa/article/9/1/00055/116900/Projections-of-physical-conditions-in-the-Gulf-of)

Contents:

-   PRESENT CLIMATE

-   RCP45

    -   year 2055
    -   year 2075

-   RCP85

    -   year 2055
    -   year 2075

Variables:

-   Bathy_depth, land_mask
-   Annual means: SST, MLD, SSS, Sbtm, Tbtm, U, V, Xbtm
-   Monthly means: SST, MLD, SSS, Sbtm, Tbtm, U, V, Xbtm

### Requirements

-   [R v4.1+](https://R-project.org)
-   [rlang](https://CRAN.R-project.org/package=rlang)
-   [dplyr](https://CRAN.R-project.org/package=dplyr)
-   [ncdf4](https://CRAN.R-project.org/package=ncdf4)
-   [stars](https://CRAN.R-project.org/package=stars)
-   [sf](https://CRAN.R-project.org/package=sf)

### Installation

    remotes::install_github("BigelowLab/brickman")

### Usage

``` r
suppressPackageStartupMessages({
    library(stars)
    library(brickman)
  })

x <- brickman::read_brickman(scenario ='RCP85', year = 2055, vars = 'SST', interval = "mon")
plot(x)
```

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->
