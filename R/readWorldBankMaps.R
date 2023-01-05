#' readWorldBankMaps
#'
#' Read World Bank Maps
#'
#' @param subtype data set to use (currently available "CountryPolygons",
#' "CountryBoundaries" "DisputedAreas" and "DisputedAreasBoundaries")
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("WorldBankMaps")
#' }
#' @seealso \code{\link{readSource}}

readWorldBankMaps <- function(subtype = "CountryPolygons") {
  r <- terra::vect(Sys.glob("*/*.shp"))
  return(list(x = r, class = "SpatVector", cache = FALSE))
}
