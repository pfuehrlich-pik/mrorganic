#' Read GSOCseq
#'
#' Read GSOCseq data
#'
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("GSOCseq")
#' }
#' @seealso \code{\link{readSource}}
#' @importFrom terra rast

readGSOCseq <- function() {
  r <- terra::rast(Sys.glob("*.tif"))
  x <- as.magpie(0)
  attr(x, "object") <- r
  return(x)
}
