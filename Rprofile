local({r <- getOption("repos")
       r["CRAN"] <- "http://cran.at.r-project.org" 
       options(repos=r)
})


# My function to initialize setup
go = function() {
	library(projectInit)
	library(RGenomeUtils)
	library(devtools)
	source("https://bioconductor.org/biocLite.R")
}

# Install RGenomeUtils
irgu = function() {
	install.packages("/code/RGenomeUtils", repos=NULL)
}