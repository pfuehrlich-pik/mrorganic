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

  # regional SOC output
  calcOutput("SOCbyLandType", file = "soc_region.cs2")

  # country SOC output
  calcOutput("SOCbyLandType", aggregate = "country", file = "soc_region.cs2")

  # gridded SOC output
  calcOutput("SOCbyLandType", aggregate = FALSE, file = "soc.nc")

}
