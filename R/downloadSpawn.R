downloadSpawn <- function() {

  toolManualDownload(c("Go to https://doi.org/10.3334/ORNLDAAC/1763",
                       "Log in and download the data (9.0GB)"))

  zipFile <- Sys.glob("*.zip")
  if (length(zipFile) < 1) stop("No zip file found!")
  if (length(zipFile) > 1) stop("More than one zip file found!")

  utils::unzip(zipFile, unzip = "unzip", junkpaths = TRUE)
  unlink(zipFile)

  return(list(url          = "https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=1763",
              doi          = "https://doi.org/10.3334/ORNLDAAC/1763",
              title        = "Global Aboveground and Belowground Biomass Carbon Density Maps for the Year 2010",
              description  = paste("This dataset provides temporally consistent and harmonized global maps of",
                                   "aboveground and belowground biomass carbon density for the year 2010 at a",
                                   "300-m spatial resolution. The aboveground biomass map integrates land-cover",
                                   "specific, remotely sensed maps of woody, grassland, cropland, and tundra",
                                   "biomass. Input maps were amassed from the published literature and, where",
                                   "necessary, updated to cover the focal extent or time period. The belowground",
                                   "biomass map similarly integrates matching maps derived from each aboveground",
                                   "biomass map and land-cover specific empirical models. Aboveground and",
                                   "belowground maps were then integrated separately using ancillary maps of",
                                   "percent tree cover and landcover and a rule-based decision tree. Maps reporting",
                                   "the accumulated uncertainty of pixel-level estimates are also provided."),
              author       = "Spawn, S.A., and H.K. Gibbs",
              unit         = "Mg C ha-1",
              version      = "1",
              release_date = "2020-04-22",
              license      = "https://www.earthdata.nasa.gov/learn/use-data/data-use-policy",
              reference    = utils::bibentry("Misc",
                                      title = paste("Global Aboveground and Belowground Biomass Carbon",
                                                    "Density Maps for the Year 2010"),
                                      author = c(utils::person("S.A.", "Spawn"),
                                                 utils::person("H.K.", "Gibbs")),
                                      year = "2020",
                                      publisher = "ORNL Distributed Active Archive Center",
                                      language = "en",
                                      url = "https://daac.ornl.gov/cgi-bin/dsviewer.pl?ds_id=1763",
                                      doi = "10.3334/ORNLDAAC/1763")))
}
