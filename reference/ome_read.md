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
ome_read(
  system.file("extdata", "ome-v0.2", "6001247.zarr", package = "rome"),
  validate = FALSE
)
#> Error in switch(ome_version, `0.1` = , `0.2` = , `0.3` = , `0.4` = metadata$multiscales,     `0.5` = metadata$ome$multiscales, stop("Unsupported OME version: ",         ome_version)): EXPR must be a length 1 vector

ome_read(
 system.file("extdata", "ome-v0.3", "9528933.zarr", package = "rome")
)
#> Error in read_schema(schema, v8): Schema '' looks like a filename but does not exist

x <- ome_read(
  system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
)
#> Error in read_schema(schema, v8): Schema '' looks like a filename but does not exist
```
