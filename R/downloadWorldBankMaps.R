#' @importFrom utils download.file

downloadWorldBankMaps <- function(subtype = "CountryBoundaries") {
  # Define subtype-specific elements of the meta data. Elements that are common to all subtypes are added further down.
  settings <- list(CountryBoundaries = list(title = "Country Boundaries",
                              description = "Country boundaries, globally",
                              url = "https://datacatalogfiles.worldbank.org/ddh-published/0038272/DR0046661/wb_adm0_boundary_lines_10m.zip"),
                   DisputedAreasBoundaries = list(title = "Boundaries of disputed areas",
                              description = "Boundaries of disputed areas, globally",
                              url = "https://datacatalogfiles.worldbank.org/ddh-published/0038272/DR0046662/wb_adm0_boundary_lines_disputed_areas_10m.zip"))
  meta <- toolSubtypeSelect(subtype, settings)

  download.file(meta$url, destfile = "tmp.zip")
  unzip("tmp.zip")
  unlink("tmp.zip")

  # Compose meta data by adding elements that are the same for all subtypes.
  return(list(url           = meta$url,
              doi           = NULL,
              title         = meta$title,
              description   = meta$description,
              author        = "World Bank",
              unit          = "1",
              version       = NA,
              release_date  = NA,
              license       = "CC-BY 4.0",
              reference     = NA))
}
