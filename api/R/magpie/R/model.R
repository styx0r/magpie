#' get all visible models
#'
#' @return all models
#' @export
get_models <- function(){

  stopifnot(logged_in())

  webpage <- httr::content(httr::GET(paste(get_url(), "models", sep = "/")))
  models_html <- webpage %>% rvest::html_nodes(xpath = "//div[@class='caption']")

  models <- data.frame(matrix(nrow = length(models_html), ncol = 3, data = NA))
  colnames(models) <- c("id", "name", "description")
  i <- 1
  for(model in models_html){
    models[i, "id"] <- as.integer(gsub("/models/", "", (model %>% rvest::html_nodes(xpath = "./a"))[1] %>% rvest::html_attr("href")))
    models[i, "name"] <- model %>% rvest::html_nodes(xpath = "./h2") %>% rvest::html_text()
    models[i, "description"] <- model %>% rvest::html_nodes(xpath = "./p") %>% rvest::html_text()
    i <- i + 1
  }

  rownames(models) <- models$id

  return(models[order(models$id),])
}

#' parameter of a given model
#'
#' NOTE: no file upload support yet
#'
#' @param model_id the given model based on the id
#' @return a list of parameter
#' @export
get_params <- function(model_id){

  stopifnot(logged_in())

  stopifnot(!missing(model_id))
  if(!(model_id %in% magpie::get_models()$id)) return("No valid model id. Check for model ids with get_models().")

  webpage <- httr::content(httr::GET(paste(magpie::get_url(), "/project_modelconfig?model_id=", model_id,"&model_revision=HEAD", sep = "")))
  if(is.null(webpage)) return("Model has no input parameter.")

  values <- webpage %>%
    rvest::html_nodes(xpath='//input | //select') %>%
    rvest::html_attr(name = "value")# %>%
  ids <- webpage %>%
    rvest::html_nodes(xpath='//input | //select') %>%
    rvest::html_attr(name = "id")# %>%
  names <- webpage %>%
    rvest::html_nodes(xpath='//input | //select') %>%
    rvest::html_attr(name = "name")# %>%

  params_list <- values
  names(params_list) <- names

  files <- webpage %>%
    rvest::html_nodes(xpath = "//input[contains(@class, 'file')]") %>% rvest::html_attr(name = "name")
  selects <- webpage %>%
    rvest::html_nodes(xpath = "//select") %>% rvest::html_attr(name = "name")
  select_values <- webpage %>%
    rvest::html_nodes(xpath='//select/option[@selected]') %>% rvest::html_text()

  if(length(files) > 0)
    params_list <- params_list[-which(names(params_list) %in% files)]

  if(length(selects) > 0)
    params_list[which(names(params_list) %in% selects)] <- select_values

  params_list <- params_list[!names(params_list) %in% c("authenticity_token", "utf8")]

  return(as.list(params_list))
}


