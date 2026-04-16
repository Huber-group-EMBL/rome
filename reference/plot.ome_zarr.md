# Plot an `ome_zarr` object.

Plot an `ome_zarr` object.

## Usage

``` r
# S3 method for class 'ome_zarr'
plot(x, level = 1, ...)
```

## Arguments

- x:

  An `ome_zarr` object.

- level:

  Integer. The scale level to plot. Defaults to `1` (the highest
  resolution).

- ...:

  Additional arguments passed to
  [`plot()`](https://rdrr.io/r/graphics/plot.default.html).

## Examples

``` r
if (FALSE) { # \dontrun{
x <- ome_read(
  "https://uk1s3.embassy.ebi.ac.uk/idr/zarr/v0.4/idr0076A/10501752.zarr"
)
plot(x)
} # }
```
