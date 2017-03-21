#' Return the configured url
#'
#' @return the actual configured url, used for all magpie api operations
#' @export
get_url <- function(){
  if(exists("magpie_url", envir = .magpie_data, inherits = F))
    return(.magpie_data$magpie_url)
  return(magpie:::url)
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
set_url <- function(url = "https://magpie.imb.medizin.tu-dresden.de"){
  require("dplyr")

  if(!(unlist(strsplit(url, ":"))[1] %in% c("http", "https"))){
    warning("No protocol given, assuming https!")
    url <- paste("https://", url, sep = "")
  }

  if(!RCurl::url.exists(url))
    stop("No server is reachable within this url!")

  old <- magpie:::get_url()
  if(exists("magpie_url", envir = .magpie_data, inherits = F))
    unlockBinding("magpie_url", .magpie_data)

  assign("magpie_url", url, .magpie_data)
  lockBinding("magpie_url", .magpie_data)

  return(old)
}

#' Deletes the manually curated url in .magpie_data
#'
#' When calling this function, the preconfigured server address to the demo server
#' at https://magpie.imb.medizin.tu-dresden.de is used.
#'
#'
#' @return the actual configured url, used for all magpie api operations.
#' @export
reset_url <- function(){
  if(!exists("magpie_url", envir = .magpie_data, inherits = F))
    stop("No user defined url present in .magpie_data!")
  unlockBinding("magpie_url", .magpie_data)
  rm("magpie_url", envir = .magpie_data, inherits = F)
  return(magpie:::url)
}
