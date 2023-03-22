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

    addEcoregions <- function(b) {
      # apply mapping from coordinates to ecoregions
      b <- merge(x = magclass::as.data.frame(b, rev = 3),
                 y = ecoregions,
                 by = c("x", "y"),
                 all.x = TRUE)

      # add region column
      # TODO how do we know structure of regionmapping dataframe? this works for regionmappingGTAP11.csv, but not h12
      # regionmapping <- madrat::toolGetMapping(madrat::getConfig("regionmapping"))
      # regiob <- merge(b, regionmapping, by = "country", all.x = TRUE)

      # add combination dimensions for aggregation
      b$country_ECO_BIOME_ <- paste(b$country, b$ECO_BIOME_, sep = "_")
      # b$region_ECO_BIOME_ <- paste(b$region, b$ECO_BIOME_, sep = "_")

      # b <- b[, c("x", "y", "country", "region", "ECO_BIOME_",
      #            "country_ECO_BIOME_", "region_ECO_BIOME_",
      #            "data", ".value")]
      b <- b[, c("x", "y", "country", "ECO_BIOME_",
                 "country_ECO_BIOME_",
                 "data", ".value")]

      b$x <- sub("\\.", "p", b$x)
      b$y <- sub("\\.", "p", b$y)
      b <- magclass::as.magpie(b, tidy = TRUE, temporal = 0,
                               spatial = setdiff(colnames(b), c("data", ".value")))
      return(b)
    }

    biomass <- addEcoregions(biomass)
    biomassWeight <- addEcoregions(biomassWeight)

    magclass::write.magpie(toolAggregate(biomass, weight = biomassWeight, to = "country_ECO_BIOME_"),
                           paste0(i, "_biomass_country_ECO_BIOME_.cs2"))
    #magclass::write.magpie(toolAggregate(biomass, weight = biomassWeight, to = "region_ECO_BIOME_"),
    #                       paste0(i, "_biomass_region_ECO_BIOME_.cs2"))
  }
}
