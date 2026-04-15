#' Validate a multiscale OME-Zarr file
#' 
#' @inheritParams ome_read
#' 
#' @returns 
#' This function is used for its side-effect and will return an error when 
#' passed an invalid OME-Zarr file
#' 
#' @export
ome_validate <- function(path, s3_client = NULL) {
  group_attributes <- Rarr::read_zarr_attributes(path, s3_client = s3_client)
  ome_version <- group_attributes$ome$version

  # We cannot download the schemas on the fly because we patch them to use local references 
  # as jsonvalidate doesn't support remote references
  # (https://github.com/ropensci/jsonvalidate/issues/70)
  schema <- system.file(
    "extdata",
    "schemas",
    ome_version,
    "image.schema",
    package = "rome"
  )

  jsonvalidate::json_validate(
    jsonlite::toJSON(group_attributes, auto_unbox = TRUE),
    schema,
    engine = "ajv",
    error = TRUE
  )
}