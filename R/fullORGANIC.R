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

  biomeRaster <- calcOutput("Ecoregions2017Raster", ecoregionsColumn = "ECO_BIOME_", aggregate = FALSE)

  for (i in c("aboveground", "belowground")) {
    calcOutput("BiomassByLandType", subtype = i,
               file = paste0(i, "_biomass_region.cs2"), round = 2)
    calcOutput("BiomassByLandType", subtype = i, aggregate = "country",
               file = paste0(i, "_biomass_country.cs2"), round = 2)
    biomass <- calcOutput("BiomassByLandType", subtype = i, aggregate = FALSE, supplementary = TRUE)
    biomassWeight <- biomass$weight
    biomass <- biomass$x
    write.magpie(biomass, paste0(i, ".nc"))
    write.magpie(round(biomass, 2), paste0(i, ".cs5"))
    plotMap(biomass, name = paste0("biomass_", i), createPng = TRUE)

    # TODO paste0(i, "_biomass_biome_country.cs2") use toolAggregate
    # add regional column
    biomass <- magclass::add_dimension(bimoass, 1.4, "biome_country")
    magclass::getItems(biomass, dim = 1.3, full = TRUE) <- 
    a <- toolAggregate(biomass, to = "biome_country", dim = 1)

    # TODO paste0(i, "_biomass_biome_region.cs2")
    regionmapping <- getConfig("regionMapping")
  }
}
