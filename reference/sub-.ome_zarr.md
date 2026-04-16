# Subset an `ome-zarr` object

Subset operation is applied on all levels of the multiscale `ome-zarr`
object. The result is an `ome-zarr` object with the same number of
levels, but each level is subsetted according to the provided indices.

## Usage

``` r
# S3 method for class 'ome_zarr'
x[...]
```

## Arguments

- x:

  An `ome-zarr` object.

- ...:

  Indices to subset the `ome-zarr` object.

## Details

The first image is subsetted using the provided indices, and the
resulting dimensions are used to subset the remaining levels, while
conserving the same scaling factor across levels

## Examples

``` r
if (FALSE) { # \dontrun{
x <- ome_read(
  "https://uk1s3.embassy.ebi.ac.uk/idr/zarr/v0.4/idr0076A/10501752.zarr"
)
y <- x[3, 1:5, 1:5]
extract_levels(y, 2)
plot(y, level = 2)
} # }
```
