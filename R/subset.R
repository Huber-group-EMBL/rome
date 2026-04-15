#' Subset an OME-Zarr object
#' 
#' Subset operation is applied on all levels of the multiscale OME-Zarr object. 
#' The result is an OME-Zarr object with the same number of levels,
#' but each level is subsetted according to the provided indices.
#' 
#' The first image is subsetted using the provided indices, and the 
#' resulting dimensions are used to subset the remaining levels, while
#' conserving the same scaling factor across levels
#' 
#' @inheritParams base::Extract
#' @param x An OME-Zarr object.
#' 
#' @export
#' 
#' @examples
#' x <- ome_read(
#'   system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
#' )
#' x[1, 1:5, 1:5]
#' 
`[.ome_zarr` <- function(x, i, j, ..., drop = TRUE) {
  x <- lapply(x, function(scale) {
    scale[i, j, ..., drop = drop]
  })
  class(x) <- "ome_zarr"
  return(x)
}