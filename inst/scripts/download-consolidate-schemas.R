download_consolidate_schemas <- function(ome_version, type, link, path) {

    # Download root schema
  schema_file <- paste0(type, ".schema")
  url <- sprintf(
    paste0(
      "https://ngff.openmicroscopy.org/%s/schemas/", schema_file
    ),
    ome_version
  )
  dest <- file.path(path, ome_version, schema_file)
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
      if (
        is.character(x) &&
        grepl("^https://ngff.openmicroscopy.org/.+/schemas/.+\\.schema$", x)
      ) {
        if(!is.na(link))
          x <- file.path(link, basename(x))
        download.file(x, file.path(path, ome_version, basename(x)))
        return(basename(x))
      } else {
        return(x)
      }
    }
  ) |>
    jsonlite::write_json(dest, auto_unbox = TRUE, pretty = TRUE)
}


# OME v0.2 fails to download from
# https://ngff.openmicroscopy.org/0.6.dev2/schemas/*.schema
# Check: https://github.com/ome/ngff/tree/main/specifications and 
# https://github.com/ome/ngff-spec/tree/c95fc4ad8b4b3fe946125375397ebb08dfd995e8
link02 <- "https://raw.githubusercontent.com/ome/ngff-spec/c95fc4ad8b4b3fe946125375397ebb08dfd995e8/schemas/"

# schema config, some version do not have labels
config <- list(
  c(version = "0.1", type = "image"),
  c(version = "0.2", type = "image", link = link02),
  c(version = "0.2", type = "label", link = link02),
  c(version = "0.3", type = "image"),
  c(version = "0.4", type = "image"),
  c(version = "0.4", type = "label"),
  c(version = "0.5", type = "image"),
  c(version = "0.5", type = "label")
)

invisible(
  lapply(config, function(cg){
    download_consolidate_schemas(ome_version = cg["version"], 
                                 type = cg["type"], 
                                 link = cg["link"],
                                 "inst/extdata/schemas")
  }) 
)
