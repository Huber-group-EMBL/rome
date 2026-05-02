#' @keywords internal
.get_version <- function(attr) {
  if("spatialdata_attrs" %in% names(attr)){
    paste0(attr[["spatialdata_attrs"]], "-sd-raster")
  } else if (!is.null(ome <- attr$ome)) {
    ome$version
  } else {
    attr$multiscales[[1]]$version
  }
}
