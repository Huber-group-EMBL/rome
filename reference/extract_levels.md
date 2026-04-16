# Extract specific levels from a multiscale `ome-zarr` object

Extract specific levels from a multiscale `ome-zarr` object

## Usage

``` r
extract_levels(x, levels)
```

## Arguments

- x:

  An `ome-zarr` object.

- levels:

  Integer vector specifying the levels to extract.

## Value

- If `levels` is of length 1, an array

- If `levels` is of length more than 1, an `ome-zarr` object

## Examples

``` r
if (FALSE) { # \dontrun{
x <- ome_read(
  "https://uk1s3.embassy.ebi.ac.uk/idr/zarr/v0.4/idr0076A/10501752.zarr"
)
extract_levels(x, c(1, 3))
extract_levels(x, 2)
} # }
```
