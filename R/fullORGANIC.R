#' fullORGANIC
#'
#' Bundle function for mrorganic which bundles all relevant outputs and write
#' them to a tgz file.
#'
#' Use \code{regionmapping = "regionmappingGTAP11.csv")} to produce outputs
#' for GTAP11 world regions.
#'
#' @param rev data revision
#' @author Jan Philipp Dietrich
#' @seealso
#' \code{\link{retrieveData}}, \code{\link{calcOutput}}, \code{\link{readSource}},
#' \code{\link{setConfig}}
#' @examples
#' \dontrun{
#' retrieveData("Organic", rev = 2, regionmapping = "regionmappingGTAP11.csv")
#' }
#'
fullORGANIC <- function(rev) {

  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  if (rev != 2) stop("rev has to be set to 2! Other data revisions are currently not available!")

  # regional SOC output
  calcOutput("SOCbyLandType", file = "soc_region.cs2", round = 2)

  # country SOC output
  calcOutput("SOCbyLandType", aggregate = "country", file = "soc_country.cs2", round = 2)

  # gridded SOC output
  soc <- calcOutput("SOCbyLandType", aggregate = FALSE, supplementary = TRUE, file = "soc.nc")
  write.magpie(round(soc$x, 2), "soc.cs5")
  write.magpie(round(soc$weight, 2), "landcover.cs5")
  write.magpie(round(soc$weight, 2), "landcover.nc")
  plotMap(soc$x, name = "SOC", createPng = TRUE)

  landShares <- round(soc$weight, 8) / dimSums(soc$weight, dim = 3)
  getComment(landShares) <- "unit: 1"
  plotMap(landShares, name = "land cover share", createPng = TRUE)

  ecoregions <- calcOutput("Ecoregions2017Raster", nrows = 720, ncols = 1440, aggregate = FALSE)
  ecoregions <- ecoregions[, c("x", "y", "ECO_BIOME_")]

  regionmapping <- madrat::toolGetMapping(madrat::getConfig("regionmapping"), type = "regional")

  for (i in c("aboveground", "belowground")) {
    calcOutput("BiomassByLandType", subtype = i,
               file = paste0(i, "_biomass_region.cs2"), round = 2)
    calcOutput("BiomassByLandType", subtype = i, aggregate = "country",
               file = paste0(i, "_biomass_country.cs2"), round = 2)

    biomass <- calcOutput("BiomassByLandType", subtype = i, aggregate = FALSE, supplementary = TRUE)

    biomassWeight <- biomass$weight
    biomass <- biomass$x

    write.magpie(biomass, paste0(i, ".nc"))

    plotMap(biomass, name = paste0("biomass_", i), createPng = TRUE)

    # add columns "country_ECO_BIOME_" and "region_ECO_BIOME_"
    biomassWeight <- toolAddEcoregions(biomassWeight, ecoregions, regionmapping)
    biomass <- toolAddEcoregions(biomass, ecoregions, regionmapping)

    write.magpie(round(biomass, 2), paste0(i, ".cs5"))

    aggregatedCountryBiome <- toolAggregate(biomass, weight = biomassWeight, to = "country_ECO_BIOME_")
    magclass::write.magpie(round(aggregatedCountryBiome, 2), paste0(i, "_biomass_country_biome.cs5"))

    aggregatedRegionBiome <- toolAggregate(biomass, weight = biomassWeight, to = "region_ECO_BIOME_")
    magclass::write.magpie(round(aggregatedRegionBiome, 2), paste0(i, "_biomass_region_biome.cs5"))
  }
}
