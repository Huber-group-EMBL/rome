#' Plot an `ome_zarr` object.
#' 
#' @param x An `ome_zarr` object.
#' @param level Integer. The scale level to plot. Defaults to `1` (the highest resolution).
#' @param ... Additional arguments passed to `plot()`. 
#' 
#' @export
#' 
#' @examples
#' x <- ome_read(
#'   system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
#' )
#' plot(x)
#' 
plot.ome_zarr <- function(x, level = 1, ...) {
  plot(EBImage::as.Image(aperm(x[[level]], c(2, 3, 1))), ...)
}