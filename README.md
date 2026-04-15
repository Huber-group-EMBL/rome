

<!-- README.md is generated from README.qmd. Please edit that file -->

# rome

<!-- badges: start -->

<!-- badges: end -->

The goal of rome is to …

## Installation

You can install the development version of rome like so:

``` r
# install.packages("pak")
pak::pak("Huber-group-EMBL/rome")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(rome)
x <- ome_read(
  system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
)
#> Warning in group_attributes$ome: partial match of 'ome' to 'omero'
#> Warning in group_attributes$ome: partial match of 'ome' to 'omero'
plot(x, all = TRUE)
```

<img src="man/figures/README-example-1.png" style="width:100.0%" />
