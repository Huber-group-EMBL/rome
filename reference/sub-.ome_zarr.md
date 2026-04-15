# Subset an OME-Zarr object

Subset operation is applied on all levels of the multiscale OME-Zarr
object. The result is an OME-Zarr object with the same number of levels,
but each level is subsetted according to the provided indices.

## Usage

``` r
# S3 method for class 'ome_zarr'
x[...]
```

## Arguments

- x:

  An OME-Zarr object.

- ...:

  Indices to subset the OME-Zarr object.

## Details

The first image is subsetted using the provided indices, and the
resulting dimensions are used to subset the remaining levels, while
conserving the same scaling factor across levels

## Examples

``` r
x <- ome_read(
  system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
)
#> Error in read_schema(schema, v8): Schema '' looks like a filename but does not exist
y <- x[3, 1:5, 1:5]
#> Error: object 'x' not found
extract_levels(y, 2)
#> Error: object 'y' not found
plot(y, level = 2)
#> Error: object 'y' not found
```
