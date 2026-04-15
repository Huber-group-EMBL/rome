# Extract specific levels from a multiscale OME-Zarr object

Extract specific levels from a multiscale OME-Zarr object

## Usage

``` r
extract_levels(x, levels)
```

## Arguments

- x:

  An OME-Zarr object.

- levels:

  Integer vector specifying the levels to extract.

## Value

- If `levels` is of length 1, an array

- If `levels` is of length more than 1, an OME-Zarr object

## Examples

``` r
x <- ome_read(
 system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
)
#> Error in read_schema(schema, v8): Schema '' looks like a filename but does not exist
extract_levels(x, c(1, 3))
#> Error: object 'x' not found
extract_levels(x, 2)
#> Error: object 'x' not found
```
