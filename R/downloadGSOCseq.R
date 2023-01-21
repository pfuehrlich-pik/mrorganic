downloadGSOCseq <- function(subtype = "ini") {
  # Define subtype-specific elements of the meta data. Elements that are common to all subtypes are added further down.
  settings <- list(ini = list(title = "Initial SOC Stocks (t0)",
                              description = "Initial Soil organic carbon stocks t0",
                              url = "http://54.229.242.119/GSOCseqv1.1/GSOCseq_T0_Map030.tif"),
                   finalSSM1 = list(title = "Final SOC stocks SSM1",
                              description = paste0("Final soil organic carbon stocks under sustainable soil",
                                                   "management scenario SSM1"),
                              url = "http://54.229.242.119/GSOCseqv1.1/GSOCseq_finalSOC_SSM1_Map030.tif"))
  meta <- toolSubtypeSelect(subtype, settings)

  utils::download.file(meta$url, destfile = basename(meta$url))

  # Compose meta data by adding elements that are the same for all subtypes.
  return(list(url           = meta$url,
              doi           = NULL,
              title         = meta$title,
              description   = meta$description,
              author        = "FAO",
              unit          = NA,
              version       = "1.1",
              release_date  = NA,
              license       = NA,
              reference     = NA))
}
