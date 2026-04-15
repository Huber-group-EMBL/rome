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
#' y <- x[3, 1:5, 1:5]
#' extract_levels(y, 2)
#' plot(y, level = 2)
#' 
`[.ome_zarr` <- function(x, i = NULL, j = NULL, ..., drop = FALSE) {
  x <- lapply(x, function(layer) {
    scale <- attr(layer, "scale")
    indices <- list(i, j, ...)
    indices <- mapply(
      function(idx, scaling_factor) {
        if (is.null(idx)) {
          return(NULL)
        }
        # FIXME: is this the most sensible way to round here?
        scaled_idx <- unique(ceiling((idx / scaling_factor)))
        return(scaled_idx)
      },
      indices,
      scale,
      SIMPLIFY = FALSE
    )
    do.call(`[`, c(list(layer), indices, list(drop = drop)))
  })
  class(x) <- "ome_zarr"
  return(x)
}