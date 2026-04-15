download_consolidate_schemas <- function(ome_version, path) {
  # Download root schema
  url <- sprintf("https://ngff.openmicroscopy.org/%s/schemas/image.schema", ome_version)
  dest <- file.path(path, ome_version, "image.schema")
  if (!dir.exists(dirname(dest))) {
    dir.create(dirname(dest), recursive = TRUE)
  }
  download.file(url, dest)

  # Fetch references and transform them to local references as jsonvalidate
  # doesn't support remote references (https://github.com/ropensci/jsonvalidate/issues/70)
  schema <- jsonlite::read_json(dest)
  flat_schema <- unlist(schema, recursive = TRUE)
  purrr::imap(flat_schema, function(value, name) {
    if (endsWith(name, "$ref") && is.character(value) && grepl("^https://ngff.openmicroscopy.org/.+/schemas/.+\\.schema$", value)) {
      ref_url <- value
      ref_name <- basename(ref_url)
      ref_dest <- file.path(path, ome_version, ref_name)
      download.file(ref_url, ref_dest)
      flat_schema[[name]] <<- ref_name
    }
  })
  relist(flat_schema, schema) |> 
    jsonlite::write_json(dest, auto_unbox = TRUE, pretty = TRUE)
}

for (v in c("0.3", "0.4", "0.5")) {
  download_consolidate_schemas(v, "inst/extdata/schemas")
}
