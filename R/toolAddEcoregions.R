#' toolAddEcoregions
#'
#' Enriches a magclass object with ecoregion and region information.
#'
#' @param x A magclass object
#' @param ecoregions Ecoregions dataframe, as returned by calcEcoregions2017Raster
#' @param regionmapping A regionmapping
#' @return x with additional ecoregion and region information. Spatial subdimensions:
#'         c("x", "y", "country", "region", "biome", "country_biome", "region_biome")
#'
#' @author Pascal Führlich
#' @export
toolAddEcoregions <- function(x, ecoregions, regionmapping) {
  # add ecoregions based on coordinates
  x <- merge(x = magclass::as.data.frame(x, rev = 3),
             y = ecoregions,
             by = c("x", "y"),
             all.x = TRUE)
  x$biome[is.na(x$biome)] <- "N/A"

  # make sure regionmapping has only 2 columns: country and region
  stopifnot(ncol(regionmapping) %in% 2:3)
  if (ncol(regionmapping) == 3) {
    regionmapping <- regionmapping[, 2:3]
  }
  colnames(regionmapping) <- c("country", "region")

  # add region column
  x$region <- stats::setNames(regionmapping$region, regionmapping$country)[x$country]

  # add combination dimensions for aggregation
  x$country_biome <- paste0(x$country, "_", x$biome)
  x$region_biome <- paste0(x$region, "_", x$biome)

  # prepare conversion to magclass object: reorder columns and change coordinate format
  x <- x[, c("x", "y", "country", "region", "biome",
             "country_biome", "region_biome",
             "data", ".value")]
  x$x <- sub("\\.", "p", x$x)
  x$y <- sub("\\.", "p", x$y)
  x <- magclass::as.magpie(x, tidy = TRUE, temporal = 0,
                           spatial = setdiff(colnames(x), c("data", ".value")))
  return(x)
}
