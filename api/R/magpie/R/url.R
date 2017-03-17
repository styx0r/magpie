#' Return the configured url
#'
#' @return the actual configured url, used for all magpie api operations
#' @export
getURL <- function(){
  if(exists("magpie_url", envir = .GlobalEnv, inherits = F))
    return(magpie_url)
  return(magpie::url)
}

#' Sets the url used for all magpie api operations
#'
#' Sets the actual url used for all api operations in global environment. It is stored in magpie_url.
#' If url is not set manually, the demo server at https://magpie.imb.medizin.tu-dresden.de is autmatically
#' chosen for all api operations.
#'
#' @param url url used for all following api operations
#'
#' @return the actual configured url, used for all magpie api operations; can differ if protocoll is missing.
#' @export
setURL <- function(url = "https://magpie.imb.medizin.tu-dresden.de"){
  require("dplyr")

  if(!(unlist(strsplit(url, ":"))[1] %in% c("http", "https"))){
    warning("No protocol given, assuming https!")
    url <- paste("https://", url, sep = "")
  }

  if(!RCurl::url.exists(url))
    stop("No server is reachable within this url!")

  if(exists("magpie_url", envir = .GlobalEnv, inherits = F))
    unlockBinding("magpie_url", .GlobalEnv)
  assign("magpie_url", url, .GlobalEnv)
  lockBinding("magpie_url", .GlobalEnv)

  return(url)
}

#' Deletes the manually curated url in .GlobalEnv
#'
#' When calling this function, the preconfigured server address to the demo server
#' at https://magpie.imb.medizin.tu-dresden.de is used.
#'
#'
#' @return the actual configured url, used for all magpie api operations.
#' @export
resetURL <- function(){
  if(!exists("magpie_url", envir = .GlobalEnv, inherits = F))
    stop("No user defined url present in .GlobalEnv!")
  unlockBinding("magpie_url", .GlobalEnv)
  rm("magpie_url", envir = .GlobalEnv, inherits = F)
  return(magpie::url)
}
