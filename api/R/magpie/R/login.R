#' Logs into a magpie environment
#'
#' @param email email of the login form
#' @param password password of the login form
#'
#' @return Success if login was succesfull, the error otherwise.
#' @export
login <- function(email, password){

  if(exists("magpie_curl", envir = .magpie_data, inherits = F))
    rm("magpie_curl", envir = .magpie_data, inherits = F)

  if(exists("magpie_at", envir = .magpie_data, inherits = F))
    rm("magpie_at", envir = .magpie_data, inherits = F)

  if(sum(c(missing(email), missing(password))) > 0)
    stop("Need to specify username and password.")

  agent="R"

  magpie_curl = getCurlHandle()
  curlSetOpt(
    cookiejar = 'cookies.txt' ,
    useragent = agent,
    followlocation = TRUE ,
    autoreferer = TRUE ,
    curl = magpie_curl
  )

  require("dplyr")
  webpage <- read_xml(getURL(paste(get_url(), "login", sep = "/"), curl = magpie_curl))
  values <- webpage %>%
    html_nodes(xpath='//input') %>%
    html_attr(name = "value")# %>%
  ids <- webpage %>%
    html_nodes(xpath='//input') %>%
    html_attr(name = "id")# %>%
  names <- webpage %>%
    html_nodes(xpath='//input') %>%
    html_attr(name = "name")# %>%

  login_list <- values
  names(login_list) <- names
  login_list["session[email]"] <- email
  login_list["session[password]"] <- password
  login_list <- login_list[-min(which(names(login_list) == "session[remember_me]"))]

  login.html = postForm(paste(get_url(), "login", sep = "/"), .params = login_list, curl = magpie_curl, style="POST")


  assign("magpie_curl", magpie_curl, .magpie_data)
  assign("magpie_at", login_list["authenticity_token"], .magpie_data)

  # individual login
  return(magpie:::get_url())
}

#' Check whether user is actual logged in.
#'
#' @return TRUE if logged in, FALSE otherwise.
#' @export
logged_in <- function(){

  if(!exists("magpie_curl", envir = .magpie_data, inherits = F)) return(FALSE)

  r <- tryCatch(getURL(get_url(), curl = .magpie_data$magpie_curl),
           error = function(e) {
              print("No valid session, most likely due to timeout or restart of the R Session.")
              return("error")
           })
  if(r == "error") return(FALSE)

  require("dplyr")
  webpage <- read_html(getURL(get_url(), curl = .magpie_data$magpie_curl))
  values <- webpage %>%
    html_nodes(xpath='//a') %>%
    html_attr(name = "href")

  return(!("/login" %in% values))
}

#' Check user of actual session
#'
#'
#' @return user name of actual logged in user
#' @export
logged_in_user <- function(){

  stopifnot(logged_in())

  webpage <- read_html(getURL(get_url(), curl = .magpie_data$magpie_curl))
  name <- webpage %>%
             html_nodes(xpath='//p') %>%
             html_text
  return(gsub(" Logged in as ", "", name))
}

#' Logs out actual user
#'
#' @return return FALSE if something went wrong, TRUE otherwise
#' @export
logout <- function(){

  if(!logged_in()) return(FALSE)

  if(exists("magpie_curl", envir = .magpie_data, inherits = F))
    rm("magpie_curl", envir = .magpie_data)
  if(exists("magpie_at", envir = .magpie_data, inherits = F))
    rm("magpie_at", envir = .magpie_data)

}
