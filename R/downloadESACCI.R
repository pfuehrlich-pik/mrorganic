downloadESACCI <- function(subtype = "landcover2010") {
  baseurl <- "ftp://geo10.elie.ucl.ac.be/CCI/"
  # Define subtype-specific elements of the meta data. Elements that are common to all subtypes are added further down.
  settings <- list(landcover2010 = list(title = "ESA CCI LandCover Map for 2010",
                      description = "ESA CCI LandCover Map for 2010 in 300m resolution",
                      url = paste0(baseurl, "LandCover/byYear/ESACCI-LC-L4-LCCS-Map-300m-P1Y-2010-v2.0.7.tif"),
                      release_date = 2017,
                      version = "2.0.7",
                      unit = 1,
                      reference = paste0("ESA. Land Cover CCI Product User Guide Version 2. Tech. Rep. (2017). ",
                                          "Available at: ",
                                          "maps.elie.ucl.ac.be/CCI/viewer/download/ESACCI-LC-Ph2-PUGv2_2.0.pdf")))
  meta <- toolSubtypeSelect(subtype, settings)
  utils::download.file(meta$url, destfile = basename(meta$url))

  utils::download.file("http://maps.elie.ucl.ac.be/CCI/viewer/download/ESACCI-LC-Legend.csv", destfile = "legend.csv")

  # Compose meta data by adding elements that are the same for all subtypes.
  return(list(url           = meta$url,
              doi           = NULL,
              title         = meta$title,
              description   = meta$description,
              author        = "ESA",
              unit          = meta$unit,
              version       = meta$version,
              release_date  = meta$release_date,
              license       = NA,
              reference     = meta$reference))
}
