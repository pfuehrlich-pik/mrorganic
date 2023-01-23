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

  gadmDataRaw <- readSource("GADM")
  disputedAreaCountries <- gadmDataRaw$COUNTRY[!gadmDataRaw$GID_0 %in% madrat::getISOlist()]
  # aggregate by COUNTRY to deal with disputed areas
  aggregatedCountries <- terra::aggregate(gadmDataRaw[gadmDataRaw$COUNTRY %in% disputedAreaCountries],
                                          by = "COUNTRY")
  aggregatedCountries$GID_0 <- madrat::toolCountry2isocode(aggregatedCountries$COUNTRY)
  aggregatedCountries <- aggregatedCountries[, c("GID_0", "COUNTRY")]
  gadmData <- rbind(gadmDataRaw[!gadmDataRaw$COUNTRY %in% disputedAreaCountries],
                    aggregatedCountries)

  # fill gaps with WorldBank data
  worldBankData <- readSource("WorldBankMaps", subtype = "CountryPolygons")
  missingCountries <- worldBankData[worldBankData$ISO_A3 %in% c("HKG", "MAC"), c("ISO_A3", "FORMAL_EN")]
  names(missingCountries) <- c("GID_0", "COUNTRY")
  out <- rbind(gadmData, missingCountries)

  names(out) <- c("ISO", "COUNTRY")

  if (!setequal(out$ISO, madrat::getISOlist())) {
    warning("calcWorldCountries ISO codes are not setequal to madrat::getISOlist")
  }
  return(list(x = out,
              description = "World country areas with all disputed areas mapped to a country",
              unit = "1",
              cache = FALSE,
              class = "SpatVector"))
}
