library(EBImage)
img_file <- system.file("images", "sample.png", package="EBImage")
img <- readImage(img_file)

test_that("version", {
  
  # no support for 0.1, 0.2 and 0.3
  lapply(c("0.1", "0.2", "0.3"), \(.) {
    expect_error(
      ome_img <- ome_write(img,
                           path = tempfile(fileext = ".ome.zarr"),
                           version = .,
                           storage_options = list(chunk_dim = c(64,64))) 
    )
  })
})

test_that("writing", {
  
  lapply(c("0.4", "0.5"), \(.) {
    ome_img <- ome_write(img,
                         path = tempfile(fileext = ".ome.zarr"),
                         version = .,
                         scalefactors = c(2,2,2),
                         storage_options = list(chunk_dim = c(64,64)))
    
    # length(scalefactors) + 1 is the number of scales
    expect_equal(length(ome_img), 4)
    
    # first scale is the original scale
    expect_equal(dim(ome_img[[1]]), dim(img))
    
    # TODO: for now, chunk_dim has to be specified:
    expect_error(
      ome_img <- ome_write(img,
                           path = tempfile(fileext = ".ome.zarr"),
                           version = .)
    )
    
    # scales have to be non-negative, non-zero and MUST have incremental 
    # values
    # NOTE: incremental scales are not dictated by NGFF but the specification
    # says it has to be ordered from largest to lowest
    # See:
    #   https://ngff.openmicroscopy.org/specifications/0.4/index.html#multiscales-metadata
    #   https://ngff.openmicroscopy.org/specifications/0.5/index.html#multiscales-metadata
    expect_error(.check_scalefactors(c(2,0.1,2)))
    expect_error(.check_scalefactors(c(2,NA,2)))
    expect_error(.check_scalefactors(c(2,-1,2)))
    expect_error(.check_scalefactors(c()))
    expect_error(.check_scalefactors(NULL))
  })
  
})
