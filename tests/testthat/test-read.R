library(utils)
library(withr)

# TODO: v0.2 throws the following error:
# Error in read_schema_dependencies(schema, children, c(file_path, parent),  : 
#   Don't yet support protocol-based sub schemas
# yes, remote schemas we cannot use ... should we have local copys of all ?
format <- c(
  "0.1" = "v01",
  # "0.2" = "v02",
  "0.3" = "v03",
  "0.4" = "v04",
  "0.5" = "v05"
)

test_that("parse ome version", {
  for (i in seq_len(length(format))) {
    omezarrzip <- system.file(
      "extdata",
      paste0("test_ngff_image_", format[i], ".ome.zarr.zip"),
      package = "rome"
    )
    td <- withr::local_tempfile()
    unzip(omezarrzip, exdir = td)
    
    # image
    x <- ome_read(td)
    # TODO: why S3 ? 
    expect_s3_class(x, "ome_zarr")
    expect_equal(attr(x, "type"), "image")
    
    # labels, version 0.1 and 0.3 do not have label.schema
    if(format[i] %in% c("0.1", "0.3")){
      x <- ome_read(file.path(td, "labels/blobs"))
      # TODO: why S3 ? 
      expect_s3_class(x, "ome_zarr")
      expect_equal(attr(x, "type"), "label")
    }
  }
})
