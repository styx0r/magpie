#' gives back all existing projects of the logged in user
#'
#' @return list of all existing projects
#' @export
get_projects <- function(){

  stopifnot(magpie::logged_in())

  webpage <- httr::content(GET(paste(magpie::get_url(), "projects", sep = "/")))
  if((grep("You have no projects yet.", as.character(webpage)) %>% length) > 0)
    return("no projects found")

  # heading
  heading <- (webpage %>% rvest::html_nodes(xpath='//thead/tr/th') %>% rvest::html_text())[-1]
  out <- data.frame(matrix(nrow = 0, ncol = length(heading)+1))
  colnames(out) <- c("id", heading)

  model_ids <- c()
  row <- 1
  for(project in (webpage %>% rvest::html_nodes(xpath = "//tbody/tr"))){
      out[row, 1] <- gsub("/projects/", "", (((project %>% rvest::html_nodes(xpath=".//td"))[1]) %>% rvest::html_nodes(xpath=".//a"))[2] %>% rvest::html_attr("href"))
      col <- 2
      for(element in ((project %>% rvest::html_nodes(xpath=".//td"))[-1])){
        out[row, col] <- rvest::html_text(element)
        if(colnames(out)[col] == "Model") model_ids <- c(model_ids, as.numeric(tail(unlist(strsplit(element %>% rvest::html_nodes(xpath = ".//a") %>% rvest::html_attr("href"), "/")), n = 1)))
        col <- col + 1
      }
    row <- row + 1
  }

  return(out)
}

#' deletes a job according to the given id
#'
#' @param project_id defines the project to be deleted
#'
#' @return if success: remaining projects, the error otherwise
#' @export
delete_project <- function(project_id = NA){

  if(!is.numeric(project_id)) return("project id has to be numeric.")

  projects <- magpie::get_projects()
  if(is.null(nrow(projects))) return(projects[1])
  if(!project_id %in% projects$id) return("project id not found")

  DELETE(paste(magpie::get_url(), "/projects/", project_id, "?redirect=false", sep = ""), body = list(authenticity_token = magpie::get_auth_token(),
                                                          rel = "nofollow"))

  return(magpie::get_projects())

}

#' create project
#'
#' @param model_id defines the model to start the project with
#' @param params defines the parameter different from the
#' standard parameter of the first job; it is recommended to call
#' get_params first and then to modify the list and put here as argument.
#'
#' @return id of the created project, error otherwise
#' @export
create_project <- function(model_id, revision = "HEAD", params = list()){

  stopifnot(logged_in())

  stopifnot(!missing(model_id))

  params_list <- magpie::get_params(model_id)

  form <- httr::content(httr::GET(paste(magpie::get_url(), "projects", "new", sep = "/")))
  form <- form %>% rvest::html_nodes(xpath = "//form[@id='new_project']")

  values <- form %>%
    rvest::html_nodes(xpath='.//input | .//select') %>%
    rvest::html_attr(name = "value")# %>%
  ids <- form %>%
    rvest::html_nodes(xpath='.//input | .//select') %>%
    rvest::html_attr(name = "id")# %>%
  names <- form %>%
    rvest::html_nodes(xpath='.//input | .//select') %>%
    rvest::html_attr(name = "name")# %>%

  form_list <- values
  names(form_list) <- names
  #names(form_list)[!is.na(ids)] <- ids[!is.na(ids)]

  form_list["project[model_id]"] <- as.character(model_id)
  form_list <- form_list[-which(names(form_list) == "project[revision]")]
  form_list["project[usertags]"] <- ""

  form_list <- form_list[-which(names(form_list) =="project[public]")[2]]

  if(is.null(nrow(params_list)))
    submit_list <- form_list
  else
    submit_list <- c(form_list, params_list)

  submit_list["config[revision]"] <- "HEAD"

  submit_list["config[default.config_sleep]"] <- "60"

  submit_list <- as.list(submit_list)

  project_submit <- httr::POST(url = paste(magpie::get_url(), "/projects", sep = ""), body = submit_list)

  return(magpie::get_projects())
}




