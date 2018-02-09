options(menu.graphics=FALSE)
options(stringsAsFactors=FALSE)

# Load projectInit (if installed)
tryCatch( {
    library(projectInit)
}, error = function(e) {
    message(e)
})


#' local({r <- getOption("repos")
#'        r["CRAN"] <- "http://cran.r-project.org" 
#'        options(repos=r)
#' })


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