#!/usr/bin/env Rscript
options(echo=FALSE);
################################################################################
# Command-line script to roxygenize a package
################################################################################
suppressPackageStartupMessages(library("optparse"))
# specify our desired options in a list
option_list <- list(
make_option(c("-i", "--package"), type="character", help="R Package Dir")
)
opt <- parse_args(OptionParser(option_list=option_list))
if (is.null(opt$package)) {
	print_help(OptionParser(option_list=option_list));
	q();
}
if (file.access(opt$package) == -1) {
	stop("Package ", opt$package, " does not exist! Use --help for options");
}

if (! "roxygen2" %in% rownames(installed.packages())) {
	install.packages("roxygen2")
}

message("Roxygenizing...");
suppressPackageStartupMessages(library(roxygen2));
roxygenize(opt$package);
