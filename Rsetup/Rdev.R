#source("http://bioconductor.org/biocLite.R")
library(BiocInstaller) 
tryCatch( { useDevel() } , error = function(e) { message(e) })
biocLite(ask=FALSE)

