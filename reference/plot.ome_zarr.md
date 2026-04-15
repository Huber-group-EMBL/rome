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
x <- ome_read(
  system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
)
#> Error in read_schema(schema, v8): Schema '' looks like a filename but does not exist
plot(x)
#> Error: object 'x' not found
```
