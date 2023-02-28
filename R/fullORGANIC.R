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

  if (rev != 2) stop("rev has to be set to 1! Other data revisions are currently not available!")

  .plotMap <- function(x) {
    for (i in getItems(x, dim = 3)) {
      grDevices::png(paste0(i, ".png"), width = 800, height = 400)
      terra::plot(as.SpatRaster(x[, , i]))
      grDevices::dev.off()
    }
  }

  # regional SOC output
  calcOutput("SOCbyLandType", file = "soc_region.cs2", round = 2)

  # country SOC output
  calcOutput("SOCbyLandType", aggregate = "country", file = "soc_country.cs2", round = 2)

  # gridded SOC output
  soc <- calcOutput("SOCbyLandType", aggregate = FALSE, supplementary = TRUE, file = "soc.nc")
  write.magpie(round(soc$x, 2), "soc.cs5")
  write.magpie(round(soc$weight, 2), "landcover.cs5")
  write.magpie(round(soc$weight, 2), "landcover.nc")
  .plotMap(soc$x)

  for (i in c("aboveground", "belowground")) {
    calcOutput("BiomassByLandType", subtype = i,
               file = paste0(i, "_biomass_region.cs2"), round = 2)
    calcOutput("BiomassByLandType", subtype = i, aggregate = "country",
               file = paste0(i, "_biomass_country.cs2"), round = 2)
    biomass <- calcOutput("BiomassByLandType", subtype = i, aggregate = FALSE,
                          file = paste0(i, ".nc"))
    write.magpie(round(biomass, 2), paste0(i, ".cs5"))
    .plotMap(biomass)
  }
}
