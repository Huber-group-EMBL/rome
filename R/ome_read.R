#' @examples 
#' ome_read(
#'   system.file("extdata", "ome-v0.2", "6001247.zarr", package = "rome")
#' )
#' 
#' ome_read(
#'  system.file("extdata", "ome-v0.3", "9528933.zarr", package = "rome")
#' )
#' 
#' x <- ome_read(
#'   system.file("extdata", "ome-v0.4", "10501752.zarr", package = "rome")
#' )

ome_read <- function(path, s3_client = NULL, validate = TRUE) {

  # FIXME: check we're in a group
  if (validate) {
    ome_validate(path, s3_client = s3_client)
  }
  
  group_attributes <- Rarr::read_zarr_attributes(path, s3_client = s3_client)
  ome_version <- group_attributes$ome$version
  scales <- get_scales(group_attributes, ome_version)

  x <- lapply(scales$datasets, function(scale) {
    read_zarr_array(file.path(path, scale$path), s3_client = s3_client)
  })

  class(x) <- "ome_zarr"

  return(x)
}