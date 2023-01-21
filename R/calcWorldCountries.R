#' Calculate world countries
#'
#' Partition the world into countries with their respective ISO codes
#'
#' @return data
#'
#' @author Patrick v. Jeetze, Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("WorldCountries", aggregate = FALSE)
#' }
#' @seealso \code{\link{calcOutput}}

calcWorldCountries <- function() {
  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  gadmData <- readSource("GADM")

  # fill gaps with WorldBank data
  worldBankData <- readSource("WorldBankMaps", subtype = "CountryPolygons")
  missingCountries <- worldBankData[worldBankData$ISO_A3 %in% c("HKG", "MAC"), c("ISO_A3", "FORMAL_EN")]
  names(missingCountries) <- c("GID_0", "COUNTRY")
  out <- rbind(gadmData, missingCountries)

  names(out) <- c("ISO", "COUNTRY")

  return(list(x = out,
              description = "World country areas with all disputed areas mapped to a country",
              unit = "1",
              cache = FALSE,
              class = "SpatVector"))
}
