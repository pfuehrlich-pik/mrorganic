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

  country  <- readSource("WorldBankMaps", subtype = "CountryPolygons")
  disputed <- readSource("WorldBankMaps", subtype = "DisputedAreas")

  # replace missing ISO codes
  map <- c("21" = "FRA",
           "51" = "NOR",
           "63"  = "XKS",
           "130" = "GTMO",
           "233" = "FRA",
           "239" = "AUS",
           "240" = "AUS")
  for (i in names(map)) {
    country$ISO_A3[as.integer(i)] <- map[i]
  }

  mapDisputed <- c("CHN", "IND", "MAR", "SDN", "IND", "CYP")
  for (i in seq_along(mapDisputed)) {
    disputed$ISO_A3[i] <- mapDisputed[i]
  }

  ssd <- terra::buffer(country[14], 50)
  country <- rbind(country[-14], ssd)

  mar <- terra::buffer(disputed[3], 50)
  disputed <- rbind(disputed[-3], mar)

  all <- rbind(country, disputed[-6])

  outList <- NULL

  for (iso in unique(all$ISO_A3)) {
    outList[[iso]] <- terra::aggregate(all[all$ISO_A3 %in% iso, "ISO_A3"])
  }

  out <- do.call(rbind, unname(outList))
  terra::values(out) <- unique(all$ISO_A3)

  return(list(x = out,
              description = "World country areas with all disputed areas mapped to a country",
              unit = "1",
              cache = FALSE,
              class = "SpatVector"))
}
