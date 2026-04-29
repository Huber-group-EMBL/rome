library(utils)

test_that("parse ome version", {
  format <- c("0.1" = "v01", 
              "0.2" = "v02", 
              "0.3" = "v03", 
              "0.4" = "v04", 
              "0.5" = "v05")
  for(i in seq_len(length(format))) {
    omezarrzip <- system.file("extdata", 
                              paste0("test_ngff_image_", 
                                     format[i],
                                     ".ome.zarr.zip"), 
                              package = "rome")
    dir.create(td <- tempfile())
    unzip(omezarrzip, exdir = td)
    print(.get_version(Rarr::read_zarr_attributes(td)))
    expect_equal(
      .get_version(Rarr::read_zarr_attributes(td)),
      names(format)[i]
    )
  }
})
