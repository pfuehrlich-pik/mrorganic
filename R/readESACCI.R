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
#' @importFrom terra rast

readESACCI <- function(subtype = "landcover2010") {
  r <- terra::rast(Sys.glob("*.tif"))
  x <- as.magpie(0)
  attr(x, "object") <- r
  return(x)
}
