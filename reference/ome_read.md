# Read a multiscale OME-Zarr file

Read a multiscale OME-Zarr file

## Usage

``` r
ome_read(path, s3_client = NULL, lazy = FALSE, validate = TRUE)
```

## Arguments

- path:

  Path to the OME-Zarr file.

- s3_client:

  Object created by
  [`paws.storage::s3()`](https://paws-r.r-universe.dev/paws.storage/reference/s3.html).
  Only required for a file on S3. Leave as `NULL` for a file on local
  storage.

- lazy:

  Logical. If `TRUE` (the default), use ZarrArray to read data lazily.
  If `FALSE`, read data into memory using Rarr. If the data can fit into
  memory, setting `lazy = FALSE` may result in better performance.

- validate:

  Logical.If `TRUE` (the default), validate the OME-Zarr file.

## Examples

``` r
if (FALSE) { # \dontrun{
x <- ome_read(
  "https://uk1s3.embassy.ebi.ac.uk/idr/zarr/v0.4/idr0076A/10501752.zarr"
)
} # }
```
