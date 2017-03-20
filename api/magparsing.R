


library("rvest")
library("stringr")
url <- "https://magpie.imb.medizin.tu-dresden.de/login"
webpage <- url %>% read_html
webpage <- read_xml(getURL(paste(get_url(), "login", sep = "/"), curl = curl))
webpage <- get_url() %>% read_html
values <- webpage %>%
  html_nodes(xpath='//input') %>%
  html_attr(name = "value")# %>%
ids <- webpage %>%
  html_nodes(xpath='//input') %>%
  html_attr(name = "id")# %>%
names <- webpage %>%
  html_nodes(xpath='//input') %>%
  html_attr(name = "name")# %>%




require("RCurl")
require("XML")

webpage <- getURL("https://magpie.imb.medizin.tu-dresden.de/login")
webpage <- readLines(tc <- textConnection(webpage)); close(tc)



xmlWebpage <- xmlParse(webpage)

getNodeSet(xmlWebpage, "//input")


pagetree <- htmlTreeParse(webpage, error=function(...){}, useInternalNodes = TRUE)
login <- getNodeSet(pagetree, "//*[starts-with(name(), 'form')]")
login <- getNodeSet(pagetree, "//*/input")

xmlDoc <- newXMLNode("root")
addChildren(xmlDoc, kids = login)
xmlSApply(xmlDoc, xmlGetAttr, "*")

sapply(login, function(e){xmlValue(e)})





fileName <- system.file("exampleData", "mtcars.xml", package="XML")
doc <- xmlTreeParse(fileName)

xmlAttrs(xmlRoot(doc))

xmlAttrs(xmlRoot(doc)[["variables"]])


doc <- xmlParse(fileName)
d = xmlRoot(doc)

xmlAttrs(d)
xmlAttrs(d) <- c(name = "Motor Trend fuel consumption data",
                 author = "Motor Trends")
xmlAttrs(d)

# clear all the attributes and then set new ones.
removeAttributes(d)
xmlAttrs(d) <- c(name = "Motor Trend fuel consumption data",
                 author = "Motor Trends")


# Show how to get the attributes with and without the prefix and
# with and without the URLs for the namespaces.
doc = xmlParse('<doc xmlns:r="http://www.r-project.org">
               <el r:width="10" width="72"/>
               <el width="46"/>
               </doc>')

xmlAttrs(xmlRoot(doc)[[1]], TRUE, TRUE)
xmlAttrs(xmlRoot(doc)[[1]], FALSE, TRUE)
xmlAttrs(xmlRoot(doc)[[1]], TRUE, FALSE)
xmlAttrs(xmlRoot(doc)[[1]], FALSE, FALSE)




r <- GET(url = "http://localhost:3000/login")
cr <- content(r)
values <- cr %>%
  html_nodes(xpath='//input') %>%
  html_attr(name = "value")# %>%
ids <- cr %>%
  html_nodes(xpath='//input') %>%
  html_attr(name = "id")# %>%
names <- cr %>%
  html_nodes(xpath='//input') %>%
  html_attr(name = "name")# %>%

login_list <- values
names(login_list) <- names
login_list["session[email]"] <- email
login_list["session[password]"] <- password
login_list <- login_list[-min(which(names(login_list) == "session[remember_me]"))]

#co <- cookies(r)

r <- POST(url = "http://localhost:3000/login", body = as.list(login_list))

r <- GET("http://localhost:3000/projects")
content(r) %>% html_nodes(xpath = "//meta") %>% html_attr("content")
headers <- list(
  #User-Agent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:28.0) Gecko/20100101 Firefox/28.0",
  Referer = "http://localhost:3000",
  Host = "http://localhost:3000",
  Connection = "keep-alive",
  #Accept-Language = "en-US,en;q=0.5",
  #Accept-Encoding = "gzip, deflate",
  Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
)
DELETE("http://localhost:3000/projects/15", body = list(authenticity_token = "BWUQFGa9/xF7QeOVHE+D1CmCTGGEgL8tYw9TyCfnWepKS62E9sOIpL1Z71lZLy6mrqMSuH5dgiP9t7ifsHgA5w==",
                                                        rel = "nofollow"))


DELETE("http://localhost:3000/logout?redirect=false", body = list(authenticity_token = "LCxeTJWEOELCpv1xzRvifD/2KDnAzXa0zrXe7bA1kyEzRzNeWY9FcZ9jdaW1ll966XP8pKk12n65pLUS4brknQ==",
                                                        rel = "nofollow"), )

