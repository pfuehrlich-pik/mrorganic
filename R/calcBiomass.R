calcBiomass <- function() {
  soc <- as.SpatRaster(calcOutput("SOCbyLandType", aggregate = FALSE))

  ecoregions <- readSource("Ecoregions2017")
  biomes <- terra::rasterize(ecoregions, soc, "ECO_BIOME_", touches = TRUE)

  # add ISO again, if as.SpatRaster preserves dim 1.3 (country) this would not be necessary
  countries <- calcOutput("WorldCountries", aggregate = FALSE)
  countryRaster <- terra::rasterize(countries, soc, "ISO", touches = TRUE)

  x <- c(soc, biomes, countryRaster)
  return(list(x = x,
              description = "TODO",
              unit = "TODO",
              class = "SpatRaster"))
}
