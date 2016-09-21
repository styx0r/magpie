input <- read.table("default.config")
system(paste("sleep", input$V2))
print(paste("Slept for", input$V2, "seconds!"))
