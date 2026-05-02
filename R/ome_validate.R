#' Validate a multiscale OME-Zarr file
#'
#' @inheritParams ome_read
#'
#' @returns
#' This function is used for its side-effect and will return the type of the 
#' OME-Zarr schema (image, label), otherwise will invoke an error when
#' passed an invalid OME-Zarr file
#'
#' @export
#'
#' @examples
#' \dontrun{
#' ome_validate(
#'   "https://uk1s3.embassy.ebi.ac.uk/idr/zarr/v0.4/idr0076A/10501752.zarr"
#' )
#' }
ome_validate <- function(path, s3_client = NULL) {
  group_attributes <- Rarr::read_zarr_attributes(path, s3_client = s3_client)

  # We cannot download the schemas on the fly because we patch them to use local references
  # as jsonvalidate doesn't support remote references
  # (https://github.com/ropensci/jsonvalidate/issues/70)
  
  if("spatialdata_attrs" %in% names(group_attributes)){
    if(!requireNamespace("SpatialData.validate"))
      stop("You have to install SpatialData.validate")
    SpatialData.validate::spdata_validate(path, type = "image")
    if("ome" %in% names(group_attributes)) 
      group_attributes <- group_attributes$ome
    type <- if("omero" %in% names(group_attributes)){
      "Image"
    } else {
      "Labels"
    }
  } else {
    
    # validate multiscale image/label
    tryCatch({
      .validate_schema(group_attributes, "image.schema")
    })
    
    # validate label
    type <- tryCatch({
      
      # check if "image-label" is present
      stopifnot(
        "image-label" %in% 
          names(
            if(is.null(ome <- group_attributes$ome)) 
              group_attributes else ome 
          )
      )
      
      # check labels.schema and validate if exists
      .validate_schema(group_attributes, "label.schema")
      
      "Labels"
    }, error = function(e) {
      "Image"
    }) 
  }
  
  type
}

.validate_schema <- function(attr, schema){
  schema <- tryCatch({
    system.file(
      "extdata",
      "schemas",
      .get_version(attr),
      schema,
      package = "rome", 
      mustWork = TRUE
    )
  }, error = function(e){
    NULL
  })
  if(!is.null(schema)){
    jsonvalidate::json_validate(
      jsonlite::toJSON(attr, auto_unbox = TRUE),
      schema,
      engine = "ajv",
      error = TRUE
    ) 
  }
}
