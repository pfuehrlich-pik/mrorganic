downloadEcoregions2017 <- function() {
  utils::download.file("https://storage.googleapis.com/teow2016/Ecoregions2017.zip",
                       "Ecoregions2017.zip", mode = "wb")
  utils::unzip("Ecoregions2017.zip")
  file.remove("Ecoregions2017.zip")
  # TODO metadata
}
