#' @keywords internal
.get_version <- function(attr) {
  if (!is.null(ome <- attr$ome)) {
    ome$version
  } else {
    attr$multiscales[[1]]$version
  }
}
