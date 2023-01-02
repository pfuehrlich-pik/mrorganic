#' Calculate SOC by land type
#'
#' Estimate soil organic carbon content split by land type
#'
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("LandTypeAreas")
#' }
#' @seealso \code{\link{calcOutput}}

calcSOCbyLandType <- function() {

  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  message("Please be patient, this will take now a while.")

  # read in SOC data
  soc <- readSource("GSOCseq", subtype = "ini", convert = FALSE)

  # read in area information
  l <- calcOutput("LandTypeAreas", aggregate = FALSE)

  # aggregate area information to SOC resolution and add very small area to each cell
  # ensuring that all values are > 0 so that it can be used as weight
  weight <- terra::aggregate(l, fact = terra::res(soc) / terra::res(l), fun = "sum") +  10^-10

  # aggregate weight to intermediate target resolution
  # (for further processing to happen in memory)
  weight25 <- terra::aggregate(weight, fact = 30, fun = "sum")

  # area weighted aggregation of SOC to 0.25 degree
  soc   <- terra::project(soc, weight)
  soc25 <- terra::aggregate(soc * weight, fact = 30, fun = "sum") / weight25

  return(list(x = as.magpie(soc25),
              weight = as.magpie(weight25),
              description = "Average SOC content by land type",
              unit = "tonnes/ha"))
}
