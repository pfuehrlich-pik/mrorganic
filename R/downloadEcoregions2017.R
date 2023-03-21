downloadEcoregions2017 <- function() {
  # filesize 142mb
  utils::download.file("https://storage.googleapis.com/teow2016/Ecoregions2017.zip",
                       "Ecoregions2017.zip", mode = "wb")
  utils::unzip("Ecoregions2017.zip")
  file.remove("Ecoregions2017.zip")
  return(list(url          = "https://ecoregions.appspot.com/",
              doi          = "https://doi.org/10.1093/biosci/bix014",
              title        = "Ecoregions 2017",
              description  = "A shapefile containing global ecoregions data, e.g. biomes.",
              author       = "Resolve",
              unit         = "categorical",
              version      = NA,
              release_date = "2017-04-05",
              license      = "CC-BY 4.0",
              reference    = paste("An Ecoregion-Based Approach to Protecting Half",
                                   "the Terrestrial Realm, BioScience, Volume 67,",
                                   "Issue 6, June 2017, Pages 534–545,",
                                   "https://doi.org/10.1093/biosci/bix014")))
}
