filename = ("out.txt")

load_package <- function(package){
    if(!(package %in% installed.packages()[,"Package"]))
     install.packages(package, repos='http://cran.us.r-project.org')
    require(package, character.only = T)
}

load_package("data.table")

data <- fread(filename, sep = " ")#, header = F, stringsAsFactors = T)
data <- matrix(unlist(data), nrow = nrow(data), byrow = F)

#data <- read.table("8t8.txt")
colnames(data) <- c("t", "type", seq(1:(ncol(data)-2)))

times <- as.numeric(data[, "t"])
types <- data[, "type"]
cells <- matrix(as.numeric(data[,3:ncol(data)]), nrow = nrow(data), byrow = F)

rm(data)

showPS <- function(time){

  # require("lattice")
  load_package("plot3D")

  size <- sqrt(ncol(cells))
  sizeQ <- size^2
  sizeQ1 <- size^2-1

  particles <- matrix(nrow = size, ncol = size, data = cells[times == time & types == "particles",])
  substrate <- matrix(nrow = size, ncol = size, data = cells[times == time & types == "substrate",])
  orientation <- matrix(nrow = size, ncol = size, data = cells[times == time & types == "orientation",])

  NBR.COLORS <- 30

  colSubstrate = colorRampPalette(c("white", "black"),
                         space="Lab")(NBR.COLORS)
#   colParticles = colorRampPalette(c("white", "black"),
#                                   space="Lab")(2)
  colParticles = colorRampPalette(c("white", "black"),
                                  space="Lab")(NBR.COLORS)
  colOrientation = colorRampPalette(c("darkmagenta","blue","green","yellow","orange","red","white"),
                                    space="Lab")(8)
  breaksSubstrate = c(as.integer((1:(NBR.COLORS)) * 1/(NBR.COLORS) * 2*median(substrate)), max(substrate) + 1)
  breaksParticles = c(as.integer((1:(NBR.COLORS)) * 1/(NBR.COLORS) * 2*mean(particles)), max(particles) + 1)
  #breaksParticles = c(0, 1, max(particles) + 1)
  breaksOrientation = c(0,1,2,3,4,5,6,7,8)

  par(mfrow = c(2,2), oma = c(0,0,2,0))

  image2D(particles, x = 1:ncol(particles), y = 1:nrow(particles), contour = TRUE, col=colParticles, breaks = breaksParticles, main = "Particles")
  image2D(substrate, x = 1:ncol(substrate), y = 1:nrow(substrate), contour = TRUE, col=colSubstrate, breaks = breaksSubstrate, main = "Substrate")#, col = ramp.col(col = c("grey", "black"), n = 4, alpha = 0.7))
  hist(as.vector(particles), breaks = seq(0,max(particles)+20,20), main = "Particles")
  image2D(orientation, x = 1:ncol(orientation), y = 1:nrow(orientation), contour = TRUE, col=colOrientation, breaks = breaksOrientation, main = "Orientation")#, col = ramp.col(col = c("grey", "black"), n = 4, alpha = 0.7))

  title(paste("Time:", time), outer = T)

  par(mfrow=c(1,1))


}

#require("manipulate")
#manipulate(showPS(time), time = slider(0, max(times), step = max(times) / (length(unique(times))-1)))

#Here we create the movies for faster visualization
load_package("animation")
saveGIF({
  for(t in unique(times)[order(unique(times))])
    showPS(t)
}, movie.name = paste(filename, ".gif", sep = ""), interval = 0.1, nmax = 30, ani.width = 600,
ani.height = 600)
