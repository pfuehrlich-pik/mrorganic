downloadGADM <- function() {
  isoCodes <- c("ALA", "ATA", "BES", "BVT", "CCK", "CXR", "ESH", "GLP",
                "GUF", "MTQ", "MYT", "REU", "SJM", "TKL", "TWN")
  writeLines(isoCodes, "isoCodes.txt")
  message("Downloading GADM data for the following countries:\n", paste(isoCodes, collapse = ", "),
          "\nThis will take a couple minutes.") # TODO alternatively omit quiet = TRUE so user will know what's downloading
  geodata::gadm(isoCodes, 0, ".", version = "4.1", resolution = 2, quiet = TRUE)
  return(list(url          = "https://gadm.org/data.html",
              doi          = NULL,
              title        = "GADM data",
              description  = paste("GADM wants to map the administrative areas of all countries, ",
                                   "at all levels of sub-division."),
              author       = "World Bank",
              unit         = "1",
              version      = "4.1",
              release_date = "2022-07-16",
              license      = "https://gadm.org/license.html",
              reference    = NA))
}
