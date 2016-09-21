
#options(error = utils::recover)
options(error = NULL)

load_package <- function(package){
    if(!(package %in% installed.packages()[,"Package"]))
     install.packages(package, repos='http://cran.us.r-project.org')
    require(package, character.only = T)
}

load_package("stringdist")
load_package("ggplot2")
load_package("RColorBrewer")
load_package("gridExtra")

draw.figures <- function(lg = FALSE, EC = FALSE, maxHD = 4, maxBCs = 50, minReads = 1) {

  dat <- read.table("example.dat")
  #dat <- dat[dat[, 1] >= 2, ]
  dat <- dat[order(dat[, 1], decreasing = TRUE), ]

  if(EC) {
    dat <- calc.EC(dat[order(dat[, 1], decreasing = FALSE) , ], maxHD)
  }

  dat <- dat[dat[, 1] >= minReads, ]
  dat <- dat[1:ifelse(dim(dat)[1] < maxBCs, dim(dat)[1], maxBCs), ]

  plot_dat <- data.frame(reads = dat[, 1],
                    pos = 1:dim(dat)[1],
                    HD = calc.HDs(dat[, 2]),
                    experiment = "example")

  plot.BC(plot_dat, maxBCs, lg)

}

plot.BC <- function(plot_dat, maxBCs, lg, zoom = 0, zoom_number = 10) {

  legend_color <- c("red", brewer.pal(9, "YlOrBr")[9:1], brewer.pal(9, "YlGnBu"), brewer.pal(9, "YlGn"), brewer.pal(9, "Greys"))
  BC_colors<- brewer.pal(5, "Reds")

  png("Kirchenplot.png", height = 400, width = 572)
    plot1 <- ggplot(plot_dat, aes(x = pos, y = reads, fill = factor(HD, levels = 0:32))) +
      geom_bar(stat="identity") +
      scale_fill_manual("HDs", values = legend_color) +
      xlab("barcodes") + ylab("barcode reads\n") +
      theme(axis.text.y = element_text(size=16),
            axis.text.x = element_blank(),
            axis.title = element_text(size=16, face="bold"),
            axis.title.y = element_text(vjust=0.5, face="bold"),
            axis.ticks.x = element_blank()) +
      if(lg) {
          scale_y_continuous(trans = "log2", label=c("1", expression(paste(10^{1})),
                                                 expression(paste(10^{2})),
                                                 expression(paste(10^{3})),
                                                 expression(paste(10^{4})),
                                                 expression(paste(10^{5})),
                                                 expression(paste(10^{6}))),
                         breaks = c(1, 10^1, 10^2, 10^3, 10^4, 10^5, 10^6), limits = c(1, 1.1*10^6))
      } else {
          scale_y_continuous(label=c("0", "100.000", "200.000", "300.000", "400.000"),
                                   breaks = c(0, 10^5, 2*10^5, 3*10^5, 4*10^5), limits = c(0, 4.3*10^5))
      }

    print(plot1)

  # if(zoom) {
  #   BC_data <- plot_dat[1:zoom_number, ]
  #
  #   vp <- viewport(width = 0.6, height = 0.4, x = 0.6, y = 0.785)
  #
  #   plot2 <- ggplot(BC_data, aes(x = pos, y = reads)) +
  #     geom_bar(stat="identity") + #, fill=BC_colors) +
  #     xlab("") + ylab("barcode reads") +
  #     theme(axis.text.y = element_text(size=12),
  #           axis.text.x = element_text(size=12),
  #           axis.title = element_text(size=12, face="bold")) +
  #     scale_y_continuous(label=c(expression(paste("1•", 10^{5})),
  #                                expression(paste("2•", 10^{5})),
  #                                expression(paste("3•", 10^{5})),
  #                                expression(paste("4•", 10^{5})),
  #                                expression(paste("5•", 10^{5}))),
  #                        breaks = c(10^5, 2*10^5, 3*10^5, 4*10^5, 5*10^5), limits = c(0, 5 * 10^5))
  #   print(plot2, vp = vp)
  # }
  dev.off()

  plot2 <- qplot(factor(experiment), reads, data = plot_dat, geom = "boxplot") +
    xlab("") + ylab("reads\n") +
    theme(axis.text = element_text(size=16),
          axis.title = element_text(size=18, face="bold"),
          axis.title.x=element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank()) +
    if(lg) {
      scale_y_continuous(trans = "log2", label=c("1", expression(paste(10^{1})),
                                                 expression(paste(10^{2})),
                                                 expression(paste(10^{3})),
                                                 expression(paste(10^{4})),
                                                 expression(paste(10^{5})),
                                                 expression(paste(10^{6}))),
                         breaks = c(1, 10^1, 10^2, 10^3, 10^4, 10^5, 10^6), limits = c(1, 1.1*10^6))
    } else {
      scale_y_continuous(label=c("0", "100.000", "200.000", "300.000", "400.000"),
                         breaks = c(0, 10^5, 2*10^5, 3*10^5, 4*10^5), limits = c(0, 4.3*10^5))
    }

  plot3 <- qplot(factor(experiment), HD, data = plot_dat, geom = "boxplot") +
    xlab("") + ylab("HDs\n") +
    theme(axis.text = element_text(size=16),
          axis.title = element_text(size=18, face="bold"),
          axis.title.x=element_blank(),
          axis.ticks.x = element_blank(),
          axis.text.x = element_blank(),
          legend.position="none") +
    scale_y_continuous(limits = c(0, 32))


  png("boxplots.png", height = 350, width = 572)
  grid.arrange(plot2, plot3, ncol=2, nrow=1)
  dev.off()
}


calc.HDs <- function(seqs) {

  #BCs <- c("GGGGCTCCCGAGGAAA", "GCTATACGCCGCGTGA", "GGCTTAGGCATGACTA", "GTTGCCCTTCGGGGGT", "ACACATCAATTTTGGT")
  BCs <- c("GGTCGANAGCTTCTTTCGGGCCGCACGGCTGCT", "TGCGACAGGGGCAACTGGTCGAACTAAGAACTC", "CACGATNCCGCTTCTATCGCGTGCACTACATGT", "GCTAAGNGGCGATCACATCCACAAGCTTCTTTG")

  HDs <- NULL
  for(i in 1:length(BCs)) {
    HDs <- cbind(HDs, stringdist(BCs[i], seqs, method="h"))
  }

  return(apply(HDs, 1, min))
}

calc.EC <- function(EC_data, maxHD) {

  mergingBC <- 1
  stop <- dim(EC_data)[1]

  while(mergingBC < stop) {

    HD <- 1
    hammDist <- stringdist(EC_data[mergingBC, 2], EC_data[(mergingBC+1):dim(EC_data)[1], 2], method="h")

    while(HD <= maxHD) {
      HDs <- c(rep(FALSE, mergingBC), hammDist == HD)

      if(sum(HDs) > 0) {
        index <- which(HDs)[1]
        if(length(index) > 1) print(index)
        EC_data[index, 1] <- EC_data[index, 1] + EC_data[mergingBC, 1]

        EC_data <- EC_data[-mergingBC, ]
        EC_data <- EC_data[order(EC_data[,1]), ]

        stop <- dim(EC_data)[1]
        HD <- maxHD + 1
      } else {
        if(HD < maxHD) {
          HD <- HD + 1
        } else {
          mergingBC <- mergingBC + 1
          HD <- maxHD + 1
        }
      }
    }

  }
  return(EC_data[order(EC_data[,1], decreasing=TRUE),])
}
