#!Rscript
# This script will install the list of packages below, various from
# CRAN, Bioconductor, or github, to set up the R computing environment
# I like.
#
# It will also create (or suggest, if one exists) an Rprofile setup to
# interfact with this R Package.

# Set local CRAN mirror:
local({r <- getOption("repos");
       r["CRAN"] <- "http://cran.at.r-project.org";  #AUSTRIA mirror
       options(repos=r)})

options(menu.graphics=FALSE)
#source("http://bioconductor.org/biocLite.R")
# Use a closer mirror (it's way faster for BSgenome packages!)
source("http://bioconductor.statistik.tu-dortmund.de/biocLite.R")
biocLite(suppressUpdates=TRUE)




args <- commandArgs(trailingOnly = F)
message(paste0(args, collapse="::"))
scriptPath <- paste0(getwd(), "/", dirname(sub("--file=","",args[grep("--file",args)])))
scriptPath = sub("/bin", "", scriptPath)
scriptPath = sub("/\\.", "", scriptPath)
scriptPath = paste0(scriptPath, "/")
message(scriptPath);
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
#BSgenome.Hsapiens.UCSC.hg19
#BSgenome.Hsapiens.UCSC.hg19.masked
} else {
	message("Package File: ", packageFile)
	packages = read.table(packageFile, stringsAsFactors=FALSE)[[1]];
}

# List of packages to install:


cu = contrib.url(biocinstallRepos())
ap = as.data.frame(available.packages(cu))

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
	biocLite(ap$Package[i], suppressUpdates=TRUE)
	} else {
	install.packages(as.character(ap$Package[i]),  contriburl = ap$Repo[i], dependencies=TRUE)
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
	library(devtools)
	install_github(paste0("sheffien/", packages[i])) 
} , error = function(e) { warning("Github Install Error: ", e); } )
}

# Suggest Rprofile code
RprofileCode = readLines(textConnection('
local({r <- getOption("repos");
       r["CRAN"] <- "http://cran.at.r-project.org";   #AUSTRIA mirror
       options(repos=r)})
options(menu.graphics=FALSE);
options(echo=TRUE);
options(stringsAsFactors=FALSE);

# Set up base directory for shared util functions:
# Change these 3 paths to locations for your setup.
options(PROJECT.CODE.BASE="/fhgfs/groups/lab_bock/nsheffield/")
options(PROJECT.DATA.BASE = "/fhgfs/groups/lab_bock/shared/")
options(RESOURCE.DIR="/fhgfs/groups/lab_bock/nsheffield/share/")
# And the old method:
#options(SHARE.DIR="SHARE_DIR")
#source(paste0(getOption("SHARE.DIR"), "project.init.R"))
'))
RprofileCode = sub("SHARE_DIR", scriptPath, RprofileCode)

# Create Rprofile if it doesn't already exist
# To not overwrite anything if it's there...
if (! file.exists("~/.Rprofile")) {
	message("#############################")
	message("Writing a new Rprofile to ~/.Rprofile")
	message(RprofileCode)
	#write(RprofileCode, "~/.Rprofile")
} else {
	message("#############################")
	message("Add this to your ~/.Rprofile:")
	message(RprofileCode)
}

## Renviron updates:
RenvironCode = "R_LIBS=~/R"
if (! file.exists("~/.Renviron")) {
	message("#############################")
	message("Writing a new Renviron to ~/.Renviron")
	write(RenvironCode, "~/.Renviron")
} else {
	message("#############################")
	message("Add this to your ~/.Renviron:")
	message(RenvironCode)
}





## Bash updates if you want to use the bin...
message(".bashrc update lines: ")
paste0("PATH=$PATH:", paste0(scriptPath, "bin"))
paste0("source ", paste0(scriptPath, "bin/alias_git.sh"))

# And R updates if you want to run the latest version of R:
# http://cran.r-project.org/bin/linux/ubuntu/
# sudo echo "deb http://cran.at.r-project.org/R/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list


