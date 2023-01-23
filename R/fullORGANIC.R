#' fullORGANIC
#'
#' Bundle function for mrorganic which bundles all relevant outputs and write
#' them to a tgz file.
#'
#' Use \code{regionmapping = "regionmappingGTAP11.csv")} to produce outputs
#' for GTAP11 world regions.
#' @author Jan Philipp Dietrich
#' @seealso
#' \code{\link{readSource}},\code{\link{getCalculations}},\code{\link{calcOutput}},\code{\link{setConfig}}
#' @examples
#' \dontrun{
#' retrieveData("Organic", regionmapping = "regionmappingGTAP11.csv")
#' }
#'
fullORGANIC <- function() {

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
  soc <- calcOutput("SOCbyLandType", aggregate = FALSE, file = "soc.nc")
  .plotMap(soc)

}
