#' Logs into a magpie environment
#'
#' @param email email of the login form
#' @param password password of the login form
#'
#' @return Success if login was succesfull, the error otherwise.
#' @export
login <- function(email, password){

  if(sum(c(missing(email), missing(password))) > 0)
    stop("Need to specify username and password.")

  r <- httr::GET(url = paste(magpie::get_url(), "/login", sep = ""))
  cr <- httr::content(r)
  values <- cr %>%
    rvest::html_nodes(xpath='//input') %>%
    rvest::html_attr(name = "value")# %>%
  ids <- cr %>%
    rvest::html_nodes(xpath='//input') %>%
    rvest::html_attr(name = "id")# %>%
  names <- cr %>%
    rvest::html_nodes(xpath='//input') %>%
    rvest::html_attr(name = "name")# %>%

  login_list <- values
  names(login_list) <- names
  login_list["session[email]"] <- email
  login_list["session[password]"] <- password
  login_list <- login_list[-min(which(names(login_list) == "session[remember_me]"))]

  r <- httr::POST(url = paste(magpie::get_url(), "/login", sep = ""), body = as.list(login_list))

  return(magpie:::get_url())
}

#' Check whether user is actual logged in.
#'
#' @return TRUE if logged in, FALSE otherwise.
#' @export
logged_in <- function(){

  webpage <- httr::content(httr::GET(magpie::get_url())) %>% rvest::html_nodes(xpath = "//a")
  values <- webpage %>%
    rvest::html_nodes(xpath='//a') %>%
    rvest::html_attr(name = "href")

  return(!("/login" %in% values))

}

#' Check user of actual session
#'
#'
#' @return user name of actual logged in user
#' @export
logged_in_user <- function(){

  stopifnot(magpie::logged_in())

  webpage <- httr::content(httr::GET(magpie::get_url()))
  name <- webpage %>%
             rvest::html_nodes(xpath='//p') %>%
             rvest::html_text()
  return(gsub(" Logged in as ", "", name))
}

#' Logs out actual user
#'
#' @return return FALSE if something went wrong, TRUE otherwise
#' @export
logout <- function(){

  if(!magpie::logged_in()) return(FALSE)

  httr::DELETE(paste(magpie::get_url(), "logout?redirect=false", sep = "/"), body = list(authenticity_token = magpie::get_auth_token(),
                                                                    rel = "nofollow") )
  return(TRUE)
}

#' get function for the authenticity token
#'
#' @return the authenticity token, if logged in, NA otherwise
#' @export
get_auth_token <- function(){

  if(magpie::logged_in())
    return(httr::content(httr::GET(magpie::get_url())) %>% rvest::html_nodes(xpath = "//meta[@name='csrf-token']") %>% rvest::html_attr("content"))

  return("Please log in first!")
}

