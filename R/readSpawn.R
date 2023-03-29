#' Read Spawn
#'
#' Read Spawn data
#'
#' @param subtype Subtype to be read in. Available types are
#' "abovegroundBiomass", "abovegroundBiomassUncertainty",
#' "belowgroundBiomass" and "belowgroundBiomassUncertainty".
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("Spawn", "abovegroundBiomass")
#' }
#' @seealso \code{\link{readSource}}

readSpawn <- function(subtype) {
  f <- toolSubtypeSelect(subtype,
        c(abovegroundBiomass = "aboveground_biomass_carbon_2010.tif",
          abovegroundBiomassUncertainty = "aboveground_biomass_carbon_2010_uncertainty.tif",
          belowgroundBiomass = "belowground_biomass_carbon_2010.tif",
          belowgroundBiomassUncertainty = "belowground_biomass_carbon_2010_uncertainty.tif"))

  # scale by 0.1 as the data is based on the documentation scaled by that factor
  # in the GeoTIFF files
  r <- 0.1 * terra::rast(f)
  return(list(x = r, class = "SpatRaster"))
}
