#' plotMap
#'
#' Create a plot showing a map.
#'
#' @param x The data to plot as magclass object
#' @param name The name/title of the plot/png
#' @param createPng If TRUE save plot as png
#' @param range range of values for the color bar. If NULL range will be detected
#' automatically
#' @param ... Further arguments passed to terra::plot
#' @export
plotMap <- function(x, name, createPng = FALSE, range = NULL, ...) {
  unit <- sub("^[^:]*: *", "", grep("unit:", magclass::getComment(x), value = TRUE))
  if (is.null(range)) range <- c(min(x), max(x))
  for (i in magclass::getItems(x, dim = 3)) {
    if (createPng) {
      withr::local_png(gsub(" ", "_", paste0(name, "_", i, ".png")), width = 800, height = 400)
    }
    terra::plot(magclass::as.SpatRaster(x[, , i]),
                main = paste0(i, " ", name, " (", unit, ")"),
                range = range,
                ylim = c(-60, 90),
                ...)
  }
}
