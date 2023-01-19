downloadGADM <- function() {
  # TODO parallel downloads
  geodata::gadm(madrat::getISOlist(), 0, ".", version = "4.1", resolution = 2)

  return(list(url          = "https://gadm.org/data.html",
              doi          = NULL,
              title        = "GADM data",
              description  = paste("GADM wants to map the administrative areas of all countries, ",
                                   "at all levels of sub-division."),
              author       = "GADM",
              unit         = "1",
              version      = "4.1",
              release_date = "2022-07-16",
              license      = "https://gadm.org/license.html",
              reference    = NA))
}
