#' Calculate SOC by land type
#'
#' Estimate soil organic carbon content split by land type
#'
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("LandTypeAreas")
#' }
#' @seealso \code{\link{calcOutput}}

calcSOCbyLandType <- function() {
  l <- calcOutput("LandTypeAreas", aggregate = FALSE)
  lAgg <- terra::aggregate(l, fact=3, fun="sum")
  lAgg25 <- terra::aggregate(lAgg, fact=30, fun="sum")
  soc <- readSource("GSOCseq", subtype="ini", convert=FALSE)
  soc <- terra::project(soc,lAgg)
  soc25 <- terra::aggregate(soc*lAgg, fact = 30, fun = "sum")/lAgg25
  return(list(x = as.magpie(soc25), weight = as.magpie(lAgg25)))
}
