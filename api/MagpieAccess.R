your.username <- 'your e-mail'
your.password <- 'your password'
setwd( "C:\arbeit\tmp" )
login.url <- "https://magpie.imb.medizin.tu-dresden.de/login"

require(RCurl)
require(XML)
#require("downloader") # zip download trial
agent="R"

options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"), ssl.verifypeer = TRUE))
curl = getCurlHandle()
curlSetOpt(
  cookiejar = 'cookies.txt' ,
  useragent = agent,
  followlocation = TRUE ,
  autoreferer = TRUE ,
  curl = curl
)

#get authenticity token
login.script <- getURL(login.url, curl=curl)
login.doc <- htmlParse(login.script, encoding = "UTF-8")
token <- paste(xpathSApply(login.doc, "//div [@class='col-md-6 col-md-offset-3']/form/input[@name='authenticity_token']/@value"))


# list parameters to pass to the website (pulled from the source html)
params <-
  list(
    'userAgent' = agent,
    'session[email]' = your.username,
    'session[password]' = your.password,
    'session[remember_me]' = "1",
    'authenticity_token' = token
  )

# logs into the form
login.html = postForm(login.url, .params = params, curl = curl, style="POST")
login.html

# create a new job for project id= 32 / userid = 57
newjob.url <- getURL("https://magpie.imb.medizin.tu-dresden.de/projects/32",curl = curl)
newjob.doc <- htmlParse(newjob.url, encoding="UTF-8")
newjob.token <- paste(xpathSApply(newjob.doc,"//form[@id='new_job']/input[@name='authenticity_token']/@value"))
newjob.projectid <- "32"
newjob.userid <-  "57"

params.job <-
  list(
    'userAgent' = agent,
    'job[project_id]' = newjob.projectid,
    'job[user_id]' = newjob.userid,
    'authenticity_token' = newjob.token
  )
html = postForm("https://magpie.imb.medizin.tu-dresden.de/jobs", .params = params.job, curl = curl, style="POST")
htmlParse(html, encoding = "UTF-8")




# download job results (zip)
# Version 1 (it doen't work)
temp <- tempfile()
download.file("https://magpie.imb.medizin.tu-dresden.de/jobs/51/download",temp, mode="wb")
data <- read.table(unz(temp, "results_Hello World_51.zip"))
unlink(temp)

# Version 2 (it doesn't work)
download("https://magpie.imb.medizin.tu-dresden.de/jobs/51/download", dest="results_Hello World_51")
unzip ("results_Hello World_51.zip", exdir = ".")

# Version 3 (it doesn't work.)
download.url <- getURL("https://magpie.imb.medizin.tu-dresden.de/jobs/51/download", curl=curl)
