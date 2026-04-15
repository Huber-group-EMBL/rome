#' @keywords internal
.get_dim_names <- function(metadata, ome_version) {
  dim_names <- switch(
    ome_version,
    "0.1" = NULL,
    "0.2" = NULL,
    "0.3" = metadata$ome$multiscales[[1]]$axes,
    "0.4" = metadata$ome$multiscales[[1]]$axes |> vapply(function(axis) axis$name),
    "0.5" = metadata$ome$multiscales[[1]]$axes |> vapply(function(axis) axis$name),
    stop("Unsupported OME version: ", ome_version)
  )
  return(dim_names)
}