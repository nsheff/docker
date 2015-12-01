#!/usr/bin/env Rscript
options(echo=FALSE);
################################################################################
# ARGUMENT PROCESSING FUNCTIONS
################################################################################
suppressPackageStartupMessages(library("optparse"))
# specify our desired options in a list
option_list <- list(
make_option(c("-i", "--inputBed"), type="character", help="Query regions of interest"),
make_option(c("-c", "--colToSplit"), type="character", default=NULL, help="Column on which to split input bed file"),
make_option(c("-f", "--folder"), type="character", default=NULL, help="Input folder of bed files"),
make_option(c("-v", "--preUniverse"), type="character", default=NULL, help="Pre-processed built in universe."),
make_option(c("-u", "--universe"), type="character", default=NULL, help="Custom universe bed file"),
make_option(c("-d", "--database"), type="character", default=NULL, help="Path to database."),
make_option(c("-o", "--outfolder"), type="character", help="Output folder", default="~"),
make_option(c("-p", "--cores"), type="integer", help="number of cores to use [Default:1]", default=1)
)

# built universe could be:
#1. tiled regions
#2. active DHSs
#3. restricted universe to set of all inputs.

opt <- parse_args(OptionParser(option_list=option_list))
if (is.null(opt$inputBed) | is.null(opt$universe)) {
	print_help(OptionParser(option_list=option_list));
	q();
}
if (file.access(opt$inputBed) == -1) {
	stop("bamFile does not exist! Use --help for options");
}

if (is.null(opt$outfolder)) {
	opt$outfolder = getwd()
}

message("Loading packages...");
suppressPackageStartupMessages(library(LOLA));
message("Loading regions...")
userSets = LOLA::readBed(opt$inputBed)
userUniv = LOLA::readBed(opt$universe)
message("Loading regionDB...")

regionDB = loadRegionDB(opt$database)

result = LOLA::runLOLA(userSets, userUniv, regionDB) 

writeCombinedEnrichment(result, opt$outfolder)

