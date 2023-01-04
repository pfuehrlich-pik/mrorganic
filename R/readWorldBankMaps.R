#' readWorldBankMaps
#'
#' Read World Bank Maps
#'
#' @param subtype data set to use (currently available "CountryBoundaries" and "DisputedAreasBoundaries")
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("WorldBankMaps")
#' }
#' @seealso \code{\link{readSource}}

readWorldBankMaps <- function(subtype = "CountryBoundaries") {
  r <- terra::vect(Sys.glob("*/*.shp"))
  return(list(x = r, class = "SpatVector"))
}
