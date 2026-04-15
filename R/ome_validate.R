#' @export
ome_validate <- function(path, s3_client = NULL) {
  group_attributes <- Rarr::read_zarr_attributes(path, s3_client = s3_client)
  ome_version <- group_attributes$ome$version

  cache_folder <- tools::R_user_dir("rome", which = "cache")
  schema <- file.path(
    cache_folder,
    "ome-schemas",
    ome_version,
    "image.schema"
  )
  if (!file.exists(schema)) {
    if (!dir.exists(dirname(schema))) {
      dir.create(dirname(schema), recursive = TRUE)
    }
    download.file(
      url = paste0(
        "https://ngff.openmicroscopy.org/",
        ome_version,
        "/schemas/image.schema"
      ),
      destfile = schema
    )
  }

  jsonvalidate::json_validate(
    jsonlite::toJSON(group_attributes, auto_unbox = TRUE),
    schema,
    engine = "ajv",
    error = TRUE
  )
}