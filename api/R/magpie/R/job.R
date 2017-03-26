#' get jobs of a given project
#'
#' @param project_id corresponding project id of the jobs looking for
#'
#' @return data.frame of ids and status of the jobs within the given project
#' @export
get_jobs_status <- function(project_id){

  stopifnot(logged_in())

  stopifnot(!missing(project_id))
  if(!project_id %in% magpie::get_projects()$id)
    return(paste("this project", project_id, "is not accessible"))

  webpage <- httr::content(httr::GET(paste(magpie::get_url(), "/projects/", project_id, sep = "")))
  jobs_html <- webpage %>% rvest::html_nodes(xpath = "//div[contains(@id,'job_id')]")

  ids <- as.numeric(gsub("job_id ","",jobs_html %>% rvest::html_attr("id")))
  status <- c()

  for(e in jobs_html){
    job_content <- (e %>% rvest::html_nodes(xpath=".//a[contains(@id, 'job_collapse_switch_')]"))[1] %>%
      rvest::html_text()
    job_content <- strsplit(x = job_content, split = "\n")[[1]]
    job_content <- gsub(" ", "", job_content, fixed = T)
    job_content <- job_content[job_content != ""]
    status <- c(status, gsub("Status:", "", job_content[grep("Status:", job_content)]))
  }


  out <- data.frame(id = ids, status = status)

  return(out)
}

#' create a job
#'
#' Given a project_id a new job is created. The model and revision of the model is defined by the project.
#'
#' @param project_id project_id of where to create a new job
#' @return job id of created job
#'@export
create_job <- function(project_id, params = list()){

  stopifnot(logged_in())

  stopifnot(!missing(project_id))
  if(!project_id %in% magpie::get_projects()$id)
    return(paste("this project", project_id, "is not accessible"))

  webpage <- httr::content(httr::GET(paste(magpie::get_url(), "/projects/", project_id, sep = ""))) %>%
      rvest::html_nodes(xpath = "//form[@id='new_job']")

  values <- webpage %>%
    rvest::html_nodes(xpath='.//input | .//select') %>%
    rvest::html_attr(name = "value")# %>%
  ids <- webpage %>%
    rvest::html_nodes(xpath='.//input | .//select') %>%
    rvest::html_attr(name = "id")# %>%
  names <- webpage %>%
    rvest::html_nodes(xpath='.//input | .//select') %>%
    rvest::html_attr(name = "name")# %>%
  
  params_list <- values
  names(params_list) <- names
  
  files <- webpage %>%
    rvest::html_nodes(xpath = ".//input[contains(@class, 'file')]") %>% rvest::html_attr(name = "name")
  selects <- webpage %>%
    rvest::html_nodes(xpath = ".//select") %>% rvest::html_attr(name = "name")
  select_values <- webpage %>%
    rvest::html_nodes(xpath='.//select/option[@selected]') %>% rvest::html_text()
  
  if(length(files) > 0)
    params_list <- params_list[-which(names(params_list) %in% files)]
  
  if(length(selects) > 0)
    params_list[which(names(params_list) %in% selects)] <- select_values

  params_list <- as.list(params_list)

  if(length(params) > 0){
    params_input_names <- gsub("\\]", "", gsub("\\[", "", names(params)))
    params_names <- gsub("\\]", "", gsub("\\[", "", gsub("job\\[", "", names(params_list))))

    for(i in 1:length(params_input_names))
      if(params_input_names[i] %in% params_names)
        params_list[[which(params_input_names[i] == params_names)]] <- params[[i]]
  }

  project_submit <- httr::POST(url = paste(magpie::get_url(), "/", "jobs", sep = ""), body = params_list)

  return(max(magpie::get_jobs_status(project_id)$id))
}

#' deletes a job
#'
#' @param project_id project id of job to be deleted
#' @param job_id job id of the job to be deleted
#'
#' @return the list of remaining jobs within the given project
#' @export
delete_job <- function(project_id, job_id){

  stopifnot(logged_in())

  if(missing(project_id) || missing(job_id)) return("Please provide the job_id and corresponding project_id as input.")
  if(!is.numeric(project_id) || !is.numeric(job_id)) return("project_id and job_id has to be numeric")

  if(!project_id %in% magpie::get_projects()$id) return("project_id not accessible")
  if(!job_id %in% magpie::get_jobs_status(project_id)$id) return("job_id is not in the given project_id")

  httr::DELETE(paste(magpie::get_url(), "/jobs/", job_id, "?redirect=false", sep = ""), body = list(authenticity_token = magpie::get_auth_token(),
                                                                                                      rel = "nofollow"))

  return(magpie::get_jobs_status(project_id))

}

#' get results of a job
#'
#' this function downloads the results of a job into a defined folder under the folder name projects/project_id/jobs/job_id
#'
#' @param project_id project id of the job corresponding project
#' @param job_id job id of the job of interest
#' @param folder folder name, where to save the resulting files
#'
#' @return list of filenames of the resulting files
#' @export
results_job <- function(project_id, job_id, folder){

  stopifnot(logged_in())

  if(missing(project_id)) return("Please provide a project id.")
  if(missing(job_id)) return("Please provide a job id.")

  jobs_status <- get_jobs_status(project_id)
  if(!job_id %in% jobs_status$id) return("job id not found in project_id")
  if(jobs_status$status[jobs_status$id == job_id] == "failed") return("job failed, no results available")

  if(missing(folder)){
    warning("No folder provided, taking the working directory.")
    folder <- ""
  }
  folder = paste(folder, "/projects/", project_id, "/jobs/", job_id, sep = "")

  if(dir.exists(folder)) warning("Folder exists ... proceeding anyways.")
  else dir.create(folder, recursive = T)

  if(dir.exists(paste(folder, "/results", sep = ""))) warning("Folder exists ... proceeding anyways.")
  else dir.create(paste(folder, "/results", sep = ""), recursive = T)

  result_files <- httr::content(httr::GET(paste(magpie::get_url(), "/jobs/", job_id, "/", "download", sep = "")))

  writeBin(result_files, paste(folder, "/", "results.zip", sep = ""))

  unzip(zipfile = paste(folder, "/results.zip", sep = ""), exdir = paste(folder, "/results", sep = ""))

  return(paste(folder, "/results", list.files(paste(folder, "/results", sep = "")), sep = ""))

}

#' get configs of a job
#'
#' this function downloads the configs of a job into a defined folder under the folder name projects/project_id/jobs/job_id
#'
#' @param project_id project id of the job corresponding project
#' @param job_id job id of the job of interest
#' @param folder folder name, where to save the resulting files
#'
#' @return list of filenames of the resulting files
#' @export
configs_job <- function(project_id, job_id, folder){

  stopifnot(logged_in())

  if(missing(project_id)) return("Please provide a project id.")
  if(missing(job_id)) return("Please provide a job id.")

  jobs_status <- get_jobs_status(project_id)
  if(!job_id %in% jobs_status$id) return("job id not found in project_id")
  if(jobs_status$status[jobs_status$id == job_id] == "failed") return("job failed, no configs available")

  if(missing(folder)){
    warning("No folder provided, taking the working directory.")
    folder <- ""
  }
  folder = paste(folder, "/projects/", project_id, "/jobs/", job_id, sep = "")

  if(dir.exists(folder)) warning("Folder exists ... proceeding anyways.")
  else dir.create(folder, recursive = T)

  if(dir.exists(paste(folder, "/configs", sep = ""))) warning("Folder exists ... proceeding anyways.")
  else dir.create(paste(folder, "/configs", sep = ""), recursive = T)

  result_files <- httr::content(httr::GET(paste(magpie::get_url(), "/jobs/", job_id, "/", "download_config", sep = "")))

  writeBin(result_files, paste(folder, "/", "configs.zip", sep = ""))

  unzip(zipfile = paste(folder, "/configs.zip", sep = ""), exdir = paste(folder, "/configs", sep = ""))

  return(paste(folder, "/configs", list.files(paste(folder, "/configs", sep = "")), sep = ""))

}




