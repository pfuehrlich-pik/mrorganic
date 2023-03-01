#' Calculate Biomass by land type
#'
#' Estimate soil organic carbon content split by land type
#'
#' @param subtype "aboveground" or "belowground"
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("SOCbyLandType")
#' }
#' @seealso \code{\link{calcOutput}}

calcBiomassByLandType <- function(subtype) {

  name <- subtype

  subtype <- toolSubtypeSelect(subtype, c(aboveground = "abovegroundBiomass",
                                          belowground = "belowgroundBiomass"))

  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  message("Please be patient, this will take now a while.")

  # read in biomass data
  biomass <- readSource("Spawn", subtype = subtype, convert = FALSE)
  weight  <- calcOutput("LandTypeAreas", aggregate = FALSE) + 10^-10
  message("Relevant data read in.")

  out <- toolAggregateByLandType(biomass, weight)

  return(list(x = out$x,
              weight = out$weight,
              description = paste("Average", name, "biomass content by land type"),
              unit = "Mg C ha-1",
              min = 0,
              structure.spatial = "-?[0-9]*p[0-9]*\\.-?[0-9]*p[0-9]*\\.[A-Z]{3}",
              structure.data = "(cropland|grassland|other)",
              isocountries = FALSE))
}
