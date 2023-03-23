#' toolAddEcoregions
#'
#' Enriches a magclass object with ecoregion and region information.
#'
#' @param x A magclass object
#' @param ecoregions Ecoregions dataframe, as returned by calcEcoregions2017Raster
#' @param regionmapping A regionmapping
#' @return x with additional ecoregion and region information. Spatial subdimensions:
#'         c("x", "y", "country", "region", "ECO_BIOME_", "country_ECO_BIOME_", "region_ECO_BIOME_")
#'
#' @author Pascal Führlich
#' @export
toolAddEcoregions <- function(x, ecoregions, regionmapping) {
  # apply mapping from coordinates to ecoregions
  x <- merge(x = magclass::as.data.frame(x, rev = 3),
             y = ecoregions,
             by = c("x", "y"),
             all.x = TRUE)

  # add region column
  stopifnot(ncol(regionmapping) %in% 2:3)
  if (ncol(regionmapping) == 3) {
    regionmapping <- regionmapping[, 2:3]
  }
  colnames(regionmapping) <- c("country", "region")
  x <- merge(x, regionmapping, by = "country", all.x = TRUE)

  # add combination dimensions for aggregation
  x$country_ECO_BIOME_ <- paste0(x$country, "_", x$ECO_BIOME_)
  x$region_ECO_BIOME_ <- paste0(x$region, "_", x$ECO_BIOME_)

  x <- x[, c("x", "y", "country", "region", "ECO_BIOME_",
             "country_ECO_BIOME_", "region_ECO_BIOME_",
             "data", ".value")]
  x$x <- sub("\\.", "p", x$x)
  x$y <- sub("\\.", "p", x$y)
  x <- magclass::as.magpie(x, tidy = TRUE, temporal = 0,
                           spatial = setdiff(colnames(x), c("data", ".value")))
  return(x)
}
