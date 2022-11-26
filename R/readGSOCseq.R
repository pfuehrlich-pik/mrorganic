#' Read GSOCseq
#'
#' Read GSOCseq data
#'
#' @param subtype Type
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("GSOCseq")
#' }
#' @seealso \code{\link{readSource}}
#' @importFrom raster raster

readGSOCseq <- function(subtype="paper") {
  r <- raster(Sys.glob("*.tif"))
  x <- as.magpie(0)
  attr(x, "object") <- r
  return(x)
}
