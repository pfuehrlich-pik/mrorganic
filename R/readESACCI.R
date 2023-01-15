#' Read ESACCI
#'
#' Read ESACCI data
#'
#' @param subtype Subtype to be read in
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("ESACCI")
#' }
#' @seealso \code{\link{readSource}}

readESACCI <- function(subtype = "landcover2010") {
  r <- terra::rast(Sys.glob("*.tif"))
  return(list(x = r, class = "SpatRaster"))
}
