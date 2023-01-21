#' Read GSOCseq
#'
#' Read GSOCseq data
#'
#' @param subtype data set to use (currently available "ini" and "finalSSM1")
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- readSource("GSOCseq")
#' }
#' @seealso \code{\link{readSource}}

readGSOCseq <- function(subtype = "ini") {
  r <- terra::rast(Sys.glob("*.tif"))
  return(list(x = r, class = "SpatRaster"))
}
