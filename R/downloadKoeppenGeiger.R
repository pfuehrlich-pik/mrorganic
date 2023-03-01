downloadKoeppenGeiger <- function() {
  utils::download.file("https://figshare.com/ndownloader/files/12407516",
                       "Beck_KG_V1.zip", mode = "wb")
  utils::unzip("Beck_KG_V1.zip")
  file.remove("Beck_KG_V1.zip")
  # TODO metadata
}
