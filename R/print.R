#' @importFrom utils head
#' @export
print.ome_zarr <- function(x, level = 1, ...) {
  cat("Multiscale OME-Zarr object.\n")
  cat(sprintf("Scale: %d/%d", level, length(x)), "\n")
  print(head(x[[level]], rep_len(5, length(dim(x[[level]]))), ...))
}