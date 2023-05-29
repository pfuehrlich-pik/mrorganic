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
#' retrieveData("Organic", rev = 2.1, regionmapping = "regionmappingGTAP11.csv")
#' }
#'
fullORGANIC <- function(rev) {
  if (rev != 2.1) stop("rev has to be set to 2.1! Please use older package versions to generate older data revisions!")

  # regional SOC output
  calcOutput("SOCbyLandType", file = "soc_region.cs2", round = 2)

  # country SOC output
  calcOutput("SOCbyLandType", aggregate = "country", file = "soc_country.cs2", round = 2)

  # gridded SOC output
  soc <- calcOutput("SOCbyLandType", aggregate = FALSE, supplementary = TRUE, file = "soc.nc")
  write.magpie(round(soc$x, 2), "soc.cs5")
  write.magpie(round(soc$weight, 2), "landcover_area_soc.cs5")
  write.magpie(soc$weight, "landcover_area_soc.nc")
  plotMap(soc$x, name = "SOC", range = c(0, 400), createPng = TRUE)

  landSharesSOC <- round(soc$weight, 8) / dimSums(soc$weight, dim = 3)
  getComment(landSharesSOC) <- "unit: 1"
  plotMap(landSharesSOC, name = "landcover share SOC", createPng = TRUE)

  ecoregions <- calcOutput("Ecoregions2017Raster", nrows = 720, ncols = 1440, aggregate = FALSE)
  ecoregions <- ecoregions[, c("x", "y", "BIOME_NAME")]
  colnames(ecoregions)[3] <- "biome"

  regionmapping <- madrat::toolGetMapping(madrat::getConfig("regionmapping"), type = "regional")

  for (i in c("aboveground", "belowground")) {
    calcOutput("BiomassByLandType", subtype = i,
               file = paste0(i, "_biomass_region.cs2"), round = 2)
    calcOutput("BiomassByLandType", subtype = i, aggregate = "country",
               file = paste0(i, "_biomass_country.cs2"), round = 2)

    biomass <- calcOutput("BiomassByLandType", subtype = i, aggregate = FALSE, supplementary = TRUE)

    biomassLandAreas <- biomass$weight
    write.magpie(biomassLandAreas, paste0(i, "_biomass_landcover_area.nc"))

    getComment(biomass$x) <- paste("unit:", biomass$unit)
    biomass <- biomass$x
    write.magpie(biomass, paste0(i, "_biomass.nc"))

    plotMap(biomass, name = paste0(i, " biomass"), createPng = TRUE)

    biomass <- toolAddEcoregions(biomass, ecoregions, regionmapping)
    write.magpie(round(biomass, 2), paste0(i, "_biomass.cs5"))

    biomassLandAreas <- toolAddEcoregions(biomassLandAreas, ecoregions, regionmapping)
    getComment(biomassLandAreas) <- "unit: ha"
    write.magpie(round(biomassLandAreas, 2), paste0(i, "_biomass_landcover_area.cs5"))

    landSharesBiomass <- round(biomassLandAreas, 8) / dimSums(biomassLandAreas, dim = 3)
    getComment(landSharesBiomass) <- "unit: 1"
    plotMap(landSharesBiomass, name = paste("landcover share", i, "biomass"), createPng = TRUE)

    aggregatedCountryBiome <- toolAggregate(biomass, weight = biomassLandAreas, to = "country_biome")
    aggregatedCountryBiome <- setItems(aggregatedCountryBiome, "country_biome",
                                       sub("_", ".", getItems(aggregatedCountryBiome, "country_biome")),
                                       raw = TRUE)
    names(dimnames(aggregatedCountryBiome))[1] <- "country.biome"
    write.magpie(round(aggregatedCountryBiome, 2), paste0(i, "_biomass_country_biome.cs5"))

    aggregatedRegionBiome <- toolAggregate(biomass, weight = biomassLandAreas, to = "region_biome")
    aggregatedRegionBiome <- setItems(aggregatedRegionBiome, "region_biome",
                                      sub("_", ".", getItems(aggregatedRegionBiome, "region_biome")),
                                      raw = TRUE)
    names(dimnames(aggregatedRegionBiome))[1] <- "region.biome"
    write.magpie(round(aggregatedRegionBiome, 2), paste0(i, "_biomass_region_biome.cs5"))
  }
}
