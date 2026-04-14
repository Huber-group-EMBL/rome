#' @export
plot.ome_zarr <- function(x, level = 1, ...) {
  plot(EBImage::as.Image(aperm(x[[level]], c(2, 3, 1))), ...)
}