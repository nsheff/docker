#!/usr/bin/env Rscript
# This script will install the list of packages below, various from
# CRAN, Bioconductor, or github, to set up the R computing environment
# I like.
#

# Try to create a local user directory for packages.
suppressWarnings(dir.create(Sys.getenv("R_LIBS_USER"), recursive=TRUE))

# Set local CRAN mirror:
options(menu.graphics=FALSE)

source("http://bioconductor.org/biocLite.R")
# Use a closer mirror (it's way faster for BSgenome packages!)
# But the problem is: it doesn't correctly resolve dependencies!
#source("http://bioconductor.statistik.tu-dortmund.de/biocLite.R")
#biocLite(suppressUpdates=TRUE)

# Seems to help to put this after the bioconductor source; since it
# updates the CRAN to a new spot, which otherwise would try the bioc
# mirror, which seems to lack some stuff.
local({
	r = getOption("repos")
    #r["CRAN"] <- "http://cran.at.r-project.org";  #AUSTRIA mirror
    r["CRAN"] <- "http://cran.r-project.org";  #AUSTRIA mirror
    options(repos=r)
})

args = commandArgs(trailingOnly = F)
message(paste0(args, collapse="::"))
scriptPath = paste0(getwd(), "/", dirname(sub("--file=","",args[grep("--file",args)])))
scriptPath = sub("/bin", "", scriptPath)
scriptPath = sub("/\\.", "", scriptPath)
scriptPath = paste0(scriptPath, "/")
message(scriptPath)
packageArg = args[grep("--packages",args)]
packageFile = sub("--packages=","",packageArg)
packagePath = paste0(getwd(), "/", packageFile)

if (length(packageFile) ==0 | !file.exists(packagePath)) {
	message("No package list found. Using default")
	# Key packages at the top
packages = readLines(textConnection("argparse
data.table
devtools
getopt
optparse
xts"))
} else {
	message("Package File: ", packageFile)
	packages = read.table(packageFile, stringsAsFactors=FALSE)[[1]]
}

# List of packages to install:

# WARNING: THESE PACKAGES ARE FACTORS AND NOT STRINGS. THIS IS
# ANNOYING. BE CAREFUL.
cu = contrib.url(biocinstallRepos())
ap = as.data.frame(available.packages(cu))
print(cu)
selected.packages = ap$Package %in% packages
unavailable.packages = ! packages %in% ap$Package

installed.packages = rownames(installed.packages())

#i=3245
# which(selected.packages)
for (i in which(selected.packages)) {
	if (ap$Package[i] %in% installed.packages) { next; }
	Sys.sleep(1)
	message("## Installing ", i, " ", ap$Package[i]);
	tryCatch( {
	if ( grepl("bioconductor", ap$Repo[i]) ) {
	message("using biocLite...")
	biocLite(as.character(ap$Package[i]))
	} else {
	install.packages(as.character(ap$Package[i]),  lib=Sys.getenv("R_LIBS_USER"),
		contriburl = ap$Repo[i], dependencies=TRUE)
	}
	} , error = function(e) { warning("Install Error: ", e); } )
}

# Update to get newly installed packages:
installed.packages = rownames(installed.packages())
# Try github dev packages:
warnings() 
warning("Unavailable packages are: ", packages[unavailable.packages])

for (i in which(unavailable.packages)) {
	if (packages[i] %in% installed.packages) { next; }
	Sys.sleep(1)
	message("## Trying github for: ", i, " ", packages[i]);
	tryCatch( {
	devtools::install_github(paste0("databio/", packages[i])) 
} , error = function(e) { warning("Github Install Error: ", e); } )
}

#Linking to BiocCheck:
#paste0("ln -s ~/bin/ ", Sys.getenv("R_LIBS_USER"), "/BiocCheck/script/BiocCheck")

# And R updates if you want to run the latest version of R:
# http://cran.r-project.org/bin/linux/ubuntu/
# sudo echo "deb http://cran.at.r-project.org/R/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list



install_global = function(pkgname) {
	pkgname

}
install.packages(as.character(ap$Package[i]),  lib=Sys.getenv("R_LIBS_USER"),
		contriburl = ap$Repo[i], dependencies=TRUE)