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
  purrr::modify_tree(
    schema,
    leaf = function(x) {
      if (is.character(x) && grepl("^https://ngff.openmicroscopy.org/.+/schemas/.+\\.schema$", x)) {
        download.file(x, file.path(path, ome_version, basename(x)))
        return(basename(x))
      } else {
        return(x)
      }
    }
  ) |> 
    jsonlite::write_json(dest, auto_unbox = TRUE, pretty = TRUE)
}

for (v in c("0.3", "0.4", "0.5")) {
  download_consolidate_schemas(v, "inst/extdata/schemas")
}
