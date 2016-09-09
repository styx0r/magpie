source("BC_functions.R")

conf_data <- read.table("default.config", sep = " ")

draw.figures(lg = conf_data[conf_data[, 1] == "lg", 2],
             EC = conf_data[conf_data[, 1] == "EC", 2],
             maxHD = conf_data[conf_data[, 1] == "maxHD", 2],
             maxBCs = conf_data[conf_data[, 1] == "maxBCs", 2],
             minReads = conf_data[conf_data[, 1] == "minReads", 2])
