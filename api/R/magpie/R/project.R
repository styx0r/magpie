#' gives back all existing projects of the logged in user
#'
#' @return list of all existing projects
#' @export
get_projects <- function(){

  stopifnot(logged_in())

  webpage <- read_html(getURL(paste(get_url(), "projects", sep = "/"), curl = .magpie_data$magpie_curl))
  if((grep("You have no projects yet.", as.character(webpage)) %>% length) > 0)
    return("No projects created.")

  # heading
  heading <- (webpage %>% html_nodes(xpath='//thead/tr/th') %>% html_text)[-1]
  out <- data.frame(matrix(nrow = 0, ncol = length(heading)+1))
  colnames(out) <- c("id", heading)

  row <- 1
  for(project in (webpage %>% html_nodes(xpath = "//tbody/tr"))){
      out[row, 1] <- gsub("/projects/", "", (((project %>% html_nodes(xpath=".//td"))[1]) %>% html_nodes(xpath=".//a"))[2] %>% html_attr("href"))
      col <- 2
      for(element in ((project %>% html_nodes(xpath=".//td"))[-1])){
        out[row, col] <- html_text(element)
        col <- col + 1
      }
    row <- row + 1
  }

  return(out)
}

