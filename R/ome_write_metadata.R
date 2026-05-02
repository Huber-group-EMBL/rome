write_ome_metadata <- function(group, 
                               image,
                               name = "",
                               version = "0.4",
                               axes = NULL,
                               type,
                               channel_labels, 
                               downscaling_metadata = NULL,
                               omero = FALSE){
  
  # for now we only do version 0.4 due to Rarr only supporting v2
  # see https://ngff.openmicroscopy.org/0.4/index.html#multiscale-md
  
  meta <- list()
  ax <- "axes"
  ct <- "coordinateTransformations"
  ds <- "datasets"
  mt <- "metadata"
  v <- "version"
  n <- "name"

  # version
  meta[[v]] <-  version
  
  # name
  meta[[n]] <- name
  
  # axis
  axes <- .get_valid_axes(image, axes)
  meta[[ax]] <- .make_axes_meta(axes)
  
  # coordinate transformations
  meta[[ct]] <- .make_empty_ct(x, axes)
  
  # datasets 
  meta[[ds]] <- .make_datasets(x, axes)
  
  # type 
  meta[["type"]] <- "image"
  
  # metadata
  if(is.null(downscaling_metadata))
    meta[[mt]] <- downscaling_metadata
  
  # multiscales
  meta <- list(multiscales = list(meta))
  
  # omero 
  if(omero)
    meta <- c(meta, 
              list(
                omero = .make_omero_meta(x, axes)
                )
              )
  
  # update json list
  Rarr::write_zarr_attributes(zarr_path = group, 
                              new.zattrs = meta)
}

#' .get_valid_axes
#' 
#' Get validated axes
#'
#' @inheritParams write_image
#' 
#' @noRd
.get_valid_axes <- function(
    x,
    axes = NULL, 
    format = "0.4"
) {
  
  if (!is.null(format) && format %in% c("0.1", "0.2")) {
    if (!is.null(axes)) {
      message("axes ignored for version 0.1 or 0.2")
    }
    return(NULL)
  }
  
  # We can guess axes for images, labels, points/shapes
  ndim <- length(dim(x))
  if (is.null(axes)) {
    if (ndim == 2) {
      axes <- c("y", "x")
    } else {
      stop("axes must be provided. Can't be guessed beyond 2D image", 
           call. = FALSE)
    } 
  } else {
    if (length(axes) != ndim) {
      stop(
        sprintf("axes length (%d) must match number of dimensions (%d)", 
                length(axes), ndim),
        call. = FALSE
      )
    }
  }
  
  # axes may be string e.g. "tczyx"
  if (is.character(axes) && length(axes) == 1L) 
    axes <- strsplit(axes, "", fixed = TRUE)[[1]]
  
  if (!is.null(ndim) && length(axes) != ndim) {
    stop(
      sprintf("axes length (%d) must match number of dimensions (%d)", 
              length(axes), ndim),
      call. = FALSE
    )
  }
  
  axes
}

.make_axes_meta <- function(x){
  .DEFAULT_AXES[
    vapply(.DEFAULT_AXES, 
           \(.) .$name %in% x, 
           logical(1))
  ]
}

.make_datasets <- function(x, axes){
  paths <- paste0(seq_len(length(x)) - 1)
  mapply(\(p) {
    list(
      coordinateTransformations = list(
        list(
          scale = vapply(axes, \(.){
            if(. == "c"){
              1
            } else if(. =="t") {
              0.1 
            } else (2^as.numeric(p))
          }, numeric(1)),
          type = "scale" 
        )
      ), 
      path = p
    )
  }, paths, USE.NAMES = FALSE, SIMPLIFY = FALSE)
}

.make_empty_ct <- function(x, axes){
  list(
    list(
      scale = vapply(axes, \(.){
        if(. == "c"){
          1
        } else if(. =="t") {
          0.1 
        } else 1
      }, numeric(1)),
      type = "scale" 
    )
  )
}
