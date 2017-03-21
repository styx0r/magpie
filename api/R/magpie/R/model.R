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

  return(models[order(models$id),])
}
